// To parse this JSON data, do
//
//     final liveChallengeScoreModel = liveChallengeScoreModelFromJson(jsonString);

import 'dart:convert';

LiveChallengeScoreModel liveChallengeScoreModelFromJson(String str) => LiveChallengeScoreModel.fromJson(json.decode(str));

String liveChallengeScoreModelToJson(LiveChallengeScoreModel data) => json.encode(data.toJson());

class LiveChallengeScoreModel {
  bool? status;
  int? statusCode;
  String? message;
  LiveChallengeScore? data;

  LiveChallengeScoreModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LiveChallengeScoreModel.fromJson(Map<String, dynamic> json) => LiveChallengeScoreModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : LiveChallengeScore.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class LiveChallengeScore {
  int? totalQuestions;
  int? answered;
  int? totalXp;
  int? correct;
  int? percentage;

  LiveChallengeScore({
    this.totalQuestions,
    this.answered,
    this.totalXp,
    this.correct,
    this.percentage,
  });

  factory LiveChallengeScore.fromJson(Map<String, dynamic> json) => LiveChallengeScore(
    totalQuestions: json["total_questions"],
    answered: json["answered"],
    totalXp: json["totalXp"],
    correct: json["correct"],
    percentage: json["percentage"],
  );

  Map<String, dynamic> toJson() => {
    "total_questions": totalQuestions,
    "answered": answered,
    "totalXp": totalXp,
    "correct": correct,
    "percentage": percentage,
  };
}
