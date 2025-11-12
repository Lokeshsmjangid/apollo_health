import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';
import 'package:apollo/resources/Apis/api_repository/live_challenges_final_result_repo.dart';
import 'package:apollo/resources/Apis/api_repository/submit_answer_live_challenge_repo.dart';
import 'package:apollo/controllers/live_challenge_round_four_ctrl.dart';
import 'package:apollo/custom_widgets/linear_progress_segment.dart';
import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:apollo/custom_widgets/custom_card_stack.dart';
import 'package:apollo/resources/countdown_timer.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:audioplayers/audioplayers.dart';
import 'live_challenge_round_timer_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class LiveChallengeRoundFourScreen extends StatefulWidget {
  const LiveChallengeRoundFourScreen({super.key});

  @override
  State<LiveChallengeRoundFourScreen> createState() =>
      _LiveChallengeRoundFourScreenState();
}

class _LiveChallengeRoundFourScreenState extends State<LiveChallengeRoundFourScreen> {
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
    // waitingTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: GetBuilder<LiveChallengeRoundFourCtrl>(
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
                    stackCount: logic.questionsApi.length>3 ? 3 :logic.questionsApi.length,
                    backCardOffset: -24,
                    duration: Duration(milliseconds: 500),
                    backCardScale: 0.05,
                    swipeEnabled:false,
                    onDrag: (index,dx, angle) {},
                    onSwipe: (index, direction) {
                      apolloPrint(message: 'Current Index:00:${logic.currentIndex}');
                      apolloPrint(message: 'index Index:00:$index');
                      final isLastQuestion = index == logic.questionsApi.length - 1;
                      logic.currentIndex = index+1; // current Question index
                      logic.isLastQ = logic.currentIndex==logic.questionsApi.length - 1; // new line added because of last index not swipe
                      apolloPrint(message: 'Medpardy Quiz isLastQ: ${logic.isLastQ}');
                      logic.update();
                      apolloPrint(message: 'Current Index:11:${logic.currentIndex}');

                      if(isLastQuestion){}
                    },
                    cards: List.generate(logic.questionsApi.length, (i) {
                      final q = logic.questionsApi[i];
                      return SizedBox.expand(child: _buildFrontCardNew(q, i, logic, logic.currentIndex));
                    }),
                  ).paddingOnly(left: 4, right: 4,top: 15),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCardNew(SoloPlayQuestion q, int qIndex, LiveChallengeRoundFourCtrl logic, int currentIndex) {
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
                      if (q.favorite == 1) {
                        q.favorite = 0;
                      } else if (q.favorite == 0) {
                        q.favorite = 1;
                      }
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
                  qIndex==0?Column(
                    children: [
                      addText500(
                        "Round 4",
                        fontSize: 20,
                        // fontFamily: 'Caprasimo',
                        height: 22,
                      ),addText500(
                        "Total Contestants - ${logic.countParticipants}",
                        fontSize: 12,
                        // fontFamily: 'Caprasimo',
                        height: 22,
                      ),
                    ],
                  ) :
                  Column(
                    children: [
                      addText500(
                        "Round 4",
                        height: 22,
                        fontSize: 20,
                      ),
                      addText400(
                        q.categoryName??'',
                        fontSize: 20,
                        fontFamily: 'Caprasimo',
                        height: 22,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showLeaveQuizSheet(context, () {
                        Get.back(); Get.to(() => DashBoardScreen());
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
              if(q.photoBy!=null && q.photoBy!.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap:(){
                        launchURL(url: '${q.photoByUrl}');
                      },
                      child: addText600(
                        '${q.photoBy??''} ',
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
                      duration: 10,
                      isInSecondsMode: true,
                      shouldStop: logic.shouldStopAllTimers,
                      onTick: (second){
                        q.secondsLeft = second;
                        setState(() {});
                      },
                      onTimerEnd: (){
                        if(logic.isLastQ==true){
                          if(!q.isAnswered && currentIndex==qIndex){ // to skip question
                            submitAnswerLiveChallengeApi(
                                gameId: logic.livePlayId,
                                questionId: q.id,
                                selectedOption: "E",
                                timeTakenSeconds: 20-q.secondsLeft,
                                favorite: q.favorite,
                                isStuck: q.isStuck==true?1:0,
                                round: 1
                            );
                          }

                          // showLoader(true); // waiting sccreen se phale ka code
                          // scoreLiveChallengesApi(liveChallengeId: logic.livePlayId).then((value){
                          //   showLoader(false);
                          //   if(value.status==true){
                          //     Get.off(LiveChallengeResultScreen(result: value.data));
                          //   }
                          // });

                          final id = logic.livePlayId;
                          final cp = logic.countParticipants;
                          roundWaitingTime = logic.round4RemainingSeconds;
                          showLoader(true);
                          resultLiveChallengesApi(liveChallengeId: id).then((girum){
                            showLoader(false);
                            if(girum.status==true){
                              Get.off(()=>LiveChallengeRoundTimerScreen(
                                livePlayId: id,
                                round: -1, // because no round after 4
                                countParticipants: cp,
                                resultData: girum.data??[],

                              ));
                            }
                          });
                        }
                        else{
                          if(!q.isAnswered && currentIndex==qIndex){ // to skip question
                            submitAnswerLiveChallengeApi(
                                gameId: logic.livePlayId,
                                questionId: q.id,
                                selectedOption: "E",
                                timeTakenSeconds: 20-q.secondsLeft,
                                favorite: q.favorite,
                                isStuck: q.isStuck==true?1:0,
                                round: 1
                            );
                          }
                          _playConfettiSound(sound: AppAssets.swipeSound);
                          swiperKey.currentState?.swipeLeft();
                        }
                      },
                    ),
                  ),

                  Positioned(
                        right: 12,
                        top: 12,
                        child: GestureDetector(
                          onTap: () {
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
                      logic.update();

                      // if (optIndex == q.correctIndex) {
                      if (q.isAnswered) {
                        if(optIndex == q.correctIndex){
                          _playConfettiSound(sound: AppAssets.correctAnswerSound);
                        }else{
                          _playConfettiSound(sound: AppAssets.wrongAnswerSound);
                        }
                        final isLastQuestion = qIndex == logic.questionsApi.length - 1;


                        if (qIndex < logic.questionsApi.length - 1) { // Optionally, swipe to next if incorrect
                          Future.delayed(
                            const Duration(milliseconds: 2000),
                                () {
                                  _playConfettiSound(sound: AppAssets.swipeSound);
                                  q.isAnswered = false;
                                  logic.update();
                                  swiperKey.currentState?.swipeLeft();
                            },
                          );
                        } else if(isLastQuestion){
                          int correctAnswers = logic.questionsApi.where((q) => q.selectedIndex == q.correctIndex).length;
                          int totalQuestions = logic.questionsApi.length;
                          double percent = (correctAnswers / totalQuestions) * 100;

                          final id = logic.livePlayId;
                          final cp = logic.countParticipants;

                          roundWaitingTime = logic.round4RemainingSeconds;

                          Future.delayed(Duration(milliseconds: 1500),(){
                            showLoader(true);
                            resultLiveChallengesApi(liveChallengeId: id).then((girum){
                              showLoader(false);
                              if(girum.status==true){
                                Get.off(()=>LiveChallengeRoundTimerScreen(
                                  livePlayId: id,
                                  round: -1, // because no round after 4
                                  countParticipants: cp,
                                  resultData: girum.data??[],
                                ));
                              }
                            });
                          });
                        }
                      }

                      submitAnswerLiveChallengeApi(
                          gameId: logic.livePlayId,
                          questionId: q.id,
                          selectedOption: q.selectedIndex==0?'A':q.selectedIndex==1?'B':q.selectedIndex==2?'C':q.selectedIndex==3?'D':"",
                          timeTakenSeconds: 20-q.secondsLeft,
                          favorite: q.favorite,
                          isStuck: q.isStuck==true?1:0,
                          round: 4
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
              addHeight(98),
            ],
          ),
        ),
      ),
    );
  }
}
