import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:apollo/Dialogues/transparent_dialogue.dart';
import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/stuck_reveal_a_letter_bottom_sheet.dart';
import 'package:apollo/custom_widgets/custom_keyboard_game.dart';

import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';

import 'package:apollo/resources/countdown_timer_wellness.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/dashboard/home_screen.dart';
import 'package:apollo/screens/game_mode/wheel_of_wellness/wheel_of_wellness_result_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class WheelOfWellnessScreen extends StatefulWidget {
  const WheelOfWellnessScreen({super.key});

  @override
  State<WheelOfWellnessScreen> createState() => _WheelOfWellnessScreenState();
}

class _WheelOfWellnessScreenState extends State<WheelOfWellnessScreen> {
  final GlobalKey<CountdownTimerWidgetWellnessState> timerKey = GlobalKey();
  final GlobalKey<HomeScreenState> stopSound = GlobalKey<HomeScreenState>();
  bool isSpine = false;
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
  final String correctWord = "HYPERTENSION";
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  int lives = 5;
  bool isCorrect = false;
  List<String> guessedLetters = ['H', 'E', 'E'];

  Future<void> _playConfettiSound({required String sound}) async {
    await _effectPlayer.play(AssetSource(sound));
  }

  Set<String> correctLetters = {};
  Set<String> incorrectLetters = {};
  List<int> glowingIndices = [];
  Timer? glowTimer;

  @override
  void initState() {

    super.initState();
    stopSound.currentState?.stopBackgroundSound();
    controllers = List.generate(
      correctWord.length, (index) => TextEditingController(),
    );
  }

  void handleKeyboardInput(String letter) {
    letter = letter.toUpperCase();
    bool letterIsCorrect = correctWord.contains(letter);

    if (letterIsCorrect) {
      // Play correct sound
      _playConfettiSound(sound: AppAssets.correctAnswerSound);

      // Reveal ALL matching letters
      List<int> revealIndices = [];
      for (int i = 0; i < correctWord.length; i++) {
        if (correctWord[i] == letter) {
          controllers[i].text = letter;
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
      if (isWordComplete()) {
        // showDialog(
        //   useSafeArea: false,
        //   barrierDismissible: false,
        //   context: context,
        //   builder: (BuildContext context) {
        //     return DialogScreen(showText: 'terrific',correctAnswer: correctWord);
        //   },
        // );

        Get.to(WheelOfWellnessResult(showText: 'terrific',correctAns: correctWord));
      }
    } else {
      // Play wrong sound
      _playConfettiSound(sound: AppAssets.wrongAnswerSound);

      setState(() {
        incorrectLetters.add(letter);
        if (lives > 0) lives--;
      });

      // Check lose condition
      if (lives <= 0) {
        // showGameOverDialog(isWin: false);

        showDialog(
          useSafeArea: false,
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return DialogScreen(showText: 'gameOver',correctAnswer: correctWord);
          },
        );

      }
    }
  }

  bool isWordComplete() {
    return controllers.every((c) => c.text.isNotEmpty);
  }

  Widget _buildLetterBox(int index) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: controllers[index].text.isNotEmpty
            ? const Color(0XFFBFE6D4)
            : AppColors.whiteColor,
        border: Border.all(color: controllers[index].text.isEmpty?Color(0XFF6425C1):Colors.transparent),
        borderRadius: BorderRadius.circular(3),
        boxShadow: glowingIndices.contains(index)
            ? [
              BoxShadow(color: Colors.yellow, blurRadius: 8, spreadRadius: 2)]
            : [],
      ),
      alignment: Alignment.center,
      child: Text(
        controllers[index].text,
        style: const TextStyle(
            fontSize: 18,
            color: Color(0XFF3EA072),
            fontWeight: FontWeight.w400,
            fontFamily: 'Caprasimo'
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Bar
                backBar(
                  title: "Wheel of Wellness",
                  isCancel: true,
                  isBack: false,

                  onTapCancel: () {
                    showLeaveQuizSheet(context,
                            () async{
                              // await _effectPlayer.play(AssetSource(AppAssets.actionButtonTapSound));
                      Get.back();
                      Get.back();
                      },
                        isWheelOfWellness: true);
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
                              child: GestureDetector(
                                onTap: () {
                                  if(isSpine==false){
                                    _playConfettiSound(sound: AppAssets.wheelSpin);
                                    apolloPrint(message: 'Spin tapped');
                                    timerKey.currentState?.startTimer();
                                    int randomIndex = Random().nextInt(items.length);
                                    selected.add(randomIndex);
                                    setState(() {isSpine=true;});
                                    // _playBackgroundSound();

                                  }

                                },
                                child: SvgPicture.asset(AppAssets.spinIndicatorImg),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CountdownTimerWidgetWellness(
                                      correctWord: correctWord,
                                      duration: 2,
                                      key: timerKey,
                                      isInSecondsMode: false),
                                  GestureDetector(
                                    onTap: (){
                                      showStuckRevealLetterSheet(context,onTapEliminate: (){
                                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                                      });
                                    },
                                    child: Container(
                                      height: 36,
                                      width: 44,
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          border: Border.all(color: AppColors.yellowColor),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: SvgPicture.asset(
                                        AppAssets.handLineImg,height: 24,width: 24,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Lives counter
                      Align(
                        alignment: Alignment.centerRight,
                        child: addText500('$lives Lives',fontSize: 16,color: AppColors.whiteColor),
                      ),
                      addHeight(10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            correctWord.length, (index) { return _buildLetterBox(index);}),
                      ),

                      addHeight(14),

                      // Question
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: addText400(
                            "When your blood pressure stays too high, even when you’re resting.",
                            textAlign: TextAlign.center,
                            fontSize: 14, color: Color(0XFF222222),height: 18
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
      bottomNavigationBar: isSpine && lives>0?MediaQuery.removePadding(
        context: context,
        removeBottom: Platform.isIOS ? true : false,
        removeTop: true,
        child: BottomAppBar(
          elevation: 0,
          color: Color(0xffABB0BC),
          child: Container(
            height: 170,

            child: CustomKeyboard(
              correctAnswer: correctWord,
              onKeyTap: handleKeyboardInput,
              correctLetters: correctLetters,
              incorrectLetters: incorrectLetters,
            ),
          ).marginOnly(bottom: 35,top: 4),
        ),
      ) : null,
    );
  }

  @override
  void dispose() {
    glowTimer?.cancel();
    super.dispose();
  }
}


/*class _WheelOfWellnessScreenState extends State<WheelOfWellnessScreen> {
  final GlobalKey<CountdownTimerWidgetWellnessState> timerKey = GlobalKey();
  bool isSpine = false;
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
  final String correctWord = "HYPERTENSION";

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  int lives = 10;
  bool isCorrect = false;

  List<String> guessedLetters = ['H', 'E', 'E']; // <-- Add this line
  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      correctWord.length, (index) => TextEditingController(),
    );
    focusNodes = List.generate(correctWord.length, (index) => FocusNode(),
    );

    // Auto fill the guessed letters
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fillWithGuessedLetters();
    });
  }

  void fillWithGuessedLetters() {
    Map<String, int> guessedMap = {};
    for (var letter in guessedLetters) {
      guessedMap[letter] = (guessedMap[letter] ?? 0) + 1;
    }

    for (int i = 0; i < correctWord.length; i++) {
      String actualLetter = correctWord[i];
      if (guessedMap.containsKey(actualLetter) && guessedMap[actualLetter]! > 0) {
        controllers[i].text = actualLetter;
        guessedMap[actualLetter] = guessedMap[actualLetter]! - 1;
      } else {
        controllers[i].clear();
      }
    }

    setState(() {});
  }

  void checkAnswer() {
    String userInput = controllers.map((c) => c.text.toUpperCase()).join();
    if (userInput == correctWord) {
      setState(() {
        isCorrect = true;
      });
      // CustomSnackBar().showSuccessSnackBar(context,message: 'Correct!, You got the right answer 🎉');
      showDialog(
        useSafeArea: false,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogScreen(showText: 'terrific',correctAnswer: correctWord);
        },
      );
    } else {
      setState(() {
        lives--;
        isCorrect = false;
      });
      showDialog(
        useSafeArea: false,
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogScreen(showText: 'tryAgain',correctAnswer: correctWord);
        },
      );
      // CustomSnackBar().showErrorSnackBar(context,message: 'Wrong!, Try again. Lives left: $lives');

    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void moveToNext(int index, String value) {
    if (value.isNotEmpty && index < controllers.length - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      // Check if the entered letter matches the correct letter at this position
      bool isCorrectLetter = correctWord[index].toUpperCase() == value.toUpperCase();
      if (!isCorrectLetter) {
        setState(() {
          lives--;
          isCorrect = false;
        });
      } else {
        setState(() {
          isCorrect = true;
        });
      }
    }
  }

  void handleKeyboardInput(String letter) {
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) {

        if (correctWord[i].toUpperCase() == letter.toUpperCase()) {
          controllers[i].text = letter.toUpperCase();
          setState(() {
            isCorrect = true;
          });

          if (i < controllers.length - 1) {
            FocusScope.of(context).requestFocus(focusNodes[i + 1]);
          }
        } else {

          setState(() {
            if(lives>0) {
              lives--;
            }
            isCorrect = false;
            showDialog(
              useSafeArea: false,
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return DialogScreen(showText: 'terrific',correctAnswer: correctWord);
              },
            );
          });

        }
        break;
      }
    }
    // Optionally check if all fields are filled and check answer
    bool allFilled = controllers.every((c) => c.text.trim().isNotEmpty);
    if (allFilled) {
      FocusScope.of(context).unfocus();
      checkAnswer();
    }
  }

  void handleBackspace() {

    for (int i = controllers.length - 1; i >= 0; i--) {
      if (controllers[i].text.isNotEmpty) {
        controllers[i].clear();
        setState(() {});
        FocusScope.of(context).requestFocus(focusNodes[i]);
        break;
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Bar
                backBar(
                  title: "Wheel of Wellness",
                  onTap: () {
                    Get.back();
                  },
                ).marginSymmetric(horizontal: 16),

                Expanded(child: Column(
                  children: [
                  addHeight(16),
                  
                  // Timer and Stuck


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
                            child: GestureDetector(
                              onTap: () {
                                if(isSpine==false){
                                  apolloPrint(message: 'Spin tapped');
                                  timerKey.currentState?.startTimer();
                                  int randomIndex = Random().nextInt(items.length);
                                  selected.add(randomIndex);
                                  setState(() {isSpine=true;});
                                }

                              },
                              child: SvgPicture.asset(
                                AppAssets.spinIndicatorImg,
                                // height: 60,
                                // width: 60,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CountdownTimerWidgetWellness(
                                  key: timerKey,
                                    duration: 5,isInSecondsMode: false),
                                GestureDetector(
                                  onTap: (){
                                    showStuckRevealLetterSheet(context);
                                  },
                                  child: Container(
                                    height: 36,
                                    width: 44,
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                    decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        border: Border.all(color: AppColors.yellowColor),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: SvgPicture.asset(
                                      AppAssets.handLineImg,height: 24,width: 24,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: addText500('$lives Lives',fontSize: 16,color: AppColors.whiteColor),
                    ),
                    addHeight(10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(correctWord.length, (index) {
                          return SizedBox(
                            width: 26,
                            height: 28,
                            child: TextField(
                              cursorHeight: 10,
                              controller: controllers[index],
                              focusNode: focusNodes[index],
                              textAlign: TextAlign.center,
                              autocorrect: false,
                              readOnly: true, // <-- prevents system keyboard
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')),
                              ],
                              textCapitalization: TextCapitalization.characters,
                              maxLength: 1,
                              style: TextStyle(
                                fontSize: 18,
                                  color: Color(0XFF3EA072), // Make
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Caprasimo'
                              ),
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                // fillColor: Color(0XFFBFE6D4),
                                fillColor: controllers[index].text.isNotEmpty? Color(0XFFBFE6D4):AppColors.whiteColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  borderSide: const BorderSide(color: Colors.transparent),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  borderSide: const BorderSide(color: Colors.transparent),
                                ),
                                  focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  borderSide: const BorderSide(color: Colors.transparent),
                                )
                              ),
                              onChanged: (val) {
                                setState(() {});
                                moveToNext(index, val);

                                // Focus next empty box if exists
                                final nextEmpty = controllers.indexWhere((c) => c.text.trim().isEmpty);
                                if (nextEmpty != -1) {
                                  FocusScope.of(context).requestFocus(focusNodes[nextEmpty]);
                                }

                                // check if all are filled
                                bool allFilled = controllers.every((c) => c.text.trim().isNotEmpty);
                                if (allFilled) {
                                  FocusScope.of(context).unfocus();
                                  checkAnswer();
                                }
                              },
                            ).marginOnly(right: index !=correctWord.length-1?2:0),
                          );})
                      ]),
                    addHeight(10),

                    // Question
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: addText400(
                        "When your blood pressure stays too high, even when you’re resting.",
                        textAlign: TextAlign.center,
                        fontSize: 14, color: Color(0XFF222222),height: 18
                      ),
                    ), 
                    addHeight(10),


                  ]).marginSymmetric(horizontal: 16))

              ],
            ),
          )


        ],
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: Platform.isIOS ? true : false,
        removeTop: true,
        child: BottomAppBar(
          elevation: 0,
          color: Color(0xffABB0BC),
          child: Container(
            height: 170,

            // child: CustomKeyboard(
            //   correctAnswer: correctWord,
            //   onKeyTap: (letter) {
            //     if (lives > 0) {
            //       handleKeyboardInput(letter);
            //     } else {
            //       handleKeyboardInput('');
            //     }
            //   },
            //
            //   onBackspace: handleBackspace,
            //     ),
          ).marginOnly(bottom: 35,top: 4),
        ),
      ),
    );
  }
}*/

class WheelItem{
  String? item;
  Color? color;
  WheelItem({this.item,this.color});
}