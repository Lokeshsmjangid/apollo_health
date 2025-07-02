import 'dart:ui';

import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

import '../models/questions_model.dart';

class LiveChallengeQuizCtrl extends GetxController{

  int currentIndex = 0;
  bool shouldStopAllTimers = false;
  bool isLastQ = false;
  final CardSwiperController cardSwiperController = CardSwiperController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // if(Get.arguments!=null) {
    //   fromScreen = Get.arguments['screen'];
    //   apolloPrint(message: 'OnQuiz:::Screen:::$fromScreen');
    // }
  }

  List<Question> questions = [
    Question(
      question:
      "What do probiotics help with?",
      options: ["Gut health", "Hair", "Hearing", "Vision"],
        explanation: 'Probiotics are beneficial bacteria that promote a healthy gut microbiome, aiding digestion and nutrient absorption. They can help prevent digestive disorders. (Source: National Institutes of Health)',
        funFact: 'Yogurt isn\'t just tasty — it\'s a probiotic powerhouse for your gut! 🥄🥛',
      imagePath: AppAssets.questionBaneer,
      correctIndex: 0,
      isLike: false,
      isAnswered: false,
      flipKey: GlobalKey<FlipCardState>()
    ),
    Question(
      question: "What is ginseng used for?",
      imagePath: AppAssets.questionBaneer,
      options: ["Sleep", "Digestion", "Vision", "Energy"],
        explanation: 'Ginseng is an herbal remedy used to boost energy levels and reduce stress. It\'s believed to enhance physical endurance and concentration. (Source: National Center for Complementary and Integrative Health)',
        funFact: 'Ginseng is so revered in Korea that some ginseng roots have sold for thousands of dollars! 🇰🇷💰',
      correctIndex: 3,
      isLike: false,
      isAnswered: false,
        flipKey: GlobalKey<FlipCardState>()
    ),
    Question(
      question:
      "What mineral helps oxygen transport?",
      imagePath: AppAssets.questionBaneer,
      options: ["Calcium", "Iron", "Zinc", "Phosphorus"],
        explanation: 'Iron is crucial for the formation of hemoglobin, a protein in red blood cells that carries oxygen throughout the body. Without it, your body can\'t get enough oxygen. (Source: National Institutes of Health)',
        funFact: 'Spinach might not make you strong like Popeye, but it sure boosts your iron levels! 🥬💪',
      correctIndex: 1,
      isLike: false,
      isAnswered: false,
        flipKey: GlobalKey<FlipCardState>()
    ),
    Question(
      question: "What does paracetamol treat?",
      imagePath: AppAssets.questionBaneer,
      options: ["Cough", "Infection", "Pain", "Dizziness"],
        explanation: '',
        funFact: '',
      correctIndex: 2,
      isLike: false,
      isAnswered: false,
        flipKey: GlobalKey<FlipCardState>()
    ),
    // Add more questions as needed
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