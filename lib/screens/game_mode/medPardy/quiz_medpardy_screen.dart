import 'dart:developer';

import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/like_question_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/stuck_bottom_sheet.dart';
import 'package:apollo/controllers/medPardy_quiz_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_card_stack.dart';
import 'package:apollo/custom_widgets/linear_progress_segment.dart';

import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/countdown_timer.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'medpardy_final_round_board_screen.dart';
import 'medpardy_second_round_board_screen.dart';

class QuizMedpardyScreen extends StatefulWidget {
  @override
  State<QuizMedpardyScreen> createState() => _QuizMedpardyScreenState();
}

class _QuizMedpardyScreenState extends State<QuizMedpardyScreen> {
  final GlobalKey<StackedDraggableSwiperState> swiperKey = GlobalKey<StackedDraggableSwiperState>();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _playConfettiSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: GetBuilder<MedpardyQuizCtrl>(
        builder: (logic) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                // addHeight(48),
                Expanded(
                  child: StackedDraggableSwiper(
                    key: swiperKey,
                    maxAngle: 30,
                    allowedDirections: {SwipeDirection.left},
                    stackCount:
                        logic.questions.length > 3 ? 3 : logic.questions.length,
                    backCardOffset: -24,
                    duration: Duration(milliseconds: 500),
                    backCardScale: 0.05,
                    swipeEnabled:
                        logic.currentIndex == (logic.questions.length - 1)
                            ? false
                            : true, // disable Swiping on last index(question),
                    onDrag: (index,dx, angle) {
                      // Do something while dragging (e.g., update UI, show overlay)
                      // print('Dragging: dx=$dx, angle=$angle');
                    },
                    onSwipe: (index, direction) {
                      print('Current Index:00:${logic.currentIndex}');
                      print('index Index:00:$index');

                      final isLastQuestion = index == logic.questions.length - 1;
                      logic.currentIndex = index + 1; // current Question index
                      logic.isLastQ = logic.currentIndex==logic.questions.length - 1; // new line added because of last index not swipe
                      print('Medpardy Quiz isLastQ: ${logic.isLastQ}');
                      logic.update();
                      print('Current Index:11:${logic.currentIndex}');

                      if (isLastQuestion) {
                        // int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                        // int totalQuestions = logic.questions.length;
                        // double percent = (correctAnswers / totalQuestions) * 100;
                        // Future.delayed(Duration(milliseconds: 3000), () {
                        //   Get.off(LiveChallengeResultScreen(result: percent));
                        // });
                      }
                    },
                    cards: List.generate(logic.questions.length, (i) {
                      final q = logic.questions[i];
                      return FlipCard(
                        key: q.flipKey,
                        flipOnTouch: false,
                        front: _buildFrontCard(q, i, logic, logic.currentIndex),
                        back: _buildBackCard(q, i, logic, logic.currentIndex),
                      );
                    }),
                  ).paddingOnly(left: 4, right: 4, top: 15),
                  /*child: CardSwiper(
                  padding: EdgeInsets.only(left: 4, right: 4, top: 15),
                  backCardOffset: Offset(0, -44),
                  cardsCount: logic.questions.length,
                  controller: logic.cardSwiperController,
                  initialIndex: logic.currentIndex,
                  threshold: 30,
                  duration: Duration(milliseconds: 500),
                  allowedSwipeDirection: AllowedSwipeDirection.only(left: true, right: false, up: false, down: false),
                  numberOfCardsDisplayed: logic.questions.length>3?3:logic.questions.length,
                  isDisabled: logic.currentIndex==(logic.questions.length-1)?true:false,
                  isLoop: false,
                  cardBuilder: (context, qIndex, percentX, percentY) {
                    final q = logic.questions[qIndex];
                    return FlipCard(
                        key: q.flipKey,
                        flipOnTouch: false,
                        front: _buildFrontCard(q, qIndex, logic,logic.currentIndex),
                        back: _buildBackCard(q, qIndex, logic, logic.currentIndex));
                  },
                  onSwipe: (previousIndex, currentIndex, direction) async {
                    */
                  /*if (!logic.questions[previousIndex].isAnswered) {
                        // Optionally show a message: "Please answer before swiping"
                        return false; // Block swipe
                      }*/
                  /*

                    final isLastQuestion = currentIndex == logic.questions.length - 1;

                    logic.currentIndex = currentIndex!; // current Question index
                    logic.update();
                    if(isLastQuestion){
                      // int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                      // int totalQuestions = logic.questions.length;
                      // double percent = (correctAnswers / totalQuestions) * 100;
                      // Future.delayed(Duration(milliseconds: 3000), () {
                      //   Get.off(LiveChallengeResultScreen(result: percent));
                      // });
                    }
                    return true;
                  },
                  onEnd: () {
                    // Optionally show a dialog or results

                  },
                ),*/
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard(q, int qIndex, logic, int currentIndex) {
    return SizedBox.expand(
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        decoration: BoxDecoration(
          color:
              qIndex == logic.currentIndex
                  ? Colors.white
                  : (qIndex == logic.currentIndex + 1
                      ? Color(0XFFDDD0F2)
                      : Color(0XFFB290E8)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.primaryLightColor, width: 3),
                right: BorderSide(color: AppColors.primaryLightColor, width: 3),
                top: BorderSide(color: AppColors.primaryLightColor, width: 3),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.yellowColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      addText400(
                        '${logic.fromPlayer}',
                        fontSize: 20,
                        fontFamily: 'Caprasimo',
                        color: AppColors.primaryColor,
                      ).marginSymmetric(horizontal: 12, vertical: 4),
                      Spacer(),
                      addText400(
                        logic.fromPlayer == 'Madelyn' ? '200' : '400',
                        fontFamily: 'Caprasimo',
                        fontSize: 20,
                        color: AppColors.primaryColor,
                      ).marginSymmetric(horizontal: 12, vertical: 4),
                    ],
                  ),
                ).marginOnly(top: 4),
                addHeight(14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                        q.isLike = !q.isLike;
                        logic.update();
                        // showLikeQuestionSheet(context);
                      },
                      child: Icon(
                        q.isLike
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: q.isLike ? Colors.red : Colors.black,
                        size: 28,
                      ),
                    ),
                    Column(
                      children: [
                        addText400(
                          "Lub Dub Nation",
                          fontSize: 20,
                          fontFamily: 'Caprasimo',
                        ),
                        addText500(
                          logic.fromPlayer == 'Madelyn'
                              ? "First Round"
                              : "Second Round",
                          fontSize: 16,
                          height: 22,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                        showLeaveQuizSheet(context, () {
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          logic.currentIndex=0;
                          logic.shouldStopAllTimers = true;
                          logic.update();
                          Get.back();
                          Get.to(() => DashBoardScreen());
                        });
                      },
                      child: Image.asset(
                        AppAssets.closeIcon,
                        color: Colors.black,
                        height: 28,
                        width: 28,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: addText600(
                    'johndoe / Unsplash',
                    color: AppColors.textColor,
                    fontSize: 9,
                  ),
                ).marginOnly(right: 10),
                SizedBox(height: 4),

                // Progress bar and question number
                /*Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Expanded(child: SegmentedProgressBar(
                                        filledSegments: int.parse('${qIndex + 1}'),
                                        totalSegments: questions.length,)),
                                      // Expanded(
                                      //   child: ClipRRect(
                                      //     borderRadius: BorderRadius.circular(5),
                                      //     child: LinearProgressIndicator(
                                      //       value: (qIndex + 1) / questions.length,
                                      //       minHeight: 7,
                                      //       backgroundColor: Colors.purple[100],
                                      //       valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(width: 10),
                                      addText500(
                                        "${qIndex + 1}/${questions.length}",

                                        fontSize: 16,

                                      ),
                                    ],
                                  ),
                                ),*/

                // Image with badges
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        q.imagePath,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: CountdownTimerWidget(
                        key: ValueKey(currentIndex),
                        duration: 20,
                        isInSecondsMode: true,
                        shouldStop: logic.shouldStopAllTimers,
                        onTimerEnd: (){
                            print('logic.isLastQ Medpardy front card 111::::${logic.isLastQ}');
                          // if(logic.isLastQ==true){
                            if (logic.round == 1) {
                              Get.off(() => MedpardySecondRoundBoardScreen());
                            } else if (logic.round == 2) { Get.off(() => MedpardyFinalRoundBoardScreen()); }
                          // }
                          // else{
                          //   _playConfettiSound(sound: AppAssets.swipeSound);
                          //   swiperKey.currentState?.swipeLeft();
                          // }
                        },
                      ),
                      /*child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.yellowColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppAssets.clockIcon,
                              height: 16,
                              width: 16,
                            ),
                            SizedBox(width: 4),
                            addText400(
                              "20 sec",
                              fontSize: 16,
                              height: 22,
                              color: AppColors.blackColor,
                            ),
                          ],
                        ),
                      ),*/
                    ),

                    Positioned(
                      right: 12,
                      top: 12,
                      child: GestureDetector(
                        onTap: () {
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          showStuckSheet(context);
                        },
                        child: Container(
                          height: 36,
                          width: 44,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            border: Border.all(color: AppColors.yellowColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset(
                            AppAssets.handLineImg,
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 26),

                // Question
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: addText500(
                    q.question,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24),

                // Answers
                ...List.generate(q.options.length, (optIndex) {
                  return GestureDetector(
                    onTap: () {
                      // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                      if (!q.isAnswered) {
                        q.isAnswered = true;
                        q.selectedIndex = optIndex;
                        logic.update();

                        if (q.isAnswered) {
                          if (optIndex == q.correctIndex) {
                            _playConfettiSound(
                              sound: AppAssets.correctAnswerSound,
                            );
                          } else {
                            _playConfettiSound(
                              sound: AppAssets.wrongAnswerSound,
                            );
                          }

                          // Flip the card if correct
                          Future.delayed(
                            const Duration(milliseconds: 1300),
                            () {
                              q.flipKey.currentState?.toggleCard();
                            },
                          );
                        } else {
                          final isLastQuestion =
                              qIndex == logic.questions.length - 1;
                          log("message 0000000 ${logic.fromScreen}");
                          // Optionally, swipe to next if incorrect
                          if (qIndex < logic.questions.length - 1) {
                            Future.delayed(
                              const Duration(milliseconds: 2000),
                              () {
                                // logic.cardSwiperController.swipe(CardSwiperDirection.left,);
                                swiperKey.currentState?.swipeLeft();
                              },
                            );
                          } else if (isLastQuestion) {
                            int correctAnswers =
                                logic.questions
                                    .where(
                                      (q) => q.selectedIndex == q.correctIndex,
                                    )
                                    .length;
                            int totalQuestions = logic.questions.length;
                            double percent =
                                (correctAnswers / totalQuestions) * 100;

                            if (logic.round == 1) {
                              Future.delayed(Duration(seconds: 3), () {
                                Get.off(() => MedpardySecondRoundBoardScreen());
                              });
                            } else if (logic.round == 2) {
                              Future.delayed(Duration(seconds: 3), () {
                                Get.off(() => MedpardyFinalRoundBoardScreen());
                              });
                            }
                          }
                        }
                      }
                    },
                    /*onTap: selectedIndices[qIndex] == null
                        ? () {
                      setState(() {
                        selectedIndices[qIndex] = optIndex;
                        if(optIndex == q.correctIndex){
                          _playConfettiSound(sound: AppAssets.correctAnswerSound);
                        }else{
                          _playConfettiSound(sound: AppAssets.wrongAnswerSound);
                        }

                        // Check if all questions have been answered
                        final allAnswered = !selectedIndices.contains(null);
                        final isLastQuestion = qIndex == questions.length - 1;

                        if (allAnswered && isLastQuestion) {
                          int total = questions.length;
                          int correct = 0;
                          for (int i = 0; i < total; i++) {
                            if (selectedIndices[i] == questions[i].correctIndex) {
                              correct++;
                            }
                          }

                          if(logic.round==1){
                            Future.delayed(Duration(seconds: 3),(){
                              Get.off(()=>MedpardySecondRoundBoardScreen());
                            });
                          } else if(logic.round==2){
                            Future.delayed(Duration(seconds: 3),(){
                              Get.off(()=>MedpardyFinalRoundBoardScreen());
                            });
                          }

                        }
                      });
                    }
                        : null,
                    */
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: logic.getOptionColor(qIndex, optIndex),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: addText500(
                          q.options[optIndex],
                          fontSize: 16,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                  ).marginOnly(bottom: 8);
                }),
                addHeight(40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard(q, int qIndex, logic, int currentIndex) {
    return SizedBox.expand(
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        decoration: BoxDecoration(
          color:
              qIndex == logic.currentIndex
                  ? Colors.white
                  : (qIndex == logic.currentIndex + 1
                      ? Color(0XFFDDD0F2)
                      : Color(0XFFB290E8)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.primaryLightColor, width: 3),
                right: BorderSide(color: AppColors.primaryLightColor, width: 3),
                top: BorderSide(color: AppColors.primaryLightColor, width: 3),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                        q.isLike = !q.isLike;
                        setState(() {});
                        // showLikeQuestionSheet(context);
                      },
                      child: Icon(
                        q.isLike
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: q.isLike ? Colors.red : Colors.black,
                        size: 28,
                      ),
                    ),
                    addText400(
                      "Lub Dub Nation",
                      fontSize: 20,
                      fontFamily: 'Caprasimo',
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () {
                        // _playConfettiSound(
                        //   sound: AppAssets.actionButtonTapSound,
                        // );
                        showLeaveQuizSheet(context, () {
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound,);
                          logic.currentIndex=0;
                          logic.shouldStopAllTimers = true;
                          logic.update();
                          Get.back();
                          Get.to(() => DashBoardScreen());
                        });
                      },
                      child: Image.asset(
                        AppAssets.closeIcon,
                        color: Colors.black,
                        height: 28,
                        width: 28,
                      ),
                    ),
                  ],
                ),
                addHeight(16),

                // Progress bar and question number
                Row(
                  children: [
                    Expanded(
                      child: SegmentedProgressBar(
                        filledSegments: int.parse('${qIndex + 1}'),
                        totalSegments: logic.questions.length,
                      ),
                    ),
                    SizedBox(width: 10),
                    addText500(
                      "${qIndex + 1}/${logic.questions.length}",
                      fontSize: 16,
                      height: 22,
                    ),
                  ],
                ),

                SizedBox(height: 8),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: addText600(
                //     'johndoe / Unsplash',
                //     color: AppColors.textColor,
                //     fontSize: 9,
                //   ),
                // ).marginOnly(right: 10),
                // SizedBox(height: 4),

                // Image with badges
                Container(
                  height: 200,
                  clipBehavior: Clip.none,
                  width: double.infinity,
                  // color: Colors.red,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Transform.scale(
                        scale: 1.17,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: SvgPicture.asset(
                            AppAssets.flipCardRaysBg,
                            // width: 270,
                            // height: 270,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: CountdownTimerWidget(
                          key: ValueKey(currentIndex),
                          duration: 20,
                          isInSecondsMode: true,
                          shouldStop: logic.shouldStopAllTimers,
                          onTimerEnd: (){
                            // if(logic.isLastQ==true){
                              print('logic.isLastQ Medpardy front card 111::::${logic.isLastQ}');
                              if (logic.round == 1) {

                                  Get.off(() => MedpardySecondRoundBoardScreen());

                              } else if (logic.round == 2) {
                                  Get.off(() => MedpardyFinalRoundBoardScreen());

                              }
                            // }
                            // else{
                            //   _playConfettiSound(sound: AppAssets.swipeSound);
                            //   swiperKey.currentState?.swipeLeft();
                            // }
                          },
                        ),
                        /*child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.yellowColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                AppAssets.clockIcon,
                                height: 16,
                                width: 16,
                              ),
                              SizedBox(width: 4),
                              addText400(
                                "20 sec",
                                fontSize: 16,
                                height: 22,
                                color: AppColors.blackColor,
                              ),
                            ],
                          ),
                        ),*/
                      ),
                      Lottie.asset(
                        'assets/Lottie/Apollo magic.json',
                        repeat: true,
                        animate: true,
                        width: 220,
                        height: 220,
                        // width: width * 0.8,
                        // height: height * 0.35,
                      ),
                    ],
                  ),
                ),

                addHeight(14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xffF3EBFF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            AppAssets.newsIcon,
                            height: 24,
                            width: 24,
                          ),
                          addWidth(12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(text: "Explanation: "),
                                  TextSpan(
                                    text: "${q.explanation}",
                                    style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      addHeight(10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            AppAssets.bulb1Img,
                            height: 24,
                            width: 24,
                          ),
                          addWidth(12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(text: "Fun Fact: "),
                                  TextSpan(
                                    text: "${q.funFact}",
                                    style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                AppButton(
                  buttonText: 'Next',
                  onButtonTap: () {
                    // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                    apolloPrint(message: 'message::::taped');
                    // timerController.resetTimer();
                    final isLastQuestion = qIndex == logic.questions.length - 1;
                    // bool allAnswered = logic.questions.every((q) => q.isAnswered);
                    if (isLastQuestion) {
                      int correctAnswers =
                          logic.questions
                              .where((q) => q.selectedIndex == q.correctIndex)
                              .length;
                      int totalQuestions = logic.questions.length;
                      double percent = (correctAnswers / totalQuestions) * 100;

                      apolloPrint(
                        message:
                            'message::::isLastQuestion taped $isLastQuestion',
                      );

                      if (logic.round == 1) {
                        Future.delayed(Duration(seconds: 1), () {
                          Get.off(() => MedpardySecondRoundBoardScreen());
                        });
                      } else if (logic.round == 2) {
                        Future.delayed(Duration(seconds: 1), () {
                          Get.off(() => MedpardyFinalRoundBoardScreen());
                        });
                      }
                    } else {
                      apolloPrint(
                        message:
                            'message::::isLastQuestion taped $isLastQuestion',
                      );
                      _playConfettiSound(sound: AppAssets.swipeSound);
                      // logic.cardSwiperController.swipe(CardSwiperDirection.left);
                      swiperKey.currentState?.swipeLeft();
                    }
                  },
                ),
                SizedBox(height: 34),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
