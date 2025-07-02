import 'dart:developer';

import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/stuck_bottom_sheet.dart';
import 'package:apollo/controllers/gM_quiz_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_card_stack.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/custom_widgets/linear_progress_segment.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/countdown_timer.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:apollo/screens/game_mode/group_play/group_play_result.dart';
import 'package:apollo/screens/game_mode/solo_play/solo_play_result.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class QuizScreenNew extends StatefulWidget {
  @override
  State<QuizScreenNew> createState() => _QuizScreenNewState();
}

class _QuizScreenNewState extends State<QuizScreenNew> {
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
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.primaryColor,
      body: GetBuilder<GMQuizCtrl>(
        init: GMQuizCtrl(),
        builder: (logic) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                addHeight(10),
                Expanded(
                  child: StackedDraggableSwiper(
                    key: swiperKey,
                    maxAngle: 30,
                    allowedDirections: {SwipeDirection.left},
                    stackCount: logic.questions.length>3?3:logic.questions.length,
                    backCardOffset: -24,
                    duration: Duration(milliseconds: 200),
                    backCardScale: 0.05,
                    swipeEnabled: logic.fromScreen=="soloPlay" && logic.currentIndex==(logic.questions.length-1)?false:true, // disable Swiping on last index(question),
                    onDrag: (index,dx, angle) {

                      // Do something while dragging (e.g., update UI, show overlay)
                      print('Dragging: index:$index, dx=$dx, angle=$angle');
                    },
                    onSwipe: (index, direction) {
                      print('Current Index:00:${logic.currentIndex}');
                      print('index Index:00:$index');

                      final isLastQuestion = index == logic.questions.length - 1;
                      logic.currentIndex = index+1; // current Question index


                        logic.isLastQ = logic.currentIndex==logic.questions.length - 1; // new line added because of last index not swipe
                        print('${logic.fromScreen} isLastQ: ${logic.isLastQ}');

                      logic.update();
                      print('Current Index:11:${logic.currentIndex}');


                      if(isLastQuestion){
                        int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                        int totalQuestions = logic.questions.length;
                        double percent = (correctAnswers / totalQuestions) * 100;
                      }
                    },
                    cards: List.generate(logic.questions.length, (i) {
                      final q = logic.questions[i];
                      return logic.fromScreen=="groupPlay"
                          ? _buildFrontCardGP(q, i, logic,logic.currentIndex)
                          : FlipCard(
                          key: q.flipKey,
                          flipOnTouch: false,
                          front: _buildFrontCard(q, i, logic,logic.currentIndex,),
                          back: _buildBackCard(q, i, logic, logic.currentIndex,));
                    }),
                  ).paddingOnly(left: 4, right: 4,top: 15),
                  /*child: CardSwiper(
                    padding: EdgeInsets.only(left: 4, right: 4,top: 15),
                    backCardOffset: Offset(0, -44),
                    cardsCount: logic.questions.length,
                    threshold: 90,
                    isLoop: false,
                    maxAngle: 45,
                    duration: Duration(milliseconds: 500),
                    controller: logic.cardSwiperController,
                    allowedSwipeDirection: AllowedSwipeDirection.only(
                      left: true,
                      right: false,
                      up: false,
                      down: false,
                    ),
                    numberOfCardsDisplayed: logic.questions.length>3?3:logic.questions.length,
                    isDisabled:  logic.fromScreen=="soloPlay" && logic.currentIndex==(logic.questions.length-1)?true:false, // disable Swiping on last index(question)
                    cardBuilder: (context, qIndex, percentX, percentY) {
                      final q = logic.questions[qIndex];
                      return  logic.fromScreen=="groupPlay"
                          ? _buildFrontCardGP(q, qIndex, logic,logic.currentIndex)
                          : FlipCard(
                        key: q.flipKey,
                          flipOnTouch: false,
                          // direction: FlipDirection.VERTICAL,
                          front: _buildFrontCard(q, qIndex, logic,logic.currentIndex),
                          back: _buildBackCard(q, qIndex, logic, logic.currentIndex));
                    },
                    onSwipe: (previousIndex, currentIndex, direction) async {
                      final isLastQuestion = currentIndex == logic.questions.length - 1;
                        logic.currentIndex = currentIndex!; // current Question index
                        logic.update();

                      if(isLastQuestion){
                        int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                        int totalQuestions = logic.questions.length;
                        double percent = (correctAnswers / totalQuestions) * 100;
                      }


                      return true;
                    },
                  ),*/
                ),
              ],
            ),
          );
        },
      ),

      /*bottomNavigationBar: Container(
        height: 52,
        width: double.infinity,
        color: Color(0XFF909090),
        child: Center(
          child: addText500(
            'Banner Ad Placeholder',
            color: AppColors.blackColor,
            fontSize: 16,
          ),
        ),
      ).marginOnly(left: 14,right: 14,bottom: 30)*/
    );
  }

  Widget _buildFrontCard(q, int qIndex, logic, int currentIndex) {
    return SizedBox.expand(
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        decoration: BoxDecoration(
          color: qIndex == logic.currentIndex
              ? Colors.white :
          (qIndex == logic.currentIndex + 1 ? Color(0XFFDDD0F2) : Color(0XFFB290E8)
          ),
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
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
            ),
            // margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(
                  color: AppColors.primaryLightColor,
                  width: 3,
                ),
                right: BorderSide(
                  color: AppColors.primaryLightColor,
                  width: 3,
                ),
                top: BorderSide(
                  color: AppColors.primaryLightColor,
                  width: 3,
                ),
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
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                        // q.is = !logic.isLike;
                        q.isLike= !q.isLike;
                        setState(() {});
                        apolloPrint(message: 'message::: ${ q.isLike}');
                        // showLikeQuestionSheet(context);
                      },
                      child: Icon(q.isLike?Icons.favorite:Icons.favorite_border_rounded,
                          color: q.isLike?Colors.red:Colors.black,size: 28),
                      // child: Image.asset(
                      //   AppAssets.favIcon,
                      //   color: logic.isLike?Colors.red:Colors.black,
                      //   height: 24,
                      //   width: 24,
                      // ),
                    ),
                    addText400(
                      "Lub Dub Nation",
                      fontSize: 20,
                      fontFamily: 'Caprasimo',
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () {
                        showLeaveQuizSheet(context,(){
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          logic.currentIndex=0;
                          logic.shouldStopAllTimers = true;
                          logic.update();
                          Get.delete<GMQuizCtrl>(force: true);
                          Get.back();
                          Get.to(()=>DashBoardScreen());
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
                        filledSegments: int.parse(
                          '${qIndex + 1}',
                        ),
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
                Align(
                    alignment: Alignment.centerRight,
                    child: addText600('johndoe / Unsplash',
                        color: AppColors.textColor,
                        fontSize: 9)).marginOnly(right: 10),
                SizedBox(height: 4),

                // Image with badges
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        q.imagePath,
                        // width: double.infinity,
                        width: MediaQuery.sizeOf(context).width*0.8,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      left: 12,
                      top: 12,
                      child:CountdownTimerWidget(
                        key: ValueKey(currentIndex),
                        duration: 20, isInSecondsMode: true,
                          shouldStop: logic.shouldStopAllTimers,
                          onTimerEnd: (){
                            if(logic.isLastQ==true){
                              print('logic.isLastQ111::::${logic.isLastQ}');
                              int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                              int totalQuestions = logic.questions.length;
                              double percent = (correctAnswers / totalQuestions) * 100;
                              Get.off(SoloResultScreen(result: percent));
                            }
                            else{
                              _playConfettiSound(sound: AppAssets.swipeSound);
                              swiperKey.currentState?.swipeLeft();
                            }
                          }

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
                    ),
                  ],
                ),
                SizedBox(height: 17),

                // Question
                addText500(
                  q.question,
                  fontSize: 20,
                  height: 28,
                  color: Colors.black87,
                ).marginSymmetric(horizontal: 8),
                SizedBox(height: 14),

                // Answers
                ...List.generate(q.options.length, (optIndex) {
                  return GestureDetector(
                    onTap: (){
                      // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                      if (!q.isAnswered) {
                        q.isAnswered = true;
                        q.selectedIndex = optIndex;
                        setState(() {});

                        // if (optIndex == q.correctIndex) {
                        if (q.isAnswered) {
                          if(optIndex == q.correctIndex){
                            _playConfettiSound(sound: AppAssets.correctAnswerSound);
                          }else{
                            _playConfettiSound(sound: AppAssets.wrongAnswerSound);
                          }


                          // Flip the card if correct
                          Future.delayed(const Duration(milliseconds: 1300), () {
                            q.flipKey.currentState?.toggleCard();
                          });

                          log("message 0000000 ${logic.fromScreen}");
                        } else {
                          final isLastQuestion = qIndex == logic.questions.length - 1;
                          log("message 0000000 ${logic.fromScreen}");
                          // Optionally, swipe to next if incorrect
                          if (qIndex < logic.questions.length - 1) {
                            Future.delayed(
                              const Duration(milliseconds: 2000),
                                  () {
                                logic.cardSwiperController.swipe(CardSwiperDirection.left,);
                              },
                            );
                          }
                          else if(isLastQuestion){


                            int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                            int totalQuestions = logic.questions.length;
                            double percent = (correctAnswers / totalQuestions) * 100;

                            Future.delayed(Duration(milliseconds: 3000), () {
                              log("message 1111 ${logic.fromScreen}");

                              if (logic.fromScreen == 'soloPlay') {
                                Get.off(SoloResultScreen(result: percent));
                              } else if (logic.fromScreen == 'groupPlay') {

                                Get.off(GroupPlayResultScreen());

                              }
                            });
                          }
                        }
                      }
                    },
                    /*logic.selectedIndices[qIndex] == null
                                              ? () {
                                                setState(() {
                                                  logic.selectedIndices[qIndex] =
                                                      optIndex;

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
                                                    double percent = (correct / total) * 100;
                                                    Future.delayed(
                                                      Duration(milliseconds: 300),
                                                      () {
                                                        if (logic.fromScreen == 'soloPlay') {
                                                          Get.off(SoloResultScreen(result: percent));
                                                        } else if (logic.fromScreen == 'groupPlay') {
                                                          Get.off(GroupPlayResultScreen());
                                                        }
                                                      },
                                                    );
                                                  }
                                                });
                                              }
                                              : null,*/
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: logic.getOptionColor(qIndex, optIndex),
                        borderRadius: BorderRadius.circular(16),
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
                // addHeight(98),

                Container(
                  height: 52,
                  width: double.infinity,
                  color: Color(0XFF909090),
                  child: Center(
                    child: addText500(
                      'Banner Ad Placeholder',
                      color: AppColors.blackColor,
                      fontSize: 16,
                    ),
                  ),
                ).marginOnly(bottom: 35,top: 20)

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCardGP(q, int qIndex, logic, int currentIndex) {
    return SizedBox.expand(
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        decoration: BoxDecoration(
          color: qIndex == logic.currentIndex
              ? Colors.white
              : (qIndex == logic.currentIndex + 1
              ? Color(0XFFDDD0F2)
              : Color(0XFFB290E8)
          ),
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
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
            ),
            // margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(
                  color: AppColors.primaryLightColor,
                  width: 3,
                ),
                right: BorderSide(
                  color: AppColors.primaryLightColor,
                  width: 3,
                ),
                top: BorderSide(
                  color: AppColors.primaryLightColor,
                  width: 3,
                ),
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
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                        // q.is = !logic.isLike;
                        q.isLike= !q.isLike;
                        setState(() {});
                        apolloPrint(message: 'message::: ${ q.isLike}');
                        // showLikeQuestionSheet(context);
                      },
                      child: Icon(q.isLike?Icons.favorite:Icons.favorite_border_rounded,
                          color: q.isLike?Colors.red:Colors.black,size: 28),
                      // child: Image.asset(
                      //   AppAssets.favIcon,
                      //   color: logic.isLike?Colors.red:Colors.black,
                      //   height: 24,
                      //   width: 24,
                      // ),
                    ),
                    addText400(
                      "Lub Dub Nation",
                      fontSize: 20,
                      fontFamily: 'Caprasimo',
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () {
                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                        showLeaveQuizSheet(context,(){
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          logic.currentIndex=0;
                          logic.shouldStopAllTimers = true;
                          logic.update();
                          Get.delete<GMQuizCtrl>(force: true);
                          Get.back();
                          Get.to(()=>DashBoardScreen());
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
                        filledSegments: int.parse(
                          '${qIndex + 1}',
                        ),
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
                Align(
                    alignment: Alignment.centerRight,
                    child: addText600('johndoe / Unsplash',
                        color: AppColors.textColor,
                        fontSize: 9)).marginOnly(right: 10),
                SizedBox(height: 4),

                // Image with badges
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        q.imagePath,
                        // width: double.infinity,
                        width: MediaQuery.sizeOf(context).width*0.8,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Timer Widget
                    Positioned(
                      left: 12,
                      top: 12,
                      child:CountdownTimerWidget(
                        key: ValueKey(currentIndex),
                        duration: 20,isInSecondsMode: true,
                        shouldStop: logic.shouldStopAllTimers,
                        onTimerEnd: (){
                          if(logic.isLastQ==true){
                            print('logic.isLastQ111::::${logic.isLastQ}');

                            Get.off(GroupPlayResultScreen());
                          }
                          else{
                            _playConfettiSound(sound: AppAssets.swipeSound);
                            swiperKey.currentState?.swipeLeft();
                          }
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
                    ),
                  ],
                ),
                SizedBox(height: 17),

                // Question
                addText500(
                  q.question,
                  fontSize: 20,
                  height: 28,
                  color: Colors.black87,
                ).marginSymmetric(horizontal: 8),
                SizedBox(height: 14),

                // Answers
                ...List.generate(q.options.length, (optIndex) {
                  return GestureDetector(
                    onTap: (){
                      // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                      if (!q.isAnswered) {
                        q.isAnswered = true;
                        q.selectedIndex = optIndex;
                        setState(() {});

                        // if (optIndex == q.correctIndex) {
                        if (q.isAnswered) {
                          if(optIndex == q.correctIndex){
                            _playConfettiSound(sound: AppAssets.correctAnswerSound);
                          }else{
                            _playConfettiSound(sound: AppAssets.wrongAnswerSound);
                          }

                            final isLastQuestion = qIndex == logic.questions.length - 1;
                            log("message 0000000 ${logic.fromScreen}");

                            if (qIndex < logic.questions.length - 1) {
                              Future.delayed(
                                const Duration(milliseconds: 2000),
                                    () {
                                      _playConfettiSound(sound: AppAssets.swipeSound);
                                  // logic.cardSwiperController.swipe(CardSwiperDirection.left);
                                      swiperKey.currentState?.swipeLeft();
                                },
                              );
                            }
                            else if(isLastQuestion){


                              int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                              int totalQuestions = logic.questions.length;
                              double percent = (correctAnswers / totalQuestions) * 100;

                              Future.delayed(Duration(milliseconds: 3000), () {
                                log("message 1111 ${logic.fromScreen}");

                                if (logic.fromScreen == 'soloPlay') {

                                  Get.off(SoloResultScreen(result: percent));
                                } else if (logic.fromScreen == 'groupPlay') {

                                  Get.off(GroupPlayResultScreen());

                                }
                              });
                            }

                        }
                      }
                    },
                    /*logic.selectedIndices[qIndex] == null
                                              ? () {
                                                setState(() {
                                                  logic.selectedIndices[qIndex] =
                                                      optIndex;

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
                                                    double percent = (correct / total) * 100;
                                                    Future.delayed(
                                                      Duration(milliseconds: 300),
                                                      () {
                                                        if (logic.fromScreen == 'soloPlay') {
                                                          Get.off(SoloResultScreen(result: percent));
                                                        } else if (logic.fromScreen == 'groupPlay') {
                                                          Get.off(GroupPlayResultScreen());
                                                        }
                                                      },
                                                    );
                                                  }
                                                });
                                              }
                                              : null,*/
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: logic.getOptionColor(qIndex, optIndex),
                        borderRadius: BorderRadius.circular(16),
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
                // addHeight(98),

                Container(
                  height: 52,
                  width: double.infinity,
                  color: Color(0XFF909090),
                  child: Center(
                    child: addText500(
                      'Banner Ad Placeholder',
                      color: AppColors.blackColor,
                      fontSize: 16,
                    ),
                  ),
                ).marginOnly(bottom: 35,top: 20)
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
          color: qIndex == logic.currentIndex
              ? Colors.white
              : (qIndex == logic.currentIndex + 1 ? Color(0XFFDDD0F2)
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
              color: AppColors.whiteColor,
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
                        q.isLike ? Icons.favorite : Icons.favorite_border_rounded,
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
                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                        showLeaveQuizSheet(context,(){
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          logic.currentIndex=0;
                          logic.shouldStopAllTimers = true;
                          logic.update();
                          Get.delete<GMQuizCtrl>(force: true);
                          Get.back();
                          Get.to(()=>DashBoardScreen());
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
                        child:CountdownTimerWidget(
                          key: ValueKey(currentIndex),
                          duration: 20,isInSecondsMode: true,
                            shouldStop: logic.shouldStopAllTimers,
                          onTimerEnd: (){
                            if(logic.isLastQ==true){
                              print('logic.isLastQ111::::${logic.isLastQ}');
                              int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                              int totalQuestions = logic.questions.length;
                              double percent = (correctAnswers / totalQuestions) * 100;
                              Get.off(SoloResultScreen(result: percent));
                            }
                            else{
                              _playConfettiSound(sound: AppAssets.swipeSound);
                              swiperKey.currentState?.swipeLeft();
                            }
                          }),
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
                          Image.asset(AppAssets.newsIcon, height: 24, width: 24),
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
                                    text:
                                    "${q.explanation}",
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
                          Image.asset(AppAssets.bulb1Img, height: 24, width: 24),
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
                                    text:
                                    "${q.funFact}",
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
                        int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                        int totalQuestions = logic.questions.length;
                        double percent = (correctAnswers / totalQuestions) * 100;

                        apolloPrint(message: 'message::::isLastQuestion taped $isLastQuestion');

                          if (logic.fromScreen == 'soloPlay') {

                            Get.off(SoloResultScreen(result: percent));
                          } else if (logic.fromScreen == 'groupPlay') {

                            Get.off(GroupPlayResultScreen());
                          }

                      } else {
                        apolloPrint(message: 'message::::isLastQuestion taped $isLastQuestion');
                        _playConfettiSound(sound: AppAssets.swipeSound);
                        // logic.cardSwiperController.swipe(CardSwiperDirection.left);
                        swiperKey.currentState?.swipeLeft();
                      }
                    }),
                SizedBox(height: 34),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

