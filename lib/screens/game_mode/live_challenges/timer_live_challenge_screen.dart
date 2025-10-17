import 'dart:async';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_models/live_challenger_register.dart';
import 'package:apollo/resources/Apis/api_repository/get_live_challenges_question_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TimerLiveChallengeScreen extends StatefulWidget {
  final int? durationInMilliseconds;
  LiveChallengerRegisterData? data;

  TimerLiveChallengeScreen({super.key, this.durationInMilliseconds,this.data});

  @override
  State<TimerLiveChallengeScreen> createState() =>
      _TimerLiveChallengeScreenState();
}

class _TimerLiveChallengeScreenState extends State<TimerLiveChallengeScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();

  Timer? _countdownTimer;


  late int remainingMilliseconds; // Remaining time in milliseconds

  // Time components
  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    super.initState();

    if (widget.durationInMilliseconds != null && widget.durationInMilliseconds! > 0) {
      remainingMilliseconds = widget.durationInMilliseconds!;
    } else {
      final eventDateTime = DateTime(2025, 12, 1, 20, 0, 0);
      final now = DateTime.now();
      remainingMilliseconds = eventDateTime.difference(now).inMilliseconds;
      if (remainingMilliseconds < 0) remainingMilliseconds = 0;
    }

    _startCountdownTimer();
  }




  void _startCountdownTimer() {
    _updateTime();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingMilliseconds <= 0) {
        timer.cancel();
        setState(() => _setTimeToZero());
        onTimerReached();
        return;
      }

      setState(() {
        remainingMilliseconds -= 1000;
        if (remainingMilliseconds < 0) remainingMilliseconds = 0;
        _updateTime();
      });
    });
  }

  void _updateTime() {
    final totalSeconds = remainingMilliseconds ~/ 1000;

    days = totalSeconds ~/ (24 * 3600);
    int remainder = totalSeconds % (24 * 3600);
    hours = remainder ~/ 3600;
    remainder %= 3600;
    minutes = remainder ~/ 60;
    seconds = remainder % 60;
  }

  void _setTimeToZero() {
    days = 0;
    hours = 0;
    minutes = 0;
    seconds = 0;
  }

  void onTimerReached() {
    showLoader(true);
    playLiveChallengesApi(liveChallengeId: widget.data?.id).then((valu){
      showLoader(false);
      if(valu.status==true){
        Get.offNamed(AppRoutes.liveChallengeQuizScreen,
            arguments: {
          'live_play_id':widget.data?.id ,
          'count_participants':valu.userParticipantCount ,
          'questions': valu.data!,

            });
      }else if(valu.status==false){
        CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${valu.message}');
      }
    });
  }

  Future<void> effectSound({required String sound}) async {
    await audioPlayer.play(AssetSource(sound));
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    audioPlayer.dispose();
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
          "Live Challenge",
          fontSize: 32,
          height: 40,
          color: AppColors.whiteColor,
          fontFamily: 'Caprasimo',
        ),
        actions: [

          GestureDetector(
            onTap: (){
              Get.to(() => DashBoardScreen());
            },
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                  // color: Colors.red,
                  shape: BoxShape.circle
              ),
              child: Image.asset(AppAssets.closeIcon).marginAll(5),
            ),
          ),
          addWidth(5)
        ],
      ),
      body: Container(
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
              child: Column(
                children: [
                  Lottie.asset(
                    'assets/Lottie/Appolo stetoskope.json',
                    repeat: true,
                    reverse: false,
                    animate: true,
                    width: 230,
                    height: 241,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: addText400(
                              'You Have Registered!',
                              fontSize: 32,
                              height: 40,
                              textAlign: TextAlign.center,
                              color: AppColors.primaryColor,
                              fontFamily: 'Caprasimo',
                            ),
                          ),
                          addHeight(24),
                          Align(
                            alignment: Alignment.center,
                            child: addText500(
                              'The event will occur on \n${widget.data?.startDate} at ${widget.data?.startTime} EST (GMT-5).',
                              fontSize: 16,
                              color: AppColors.blackColor,
                              textAlign: TextAlign.center,
                              height: 22,
                            ),
                          ).marginSymmetric(horizontal: 20),
                          addHeight(30),
                          Align(
                            alignment: Alignment.center,
                            child: addText700(
                              'Time left until event:',
                              fontSize: 24,
                              color: AppColors.blackColor,
                              textAlign: TextAlign.center,
                              height: 1.4,
                            ),
                          ).marginSymmetric(horizontal: 20),
                          addHeight(24),
                          buildCountdownTimer(
                            days: days,
                            hours: hours,
                            minutes: minutes,
                            seconds: seconds,
                          ),
                          addHeight(30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCountdownTimer({
    required int days,
    required int hours,
    required int minutes,
    required int seconds,
  }) { return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _timeBox(value: days, label: "Days"),
            const SizedBox(width: 15),
            _timeBox(value: hours, label: "Hours"),
            const SizedBox(width: 15),
            _timeBox(value: minutes, label: "Min"),
            const SizedBox(width: 15),
            _timeBox(value: seconds, label: "Sec"),
          ],
        ),
      ],
    );}

  Widget _timeBox({required int value, required String label}) {
    return Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.yellowColor,
            border: Border.all(color: AppColors.brownColor, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: addText400(
            value.toString().padLeft(2, '0'),
            fontSize: 26,
            height: 40,
            fontFamily: 'Caprasimo',
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 4),
        addText400(
          label,
          fontSize: 12,
          color: AppColors.blackColor,
        ),
      ]);
  }
}
