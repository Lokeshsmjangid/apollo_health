import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';
import 'package:apollo/resources/Apis/api_repository/submit_answer_group_play_repo.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/screens/game_mode/group_play/group_play_waiting_screen.dart';
import 'package:apollo/screens/game_mode/group_play/group_play_question_card.dart';
import 'package:apollo/resources/Apis/api_repository/group_play_result_repo.dart';
import 'package:apollo/resources/Apis/api_repository/solo_play_result_repo.dart';
import 'package:apollo/resources/Apis/api_repository/quit_group_play_repo.dart';
import 'package:apollo/resources/Apis/api_repository/quit_solo_play_repo.dart';
import 'package:apollo/resources/Apis/api_repository/submit_answer_repo.dart';
import 'package:apollo/screens/game_mode/group_play/group_play_result.dart';
import 'package:apollo/screens/game_mode/solo_play/solo_play_result.dart';
import 'package:apollo/custom_widgets/linear_progress_segment.dart';
import 'package:apollo/resources/countdown_timer_explanation.dart';
import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:apollo/custom_widgets/custom_card_stack.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/countdown_timer.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/controllers/gM_quiz_ctrl.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'solo_play_question_without_explanation.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'solo_flip/front_card.dart';
import 'package:get/get.dart';
import 'dart:async';

class QuizScreenNew extends StatefulWidget {
  const QuizScreenNew({super.key});

  @override
  State<QuizScreenNew> createState() => _QuizScreenNewState();
}

class _QuizScreenNewState extends State<QuizScreenNew> with WidgetsBindingObserver{
  final GlobalKey<StackedDraggableSwiperState> swiperKey = GlobalKey<StackedDraggableSwiperState>();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSwiping = false;
  @override
  void initState() {
    super.initState();
    // Future.microtask((){
    //
    //   startTimer();
    // });
    WidgetsBinding.instance.addObserver(this);
    // _loadBannerAd();
  }

  @override
  void dispose() {
    // Unregister
    // waitingTimer?.cancel();
    // _bannerAd?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }
  Future<void> _playConfettiSound({required String sound}) async {
    // if(AuthData().musicONOFF) {
      await _audioPlayer.play(AssetSource(sound));
    // }
  }

  void _safeSwipeLeft() {
    if (_isSwiping) return;
    _isSwiping = true;
    swiperKey.currentState?.swipeLeft();
    Future.delayed(const Duration(milliseconds: 300), () {
      _isSwiping = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Called automatically when app state changes
    super.didChangeAppLifecycleState(state);

    // Show toast message based on state
    switch (state) {
      case AppLifecycleState.resumed:
        apolloPrint(message: "App resumed (foreground)");
        break;

      case AppLifecycleState.inactive:
        apolloPrint(message: "App inactive");
        break;

      case AppLifecycleState.paused:
        apolloPrint(message: "App in background");
        break;

      case AppLifecycleState.detached:
        apolloPrint(message: "App is terminating");
        if(Get.find<GMQuizCtrl>().fromScreen=="soloPlay"){
          showLeaveQuizSheet(context, () {
            quitSoloPlayApi(gameId: Get.find<GMQuizCtrl>().gameData?.id);
          });
        }
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        // throw UnimplementedError();
    }

    // Optional: you can also trigger pause logic, mute audio, save quiz, etc.
  }



  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(
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
                      stackCount: logic.questionsApi.length > 3 ? 3 : logic.questionsApi.length,
                      backCardOffset: -24,
                      duration: Duration(milliseconds: 200),
                      backCardScale: 0.05,
                      swipeEnabled: false,
                      onDrag: (index, dx, angle) {
                        // Do something while dragging (e.g., update UI, show overlay)
                        apolloPrint(
                          message: 'Dragging: index:$index, dx=$dx, angle=$angle',
                        );
                      },
                      onSwipe: (index, direction) {
                        apolloPrint(message: 'Current Index:00:${logic.currentIndex}');
                        apolloPrint(message: 'index Index:00:$index');

                        final isLastQuestion = index == logic.questionsApi.length - 1;
                        logic.currentIndex = index + 1; // current Question index

                        logic.isLastQ = logic.currentIndex == logic.questionsApi.length - 1; // new line added because of last index not swipe
                        apolloPrint(message: '${logic.fromScreen} isLastQ: ${logic.isLastQ}',);

                        logic.update();
                        apolloPrint(message: 'Current Index:11:${logic.currentIndex}',);
                        _isSwiping = false; // ensure unlock on callback as well

                        if (isLastQuestion) {
                          int correctAnswers = logic.questionsApi.where((q) => q.selectedIndex == q.correctIndex).length;
                          int totalQuestions = logic.questionsApi.length;
                          double percent = (correctAnswers / totalQuestions) * 100;
                        }
                      },
                      cards: List.generate(logic.questionsApi.length, (i) {
                        final q = logic.questionsApi[i];
                        return logic.fromScreen == "groupPlay"
                            ? GroupPlayQuestionCard(
                          question: q,
                          questionIndex: i,
                          logic: logic,
                          currentIndex: logic.currentIndex,
                          onSwipeLeft: _safeSwipeLeft,
                        )
                        // _buildFrontCardGP(q, i, logic, logic.currentIndex)
                            : logic.gameData!.showExplanation == 0 // for solo play
                            ? SoloPlayQuestionWithoutExplanation(
                          question: q, questionIndex: i, logic: logic,
                          currentIndex: logic.currentIndex,// pass your banner ready flag
                          onSwipeLeft: _safeSwipeLeft,
                        )  // for solo play
                            // ? _buildFrontCardSP(q, i, logic, logic.currentIndex)  // for solo play
                            : FlipCard(  // for solo play
                              key: q.flipKey,
                              flipOnTouch: false,
                              // front: _buildFrontCard(q, i, logic, logic.currentIndex),
                              // back: _buildBackCard(q, i, logic, logic.currentIndex),
                              front: FrontCard(q: q,qIndex: i,logic: logic,currentIndex: logic.currentIndex, onSwipeLeft: () => swiperKey.currentState?.swipeLeft()),
                              back: _buildBackCard(q, i, logic, logic.currentIndex));
                      }),
                    ).paddingOnly(left: 4, right: 4, top: 15),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFrontCardGP(
    SoloPlayQuestion q,
    int qIndex,
    logic,
    int currentIndex,
  ) {
    return SizedBox.expand(
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        decoration: BoxDecoration(
          color: qIndex == logic.currentIndex
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
            // margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
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
                        if (q.favorite == 1) {
                          q.favorite = 0;
                        } else if (q.favorite == 0) {
                          q.favorite = 1;
                        }
                        // q.isLike= !q.isLike;
                        setState(() {});
                        // apolloPrint(message: 'message::: ${ q.isLike}');
                        // showLikeQuestionSheet(context);
                      },
                      child: Icon(
                        q.favorite == 1
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: q.favorite == 1 ? Colors.red : Colors.black,
                        size: 28,
                      ),
                      // child: Image.asset(
                      //   AppAssets.favIcon,
                      //   color: logic.isLike?Colors.red:Colors.black,
                      //   height: 24,
                      //   width: 24,
                      // ),
                    ),
                    addText400(
                      q.categoryName ?? '',
                      fontSize: 20,
                      fontFamily: 'Caprasimo',
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () {
                        // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                        showLeaveQuizSheet(context, () {
                          showLoader(true);
                          quitGroupPlayApi(gameId: logic.gameData?.id).then((value){
                            showLoader(false);
                            if(value.status==true){
                              // _bannerAd?.dispose();
                              logic.currentIndex = 0;
                              logic.shouldStopAllTimers = true;
                              logic.update();
                              Get.delete<GMQuizCtrl>(force: true);
                              Get.back();
                              Get.to(() => DashBoardScreen());
                            }
                          });

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
                        totalSegments: logic.questionsApi.length,
                      ),
                    ),
                    SizedBox(width: 10),
                    addText500(
                      "${qIndex + 1}/${logic.questionsApi.length}",

                      fontSize: 16,
                      height: 22,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap:(){
                          launchURL(url: '${q.photoByUrl}');
                        },
                        child: addText600(
                          '${q.photoBy} ',
                          color: AppColors.textColor,
                          fontSize: 9,
                        ),
                      ),GestureDetector(
                        onTap:(){
                          launchURL(url: '${q.imageUrlUnsplash}');
                        },
                        child: addText600(
                          '/ Unsplash',
                          color: AppColors.textColor,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ).marginOnly(right: 10),
                SizedBox(height: 4),

                // Image with badges
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      /*child: Image.asset(
                        q.imagePath,

                        width: MediaQuery.sizeOf(context).width*0.8,
                        height: 200,
                        fit: BoxFit.cover,
                      ),*/
                      child: CachedImageCircle2(
                        imageUrl: q.imageUrl,
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 200,
                        fit: BoxFit.cover,
                        isCircular: false,
                      ),
                    ),

                    // Timer Widget
                    Positioned(
                      left: 12,
                      top: 12,
                      child: CountdownTimerWidget(
                        key: ValueKey(currentIndex),
                        duration: 20,
                        isInSecondsMode: true,
                        shouldStop: logic.shouldStopAllTimers,
                        onTick: (second){
                          q.secondsLeft = second;
                          setState(() {});
                        },
                        onTimerEnd: () {
                          if (logic.isLastQ == true) {
                            apolloPrint(message: 'logic.isLastQ111::::${logic.isLastQ}');


                            if(!q.isAnswered && currentIndex==qIndex){ // added for skip
                              submitAnswerGroupApi(
                                  gameId: logic.gameData?.id,
                                  questionId: q.id,
                                  selectedOption: "E",
                                  timeTakenSeconds: 20-q.secondsLeft, favorite: q.favorite, isStuck: q.isStuck==true?1:0
                              );
                            }


                            showLoader(true);
                            groupPlayResultApi(gameId: logic.gameData?.id).then((value){
                              showLoader(false);
                              if(value.status==true){

                                  groupWaitingTime = logic.groupPlayRemainingSeconds;

                                Get.off(GroupPlayWaitingScreen(
                                // Get.off(GroupPlayResultScreen( // Before groupPlay waiting screen
                                  isPlayRequest: logic.isPlayRequest,
                                    users: value.users!,isMadPardy: false,
                                    gameId: logic.gameData?.id));

                                apolloPrint(message: 'timmmmmmm: $groupWaitingTime');
                              }
                            });
                          } else {
                            _playConfettiSound(sound: AppAssets.swipeSound);
                            swiperKey.currentState?.swipeLeft();
                            if(!q.isAnswered && currentIndex==qIndex){ // added for skip
                              submitAnswerGroupApi(
                                  gameId: logic.gameData?.id,
                                  questionId: q.id,
                                  selectedOption: "E",
                                  timeTakenSeconds: 20-q.secondsLeft, favorite: q.favorite, isStuck: q.isStuck==true?1:0
                              );
                            }
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
                          // showStuckSheet(context);
                          if( q.isStuck==false && q.options != null && q.options!.every((option) => option.trim().isNotEmpty)){
                            final totalOptions = q.options?.length ?? 0;
                            final availableIndices = List.generate(totalOptions, (i) => i)
                                .where((i) => i != q.correctIndex && !q.highlightedOptionIndices!.contains(i))
                                .toList();

                            if (availableIndices.length >= 2) {
                              availableIndices.shuffle();
                              final toHighlight = availableIndices.take(2);
                              q.highlightedOptionIndices!.addAll(toHighlight);

                            } else if (availableIndices.length == 1) {
                              q.highlightedOptionIndices!.add(availableIndices.first);
                            }
                            q.isStuck=true;
                            setState(() {});
                          }

                        },
                        child: Container(
                          height: 26,
                          width: 32,
                          // padding: EdgeInsets.symmetric(
                          //   horizontal: 10,
                          //   vertical: 6,
                          // ),
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
                    ),
                  ],
                ),
                SizedBox(height: 17),

                // Question
                addText500(
                  q.question ?? '',
                  fontSize: 20,
                  height: 28,
                  color: Colors.black87,
                  textAlign: TextAlign.center
                ).marginSymmetric(horizontal: 8),
                SizedBox(height: 14),

                // Answers
                ...List.generate(q.options!.length, (optIndex) {
                  final isHighlighted = q.highlightedOptionIndices!.contains(optIndex);
                  return GestureDetector(
                    onTap: () {

                      // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                      if (q.options![optIndex].isNotEmpty && !q.isAnswered) {
                        q.isAnswered = true;
                        q.selectedIndex = optIndex;
                        setState(() {});

                        // if (optIndex == q.correctIndex) {
                        if (q.isAnswered) {
                          if (optIndex == q.correctIndex) {
                            _playConfettiSound(sound: AppAssets.correctAnswerSound);
                          }
                          else {
                            _playConfettiSound(sound: AppAssets.wrongAnswerSound);
                          }

                          final isLastQuestion = qIndex == logic.questionsApi.length - 1;
                          apolloPrint(message: "message 0000000 ${logic.fromScreen}");

                          if (qIndex < logic.questionsApi.length - 1) {

                            Future.delayed(const Duration(milliseconds: 2000),
                              () {
                                _playConfettiSound(sound: AppAssets.swipeSound);
                                q.isAnswered = false; // added for blink colors issue
                                setState(() {}); // added for blink colors issue
                                swiperKey.currentState?.swipeLeft();
                              },
                            );
                          } else if (isLastQuestion) {
                            // int correctAnswers = logic.questionsApi.where((q) => q.selectedIndex == q.correctIndex).length;
                            // int totalQuestions = logic.questionsApi.length;
                            // double percent = (correctAnswers / totalQuestions) * 100;

                            showLoader(true);
                            groupPlayResultApi(gameId: logic.gameData?.id).then((value){
                              showLoader(false);
                              if(value.status==true){
                                if (logic.fromScreen == 'groupPlay') {
                                  groupWaitingTime = logic.groupPlayRemainingSeconds;
                                  Get.off(()=> GroupPlayWaitingScreen(
                                  // Get.off(GroupPlayResultScreen( // Before groupPlay waiting screen
                                      isPlayRequest: logic.isPlayRequest,
                                      users: value.users!,isMadPardy: false,
                                      gameId: logic.gameData?.id));
                                  apolloPrint(message: 'timmmmmmm: $groupWaitingTime');
                                }}
                            });
                          }
                        }

                        submitAnswerGroupApi(
                            gameId: logic.gameData?.id,
                            questionId: q.id,
                            selectedOption: q.selectedIndex==0?'A':q.selectedIndex==1?'B':q.selectedIndex==2?'C':q.selectedIndex==3?'D':"",
                            timeTakenSeconds: 20-q.secondsLeft, favorite: q.favorite, isStuck: q.isStuck==true?1:0
                        );
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
                        color: q.options![optIndex].isEmpty || isHighlighted? Color(0XFFF6F6F6) : logic.getOptionColor(qIndex, optIndex),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: addText500(
                          q.options![optIndex],
                          fontSize: 16,
                          color: q.options![optIndex].isEmpty || isHighlighted?Color(0XFFDCDCDC):AppColors.blackColor,
                        ),
                      ),
                    )).marginOnly(bottom: 8);
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
                ).marginOnly(bottom: 35, top: 20),
              ],
            ),
          ),
        ),
      ),
    );}

  Widget _buildFrontCardSP(
    SoloPlayQuestion q,
    int qIndex,
      GMQuizCtrl logic,
    int currentIndex,
  ) { return SizedBox.expand( // it is for hide explanation
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
            // margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
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
                        if (q.favorite == 1) {
                          q.favorite = 0;
                        } else if (q.favorite == 0) {
                          q.favorite = 1;
                        }
                        // q.isLike= !q.isLike;
                        setState(() {});
                        // apolloPrint(message: 'message::: ${ q.isLike}');
                        // showLikeQuestionSheet(context);
                      },
                      child: Icon(
                        q.favorite == 1
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: q.favorite == 1 ? Colors.red : Colors.black,
                        size: 28,
                      ),
                      // child: Image.asset(
                      //   AppAssets.favIcon,
                      //   color: logic.isLike?Colors.red:Colors.black,
                      //   height: 24,
                      //   width: 24,
                      // ),
                    ),
                    addText400(
                      q.categoryName ?? '',
                      fontSize: 20,
                      fontFamily: 'Caprasimo',
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () {

                        showLeaveQuizSheet(context, () {
                          Get.back();
                          showLoader(true);
                          quitSoloPlayApi(gameId: logic.gameData?.id).then((quit){
                          showLoader(false);
                          if(quit.status==true){
                            logic.currentIndex = 0;
                            logic.shouldStopAllTimers = true;
                            logic.update();
                            Get.delete<GMQuizCtrl>(force: true);
                            Get.to(() => DashBoardScreen());
                          }else if(quit.status==false){
                            CustomSnackBar().showSnack(Get.context!,message: '${quit.message}',isSuccess: false);
                          }

                          });


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
                        totalSegments: logic.questionsApi.length,
                      ),
                    ),
                    SizedBox(width: 10),
                    addText500(
                      "${qIndex + 1}/${logic.questionsApi.length}",

                      fontSize: 16,
                      height: 22,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap:(){
                          launchURL(url: '${q.photoByUrl}');
                        },
                        child: addText600(
                          '${q.photoBy} ',
                          color: AppColors.textColor,
                          fontSize: 9,
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          launchURL(url: '${q.imageUrlUnsplash}');
                        },
                        child: addText600(
                          '/ Unsplash',
                          color: AppColors.textColor,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ).marginOnly(right: 10),
                SizedBox(height: 4),

                // Image with badges
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      /*child: Image.asset(
                        q.imagePath,

                        width: MediaQuery.sizeOf(context).width*0.8,
                        height: 200,
                        fit: BoxFit.cover,
                      ),*/
                      child: CachedImageCircle2(
                        imageUrl: q.imageUrl,
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 200,
                        fit: BoxFit.cover,
                        isCircular: false,
                      ),
                    ),

                    // Timer Widget
                    Positioned(
                      left: 12,
                      top: 12,
                      child: CountdownTimerWidget(
                        key: ValueKey(currentIndex),
                        duration: 20,
                        isInSecondsMode: true,
                        shouldStop: logic.shouldStopAllTimers,
                        onTick: (second){
                          q.secondsLeft =second;
                          setState(() {});
                        },
                        onTimerEnd: () {
                          if (logic.isLastQ == true) {
                            apolloPrint(
                              message: 'logic.isLastQ111::::${logic.isLastQ}',
                            );
                            if(!q.isAnswered){ // added for skip
                            submitAnswerApi(
                            gameId: logic.gameData?.id,
                            questionId: q.id,
                            selectedOption: "E",
                            timeTakenSeconds: 20-q.secondsLeft, favorite: q.favorite, isStuck: q.isStuck==true?1:0
                            );}


                            showLoader(true);
                            soloPlayResultApi(gameId: logic.gameData?.id).then((value){
                              showLoader(false);
                              if(value.status==true){Get.off(SoloResultScreen(soloPlayResult: value.data));}
                            });
                          } else {
                            _playConfettiSound(sound: AppAssets.swipeSound);
                            swiperKey.currentState?.swipeLeft();

                            if(!q.isAnswered && currentIndex==qIndex){ // added for skip
                              submitAnswerApi(
                                  gameId: logic.gameData?.id,
                                  questionId: q.id,
                                  selectedOption: "E",
                                  timeTakenSeconds: 20-q.secondsLeft, favorite: q.favorite, isStuck: q.isStuck==true?1:0
                              );
                            }

                          }
                        },
                      ),
                    ),


                    Positioned(
                      right: 12,
                      top: 12,
                      child: GestureDetector(
                        onTap: () {
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          // showStuckSheet(context);

                          if( q.isStuck==false && q.options != null && q.options!.every((option) => option.trim().isNotEmpty)){
                          final totalOptions = q.options?.length ?? 0;
                          final availableIndices = List.generate(totalOptions, (i) => i)
                              .where((i) => i != q.correctIndex && !q.highlightedOptionIndices!.contains(i))
                              .toList();

                          if (availableIndices.length >= 2) {
                            // Shuffle and pick the first two
                            availableIndices.shuffle();
                            final toHighlight = availableIndices.take(2);
                            q.highlightedOptionIndices!.addAll(toHighlight);

                          } else if (availableIndices.length == 1) {
                            // Only one left to highlight
                            q.highlightedOptionIndices!.add(availableIndices.first);

                          }
                          q.isStuck=true;
                          setState(() {});
                          }

                        },
                        child: Container(
                          height: 26,
                          width: 32,
                          // padding: EdgeInsets.symmetric(
                          //   horizontal: 10,
                          //   vertical: 6,
                          // ),
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
                    ),
                  ],
                ),
                SizedBox(height: 17),

                // Question
                addText500(
                  q.question ?? '',
                  fontSize: 20,
                  height: 28,
                  textAlign: TextAlign.center,
                  color: Colors.black87,
                ).marginSymmetric(horizontal: 8),
                SizedBox(height: 14),

                // Answers
                ...List.generate(q.options!.length, (optIndex) {
                  final isHighlighted = q.highlightedOptionIndices!.contains(optIndex);
                  return GestureDetector(
                    onTap: () {
                      // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                      if (q.options![optIndex].isNotEmpty && !q.isAnswered ) {
                        q.isAnswered = true;
                        q.selectedIndex = optIndex;
                        setState(() {});

                        // if (optIndex == q.correctIndex) {
                        if (q.isAnswered) {
                          if (optIndex == q.correctIndex) {
                            _playConfettiSound(
                              sound: AppAssets.correctAnswerSound,
                            );
                          }
                          else {
                            _playConfettiSound(
                              sound: AppAssets.wrongAnswerSound,
                            );
                          }

                          final isLastQuestion = qIndex == logic.questionsApi.length - 1;
                          apolloPrint(message: "message 0000000 ${logic.fromScreen}");

                          if (qIndex < logic.questionsApi.length - 1) {
                            Future.delayed(
                              const Duration(milliseconds: 2000),
                              () {
                                _playConfettiSound(sound: AppAssets.swipeSound);
                                q.isAnswered = false; // added for blink colors issue
                                setState(() {}); // added for blink colors issue
                                swiperKey.currentState?.swipeLeft();
                              },
                            );
                          } else if (isLastQuestion) {
                            // int correctAnswers = logic.questionsApi.where((q) => q.selectedIndex == q.correctIndex).length;
                            // int totalQuestions = logic.questionsApi.length;
                            // double percent = (correctAnswers / totalQuestions) * 100;


                            showLoader(true);
                            soloPlayResultApi(gameId: logic.gameData?.id).then((value){
                              showLoader(false);
                              if(value.status==true){
                                if (logic.fromScreen == 'soloPlay') {
                                  Get.off(SoloResultScreen(soloPlayResult: value.data));
                                } else if (logic.fromScreen == 'groupPlay') {
                                  Get.off(GroupPlayResultScreen());
                                }
                              }

                            });
                          }
                        }
                        submitAnswerApi(
                          gameId: logic.gameData?.id,
                          questionId: q.id,
                          selectedOption: q.selectedIndex==0?'A':q.selectedIndex==1?'B':q.selectedIndex==2?'C':q.selectedIndex==3?'D':"",
                          timeTakenSeconds: 20-q.secondsLeft, favorite: q.favorite, isStuck: q.isStuck==true?1:0
                        );
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
                        color: q.options![optIndex].isEmpty|| isHighlighted?Color(0XFFF6F6F6):logic.getOptionColor(qIndex, optIndex),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: addText500(
                          q.options![optIndex],
                          fontSize: 16,
                          color: q.options![optIndex].isEmpty || isHighlighted?Color(0XFFDCDCDC):AppColors.blackColor,
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
                ).marginOnly(bottom: 35, top: 20),
              ],
            ),
          ),
        ),
      ),
    );}

  Widget _buildFrontCard(
    SoloPlayQuestion q,
    int qIndex, GMQuizCtrl logic,
    int currentIndex
  ) { return SizedBox.expand(
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
            // margin: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
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
                        if (q.favorite == 0) {
                          q.favorite = 1;
                        } else if (q.favorite == 1) {
                          q.favorite = 0;
                        }

                        // q.isLike= !q.isLike;
                        setState(() {});
                        apolloPrint(message: 'message::: ${q.favorite}');
                        // showLikeQuestionSheet(context);
                      },
                      child: Icon(
                        q.favorite == 1
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: q.favorite == 1 ? Colors.red : Colors.black,
                        size: 28,
                      ),
                      // child: Image.asset(
                      //   AppAssets.favIcon,
                      //   color: logic.isLike?Colors.red:Colors.black,
                      //   height: 24,
                      //   width: 24,
                      // ),
                    ),
                    addText400(
                      q.categoryName ?? '',
                      fontSize: 20,
                      fontFamily: 'Caprasimo',
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () {

                        showLeaveQuizSheet(context, () {
                          // _bannerAd?.dispose();
                          Get.back();
                          showLoader(true);
                          quitSoloPlayApi(gameId: logic.gameData?.id).then((quit){
                            showLoader(false);
                            if(quit.status==true){
                              logic.currentIndex = 0;
                              logic.shouldStopAllTimers = true;
                              logic.update();
                              Get.delete<GMQuizCtrl>(force: true);
                              Get.to(() => DashBoardScreen());
                            }else if(quit.status==false){
                              CustomSnackBar().showSnack(Get.context!,message: '${quit.message}',isSuccess: false);
                            }

                          });


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
                        totalSegments: logic.questionsApi.length,
                      ),
                    ),
                    SizedBox(width: 10),

                    addText500(
                      "${qIndex + 1}/${logic.questionsApi.length}",

                      fontSize: 16,
                      height: 22,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap:(){
                          launchURL(url: '${q.photoByUrl}');
                        },
                        child: addText600(
                          '${q.photoBy} ',
                          color: AppColors.textColor,
                          fontSize: 9,
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          launchURL(url: '${q.imageUrlUnsplash}');
                        },
                        child: addText600(
                          '/ Unsplash',
                          color: AppColors.textColor,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ).marginOnly(right: 10),
                SizedBox(height: 4),

                // Image with badges
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      // child: Image.asset(
                      //   q.imagePath,
                      //   // width: double.infinity,
                      //   width: MediaQuery.sizeOf(context).width*0.8,
                      //   height: 200,
                      //   fit: BoxFit.cover,
                      // ),
                      child: CachedImageCircle2(
                        imageUrl: q.imageUrl,
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: 200,
                        fit: BoxFit.cover,
                        isCircular: false,
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
                        onTimerEnd: () {
                          if (logic.isLastQ == true && !q.isAnswered) {
                            apolloPrint(message: 'logic.isLastQ111::::${logic.isLastQ}');
                            if(!q.isAnswered && currentIndex==qIndex){ // added for skip
                              submitAnswerApi(
                                  gameId: logic.gameData?.id,
                                  questionId: q.id,
                                  selectedOption: "E",
                                  timeTakenSeconds: 20-q.secondsLeft, favorite: q.favorite, isStuck: q.isStuck==true?1:0
                              );
                            }

                            showLoader(true);
                            soloPlayResultApi(gameId: logic.gameData?.id).then((value){
                              showLoader(false);
                              if(value.status==true){Get.off(SoloResultScreen(soloPlayResult: value.data));}
                            });
                          } else{
                            apolloPrint(message: 'message:::::fdsff${!q.isAnswered}');
                            if(logic.currentIndex==qIndex && !q.isAnswered){
                              _playConfettiSound(sound: AppAssets.swipeSound);
                              swiperKey.currentState?.swipeLeft();
                              if(!q.isAnswered && currentIndex==qIndex){ // added for skip
                                submitAnswerApi(
                                    gameId: logic.gameData?.id,
                                    questionId: q.id,
                                    selectedOption: "E",
                                    timeTakenSeconds: 20-q.secondsLeft, favorite: q.favorite, isStuck: q.isStuck==true?1:0
                                );
                              }
                            }
                          }
                        },
                        onTick: (second){
                          q.secondsLeft = second;
                          setState(() {});
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
                          // showStuckSheet(context);


                          if(q.isStuck==false && q.options != null && q.options!.every((option) => option.trim().isNotEmpty)) {
                            final totalOptions = q.options?.length ?? 0;
                            final availableIndices = List.generate(
                                totalOptions, (i) => i)
                                .where((i) =>
                            i != q.correctIndex &&
                                !q.highlightedOptionIndices!.contains(i))
                                .toList();

                            if (availableIndices.length >= 2) {
                              // Shuffle and pick the first two
                              availableIndices.shuffle();
                              final toHighlight = availableIndices.take(2);
                              q.highlightedOptionIndices!.addAll(toHighlight);
                            } else if (availableIndices.length == 1) {
                              // Only one left to highlight
                              q.highlightedOptionIndices!.add(availableIndices.first);

                            }
                            q.isStuck=true;
                            setState(() {});
                          }
                        },
                        child: Container(
                          height: 26,
                          width: 32,
                          // padding: EdgeInsets.symmetric(
                          //   horizontal: 10,
                          //   vertical: 6,
                          // ),
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
                    ),
                  ],
                ),
                SizedBox(height: 17),

                // Question
                addText500(
                  q.question ?? '',
                  fontSize: 20,
                  height: 28,
                  color: Colors.black87,
                    textAlign: TextAlign.center
                ).marginSymmetric(horizontal: 8),
                SizedBox(height: 14),

                // Answers
                ...List.generate(q.options!.length, (optIndex) {
                  final isHighlighted = q.highlightedOptionIndices!.contains(optIndex);
                  return GestureDetector(
                    onTap: () {
                      // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                      if (q.options![optIndex].isNotEmpty && !q.isAnswered) {
                        q.isAnswered = true;
                        q.selectedIndex = optIndex;
                        setState(() {});

                        if (q.isAnswered) {
                          if (optIndex == q.correctIndex) {
                            _playConfettiSound(
                              sound: AppAssets.correctAnswerSound,
                            );
                          }
                          else {
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
                          apolloPrint(message: "message 0000000 ${logic.fromScreen}");


                        }
                        else {
                          final isLastQuestion = qIndex == logic.questionsApi.length - 1;
                          apolloPrint(message: "message 0000000 ${logic.fromScreen}");
                          // Optionally, swipe to next if incorrect
                          if (qIndex < logic.questionsApi.length - 1) {
                            Future.delayed(
                              const Duration(milliseconds: 2000),
                              () {
                                logic.cardSwiperController.swipe(
                                  CardSwiperDirection.left,
                                );
                              },
                            );
                          }
                          else if (isLastQuestion) {
                            int correctAnswers = logic.questionsApi.where((q) => q.selectedIndex == q.correctIndex).length;
                            int totalQuestions = logic.questionsApi.length;
                            double percent = (correctAnswers / totalQuestions) * 100;

                            Future.delayed(Duration(milliseconds: 3000), () {
                              apolloPrint(message: "message 1111 ${logic.fromScreen}");

                              if (logic.fromScreen == 'soloPlay') {
                                Get.off(SoloResultScreen(result: percent));
                              }
                              else if (logic.fromScreen == 'groupPlay') {
                                Get.off(GroupPlayResultScreen());
                              }
                            });
                          }
                        }

                        // int? secondsLeft = q.timerTakenKey?.currentState?.secondsLeft;
                        // print('secondsLeft$secondsLeft');
                        // int timeTaken = 20 - (secondsLeft ?? 0);

                        submitAnswerApi(
                            gameId: logic.gameData?.id,
                            questionId: q.id,
                            selectedOption:
                            q.selectedIndex==0?'A':
                            q.selectedIndex==1?'B':
                            q.selectedIndex==2?'C':
                            q.selectedIndex==3?'D'
                                :"",
                            timeTakenSeconds: 20-q.secondsLeft,
                            favorite: q.favorite, isStuck: q.isStuck==true?1:0
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: q.options![optIndex].isEmpty|| isHighlighted?Color(0XFFF6F6F6):logic.getOptionColor(qIndex, optIndex),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: addText500(
                          q.options![optIndex],
                          fontSize: 16,
                          color: q.options![optIndex].isEmpty || isHighlighted?Color(0XFFDCDCDC):AppColors.blackColor,
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
                ).marginOnly(bottom: 35, top: 20),
              ],
            ),
          ),
        ),
      ),
    );}

  Widget _buildBackCard(
    SoloPlayQuestion q,
    int qIndex,
    logic,
    int currentIndex,
  ) { return SizedBox.expand(
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
                        if (q.favorite == 0) {
                          q.favorite = 1;
                        } else if (q.favorite == 1) {
                          q.favorite = 0;
                        }

                        //q.isLike = !q.isLike;
                        setState(() {});
                      },
                      child: Icon(
                        q.favorite == 1
                            ? Icons.favorite
                            : Icons.favorite_border_rounded,
                        color: q.favorite == 1 ? Colors.red : Colors.black,
                        size: 28,
                      ),
                    ),
                    addText400(
                      q.categoryName ?? '',
                      fontSize: 20,
                      fontFamily: 'Caprasimo',
                      height: 22,
                    ),
                    GestureDetector(
                      onTap: () {
                        showLeaveQuizSheet(context, () {
                          // _bannerAd?.dispose();
                          Get.back();
                          showLoader(true);
                          quitSoloPlayApi(gameId: logic.gameData?.id).then((quit){
                            showLoader(false);
                            if(quit.status==true){
                              logic.currentIndex = 0;
                              logic.shouldStopAllTimers = true;
                              logic.update();
                              Get.delete<GMQuizCtrl>(force: true);
                              Get.to(() => DashBoardScreen());
                            }else if(quit.status==false){
                              CustomSnackBar().showSnack(Get.context!,message: '${quit.message}',isSuccess: false);
                            }

                          });


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
                        totalSegments: logic.questionsApi.length,
                      ),
                    ),
                    SizedBox(width: 10),
                    addText500(
                      "${qIndex + 1}/${logic.questionsApi.length}",
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
                      if(logic.currentIndex==qIndex && q.isAnswered)
                      Positioned(
                        left: 12,
                        top: 12,
                        child: CountdownTimerWidgetExplanation(
                          key: ValueKey(currentIndex),
                          duration: 40,
                          isInSecondsMode: true,
                          shouldStop: logic.shouldStopAllTimers,
                          onTimerEnd: () {
                            if (logic.isLastQ == true) {
                              apolloPrint(
                                message: 'logic.isLastQ111::::${logic.isLastQ}',
                              );
                              // int correctAnswers = logic.questionsApi.where((q) => q.selectedIndex == q.correctIndex,).length;
                              // int totalQuestions = logic.questionsApi.length;
                              // double percent = (correctAnswers / totalQuestions) * 100;
                              // Get.off(SoloResultScreen(result: percent));
                              showLoader(true);
                              soloPlayResultApi(gameId: logic.gameData?.id,).then((value){
                                showLoader(false);
                                if(value.status==true){
                                  Get.off(SoloResultScreen(soloPlayResult: value.data));}
                              });
                            } else {
                              apolloPrint(message: 'risabh pant');
                              _playConfettiSound(sound: AppAssets.swipeSound);
                              swiperKey.currentState?.swipeLeft();
                            }
                          },
                          onTick: (sec){
                            q.secondsExpLeft = sec;
                            setState(() {});
                          },
                        ),
                      ),
                      Lottie.asset(
                        'assets/Lottie/Apollo magic.json',
                        repeat: true,
                        animate: true,
                        width: 220,
                        height: 220,
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
                                  HTML.toTextSpan(
                                    context,
                                    q.explanation??"",
                                      defaultTextStyle: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Manrope',
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.w500,),
                                      overrideStyle: {
                                        "a": TextStyle(
                                          decoration: TextDecoration.none, // Remove underline from links
                                          color: Colors.blue, // Or your preferred color
                                        ),
                                        "u": TextStyle(
                                          decoration: TextDecoration.none, // Remove underline from <u>
                                        ),}
                                  ),
                                  // TextSpan(
                                  //   text: q.explanation??"",
                                  //   style: TextStyle(
                                  //     fontFamily: 'Manrope',
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
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
                                  HTML.toTextSpan(
                                    context,
                                    q.funFact??"",
                                    defaultTextStyle: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Manrope',
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,),
                                      overrideStyle: {
    "a": TextStyle(
    decoration: TextDecoration.none, // Remove underline from links
    color: Colors.blue, // Or your preferred color
    ),
    "u": TextStyle(
    decoration: TextDecoration.none, // Remove underline from <u>
    ),}
                                  ),
                                  // TextSpan(
                                  //   text: "${q.funFact}",
                                  //   style: TextStyle(
                                  //     fontFamily: 'Manrope',
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
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
                    final isLastQuestion =
                        qIndex == logic.questionsApi.length - 1;
                    // bool allAnswered = logic.questions.every((q) => q.isAnswered);
                    if (isLastQuestion) {
                      // int correctAnswers = logic.questionsApi.where((q) => q.selectedIndex == q.correctIndex).length;
                      // int totalQuestions = logic.questionsApi.length;
                      // double percent = (correctAnswers / totalQuestions) * 100;


                      if (logic.fromScreen == 'soloPlay') {
                        showLoader(true);
                        soloPlayResultApi(gameId: logic.gameData?.id).then((value){
                          showLoader(false);
                          if(value.status==true){
                            Get.off(SoloResultScreen(soloPlayResult: value.data));}
                        });
                      } else if (logic.fromScreen == 'groupPlay') {
                        Get.off(GroupPlayResultScreen());
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
    );}
}