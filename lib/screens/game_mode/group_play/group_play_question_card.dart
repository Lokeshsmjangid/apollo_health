import 'dart:io';

import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/controllers/gM_quiz_ctrl.dart';
import 'package:apollo/custom_widgets/linear_progress_segment.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';
import 'package:apollo/resources/Apis/api_repository/group_play_result_repo.dart' show groupPlayResultApi;
import 'package:apollo/resources/Apis/api_repository/quit_group_play_repo.dart';
import 'package:apollo/resources/Apis/api_repository/submit_answer_group_play_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/countdown_timer.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'group_play_waiting_screen.dart';

class GroupPlayQuestionCard extends StatefulWidget {
  final SoloPlayQuestion question;
  final int questionIndex;
  final GMQuizCtrl logic; // Your GMQuizCtrl or controller instance
  final int currentIndex;
  final VoidCallback? onSwipeLeft;

  const GroupPlayQuestionCard({
    Key? key,
    required this.question,
    required this.questionIndex,
    required this.logic,
    required this.currentIndex,
    this.onSwipeLeft,
  }) : super(key: key);

  @override
  _GroupPlayQuestionCardState createState() => _GroupPlayQuestionCardState();
}

class _GroupPlayQuestionCardState extends State<GroupPlayQuestionCard> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    if(AuthData().isPremium==false){
      // _loadBannerAd();
      initUnityAds();
    }
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> initUnityAds() async {
    // await UnityAds.init(
    //   gameId: Platform.isAndroid
    //       ? ApiUrls.gameIdAndroid
    //       : ApiUrls.gameIdIOS,
    //   testMode: true,
    //   onComplete: () => print('✅ Unity Ads Initialized'),
    //   onFailed: (error, message) => print('❌ Unity Init Failed: $error | $message'),
    // );
    final placementId = Platform.isAndroid
        ? ApiUrls.unityBannerAndroid
        : ApiUrls.unityBannerIOS;
    // UnityAds.load(
    //   placementId: placementId,
    //   onComplete: (placementId) {
    //     print("✅ Banner Ad Loaded: $placementId");
    //     setState(() => isBannerLoaded = true);
    //   },
    //   onFailed: (placementId, error, message) {
    //     print("❌ Banner Load Failed: $message");
    //   },
    // );
  }

  // BannerAd? _bannerAd;
  // AdWidget? _adWidget;
  // bool _isBannerAdReady = false;
  // void _loadBannerAd() {
  //   _bannerAd = BannerAd(
  //     adUnitId: Platform.isIOS?ApiUrls.adUnitIdBannerIos:ApiUrls.adUnitIdBanner,  // Replace with your actual or test ad unit ID
  //     size: AdSize.banner,
  //     request: AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (ad) {
  //         // Create AdWidget once ad is loaded
  //         if (!mounted) return;
  //         _adWidget = AdWidget(ad: ad as BannerAd);
  //
  //         setState(() {
  //           _isBannerAdReady = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         print('BannerAd failed to load: $error');
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //
  //   _bannerAd!.load();
  // }

  Future<void> _playConfettiSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final qIndex = widget.questionIndex;
    final logic = widget.logic;
    final currentIndex = widget.currentIndex;
    return SizedBox.expand(
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        decoration: BoxDecoration(
          color: qIndex == logic.currentIndex
              ? Colors.white
              : (qIndex == logic.currentIndex + 1 ? Color(0XFFDDD0F2) : Color(0XFFB290E8)),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: AppColors.primaryLightColor, width: 3),
                right: BorderSide(color: AppColors.primaryLightColor, width: 3),
                top: BorderSide(color: AppColors.primaryLightColor, width: 3),
              ),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!mounted) return;
                        setState(() {
                          q.favorite = (q.favorite == 1) ? 0 : 1;
                        });
                      },
                      child: Icon(
                        q.favorite == 1 ? Icons.favorite : Icons.favorite_border_rounded,
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
                          showLoader(true);
                          quitGroupPlayApi(gameId: logic.gameData?.id).then((value) {
                            showLoader(false);
                            if (value.status == true) {
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
                        filledSegments: qIndex + 1,
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

                // Photo credits aligned right
                if(q.photoBy!=null && q.photoBy!.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            launchURL(url: q.photoByUrl ?? '');
                          },
                          child: addText600(
                            '${q.photoBy ?? ''} ',
                            color: AppColors.textColor,
                            fontSize: 9,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            launchURL(url: q.imageUrlUnsplash ?? '');
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

                // Image and timer stack
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
                        duration: 20,
                        isInSecondsMode: true,
                        shouldStop: logic.shouldStopAllTimers,
                        onTick: (second) {
                          if (!mounted) return;
                          setState(() {
                            q.secondsLeft = second;
                            Future.delayed(Duration(milliseconds: 500),(){
                              if(qIndex==currentIndex){
                                q.hasTimerStarted = true;
                              }

                            });

                          });
                        },
                        onTimerEnd: () {
                          if (!mounted) return;
                          if (logic.isLastQ == true) {
                            if (!q.isAnswered && currentIndex == qIndex) {
                              submitAnswerGroupApi(
                                gameId: logic.gameData?.id,
                                questionId: q.id,
                                selectedOption: "E",
                                timeTakenSeconds: 20 - q.secondsLeft,
                                favorite: q.favorite,
                                isStuck: q.isStuck ? 1 : 0,
                              );
                            }
                            showLoader(true);
                            groupPlayResultApi(gameId: logic.gameData?.id).then((value) {
                              if (!mounted) return;
                              showLoader(false);
                              if (value.status == true) {
                                groupWaitingTime = logic.groupPlayRemainingSeconds;
                                Get.off(
                                  GroupPlayWaitingScreen(
                                    isPlayRequest: logic.isPlayRequest,
                                    users: value.users!,
                                    isMadPardy: false,
                                    gameId: logic.gameData?.id,
                                  ),
                                );
                              }
                            });
                          } else {
                            _playConfettiSound(sound: AppAssets.swipeSound);
                            if (widget.onSwipeLeft != null) widget.onSwipeLeft!();
                            if (!q.isAnswered && currentIndex == qIndex) {
                              submitAnswerGroupApi(
                                gameId: logic.gameData?.id,
                                questionId: q.id,
                                selectedOption: "E",
                                timeTakenSeconds: 20 - q.secondsLeft,
                                favorite: q.favorite,
                                isStuck: q.isStuck ? 1 : 0,
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
                          if (q.isStuck == false &&
                              q.options != null &&
                              q.options!.every((option) => option.trim().isNotEmpty)) {
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
                            setState(() {
                              q.isStuck = true;
                            });
                          }
                        },
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
                    ),
                  ],
                ),

                SizedBox(height: 17),

                // Question text
                addText500(
                  q.question ?? '',
                  fontSize: 20,
                  height: 28,
                  color: Colors.black87,
                  textAlign: TextAlign.center,
                ).marginSymmetric(horizontal: 8),

                SizedBox(height: 14),

                // Options list
                ...List.generate(q.options!.length, (optIndex) {
                  final isHighlighted = q.highlightedOptionIndices!.contains(optIndex);
                  return GestureDetector(
                    onTap: () {
                      if (!q.hasTimerStarted) return;
                      if (q.options![optIndex].isNotEmpty && !q.isAnswered) {
                        setState(() {
                          q.isAnswered = true;
                          q.selectedIndex = optIndex;
                        });

                        if (q.isAnswered) {
                          if (optIndex == q.correctIndex) {
                            _playConfettiSound(sound: AppAssets.correctAnswerSound);
                          } else {
                            _playConfettiSound(sound: AppAssets.wrongAnswerSound);
                          }

                          final isLastQuestion = qIndex == logic.questionsApi.length - 1;

                          if (qIndex < logic.questionsApi.length - 1) {
                            print('Vishal khuswa');
                            Future.delayed(const Duration(milliseconds: 2000), () {
                              if (!mounted) return;
                              _playConfettiSound(sound: AppAssets.swipeSound);
                              setState(() {
                                q.isAnswered = false;
                              });
                              // widget.onSwipeLeft?.call();
                              if (widget.onSwipeLeft != null) widget.onSwipeLeft!();
                            });
                          } else if (isLastQuestion) {
                            showLoader(true);
                            groupPlayResultApi(gameId: logic.gameData?.id).then((value) {
                              if (!mounted) return;
                              showLoader(false);
                              if (value.status == true) {
                                if (logic.fromScreen == 'groupPlay') {
                                  groupWaitingTime = logic.groupPlayRemainingSeconds;
                                  Get.off(
                                    GroupPlayWaitingScreen(
                                      isPlayRequest: logic.isPlayRequest,
                                      users: value.users!,
                                      isMadPardy: false,
                                      gameId: logic.gameData?.id,
                                    ),
                                  );
                                }
                              }
                            });
                          }
                        }

                        submitAnswerGroupApi(
                          gameId: logic.gameData?.id,
                          questionId: q.id,
                          selectedOption: q.selectedIndex == 0
                              ? 'A'
                              : q.selectedIndex == 1
                              ? 'B'
                              : q.selectedIndex == 2
                              ? 'C'
                              : q.selectedIndex == 3
                              ? 'D'
                              : "",
                          timeTakenSeconds: 20 - q.secondsLeft,
                          favorite: q.favorite,
                          isStuck: q.isStuck ? 1 : 0,
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                      decoration: BoxDecoration(
                        color: q.options![optIndex].isEmpty || isHighlighted ? Color(0XFFF6F6F6) : logic.getOptionColor(qIndex, optIndex),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: addText500(
                          q.options![optIndex],
                          fontSize: 16,
                          color: q.options![optIndex].isEmpty || isHighlighted ? Color(0XFFDCDCDC) : AppColors.blackColor,
                        ),
                      ),
                    ),
                  ).marginOnly(bottom: 8);
                }),

                // Banner ad placeholder container
                if(!AuthData().isPremium)
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 20, bottom: 35),
                    height: 52,
                    width: double.infinity,
                    child: UnityBannerAd(
                      placementId: Platform.isIOS
                          ? ApiUrls.unityBannerIOS
                          : ApiUrls.unityBannerAndroid,
                    ),
                  ),
                // if (_isBannerAdReady && _bannerAd != null)
                //   Container(
                //     height: 52,
                //     width: double.infinity,
                //     color: Color(0XFF909090),
                //     child: _adWidget,
                //   ).marginOnly(bottom: 35, top: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
