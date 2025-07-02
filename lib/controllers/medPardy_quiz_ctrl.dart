import 'dart:ui';

import 'package:apollo/models/questions_model.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

class MedpardyQuizCtrl extends GetxController{
  String? fromPlayer;
  final CardSwiperController cardSwiperController = CardSwiperController();
  int currentIndex = 0;
  int? round;

  // added new key
  bool shouldStopAllTimers = false;
  bool isLastQ = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(Get.arguments!=null) {
      round = Get.arguments['round'];
      fromPlayer = Get.arguments['fromPlayer'];
      apolloPrint(message: 'OnQuiz:::Screen:::$fromPlayer');
    }
  }
  final List<Question> questions = [

    Question(
      question: "What is the capital of France?",
      imagePath: AppAssets.questionBaneer,
      options: ["London", "Berlin", "Paris", "Madrid"],
      explanation: 'Probiotics are beneficial bacteria that promote a healthy gut microbiome, aiding digestion and nutrient absorption. They can help prevent digestive disorders. (Source: National Institutes of Health)',
      funFact: 'Yogurt isn\'t just tasty — it\'s a probiotic powerhouse for your gut! 🥄🥛',
      correctIndex: 2,
      isLike: false, isAnswered: false,
        flipKey: GlobalKey<FlipCardState>()
    ),

  ];

  Color getOptionColor(int qIndex, int optIndex) {
    final question = questions[qIndex];
    if (!question.isAnswered) return AppColors.purpleLightColor;

    if (optIndex == question.correctIndex) {
      return AppColors.correctAnsColor; // Correct answer is green
    } else if (question.selectedIndex == optIndex) {
      return AppColors.wrongAnsColor; // Selected wrong answer is red
    }
    return AppColors.purpleLightColor; // Others remain default
  }

}