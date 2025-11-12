import 'package:apollo/resources/Apis/api_repository/live_challenges_final_result_repo.dart';
import 'package:apollo/resources/Apis/api_repository/live_challenges_round_repo.dart';
import 'package:apollo/screens/game_mode/live_challenges/media_preview_screen.dart';
import 'package:apollo/resources/Apis/api_models/live_challenge_final_result.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/custom_widgets/flow_line_effect.dart';
import 'live_challenge_result_with_country_score.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'live_challenge_result.dart';
import 'package:get/get.dart';
import 'dart:async';

int roundWaitingTime = 0;
class LiveChallengeRoundTimerScreen extends StatefulWidget {
  int? livePlayId;
  int? round;
  int? countParticipants;
  List<LiveChallengeFinalResult> resultData;

  LiveChallengeRoundTimerScreen({super.key,this.livePlayId,this.round,this.countParticipants,this.resultData=const []});

  @override
  State<LiveChallengeRoundTimerScreen> createState() =>
      _LiveChallengeRoundTimerScreenState();
}

class _LiveChallengeRoundTimerScreenState extends State<LiveChallengeRoundTimerScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();

  int seconds = 10; // initial countdown value
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    seconds = roundWaitingTime;
    Future.microtask((){
      startTimer();
    });

  }


  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });

        if(widget.round == -1 && (seconds==15 || seconds==10 || seconds==4)){
                          resultLiveChallengesApi(liveChallengeId: widget.livePlayId).then((value){
                            if(value.status==true){
                                widget.resultData = value.data??[];
                                setState(() {});
                              }
                          });
        }
      } else {
        timer.cancel();
        if(widget.round==2){ // its means coming from round 1
          showLoader(true);
          changeRoundLiveChallengesApi(liveChallengeId: widget.livePlayId,round: widget.round).then((value){
            showLoader(false);
            if(value.status==true){
              /*Get.offNamed(AppRoutes.liveChallengeRoundTwoScreen, // before ads
                  arguments: {
                'live_play_id': widget.livePlayId,
                'questions': value.data!.questions,
                'count_participants':widget.countParticipants});*/
              Get.off(
                  MediaPreviewScreen(
                  url: value.data!.adsAdmin!.ads??'',
                  type: value.data!.adsAdmin!.type??'',
                  round: widget.round,
                  livePlayId: widget.livePlayId,
                  countParticipants: widget.countParticipants,
                  questionsApi: value.data!.questions??[],
              ));

            }else if(value.status==false){

              CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
            }

          });
        }
        else if(widget.round==3){ // its means coming from round 1
          showLoader(true);
          changeRoundLiveChallengesApi(liveChallengeId: widget.livePlayId,round: widget.round).then((value){
            showLoader(false);
            if(value.status==true){
              /*Get.offNamed(AppRoutes.liveChallengeRoundThreeScreen,
                  arguments: {
                'live_play_id': widget.livePlayId,
                'questions': value.data!.questions,
                'count_participants':widget.countParticipants});*/
              Get.off(
                  MediaPreviewScreen(
                    url: value.data!.adsAdmin!.ads??'',
                    type: value.data!.adsAdmin!.type??'',
                    round: widget.round,
                    livePlayId: widget.livePlayId,
                    countParticipants: widget.countParticipants,
                    questionsApi: value.data!.questions??[],
                  ));

            }else if(value.status==false){

              CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
            }

          });
        }
        else if(widget.round==4){ // its means coming from round 1
          showLoader(true);
          changeRoundLiveChallengesApi(liveChallengeId: widget.livePlayId,round: widget.round).then((value){
            showLoader(false);
            if(value.status==true){
              /*Get.offNamed(AppRoutes.liveChallengeRoundFourScreen,
                  arguments: {
                'live_play_id': widget.livePlayId,
                'questions': value.data!.questions,
                'count_participants':widget.countParticipants});*/
              Get.off(
                  MediaPreviewScreen(
                    url: value.data!.adsAdmin!.ads??'',
                    type: value.data!.adsAdmin!.type??'',
                    round: widget.round,
                    livePlayId: widget.livePlayId,
                    countParticipants: widget.countParticipants,
                    questionsApi: value.data!.questions??[],
                  ));


            }else if(value.status==false){

              CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
            }

          });
        }
        else if(widget.round==-1){ // its means coming from round 1
          resultLiveChallengesApi(liveChallengeId: widget.livePlayId).then((value){
                if(value.status==true){
                  widget.resultData = value.data!;
                  setState(() {});

                  if(widget.resultData.isNotEmpty){
                    if(widget.resultData[0].userId==AuthData().userModel?.id){
                    Get.off(LiveChallengeResultScreen(resultData: value.data));
                    } else{
                      Get.off(LivePlayResultWithScoreScreen(resultData: value.data));
                    }
                  }
              }
            });

        }

      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: addText400(
          "Just a sec...",
          fontSize: 32,
          height: 40,
          color: AppColors.whiteColor,
          fontFamily: 'Caprasimo',
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.liveChBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(AppAssets.liveChBg, fit: BoxFit.cover),
            ),
            SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    addHeight(28),
                    Lottie.asset(
                      'assets/Lottie/Appolo stetoskope.json',
                      repeat: true,
                      reverse: false,
                      animate: true,
                      width: 230,
                      height: 241,
                    ),
                    addHeight(50),
                    gameStartBox(
                      hug1: 195,
                      hug2: 36,
                      seconds: seconds,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gameStartBox({
    required int hug1,
    required int hug2,
    required int seconds,
  }) { return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: addText500(
              widget.round==-1? "Stand by! Results are loading...":'Hang tight! Next round kicks off right after a brief message from our sponsor.',
              textAlign: TextAlign.center,
              fontSize: 16,height: 22,color: AppColors.whiteColor
          ).marginSymmetric(horizontal: 12),
        ),

        addHeight(50),
        FlowingLineEffect(),


        /*const SizedBox(height: 12),

        // Countdown Number
        Container(
          height: 60,
          width: 60,
          // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.yellowColor,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColors.settingTxtColor1,width: 1),
          ),
          child: Center(
            child: addText400(
                '$seconds',
                fontSize: 32,fontFamily: 'Caprasimo'
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Seconds Text
        addText400(
          'Seconds',
          fontSize: 12,color: AppColors.whiteColor
        ),*/
      ],
    ),
  ); }
}
