import 'dart:ui';

import 'package:apollo/models/medpardy_board_cells.dart';
import 'package:apollo/models/medpardy_players_model.dart';
import 'package:apollo/resources/Apis/api_models/category_model.dart';
import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

class Medpardy2ndRoundQuizCtrl extends GetxController{
  String? fromPlayer;
  final CardSwiperController cardSwiperController = CardSwiperController();
  int currentIndex = 0;

  // added new key
  bool shouldStopAllTimers = false;
  bool isLastQ = false;


  // from past screen
  bool? initialTime;
  int? gameId;
  int? round;
  int? selectedXp;
  int? selectedPlayerIndex;
  List<Category> categories = [];
  List<MedPardyPlayerModel> players = [];
  List<MedpardySelectedCell> selectedCells = [];
  List<SoloPlayQuestion> questionsApi =[];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(Get.arguments!=null) {
      initialTime = Get.arguments['initialTime'];
      gameId = Get.arguments['game_id'];
      round = Get.arguments['round'];
      selectedPlayerIndex = Get.arguments['selected_player'] ?? 0;
      selectedXp = Get.arguments['selectedXp'] ?? 0;
      categories = Get.arguments['category_list'];
      players = Get.arguments['players_list'];
      questionsApi = Get.arguments['questions'];
      final rawCells = Get.arguments['cells'];


      print('gameId: $gameId');
      print('selectedPlayerIndex: $selectedPlayerIndex');
      print('categories: $categories');
      print('players: $players');
      print('rawCells: $rawCells');
      if (rawCells != null && rawCells is List) {
        selectedCells = rawCells.map((e) {
          if (e is MedpardySelectedCell) {
            return e; // Already typed
          } else if (e is Map<String, dynamic>) {
            return MedpardySelectedCell.fromMap(e);
          } else if (e is Map) {
            return MedpardySelectedCell.fromMap(Map<String, dynamic>.from(e));
          } else {
            throw Exception("Invalid selected cell data: $e");
          }
        }).toList();

      } else {
        selectedCells = [];
      }
    }
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