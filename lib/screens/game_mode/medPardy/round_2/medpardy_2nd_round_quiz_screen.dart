import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/models/medpardy_board_cells.dart';
import 'package:apollo/models/medpardy_players_model.dart';
import 'package:apollo/resources/Apis/api_models/category_model.dart';
import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';
import 'package:apollo/resources/Apis/api_repository/medpardy_change_round_repo.dart';
import 'package:apollo/resources/Apis/api_repository/medpardy_submit_answer_repo.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/countdown_timer_explanation.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
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
import 'package:simple_html_css/simple_html_css.dart';

import 'medpardy_2nd_round_quiz_ctrl.dart';

class Medpardy2ndRoundQuizScreen extends StatefulWidget {
  const Medpardy2ndRoundQuizScreen({super.key});

  @override
  State<Medpardy2ndRoundQuizScreen> createState() => _Medpardy2ndRoundQuizScreenState();
}

class _Medpardy2ndRoundQuizScreenState extends State<Medpardy2ndRoundQuizScreen> {
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
      body: GetBuilder<Medpardy2ndRoundQuizCtrl>(
        builder: (logic) {
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: StackedDraggableSwiper(
                    key: swiperKey,
                    maxAngle: 30,
                    allowedDirections: {SwipeDirection.left},
                    stackCount: logic.questionsApi.length > 3 ? 3 : logic.questionsApi.length,
                    backCardOffset: -24,
                    duration: Duration(milliseconds: 500),
                    backCardScale: 0.05,
                    swipeEnabled: false,
                    onDrag: (index,dx, angle) {
                      // Do something while dragging (e.g., update UI, show overlay)
                      // print('Dragging: dx=$dx, angle=$angle');
                    },
                    onSwipe: (index, direction) {
                      apolloPrint(message: 'Current Index:00:${logic.currentIndex}');
                      apolloPrint(message: 'index Index:00:$index');

                      final isLastQuestion = index == logic.questionsApi.length - 1;
                      logic.currentIndex = index + 1; // current Question index
                      logic.isLastQ = logic.currentIndex==logic.questionsApi.length - 1; // new line added because of last index not swipe
                      apolloPrint(message: 'Medpardy Quiz isLastQ: ${logic.isLastQ}');
                      logic.update();
                      apolloPrint(message: 'Current Index:11:${logic.currentIndex}');

                      if (isLastQuestion) {}
                    },
                    cards: List.generate(logic.questionsApi.length, (i) {
                      final q = logic.questionsApi[i];
                      // return _buildFrontCard(q, i, logic, logic.currentIndex);
                      return FlipCard(
                        key: q.flipKey,
                        flipOnTouch: false,
                        front: _buildFrontCard(q, i, logic, logic.currentIndex),
                        back: _buildBackCard(q, i, logic, logic.currentIndex),
                      );
                    }),
                  ).paddingOnly(left: 4, right: 4, top: 15),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard(SoloPlayQuestion q, int qIndex, Medpardy2ndRoundQuizCtrl logic, int currentIndex) {
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
                        logic.players[logic.selectedPlayerIndex!].name??'',
                        fontSize: 20,
                        fontFamily: 'Caprasimo',
                        color: AppColors.primaryColor,
                      ).marginSymmetric(horizontal: 12, vertical: 4),
                      Spacer(),
                      addText400(
                        '${logic.selectedXp}',
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
                    Column(
                      children: [
                        addText400(
                          q.categoryName??"",
                          fontSize: 20,
                          fontFamily: 'Caprasimo',
                        ),
                        addText500(
                          "Second Round",
                          fontSize: 16,
                          height: 22,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showLeaveQuizSheet(context, () {
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          logic.currentIndex=0;
                          logic.shouldStopAllTimers = true;
                          logic.update();
                          Get.back();
                          Get.delete<Medpardy2ndRoundQuizCtrl>(force: true);
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
                if(q.photoBy!=null && q.photoBy!.isNotEmpty)
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
                if(q.photoBy!=null && q.photoBy!.isNotEmpty)
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
                      child: CountdownTimerWidget( // back card not used
                        key: ValueKey(currentIndex),
                        duration: 20,
                        isInSecondsMode: true,
                        shouldStop: logic.shouldStopAllTimers,
                        onTick: (sec){
                          q.secondsLeft = sec;
                          setState(() {});
                        },
                        onTimerEnd: (){
                          // timer handle karna hai
                          if(!q.isAnswered){
                            bool initialTime = false;
                            int playerIndex = logic.selectedPlayerIndex!;
                            int gameId = logic.gameId??-10;
                            List<Category> categories = logic.categories;
                            List<MedPardyPlayerModel> players = logic.players;
                            List<MedpardySelectedCell> selectedCells = logic.selectedCells;
                            if(selectedCells.length==15){
                              showLoader(true);
                              medpardyChangeRoundApi(gameId: gameId, round: 3).then((value){
                                showLoader(false);
                                if(value.status==true && value.data!=null){
                                  Get.offNamed(AppRoutes.medpardy3rdRoundScreen,arguments: {
                                    'initialTime': true,
                                    'game_id': gameId,
                                    'category_list': value.data!.categoryList??[],
                                    'selected_player': 0,
                                    'players_list':players,
                                    'cells':[],
                                  });
                                } else if(value.status==false){
                                  CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                                }

                              });

                            }
                            else{
                              Get.offNamed(AppRoutes.medpardy2ndRoundScreen,arguments: {
                                'initialTime': initialTime,
                                'game_id': gameId,
                                'category_list': categories,
                                'selected_player': playerIndex==0?1:playerIndex==1?2:playerIndex==2?0:-1,
                                'players_list': players,
                                'cells': selectedCells??[],
                              });}
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
                              availableIndices.shuffle();
                              final toHighlight = availableIndices.take(2);
                              q.highlightedOptionIndices!.addAll(toHighlight);

                            } else if (availableIndices.length == 1) {
                              q.highlightedOptionIndices!.add(availableIndices.first);
                            }
                            logic.selectedXp = (logic.selectedXp! / 2).round();
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
                            // Flip the card if correct
                            Future.delayed(
                              const Duration(milliseconds: 1300),
                                  () {
                                q.flipKey.currentState?.toggleCard();
                              },
                            );
                            logic.players[logic.selectedPlayerIndex!].hp = (optIndex == q.correctIndex)? (logic.players[logic.selectedPlayerIndex!].hp+logic.selectedXp!):(logic.players[logic.selectedPlayerIndex!].hp-0);
                            logic.update();
                          } else{
                            final isLastQuestion = qIndex == logic.questionsApi.length - 1;

                            if (qIndex < logic.questionsApi.length - 1) {

                              Future.delayed(const Duration(milliseconds: 2000),
                                    () {
                                  _playConfettiSound(sound: AppAssets.swipeSound);
                                  // q.isAnswered = false; // added for blink colors issue
                                  // setState(() {}); // added for blink colors issue
                                  logic.cardSwiperController.swipe(
                                    CardSwiperDirection.left,
                                  );
                                },
                              );
                            }
                            else if (isLastQuestion) {
                              logic.players[logic.selectedPlayerIndex!].hp = (optIndex == q.correctIndex)? (logic.players[logic.selectedPlayerIndex!].hp+logic.selectedXp!):(logic.players[logic.selectedPlayerIndex!].hp-0);
                              logic.update();
                              Future.delayed(Duration(milliseconds: 2000),(){
                                bool initialTime = false;
                                int playerIndex = logic.selectedPlayerIndex!;
                                int gameId = logic.gameId??-10;
                                List<Category> categories = logic.categories;
                                List<MedPardyPlayerModel> players = logic.players;
                                List<MedpardySelectedCell> selectedCells = logic.selectedCells;
                                if(selectedCells.length==15){
                                  showLoader(true);
                                  medpardyChangeRoundApi(gameId: gameId, round: 3).then((value){
                                    showLoader(false);
                                    if(value.status==true && value.data!=null){
                                      Get.offNamed(AppRoutes.medpardy3rdRoundScreen,arguments: {
                                        'initialTime': true,
                                        'game_id': gameId,
                                        'category_list': value.data!.categoryList??[],
                                        'selected_player': 0,
                                        'players_list':players,
                                        'cells':[],
                                      });
                                    } else if(value.status==false){
                                      CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                                    }

                                  });

                                }
                                else{
                                  Get.offNamed(AppRoutes.medpardy2ndRoundScreen,arguments: {
                                    'initialTime': initialTime,
                                    'game_id': gameId,
                                    'category_list': categories,
                                    'selected_player': playerIndex==0?1:playerIndex==1?2:playerIndex==2?0:-1,
                                    'players_list': players,
                                    'cells': selectedCells??[],
                                  });
                                }
                              });
                            }
                          }

                          // submit answer api
                          medpardySubmitAnswerApi(
                            gameID: logic.gameId,
                            xp: q.isStuck == true ? logic.selectedXp! * 2 : logic.selectedXp,
                            round: 2,
                            player: logic.players[logic.selectedPlayerIndex!].name??'',
                            qId: q.id,
                            selectedOption: q.selectedIndex==0?'A':q.selectedIndex==1?'B':q.selectedIndex==2?'C':q.selectedIndex==3?'D':"",
                            qTimeTaken: 20-q.secondsLeft,
                            favorite: q.favorite,
                            isStuck: q.isStuck==true?1:0
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
                addHeight(40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard(SoloPlayQuestion q, int qIndex,Medpardy2ndRoundQuizCtrl logic, int currentIndex) {
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
                    Column(
                      children: [
                        addText400(
                          q.categoryName??"",
                          fontSize: 20,
                          fontFamily: 'Caprasimo',
                        ),
                        addText500(
                          "Second Round",
                          fontSize: 16,
                          height: 22,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showLeaveQuizSheet(context, () {
                          logic.currentIndex=0;
                          logic.shouldStopAllTimers = true;
                          logic.update();
                          Get.back();
                          Get.delete<Medpardy2ndRoundQuizCtrl>(force: true);
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
                          onTimerEnd: (){
                            bool initialTime = false;
                            int playerIndex = logic.selectedPlayerIndex!;
                            int gameId = logic.gameId??-10;
                            List<Category> categories = logic.categories;
                            List<MedPardyPlayerModel> players = logic.players;
                            List<MedpardySelectedCell> selectedCells = logic.selectedCells;
                            if(selectedCells.length==15){
                              showLoader(true);
                              medpardyChangeRoundApi(gameId: gameId, round: 3).then((value){
                                showLoader(false);
                                if(value.status==true && value.data!=null){
                                  Get.offNamed(AppRoutes.medpardy3rdRoundScreen,arguments: {
                                    'initialTime': true,
                                    'game_id': gameId,
                                    'category_list': value.data!.categoryList??[],
                                    'selected_player': 0,
                                    'players_list':players,
                                    'cells':[],
                                  });
                                }
                                else if(value.status==false){
                                  CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                                }

                              });
                            }
                            else{
                              Get.offNamed(AppRoutes.medpardy2ndRoundScreen,arguments: {
                                'initialTime': initialTime,
                                'game_id': gameId,
                                'category_list': categories,
                                'selected_player': playerIndex==0?1:playerIndex==1?2:playerIndex==2?0:-1,
                                'players_list': players,
                                'cells': selectedCells??[],
                              });
                            }
                          },
                        ),
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
                    bool initialTime = false;
                    int playerIndex = logic.selectedPlayerIndex!;
                    int gameId = logic.gameId??-10;
                    List<Category> categories = logic.categories;
                    List<MedPardyPlayerModel> players = logic.players;
                    List<MedpardySelectedCell> selectedCells = logic.selectedCells;
                    if(selectedCells.length==15){
                      showLoader(true);
                      medpardyChangeRoundApi(gameId: gameId, round: 3).then((value){
                        showLoader(false);
                        if(value.status==true && value.data!=null){
                          Get.offNamed(AppRoutes.medpardy3rdRoundScreen,arguments: {
                            'initialTime': true,
                            'game_id': gameId,
                            'category_list': value.data!.categoryList??[],
                            'selected_player': 0,
                            'players_list':players,
                            'cells':[],
                          });
                        } else if(value.status==false){
                          CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                        }

                      });
                    }
                    else{
                      Get.offNamed(AppRoutes.medpardy2ndRoundScreen,arguments: {
                        'initialTime': initialTime,
                        'game_id': gameId,
                        'category_list': categories,
                        'selected_player': playerIndex==0?1:playerIndex==1?2:playerIndex==2?0:-1,
                        'players_list': players,
                        'cells': selectedCells??[],
                      });
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
