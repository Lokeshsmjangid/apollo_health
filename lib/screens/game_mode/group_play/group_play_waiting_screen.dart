import 'dart:async';
import 'package:apollo/custom_widgets/flow_line_effect.dart';
import 'package:apollo/resources/Apis/api_models/group_play_result_model.dart';
import 'package:apollo/resources/Apis/api_repository/group_play_result_update_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'group_play_result.dart';

int groupWaitingTime = 0;
class GroupPlayWaitingScreen extends StatefulWidget {
  bool? isPlayRequest;
  bool? isMadPardy;
  int? gameId;
  List<GroupUser> users;

  GroupPlayWaitingScreen({super.key,this.isPlayRequest,this.isMadPardy = false,this.users = const[],this.gameId});

  @override
  State<GroupPlayWaitingScreen> createState() =>
      _GroupPlayWaitingScreenState();
}

class _GroupPlayWaitingScreenState extends State<GroupPlayWaitingScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();

   // initial countdown value
  int countdown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    Future.microtask((){
      setState(() {
        countdown = groupWaitingTime;
      });
      startTimer();


    });}



  void startTimer() {
    if(groupWaitingTime>0){
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (countdown > 0) {
          setState(() {
            countdown--;
          });
          if(countdown==0){
            Get.off(()=>GroupPlayResultScreen( // Before groupPlay waiting screen
                isPlayRequest: widget.isPlayRequest,
                users: widget.users,isMadPardy: false,
                gameId: widget.gameId));
          } else if((countdown > 40 && countdown % 5 == 0) || (countdown <= 40 && countdown % 3 == 0)){
            groupPlayResultUpdateApi(gameId: widget.gameId).then((value){

              if(value.users!=null){
                widget.users = value.users??[];
                if (value.users!.isNotEmpty && value.users!.every((user) => user.gameComplete == 1)) {
                  timer.cancel();
                  Get.off(()=>GroupPlayResultScreen( // Before groupPlay waiting screen
                      isPlayRequest: widget.isPlayRequest,
                      users: value.users??[],
                      isMadPardy: false,
                      gameId: widget.gameId));
                }
              }
              setState(() {});
            });
          }
        } else {
          timer.cancel();

        }
      });
    } else {
      showLoader(true);
      groupPlayResultUpdateApi(gameId: widget.gameId).then((value){
        showLoader(false);
        if(value.status==true){
          Get.off(()=>GroupPlayResultScreen( // Before groupPlay waiting screen
              isPlayRequest: widget.isPlayRequest,
              users: value.users??[],
              isMadPardy: false,
              gameId: widget.gameId));
        }
        setState(() {});
      });
    }

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    apolloPrint(message: "$groupWaitingTime-->$countdown");
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                        seconds: countdown,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
              'Stand by! Results are loading...',textAlign: TextAlign.center,
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

