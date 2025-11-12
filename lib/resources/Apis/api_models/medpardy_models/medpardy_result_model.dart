// To parse this JSON data, do
//
//     final medpardyResultModel = medpardyResultModelFromJson(jsonString);

import 'dart:convert';

MedpardyResultModel medpardyResultModelFromJson(String str) => MedpardyResultModel.fromJson(json.decode(str));

String medpardyResultModelToJson(MedpardyResultModel data) => json.encode(data.toJson());

class MedpardyResultModel {
  bool? status;
  int? statusCode;
  String? message;
  List<MedpardyResult>? data;

  MedpardyResultModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory MedpardyResultModel.fromJson(Map<String, dynamic> json) => MedpardyResultModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<MedpardyResult>.from(json["data"]!.map((x) => MedpardyResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MedpardyResult {
  dynamic player;
  String? ernPoint;
  int? correctAnswers;
  int? percentage;
  int? totalTimeTakenSeconds;

  MedpardyResult({
    this.player,
    this.ernPoint,
    this.correctAnswers,
    this.percentage,
    this.totalTimeTakenSeconds,
  });

  factory MedpardyResult.fromJson(Map<String, dynamic> json) => MedpardyResult(
    player: json["player"],
    ernPoint: json["ern_point"],
    correctAnswers: json["correct_answers"],
    percentage: json["percentage"],
    totalTimeTakenSeconds: json["total_time_taken_seconds"],
  );

  Map<String, dynamic> toJson() => {
    "player": player,
    "ern_point": ernPoint,
    "correct_answers": correctAnswers,
    "percentage": percentage,
    "total_time_taken_seconds": totalTimeTakenSeconds,
  };
}
