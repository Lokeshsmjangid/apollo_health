// To parse this JSON data, do
//
//     final soloPlayQuestionsModel = soloPlayQuestionsModelFromJson(jsonString);

import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

SoloPlayQuestionsModel soloPlayQuestionsModelFromJson(String str) => SoloPlayQuestionsModel.fromJson(json.decode(str));

String soloPlayQuestionsModelToJson(SoloPlayQuestionsModel data) => json.encode(data.toJson());

class SoloPlayQuestionsModel {
  bool? status;
  int? statusCode;
  int? userParticipantCount;
  String? message;
  List<SoloPlayQuestion>? data;
  GameData? gameData;

  SoloPlayQuestionsModel({
    this.status,
    this.statusCode,
    this.userParticipantCount,
    this.message,
    this.data,
    this.gameData,
  });

  factory SoloPlayQuestionsModel.fromJson(Map<String, dynamic> json) => SoloPlayQuestionsModel(
    status: json["status"],
    statusCode: json["statusCode"],
    userParticipantCount: json["userParticipantCount"],
    message: json["message"],
    data: json["data"] == null ? [] : List<SoloPlayQuestion>.from(json["data"]!.map((x) => SoloPlayQuestion.fromJson(x))),
    gameData: json["gameData"] == null ? null : GameData.fromJson(json["gameData"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "userParticipantCount": userParticipantCount,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "gameData": gameData?.toJson(),
  };
}

class SoloPlayQuestion {
  int? id;
  dynamic userId;
  dynamic editedBy;
  String? categoryId;
  String? categoryName;
  String? difficultyLevel;
  String? question;
  String? imageUrl;
  String? optionA;
  String? optionB;
  String? optionC;
  String? optionD;
  String? correctAnswer;
  String? explanation;
  String? funFact;
  dynamic pointEarn;
  dynamic gameModeId;
  dynamic isImageExit;
  int? viewUpdate;
  dynamic status;
  int? favorite;
  int? flag;
  String? photoBy;
  String? photoByUrl;
  String? imageUrlUnsplash;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<String>? options;
  int? correctIndex;
  final GlobalKey<FlipCardState> flipKey;
  int? selectedIndex;
  bool isAnswered;
  bool wasSwiped;
  bool isStuck;
  bool hasTimerStarted;
  int secondsLeft;
  int secondsExpLeft;
  List<int>? highlightedOptionIndices;


  SoloPlayQuestion({
    this.id,
    this.userId,
    this.editedBy,
    this.categoryId,
    this.categoryName,
    this.difficultyLevel,
    this.question,
    this.imageUrl,
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.correctAnswer,
    this.explanation,
    this.funFact,
    this.pointEarn,
    this.gameModeId,
    this.isImageExit,
    this.viewUpdate,
    this.status,
    this.favorite,
    this.flag,
    this.photoBy,
    this.photoByUrl,
    this.imageUrlUnsplash,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.options,
    this.isAnswered= false,
    this.wasSwiped= false,
    this.isStuck= false,
    this.selectedIndex,
    this.correctIndex,
    this.hasTimerStarted =false,
    this.secondsLeft = 20,
    this.secondsExpLeft = 0,
    List<int>? highlightedOptionIndices,
    GlobalKey<FlipCardState>? flipKey,
  }) : flipKey = flipKey ?? GlobalKey<FlipCardState>(),highlightedOptionIndices = highlightedOptionIndices ?? [];

  factory SoloPlayQuestion.fromJson(Map<String, dynamic> json) => SoloPlayQuestion(
    id: json["id"],
    userId: json["user_id"],
    editedBy: json["edited_by"],
    categoryId: json["category_id"],
    categoryName: json["category_name"],
    difficultyLevel: json["difficulty_level"],
    question: json["question"],
    imageUrl: json["image_url"],
    optionA: json["option_a"],
    optionB: json["option_b"],
    optionC: json["option_c"],
    optionD: json["option_d"],
    correctAnswer: json["correct_answer"],
    explanation: json["explanation"],
    funFact: json["fun_fact"],
    pointEarn: json["point_earn"],
    gameModeId: json["game_mode_id"],
    isImageExit: json["is_image_exit"],
    viewUpdate: json["view_update"],
    status: json["status"],
    favorite: json["favorite"],
    flag: json["flag"],
    photoBy: json["photo_by"],
    photoByUrl: json["photo_by_url"],
    imageUrlUnsplash: json["image_url_unsplash"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
    correctIndex: json["correctIndex"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "edited_by": editedBy,
    "category_id": categoryId,
    "category_name": categoryName,
    "difficulty_level": difficultyLevel,
    "question": question,
    "image_url": imageUrl,
    "option_a": optionA,
    "option_b": optionB,
    "option_c": optionC,
    "option_d": optionD,
    "correct_answer": correctAnswer,
    "explanation": explanation,
    "fun_fact": funFact,
    "point_earn": pointEarn,
    "game_mode_id": gameModeId,
    "is_image_exit": isImageExit,
    "view_update": viewUpdate,
    "status": status,
    "favorite": favorite,
    "flag": flag,
    "photo_by": photoBy,
    "photo_by_url": photoByUrl,
    "image_url_unsplash": imageUrlUnsplash,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
    "correctIndex": correctIndex,

  };
}

class GameData {
  int? userId;
  int? pointEarn;
  dynamic numberOfQuestion;
  String? categoryId;
  dynamic showExplanation;
  dynamic timedMode;
  dynamic highStakesMode;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  dynamic winnerTakeMode;

  GameData({
    this.userId,
    this.pointEarn,
    this.numberOfQuestion,
    this.categoryId,
    this.showExplanation,
    this.timedMode,
    this.highStakesMode,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.winnerTakeMode,
  });

  factory GameData.fromJson(Map<String, dynamic> json) => GameData(
    userId: json["user_id"],
    pointEarn: json["point_earn"],
    numberOfQuestion: json["number_of_question"],
    categoryId: json["category_id"],
    showExplanation: json["show_explanation"],
    timedMode: json["timed_mode"],
    highStakesMode: json["high_stakes_mode"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
    winnerTakeMode: json["winner_take_mode"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "point_earn": pointEarn,
    "number_of_question": numberOfQuestion,
    "category_id": categoryId,
    "show_explanation": showExplanation,
    "timed_mode": timedMode,
    "high_stakes_mode": highStakesMode,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
    "winner_take_mode": winnerTakeMode,
  };
}
