import 'dart:async';
import 'dart:ui';

import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

class LiveChallengeRoundThreeCtrl extends GetxController{
  int round3RemainingSeconds = 0; // initial countdown value
  Timer? waitingTimer;


  int currentIndex = 0;
  bool shouldStopAllTimers = false;
  bool isLastQ = false;
  final CardSwiperController cardSwiperController = CardSwiperController();

  int? livePlayId;
  int? countParticipants;
  List<SoloPlayQuestion> questionsApi =[];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(Get.arguments!=null) {
      livePlayId = Get.arguments['live_play_id'];
      countParticipants = Get.arguments['count_participants'];
      questionsApi = Get.arguments['questions'];
      apolloPrint(message: 'OnQuiz:::Screen:::$livePlayId');
      if(questionsApi.isNotEmpty){
        Future.microtask((){
          round3RemainingSeconds = questionsApi.length*10;
          update();
          startTimer();
        });
      }
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    waitingTimer?.cancel();
    super.dispose();

  }

  void startTimer() {
    waitingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (round3RemainingSeconds > 0) {
          round3RemainingSeconds--;
        update();
      } else {
        timer.cancel();
      }
    });
  }


  Color getOptionColor(int qIndex, int optIndex) {
    final question = questionsApi[qIndex];
    if (!question.isAnswered) return AppColors.purpleLightColor;

    if (optIndex == question.correctIndex) {
      return AppColors.correctAnsColor; // Correct answer is green
    } else if (question.selectedIndex == optIndex) {
      return AppColors.wrongAnsColor; // Selected wrong answer is red
    }
    return AppColors.purpleLightColor; // Others remain default
  }

}