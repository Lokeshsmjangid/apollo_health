import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:apollo/Dialogues/transparent_dialogue.dart';
import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/controllers/home_ctrl.dart';
import 'package:apollo/custom_widgets/custom_keyboard_game.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_models/wheel_for_wellness_model.dart';
import 'package:apollo/resources/Apis/api_repository/wellness_daily_limit_repo.dart';
import 'package:apollo/resources/Apis/api_repository/wheel_for_wellness_repo.dart';
import 'package:apollo/resources/Apis/api_repository/wheel_for_wellness_result_repo.dart';

import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';

import 'package:apollo/resources/countdown_timer_wellness.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/game_mode/wheel_of_wellness/spin_button.dart';
import 'package:apollo/screens/game_mode/wheel_of_wellness/wheel_of_wellness_result_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WheelItem{
  String? item;
  Color? color;
  WheelItem({this.item,this.color});
}

class WheelOfWellnessScreen extends StatefulWidget {
  const WheelOfWellnessScreen({super.key});

  @override
  State<WheelOfWellnessScreen> createState() => _WheelOfWellnessScreenState();
}

class _WheelOfWellnessScreenState extends State<WheelOfWellnessScreen> {

  final GlobalKey<CountdownTimerWidgetWellnessState> timerKey = GlobalKey();

  bool isSpine = false;
  bool isRevel = false;
  int revelCount = 0;

  List<WheelItem> items = [
    WheelItem(item: '100',color: Color(0XFFFFCD83)),
    WheelItem(item: '150',color: Color(0XFF7B47CC)),
    WheelItem(item: '200',color: Color(0XFFF8A2E7)),
    WheelItem(item: '250',color: Color(0XFF7B47CC)),
    WheelItem(item: '300',color: Color(0XFF9AACFF)),
    WheelItem(item: '350',color: Color(0XFF7B47CC)),
    WheelItem(item: '400',color: Color(0XFFFFAEA8)),
    WheelItem(item: '450',color: Color(0XFF7B47CC)),
    WheelItem(item: '500',color: Color(0XFFAAD7C3)),
    WheelItem(item: '550',color: Color(0XFF7B47CC)),
  ];
  StreamController<int> selected = StreamController<int>();

  // for answer
  // final String correctWord = "HYPERTENSION";
  // int lives = 5;
  int lives = 0;
  int stopWheelPoint = 0;
  bool isCorrect = false;
  String correctWord = "";
  List<FocusNode>? focusNodes;
  List<TextEditingController>? controllers;
  List<String> guessedLetters = ['H', 'E', 'E'];
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _backgroundPlayer = AudioPlayer();

  Timer? glowTimer;
  List<int> glowingIndices = [];
  Set<String> correctLetters = {};
  Set<String> incorrectLetters = {};
  Future<void> _playConfettiSound({required String sound}) async {
    await _effectPlayer.play(AssetSource(sound));
  }

  @override
  void initState() {

    super.initState();
    Future.microtask((){
    Get.find<HomeController>().stopBackgroundSound();
    getWellNessData();});
  }

  void handleKeyboardInput(String letter) async{
    letter = letter.toUpperCase();

    if (incorrectLetters.contains(letter)) return;

    bool letterIsCorrect = correctWord.contains(letter);

    if (letterIsCorrect) {
      // Play correct sound
      _playConfettiSound(sound: AppAssets.correctAnswerSound);

      // Reveal ALL matching letters
      List<int> revealIndices = [];
      for (int i = 0; i < correctWord.length; i++) {
        if (correctWord[i] == letter) {
          controllers![i].text = letter;
          revealIndices.add(i);
        }
      }

      // Add glow effect
      setState(() {
        correctLetters.add(letter);
        glowingIndices = revealIndices;
      });

      // Remove glow after delay
      glowTimer?.cancel();
      glowTimer = Timer(const Duration(milliseconds: 500), () {
        setState(() => glowingIndices = []);
      });

      // Check win condition
      if (isWordComplete()){
        // showDialog(
        //   useSafeArea: false,
        //   barrierDismissible: false,
        //   context: context,
        //   builder: (BuildContext context) {
        //     return DialogScreen(showText: 'terrific',correctAnswer: correctWord);
        //   },
        // );
        await getWellNessResultApi(
        wellnessId: modelWell.data?.id??0,
        wellnessGameId: modelWell.data?.wellnessGameId??0,
        answer: modelWell.data?.revealedMedicalTerm??0,
        stuck: revelCount>0?1:0,stuckCount: revelCount,
        time: 20,
        wheelPoint: stopWheelPoint, lives: lives).then((value){
          if(value.status==true){

            Get.to(WheelOfWellnessResult(showText: 'terrific',correctAns: {
            "id": modelWell.data?.id??0,
            "wellness_game_id": modelWell.data?.wellnessGameId??0,
            "hidden_medical_term": modelWell.data?.hiddenMedicalTerm??'',
            "club": modelWell.data?.club??'',
            "revealed_medical_term": modelWell.data?.revealedMedicalTerm??"",
            "description": modelWell.data?.description??'',
            "stuck": isRevel,
            "time": 20,
            "answer": "wrong",
            "wheel_Point": stopWheelPoint,

            },hP: value.data!)); // yaaaaaa
            timerKey.currentState?.timer?.cancel();
          }
        });}
    }
    else {

      // Play wrong sound
      _playConfettiSound(sound: AppAssets.wrongAnswerSound);
      setState(() {
        incorrectLetters.add(letter);
        apolloPrint(message: "incrorere:::$incorrectLetters");
        if (lives > 0) lives--;
      });

      // Check lose condition
      if (lives <= 0) {
        showDialog(
          useSafeArea: false,
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return DialogScreen(showText: 'gameOver',
              correctAnswer: {
            "id": modelWell.data?.id??0,
            "wellness_game_id": modelWell.data?.wellnessGameId??0,
            "hidden_medical_term": modelWell.data?.hiddenMedicalTerm??'',
            "club": modelWell.data?.club??'',
            "revealed_medical_term": modelWell.data?.revealedMedicalTerm??"",
            "description": modelWell.data?.description??'',
            "stuck": isRevel,
            "stuckCount": revelCount,
            "time": 20,
            "lives": lives,
            "answer": "wrong",
            "wheel_Point": stopWheelPoint,
            },
            );
          },
        );
        timerKey.currentState?.timer?.cancel();
      }
    }
  }

  bool isWordComplete() {
    return controllers!.every((c) => c.text.isNotEmpty);
  }

  Widget _buildLetterBox(int index) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: controllers![index].text.isNotEmpty
            ? const Color(0XFFBFE6D4)
            : AppColors.whiteColor,
        border: Border.all(color: controllers![index].text.isEmpty?Color(0XFF6425C1):Colors.transparent),
        borderRadius: BorderRadius.circular(3),
        boxShadow: glowingIndices.contains(index)
            ? [
              BoxShadow(color: Colors.yellow, blurRadius: 8, spreadRadius: 2)]
            : [],
      ),
      alignment: Alignment.center,
      child: Text(
        controllers![index].text,
        style: const TextStyle(
            fontSize: 18,
            color: Color(0XFF3EA072),
            fontWeight: FontWeight.w400,
            fontFamily: 'Caprasimo'
        ),
      ),
    );
  }

  // api call
  WheelForWellnessModel modelWell = WheelForWellnessModel();
  getWellNessData() async{
    showLoader(true);
    await wheelForWellnessApi().then((value){
      modelWell = value;
      if(value.data!=null){
        correctWord = value.data!.revealedMedicalTerm?.toUpperCase()??"";
        lives = value.data!.live??0;
        controllers = List.generate(
          correctWord.length, (index) => TextEditingController(),
        );
      }
      else{ CustomSnackBar().showSnack(Get.context!,message: '${value.message}', isSuccess: false); }
      showLoader(false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        image: DecorationImage(image: AssetImage(AppAssets.notificationsBg),fit: BoxFit.cover)
      ),
      child: Scaffold( backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  addHeight(10),

                  // Top Bar
                  backBar(
                    title: "Wheel of Wellness",
                    isCancel: true,
                    isBack: false,

                    onTapCancel: () {
                      showLeaveQuizSheet(context, () async{ Get.back();Get.back(); }, isWheelOfWellness: true);
                    },
                  ).marginSymmetric(horizontal: 16),
                  Expanded(
                      child: Column(
                      children: [
                        addHeight(16),
                        // Wheel
                        SizedBox(
                          height: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [

                              SvgPicture.asset(AppAssets.spinBGImg,),
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFFFFD93B), // Outer border color
                                      width: 10,
                                    ),
                                    boxShadow: []
                                ),
                                child: FortuneWheel(
                                  physics: NoPanPhysics(),
                                  selected: selected.stream,
                                  animateFirst: false,
                                  items: [
                                    for (var it in items)
                                      FortuneItem(
                                        child: addText400(
                                          '${it.item}',
                                          fontSize: 26,
                                          fontFamily: 'Caprasimo',
                                          color: Colors.white,

                                        ).marginOnly(left: 42),
                                        style: FortuneItemStyle(

                                          color: it.color!,
                                          borderColor: Colors.transparent,
                                          // borderWidth: 10
                                          // borderWidth: 10,
                                        ),

                                      ),
                                  ],

                                  indicators: <FortuneIndicator>[
                                    FortuneIndicator(
                                      child: SizedBox(),
                                    ),
                                  ],
                                ),
                              ).marginAll(14),
                              Positioned(
                                bottom: 50,
                                top: 0,
                                child: SpinButton(
                                    onTap: () {

                                      if(isSpine==false && modelWell.data!=null){
                                  _playConfettiSound(sound: AppAssets.wheelSpin);
                                  apolloPrint(message: 'Spin tapped');
                                  timerKey.currentState?.startTimer();
                                  int randomIndex = Random().nextInt(items.length);
                                  selected.add(randomIndex);
                                  stopWheelPoint = int.parse('${items[randomIndex].item}');
                                  setState(() {isSpine=true;});
                                  apolloPrint(message: '${items[randomIndex].item}');


                                  wfwDailyLimitApi(wellnessGameId: modelWell.data?.wellnessGameId??0); // to stop after 5 time hit


                                } },
                                    isSpine: isSpine),
                                /*child: GestureDetector(
                                  onTap: () {
                                    if(isSpine==false && modelWell.data!=null){
                                      _playConfettiSound(sound: AppAssets.wheelSpin);
                                      apolloPrint(message: 'Spin tapped');
                                      timerKey.currentState?.startTimer();
                                      int randomIndex = Random().nextInt(items.length);
                                      selected.add(randomIndex);
                                      stopWheelPoint = int.parse('${items[randomIndex].item}');
                                      setState(() {isSpine=true;});
                                      apolloPrint(message: '${items[randomIndex].item}');
                                    }

                                  },
                                  child: SvgPicture.asset(AppAssets.spinIndicatorImg),
                                ),*/
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  height: 26,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CountdownTimerWidgetWellness(
                                          correctWord: correctWord,
                                          duration: 3,
                                          key: timerKey,
                                          isInSecondsMode: false,
                                      onTick: (sec){
                                            if(sec==0) {
                                              showDialog(
                                          useSafeArea: false,
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogScreen(showText: 'gameOver',correctAnswer: {
                                            "id": modelWell.data?.id??0,
                                            "wellness_game_id": modelWell.data?.wellnessGameId??0,
                                            "hidden_medical_term": modelWell.data?.hiddenMedicalTerm??'',
                                            "club": modelWell.data?.club??'',
                                            "revealed_medical_term": modelWell.data?.revealedMedicalTerm??"",
                                            "description": modelWell.data?.description??'',
                                            "stuck": isRevel,
                                            "stuckCount": revelCount,
                                            "time": 20,
                                            "lives": lives,
                                            "answer": "wrong",
                                            "wheel_Point": stopWheelPoint},);
                                          },
                                        );
                                            }
                                      },

                                      ),
                                      isRevel
                                          ? SizedBox.shrink()
                                          : GestureDetector(
                                        onTap: () async{
                                          if (isSpine == true && isRevel == false && lives > 0) {
                                            List<int> emptyIndices = [];
                                            for (int i = 0; i < controllers!.length; i++) {
                                              if (controllers![i].text.isEmpty) {
                                                emptyIndices.add(i);
                                              }
                                            }
                                            if (emptyIndices.isNotEmpty) {
                                              int randomIndex = emptyIndices[Random().nextInt(emptyIndices.length)];
                                              String letterToReveal = correctWord[randomIndex];
                                              List<int> allMatchingIndices = emptyIndices
                                                  .where((i) => correctWord[i] == letterToReveal)
                                                  .toList();
                                              for (int idx in allMatchingIndices) {
                                                controllers![idx].text = letterToReveal;
                                                correctLetters.add(letterToReveal.toUpperCase());
                                              }

                                              _playConfettiSound(sound: AppAssets.correctAnswerSound);

                                              setState(() {
                                                revelCount = revelCount + 1;
                                                if (revelCount == 2) {
                                                  isRevel = true;
                                                }
                                                glowingIndices = allMatchingIndices;
                                              });
                                              glowTimer?.cancel();
                                              glowTimer = Timer(const Duration(milliseconds: 500), () {
                                                setState(() => glowingIndices = []);
                                              });

                                              if (isWordComplete()){

                                                await getWellNessResultApi(
                                                    wellnessId: modelWell.data?.id??0,
                                                    wellnessGameId: modelWell.data?.wellnessGameId??0,
                                                    answer: modelWell.data?.revealedMedicalTerm??0,
                                                    stuck: revelCount>0?1:0,stuckCount: revelCount,
                                                    time: 20,
                                                    wheelPoint: stopWheelPoint, lives: lives).then((value){
                                                  if(value.status==true){

                                                    Get.to(WheelOfWellnessResult(showText: 'terrific',correctAns: {
                                                      "id": modelWell.data?.id??0,
                                                      "wellness_game_id": modelWell.data?.wellnessGameId??0,
                                                      "hidden_medical_term": modelWell.data?.hiddenMedicalTerm??'',
                                                      "club": modelWell.data?.club??'',
                                                      "revealed_medical_term": modelWell.data?.revealedMedicalTerm??"",
                                                      "description": modelWell.data?.description??'',
                                                      "stuck": isRevel,
                                                      "time": 20,
                                                      "answer": "wrong",
                                                      "wheel_Point": stopWheelPoint,

                                                    },hP: value.data!)); // yaaaaaa
                                                    timerKey.currentState?.timer?.cancel();
                                                  }
                                                });}
                                            }

                                          }
                                        },

                                        /*onTap: (){  // before 29 aug 2025

                                          if(isSpine==true && isRevel==false && lives > 0){
                                            List<int> emptyIndices = []; // find empty indices
                                            for (int i = 0; i < controllers!.length; i++) {
                                              if (controllers![i].text.isEmpty) {
                                                emptyIndices.add(i);
                                              }
                                            }

                                            if (emptyIndices.isNotEmpty) { // Reveal a random empty letter
                                              int randomIndex = emptyIndices[Random()
                                                  .nextInt(
                                                  emptyIndices.length)];
                                              String letter = correctWord[randomIndex];
                                              controllers![randomIndex].text =
                                                  letter;
                                              correctLetters.add(
                                                  letter.toUpperCase());
                                              _playConfettiSound(
                                                  sound: AppAssets.correctAnswerSound);

                                              setState(() { // Decrease lives
                                                revelCount = revelCount+1;

                                                if(revelCount==2){
                                                  isRevel = true;
                                                }
                                                // lives = lives > 0 ? lives - 1 : 0;
                                                glowingIndices = [randomIndex];
                                              });

                                              // timer to stop glowing after a short period
                                              glowTimer?.cancel();
                                              glowTimer = Timer(const Duration(
                                                  milliseconds: 500), () {
                                                setState(() =>
                                                glowingIndices = []);
                                              });
                                            }}
                                        },*/
                                        child: Container(
                                          height: 26,
                                          width: 32,
                                          // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                          decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              border: Border.all(color: AppColors.yellowColor),
                                              borderRadius: BorderRadius.circular(10)),
                                          child: SvgPicture.asset(
                                            AppAssets.handLineImg,height: 22,width: 18,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ])),

                        // Lives counter
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: addText500('${correctWord.length} Letters',fontSize: 16,color: AppColors.whiteColor),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: addText500('$lives Lives',fontSize: 16,color: AppColors.whiteColor),
                            ),
                          ],
                        ),
                        addHeight(10),

                        // if(modelWell.data!=null)
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        if(modelWell.data!=null)
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 0.0, // Adjust spacing between boxes
                            runSpacing: 2.0, // Optional: spacing if wrapped to new line
                          children: List.generate(
                              correctWord.length, (index) { return _buildLetterBox(index);}),
                        ),

                        addHeight(14),

                        // Question
                        if(isSpine && modelWell.data!=null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: addText600( //semi-bold
                              "${modelWell.data?.club}",
                              textAlign: TextAlign.center,
                              fontSize: 16, color: Color(0XFF222222),height: 18
                          ),
                        ),
                        addHeight(10),


                      ]).marginSymmetric(horizontal: 16))


                  // Keyboard

                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: isSpine && lives>0
            ? MediaQuery.removePadding(
          context: context,
          removeBottom: Platform.isIOS ? true : false,
          removeTop: true,
          child: BottomAppBar(
            elevation: 0,
            color: Color(0xffABB0BC),
            child: SizedBox(
              height: 170,

              child: CustomKeyboard(
                correctAnswer: correctWord,
                onKeyTap: handleKeyboardInput,
                correctLetters: correctLetters,
                incorrectLetters: incorrectLetters,
              ),
            ).marginOnly(bottom: 35,top: 4),
          ),
        )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    glowTimer?.cancel();
    super.dispose();
  }
}




