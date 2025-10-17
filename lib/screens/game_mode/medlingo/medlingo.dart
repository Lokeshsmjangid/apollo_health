import 'dart:math' as Math;
import 'dart:math';

import 'package:apollo/Dialogues/medlingo_game_over_dialogue.dart';
import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/controllers/madlingo_ctrls/medlingo_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_repository/medlingo_result_repo.dart';
import 'package:apollo/resources/Apis/api_repository/quit_medlingo_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/game_mode/medlingo/medlingo_result_screen.dart';
import 'package:apollo/screens/game_mode/medlingo/medlingo_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// import 'package:apollo/resources/Apis/api_models/medlingo_start_model.dart';
class MedLingoWordGame extends StatefulWidget {
  // final String word; // Correct answer
  // final String imageUrl;
  // MedLingoData? gameData;

  MedLingoWordGame({
    super.key,
    // required this.word,
    // required this.imageUrl,
    // this.gameData
  });

  @override
  State<MedLingoWordGame> createState() => _MedLingoWordGameState();
}

class _MedLingoWordGameState extends State<MedLingoWordGame> {
  // late List<String?> answerBoxes;
  // late List<String> availableLetters;

  // for hand
  // bool isStuck = false;
  // bool _attemptStarted = false;

  @override
  void initState() {
    super.initState();
    // answerBoxes = List.generate(widget.word.length, (_) => null);

    // Split letters and shuffle to display in circle
    // availableLetters = widget.word.split('');
    // availableLetters.shuffle();
  }

  /*bool _hasNavigated = false;
  bool get isAnswerComplete => !answerBoxes.contains(null);
  void _checkAndNavigate() {
    if (isAnswerComplete && !_hasNavigated) {
      _hasNavigated = true;
      final userAnswer = answerBoxes.map((e) => e ?? '').join('');
      final correct = userAnswer == widget.word;
      if (correct) {
        Get.to(MedLingoResult(showText: 'terrific', correctAns: widget.word));
      } else {
        Get.to(MedLingoResult(showText: 'tryAgain', correctAns: widget.word));
      }
    }
  }

  void _onLetterDroppedToBox(int boxIndex, String letter, {int? fromBox}) {
    setState(() {
      _attemptStarted = true;
      if (fromBox != null) {
        final prevLetter = answerBoxes[boxIndex];
        answerBoxes[boxIndex] = letter;
        answerBoxes[fromBox] = prevLetter;
      } else {
        if (answerBoxes[boxIndex] != null) {
          availableLetters.add(answerBoxes[boxIndex]!);
        }
        answerBoxes[boxIndex] = letter;
        availableLetters.remove(letter);
      }
      // _checkAndNavigate();  // Check after updating
    });
  }

  void _onLetterDroppedToPad(String letter) {
    setState(() {
      int idx = answerBoxes.indexOf(letter);
      if (idx != -1) {
        answerBoxes[idx] = null;
        availableLetters.add(letter);
      }
    });
    _hasNavigated = false;
  }

  Widget _dragLetter(String letter, {Color bg = const Color(0xFF7952C3)}) => Container(
    width: 34,
    height: 34,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      // Uncomment below if you want colored circles
      // color: bg,
      // boxShadow: [
      //   BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 3, offset: Offset(0, 2))
      // ],
      // border: Border.all(color: Colors.white, width: 2)
    ),
    child: addText400(letter.toUpperCase(),fontFamily: 'Caprasimo',fontSize: 26,height: 34),
  );*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: addText400("MedLingo",
            fontSize: 32,
            color: Colors.white,
            fontFamily: 'Caprasimo',
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                showLeaveQuizSheet(context, () async {

                  quitMedLingoApi(gameId: Get.find<MedlingoCtrl>().gameData!.medlingoGameId??0);
                  Get.back();
                  Get.back();
                }, isWheelOfWellness: true);
              },
              child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    // color: Colors.red,
                      shape: BoxShape.circle
                  ),
                  child: Image.asset(AppAssets.closeIcon, height: 24).marginAll(
                      6))).marginSymmetric(horizontal: 10)
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            image: DecorationImage(
                image: AssetImage(AppAssets.notificationsBg), fit: BoxFit.cover)
        ),
        child: SafeArea(
          bottom: false,
          child: GetBuilder<MedlingoCtrl>(builder: (logic) {
            return Column(
              children: [
                // addHeight(10),
            // Photo credit links
                if(logic.gameData!.photoBy!=null && logic.gameData!.photoBy!.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => launchURL(url: logic.gameData!.photoByUrl ?? ''), //photoByUrl
                          child: addText600(
                            '${logic.gameData!.photoBy ?? 'lokesh'} / ',
                            color: AppColors.purpleLightColor,
                            fontSize: 9,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => launchURL(url: logic.gameData!.imageUrlUnsplash ?? ''), // imageUrlUnsplash
                          child: addText600(
                            'Unsplash',
                            color: AppColors.purpleLightColor,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ).marginSymmetric(horizontal: 14),
                if(logic.gameData!.photoBy!=null && logic.gameData!.photoBy!.isNotEmpty)
                  SizedBox(height: 4),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.yellow150Color),
                        boxShadow: [
                          BoxShadow(blurRadius: 8,
                              color: Colors.black12,
                              offset: Offset(0, 2))
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedImageCircle2(imageUrl: logic.imageUrl,
                            width: double.infinity,
                            // width: MediaQuery.sizeOf(context).width * 0.8,
                            height: 172.64,
                            isCircular: false),
                      )
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      left: 10,
                      child: SizedBox(
                        height: 26,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CountdownTimerWidgetMedlingo(
                              duration: 3,
                              correctWord: logic.word,
                              isInSecondsMode: false,
                              onTick: (sec) {
                                if (sec == 0) {

                                  final userAnswer = logic.answerBoxes!.map((e) => e ?? '').join('');
                                  if (userAnswer.isNotEmpty && userAnswer.length == logic.answerBoxes!.length) {
                                    final correct = userAnswer == logic.word;
                                    if (correct && !logic.timeOver) {
                                      logic.timeOver=true;
                                      logic.update();
                                      showLoader(true);
                                      getMedLingoResultApi(
                                          medLingoId: logic.gameData!.id,
                                          gameId: logic.gameData!.medlingoGameId,
                                          time: sec,
                                          stuck: logic.isStuck ? 1 : 0,
                                          stuckCount: logic.attemptCount,
                                          answer: userAnswer).then((
                                          result) {
                                        showLoader(false);
                                        if (result.status == true && result.data != null) {

                                          Get.to(()=>MedLingoResult(
                                            showText: 'terrific',
                                            correctAns: logic.word,
                                            hP: result.data!.xp ?? 0,
                                            showDesc: result.data!.explanation ?? "",));
                                        }
                                        else if (result.status == false) {
                                          CustomSnackBar().showSnack(
                                              Get.context!, isSuccess: false,
                                              message: '${result.message}');
                                        }
                                      });
                                    }
                                  }
                                  else {
                                    if(!logic.hasQuit){
                                      logic.hasQuit = true;
                                      logic.update();
                                      quitMedLingoApi(gameId: logic.gameData!.medlingoGameId??0);
                                      showDialog(
                                        useSafeArea: false,
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MedlingoGameOverDialog(showText: 'gameOver',gameStates: {
                                            "correctAns": logic.word,
                                            "hP": 0,
                                            "showDesc": logic.gameData!.explanation ?? "",
                                          });
                                        },
                                      );
                                      // Get.to(()=>MedLingoResult(
                                      //     showText: 'tryAgain',
                                      //     correctAns: logic.word,
                                      //     hP: 0,
                                      //     showDesc: logic.gameData!
                                      //         .explanation ?? ""));
                                    }

                                  }
                                }
                              },
                            ),
                            if (!logic.attemptStarted)
                              GestureDetector(

                                onTap: () {

                                  logic.isStuck = true; // to send value in api

                                  logic.update();

                                  // 🔥 Instead of excluding repeated letters, just check each position

                                  List<int> eligiblePositions = [];

                                  for (int i = 0; i < logic.word!.length; i++) {

                                    String correctLetter = logic.word![i];

                                    // If box empty OR wrong letter → eligible for hint

                                    if (logic.answerBoxes![i] == null || logic.answerBoxes![i] != correctLetter) {

                                      eligiblePositions.add(i);

                                    }

                                  }

                                  // Pick a random eligible position and fill it

                                  if (eligiblePositions.isNotEmpty) {

                                    int randomPos = eligiblePositions[Random().nextInt(eligiblePositions.length)];

                                    String correctLetter = logic.word![randomPos];

                                    // ✅ FIX: if a wrong letter is already in that position → return it to availableLetters

                                    String? existingLetter = logic.answerBoxes![randomPos];

                                    if (existingLetter != null && existingLetter != correctLetter) {

                                      logic.availableLetters!.add(existingLetter);

                                    }

                                    // ✅ Place hint letter only if available in wheel

                                    if (logic.availableLetters!.contains(correctLetter)) {

                                      logic.answerBoxes![randomPos] = correctLetter;

                                      logic.availableLetters!.remove(correctLetter);

                                      // ✅ attemptCount only when letter added

                                      logic.attemptCount = logic.attemptCount + 1;

                                      if (logic.attemptCount == 2) {

                                        logic.attemptStarted = true; // to hide hand

                                      }

                                    }

                                  }

                                  logic.update();

                                },




                                /*onTap: () {
                                  logic.isStuck = true; // to send value in api
                                  logic.update();

                                  //find repeated letters
                                  Map<String, int> letterCounts = {};
                                  for (var ch in logic.word!.split('')) {
                                    letterCounts[ch] = (letterCounts[ch] ?? 0) + 1;
                                  }

                                  // letters repeat more than one
                                  Set<String> repeatedLetters = letterCounts.entries
                                      .where((e) => e.value > 1)
                                      .map((e) => e.key)
                                      .toSet();

                                  // Find positions to give hint
                                  List<int> eligiblePositions = [];
                                  for (int i = 0; i < logic.word!.length; i++) {
                                    String correctLetter = logic.word![i];
                                    bool isRepeated = repeatedLetters.contains(correctLetter);

                                    if (!isRepeated &&
                                        (logic.answerBoxes![i] == null ||
                                            logic.answerBoxes![i] != correctLetter)) {
                                      eligiblePositions.add(i);
                                    }
                                  }

                                  // Pick a random eligible position and fill it
                                  if (eligiblePositions.isNotEmpty) {
                                    int randomPos = eligiblePositions[Random().nextInt(eligiblePositions.length)];
                                    String correctLetter = logic.word![randomPos];

                                    if (logic.availableLetters!.contains(correctLetter)) {
                                      logic.answerBoxes![randomPos] = correctLetter;
                                      logic.availableLetters!.remove(correctLetter);

                                      // ✅ attemptCount only when letter added
                                      logic.attemptCount = logic.attemptCount + 1;

                                      if (logic.attemptCount == 2) {
                                        logic.attemptStarted = true; // to hide hand
                                      }
                                    }
                                  }

                                  logic.update();
                                },*/



                                // working code 1
                                /*onTap: () {
                                  // setState(() {
                                    logic.isStuck = true; // to send value in api

                                    logic.attemptCount = logic.attemptCount+1;
                                    logic.update();
                                    if(logic.attemptCount==2){
                                      logic.attemptStarted = true; // to hide hand
                                    }

                                    //find repeated letters
                                    Map<String, int> letterCounts = {};
                                    for (var ch in logic.word!.split('')) {
                                      letterCounts[ch] =(letterCounts[ch] ?? 0) + 1;
                                    }

                                    // letters repeat more than one
                                    Set<String> repeatedLetters = letterCounts.entries.where((e) => e.value > 1).map((e) => e.key).toSet();

                                    // Find positions to give hint
                                    List<int> eligiblePositions = [];
                                    for (int i = 0; i < logic.word!.length; i++) {
                                      String correctLetter = logic.word![i];
                                      bool isRepeated = repeatedLetters
                                          .contains(correctLetter);

                                      if (!isRepeated && (logic.answerBoxes![i] == null || logic.answerBoxes![i] !=correctLetter)) {
                                        eligiblePositions.add(i);
                                      }
                                    }

                                    // Pick a random eligible position and filled it
                                    if (eligiblePositions.isNotEmpty) {
                                      int randomPos = eligiblePositions[Random().nextInt(eligiblePositions.length)];
                                      String correctLetter = logic.word![randomPos];

                                      if (logic.availableLetters!.contains(correctLetter)) {
                                        logic.answerBoxes![randomPos] = correctLetter;
                                        logic.availableLetters!.remove(correctLetter);
                                      }
                                    }
                                    logic.update();
                                  // });
                                },*/

                                child: Container(
                                  height: 26,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    border: Border.all(color: AppColors.yellowColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SvgPicture.asset(
                                    AppAssets.handLineImg,
                                    height: 22,
                                    width: 18,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).marginOnly(right: 10,left: 10),
                const SizedBox(height: 4),
                addText500(
                  logic.gameData!.clue??'',fontSize: 14, textAlign: TextAlign.center,
                  color: AppColors.whiteColor,height: 18).marginSymmetric(horizontal: 16),
                const SizedBox(height: 20),
                // Text('${logic.availableLetters}'),
                // Text('${logic.answerBoxes}'),

                // Answer boxes row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(logic.word!.length, (i) {
                    return DragTarget<Map<String, dynamic>>(
                      onWillAccept: (data) => i != data?['fromBox'],
                      onAccept: (data) {
                        logic.onLetterDroppedToBox(i, data['letter'], fromBox: data['fromBox']);
                      },

                      builder: (context, candidate, rejected) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: logic.answerBoxes![i] != null
                                ? const Color(0XFFBFE6D4) //
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: logic.answerBoxes![i] != null
                                  ? Colors.transparent
                                  : const Color(0xFF6FCF97),
                            ),
                            boxShadow: candidate.isNotEmpty
                                ? [
                              BoxShadow(
                                  color: AppColors.yellowColor, //
                                  blurRadius: 8,
                                  spreadRadius: 2)
                            ]
                                : [],
                          ),
                          child: logic.answerBoxes![i] == null
                              ? const SizedBox()
                              : Draggable<Map<String, dynamic>>(
                            data: {'letter': logic.answerBoxes![i], 'fromBox': i},
                            feedbackOffset: const Offset(-0, -50),
                            feedback: Transform.translate(
                              offset: const Offset(-0, -52),
                              child: Transform.scale(
                                scale: 1.0,
                                child: logic.dragLetterDisplay(
                                  logic.answerBoxes![i]!,
                                  textColor: AppColors.orangeColor,
                                ),
                              ),
                            ),
                            childWhenDragging: const SizedBox(),
                            child: addText400(
                              logic.answerBoxes![i]!,
                              fontSize: 18,
                              color: const Color(0XFF3EA072),
                              fontFamily: 'Caprasimo',
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 30),
                Container(
                  // height,width: 254,
                  width: 242,
                  height: 242,
                  decoration: BoxDecoration(
                    color: AppColors.yellow150Color, // Circle Bg Color
                    // borderRadius: BorderRadius.circular(127),
                    borderRadius: BorderRadius.circular(121),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),

                  child: DragTarget<Map<String, dynamic>>(
                    onWillAccept: (data) => data?['fromBox'] != null,    // Sirf box se aaye tab hi accept
                    onAccept: (data) {
                      logic.onLetterDroppedToPad(data['letter']);
                    },

                    builder: (context, candidate, rejected) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ...List.generate(logic.availableLetters!.length, (idx) {
                            final angle = (idx / logic.availableLetters!.length) * 2 * pi - pi / 2;
                            final radius = 82.6;
                            return Positioned(
                              left: 121 + radius * Math.cos(angle) - 17,
                              top: 121 + radius * Math.sin(angle) - 17,
                              child: Draggable<Map<String, dynamic>>(
                                data: {'letter': logic.availableLetters![idx], 'fromBox': null},
                                feedbackOffset: const Offset(-0, -52),
                                feedback: Transform.translate(
                                  offset: const Offset(0, -52),
                                  child: logic.dragLetter(logic.availableLetters![idx], idx),
                                ),
                                childWhenDragging: const SizedBox(width: 32, height: 32),
                                child: logic.dragLetter(logic.availableLetters![idx], idx),
                              ),
                            );
                          }),


                          /*...List.generate(logic.availableLetters!.length, (idx) {
                            final angle = (idx / logic.availableLetters!.length) * 2 * pi - pi / 2;
                            // final radius = 87.0;
                            final radius = 82.6;
                            return Positioned(
                              left: 121 + radius * Math.cos(angle) - 17,
                              top: 121 + radius * Math.sin(angle) - 17,
                              child: Draggable<Map<String, dynamic>>(
                                data: {
                                  'letter': logic.availableLetters![idx],
                                  'fromBox': null
                                },
                                // feedback: logic.dragLetter(logic.availableLetters![idx]),
                                feedbackOffset: const Offset(-0, -52),
                                feedback: Transform.translate(
                                  offset: Offset(0, -52),
                                  child: Transform.scale(
                                    scale: 1.0, // Increase value for even larger
                                    child: logic.dragLetter(
                                      logic.availableLetters![idx],
                                       textColor: Colors.orange,
                                    ),
                                  ),
                                ),
                                childWhenDragging: const SizedBox(width: 32, height: 32),

                                child: logic.dragLetter(logic.availableLetters![idx]),
                              ),
                            );
                          }),*/
                          GestureDetector(
                            onTap: () {
                              logic.availableLetters!.shuffle();
                              logic.update();
                            },
                            child: SvgPicture.asset(AppAssets.medlingoSuffleIcon),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                /*Container(
                  width: 254,
                  height: 254,
                  decoration: BoxDecoration(
                    color: AppColors.yellow150Color,
                    borderRadius: BorderRadius.circular(127),
                    // makes it a perfect circle
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Stack(alignment: Alignment.center,
                    children: [
                      ...List.generate(logic.availableLetters!.length, (idx) {
                        // final angle = (idx / availableLetters.length) * 2 * 3.14159265359;
                        // final radius = 87.0;
                        final angle = (idx / logic.availableLetters!.length) * 2 *
                            pi - pi / 2;
                        final radius = 87.0;
                        return Positioned(
                          left: 127 + radius * Math.cos(angle) - 17,
                          // 127 is center, 17 is half of letter size
                          top: 127 + radius * Math.sin(angle) - 17,
                          child: Draggable<Map<String, dynamic>>(
                            data: {
                              'letter': logic.availableLetters![idx],
                              'fromBox': null
                            },
                            feedback: logic.dragLetter(logic.availableLetters![idx]),
                            childWhenDragging: const SizedBox(
                                width: 32, height: 32),
                            child: DragTarget<Map<String, dynamic>>(
                              onWillAccept: (data) => data?['fromBox'] != null,
                              onAccept: (data) {
                                logic.onLetterDroppedToPad(data['letter']);
                              },
                              builder: (context, c, r) {
                                return logic.dragLetter(logic.availableLetters![idx]);
                              },
                            ),
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: () {
                          logic.availableLetters!.shuffle();
                          logic.update();
                          // setState(() {});
                        },
                        child: SvgPicture.asset(
                            AppAssets.medlingoSuffleIcon),
                      ),
                    ],
                  ),
                ),*/
                const SizedBox(height: 34),

                // Submit button
                AppButton(
                    buttonText: 'Submit',
                    buttonTxtColor: AppColors.primaryColor,
                    buttonColor: AppColors.whiteColor,
                    onButtonTap: () {
                      apolloPrint(message: '${logic.answerBoxes!.isNotEmpty}');
                      apolloPrint(message: '${logic.answerBoxes!.length}');
                      apolloPrint(
                          message: logic.answerBoxes!.map((e) => e ?? '').join(
                              ''));
                      final userAnswer = logic.answerBoxes
                          !.map((e) => e ?? '')
                          .join('');

                      if (userAnswer.isNotEmpty && userAnswer.length == logic.answerBoxes!.length) {
                        final correct = userAnswer == logic.word;
                        if (correct) {
                          showLoader(true);
                          getMedLingoResultApi(
                              medLingoId: logic.gameData!.id,
                              gameId: logic.gameData!.medlingoGameId,
                              time: 3,
                              stuck: logic.isStuck ? 1 : 0,
                              stuckCount: logic.attemptCount,
                              answer: userAnswer).then((result) {
                            showLoader(false);
                            if (result.status == true &&
                                result.data != null) {
                              Get.to(() =>MedLingoResult(
                                showText: 'terrific',
                                correctAns: logic.word,
                                hP: result.data!.xp ?? 0,
                                showDesc: result.data!.explanation ?? ""));
                            } else if (result.status == false) {
                              CustomSnackBar().showSnack(
                                  Get.context!, isSuccess: false,
                                  message: '${result.message}');
                            }
                          });
                        }
                        else {
                          quitMedLingoApi(gameId: logic.gameData!.medlingoGameId??0);
                          Get.to(() =>MedLingoResult(
                              showText: 'tryAgain', correctAns: logic.word,
                              showDesc: logic.gameData!.explanation ?? ''));
                        }
                      } else {
                        CustomSnackBar().showSnack(context, message: 'Finish the puzzle to continue.', isSuccess: false);
                      }
                    }),
                addHeight(24)
              ],
            );
          }).marginSymmetric(horizontal: 16))));}}