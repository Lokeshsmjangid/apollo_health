import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/bottom_sheets/stuck_bottom_sheet.dart';
import 'package:apollo/controllers/live_challenge_quiz_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_card_stack.dart';
import 'package:apollo/custom_widgets/linear_progress_segment.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/countdown_timer.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:apollo/screens/game_mode/live_challenges/live_challenge_result.dart';
import 'package:lottie/lottie.dart';

class LiveChallengeQuizScreen extends StatefulWidget {
  @override
  State<LiveChallengeQuizScreen> createState() =>
      _LiveChallengeQuizScreenState();
}

class _LiveChallengeQuizScreenState extends State<LiveChallengeQuizScreen> {
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
      body: GetBuilder<LiveChallengeQuizCtrl>(
        builder: (logic) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                // addHeight(60),
                Expanded(
                  child: StackedDraggableSwiper(
                    key: swiperKey,
                    maxAngle: 30,
                    allowedDirections: {SwipeDirection.left},
                    stackCount: logic.questions.length>3?3:logic.questions.length,
                    backCardOffset: -24,
                    duration: Duration(milliseconds: 500),
                    backCardScale: 0.05,
                    swipeEnabled: logic.currentIndex==(logic.questions.length-1)?false:true, // disable Swiping on last index(question),
                    onDrag: (index,dx, angle) {
                      // Do something while dragging (e.g., update UI, show overlay)
                      // print('Dragging: dx=$dx, angle=$angle');
                    },
                    onSwipe: (index, direction) {
                      print('Current Index:00:${logic.currentIndex}');
                      print('index Index:00:$index');



                      final isLastQuestion = index == logic.questions.length - 1;
                      logic.currentIndex = index+1; // current Question index
                      logic.isLastQ = logic.currentIndex==logic.questions.length - 1; // new line added because of last index not swipe
                      print('Medpardy Quiz isLastQ: ${logic.isLastQ}');
                      logic.update();
                      print('Current Index:11:${logic.currentIndex}');

                      if(isLastQuestion){
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
                      return SizedBox.expand(child: _buildFrontCardNew(q, i, logic, logic.currentIndex));
                    },

                    ),
                  ).paddingOnly(left: 4, right: 4,top: 15),
                  /*child: CardSwiper(
                    padding: EdgeInsets.only(left: 4, right: 4, top: 15),
                    backCardOffset: Offset(0, -44),
                    cardsCount: logic.questions.length,
                    // threshold: 10,
                    controller: logic.cardSwiperController,
                    initialIndex: logic.currentIndex,
                    duration: Duration(milliseconds: 500),
                    allowedSwipeDirection: AllowedSwipeDirection.only(
                      left: true,
                      right: false,
                      up: false,
                      down: false,
                    ),
                    numberOfCardsDisplayed: logic.questions.length > 3 ? 3 : logic.questions.length,
                    isLoop: false,
                    isDisabled: logic.currentIndex==(logic.questions.length-1)?true:false, // disable Swiping on last index(question)
                     cardBuilder: (context, qIndex, percentX, percentY) {
                      final q = logic.questions[qIndex];
                      return _buildFrontCardNew(q, qIndex, logic, logic.currentIndex);
                      return FlipCard(
                        key: q.flipKey,
                        flipOnTouch: false, // We'll flip programmatically
                        front: _buildFrontCard(q, qIndex, logic, logic.currentIndex),
                        back: _buildBackCard(q, qIndex, logic, logic.currentIndex),
                      );
                    },
                    onSwipe: (previousIndex, currentIndex, direction) async {
                      if (!logic.questions[previousIndex].isAnswered) {
                        // Optionally show a message: "Please answer before swiping"
                        return false; // Block swipe
                      }

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
                  ),*/
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackCard(q, int qIndex, logic, int currentIndex) {
    return Container(
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
                      showLeaveQuizSheet(context,(){
                        logic.currentIndex=0;
                        logic.update();
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
                      child: CountdownTimerWidget(
                        key: ValueKey(currentIndex),
                        duration: 20,isInSecondsMode: true,),
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
                                      "Grapes are the perfect size and shape to block a toddler/’s airway. Always slice them lengthwise for safety! (Source: National Institutes of Health)",
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
                                      "In 2017, Chrissy Teigen posted on Instagram slicing grapes for her daughter - and parents everywhere followed suit! 🍇👶",
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
                    final isLastQuestion = qIndex == logic.questions.length - 1;
                    // bool allAnswered = logic.questions.every((q) => q.isAnswered);
                    if (isLastQuestion) {
                      int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                      int totalQuestions = logic.questions.length;
                      double percent = (correctAnswers / totalQuestions) * 100;


                      Future.delayed(Duration(milliseconds: 1500), () {
                        Get.off(LiveChallengeResultScreen(result: percent));
                      });
                    }else {
                      logic.cardSwiperController.swipe(CardSwiperDirection.left);
                    }

              }),
              SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCard(q, int qIndex, logic, int currentIndex) {
    return Container(
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
                  qIndex==0?Column(
                    children: [
                      addText500(
                        "Round 1",
                        fontSize: 20,
                        // fontFamily: 'Caprasimo',
                        height: 22,
                      ),addText500(
                        "Total Contestants - 500",
                        fontSize: 12,
                        // fontFamily: 'Caprasimo',
                        height: 22,
                      ),
                    ],
                  ):addText400(
                    "Lub Dub Nation",
                    fontSize: 20,
                    fontFamily: 'Caprasimo',
                    height: 22,
                  ),
                  GestureDetector(
                    onTap: () {
                      showLeaveQuizSheet(context,(){
                        logic.currentIndex=0;
                        logic.update();
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
              Align(
                alignment: Alignment.centerRight,
                child: addText600(
                  'johndoe / Unsplash',
                  color: AppColors.textColor,
                  fontSize: 9,
                ),
              ).marginOnly(right: 10),
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
                    child: CountdownTimerWidget(
                      key: ValueKey(currentIndex),
                      duration: 20,isInSecondsMode: true,),
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

                  Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
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
                              addText400('Your Score', fontSize: 12),
                              SizedBox(width: 4),
                              addText400(
                                "3250",
                                fontSize: 16,
                                color: AppColors.blackColor,
                                fontFamily: 'Caprasimo',
                              ),
                            ],
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
                  onTap: () {
                    if (!q.isAnswered) {
                      q.isAnswered = true;
                      q.selectedIndex = optIndex;
                      logic.update();

                      // if (optIndex == q.correctIndex) {
                      if (q.isAnswered) {
                        // Flip the card if correct
                        Future.delayed(const Duration(milliseconds: 1300), () {
                          q.flipKey.currentState?.toggleCard();
                        });
                      } else {
                        final isLastQuestion = qIndex == logic.questions.length - 1;

                        // Optionally, swipe to next if incorrect
                        if (qIndex < logic.questions.length - 1) {
                          Future.delayed(
                            const Duration(milliseconds: 2000),
                            () {
                              logic.cardSwiperController.swipe(CardSwiperDirection.left,);
                            },
                          );
                        } else if(isLastQuestion){
                          int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                          int totalQuestions = logic.questions.length;
                          double percent = (correctAnswers / totalQuestions) * 100;

                          Future.delayed(Duration(milliseconds: 3000), () {
                            Get.off(LiveChallengeResultScreen(result: percent));
                          });
                        }
                      }
                    }
                  },
                  /*onTap: () { // old working before card fliped
                    if (!q.isAnswered) {
                      q.isAnswered = true;
                      q.selectedIndex = optIndex; // <-- save selected option
                      setState(() {});

                      if(qIndex<logic.questions.length-1) {
                        Future.delayed(const Duration(milliseconds: 3000), () {
                          logic.cardSwiperController.swipe(CardSwiperDirection.left);
                        });
                      }
                    }
                    final isLastQuestion = qIndex == logic.questions.length - 1;
                    bool allAnswered = logic.questions.every((q) => q.isAnswered);
                    if (allAnswered && isLastQuestion) {
                      int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                      int totalQuestions = logic.questions.length;
                      double percent = (correctAnswers / totalQuestions) * 100;


                      Future.delayed(Duration(milliseconds: 3000), () {
                        Get.off(LiveChallengeResultScreen(result: percent));
                      });
                    }
                  },*/
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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

              if (int.parse('${qIndex + 1}') == logic.questions.length)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
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
                  ),
                ).marginOnly(top: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrontCardNew(q, int qIndex, logic, int currentIndex) {
    return Container(
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
                  qIndex==0?Column(
                    children: [
                      addText500(
                        "Round 1",
                        fontSize: 20,
                        // fontFamily: 'Caprasimo',
                        height: 22,
                      ),addText500(
                        "Total Contestants - 500",
                        fontSize: 12,
                        // fontFamily: 'Caprasimo',
                        height: 22,
                      ),
                    ],
                  ):addText400(
                    "Lub Dub Nation",
                    fontSize: 20,
                    fontFamily: 'Caprasimo',
                    height: 22,
                  ),
                  GestureDetector(
                    onTap: () {
                      // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                      showLeaveQuizSheet(context,(){
                        logic.currentIndex=0;
                        logic.shouldStopAllTimers = true;
                        logic.update();
                        Get.delete<LiveChallengeQuizCtrl>(force: true);
                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
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
              Align(
                alignment: Alignment.centerRight,
                child: addText600(
                  'johndoe / Unsplash',
                  color: AppColors.textColor,
                  fontSize: 9,
                ),
              ).marginOnly(right: 10),
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
                    child: CountdownTimerWidget(
                      key: ValueKey(currentIndex),
                      duration: 20,
                      isInSecondsMode: true,
                      shouldStop: logic.shouldStopAllTimers,
                      onTimerEnd: (){
                        if(logic.isLastQ==true){
                          int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                          int totalQuestions = logic.questions.length;
                          double percent = (correctAnswers / totalQuestions) * 100;
                          Get.off(LiveChallengeResultScreen(result: percent));
                        }else{
                          _playConfettiSound(sound: AppAssets.swipeSound);
                          swiperKey.currentState?.swipeLeft();
                        }
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
                  onTap: () {
                    // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                    if (!q.isAnswered) {
                      q.isAnswered = true;
                      q.selectedIndex = optIndex;
                      logic.update();

                      // if (optIndex == q.correctIndex) {
                      if (q.isAnswered) {
                        if(optIndex == q.correctIndex){
                          _playConfettiSound(sound: AppAssets.correctAnswerSound);
                        }else{
                          _playConfettiSound(sound: AppAssets.wrongAnswerSound);
                        }
                        final isLastQuestion = qIndex == logic.questions.length - 1;

                        // Optionally, swipe to next if incorrect
                        if (qIndex < logic.questions.length - 1) {
                          Future.delayed(
                            const Duration(milliseconds: 2000),
                                () {
                                  _playConfettiSound(sound: AppAssets.swipeSound);
                              // logic.cardSwiperController.swipe(CardSwiperDirection.left,);
                                  swiperKey.currentState?.swipeLeft();
                            },
                          );
                        } else if(isLastQuestion){
                          int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                          int totalQuestions = logic.questions.length;
                          double percent = (correctAnswers / totalQuestions) * 100;

                          Future.delayed(Duration(milliseconds: 3000), () {
                            Get.off(LiveChallengeResultScreen(result: percent));
                          });
                        }
                      }
                    }
                  },
                  /*onTap: () { // old working before card fliped
                    if (!q.isAnswered) {
                      q.isAnswered = true;
                      q.selectedIndex = optIndex; // <-- save selected option
                      setState(() {});

                      if(qIndex<logic.questions.length-1) {
                        Future.delayed(const Duration(milliseconds: 3000), () {
                          logic.cardSwiperController.swipe(CardSwiperDirection.left);
                        });
                      }
                    }
                    final isLastQuestion = qIndex == logic.questions.length - 1;
                    bool allAnswered = logic.questions.every((q) => q.isAnswered);
                    if (allAnswered && isLastQuestion) {
                      int correctAnswers = logic.questions.where((q) => q.selectedIndex == q.correctIndex).length;
                      int totalQuestions = logic.questions.length;
                      double percent = (correctAnswers / totalQuestions) * 100;


                      Future.delayed(Duration(milliseconds: 3000), () {
                        Get.off(LiveChallengeResultScreen(result: percent));
                      });
                    }
                  },*/
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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

              if (int.parse('${qIndex + 1}') == logic.questions.length)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
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
                  ),
                ).marginOnly(top: 28),
            ],
          ),
        ),
      ),
    );
  }
}
