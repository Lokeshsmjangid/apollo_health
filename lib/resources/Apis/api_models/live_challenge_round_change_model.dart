// To parse this JSON data, do
//
//     final liveChallengeRoundChangeModel = liveChallengeRoundChangeModelFromJson(jsonString);

import 'dart:convert';

import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';

LiveChallengeRoundChangeModel liveChallengeRoundChangeModelFromJson(String str) => LiveChallengeRoundChangeModel.fromJson(json.decode(str));

String liveChallengeRoundChangeModelToJson(LiveChallengeRoundChangeModel data) => json.encode(data.toJson());

class LiveChallengeRoundChangeModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  LiveChallengeRoundChangeModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LiveChallengeRoundChangeModel.fromJson(Map<String, dynamic> json) => LiveChallengeRoundChangeModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? round;
  List<SoloPlayQuestion>? questions;
  LiveChallengeAds? adsAdmin;

  Data({
    this.round,
    this.questions,
    this.adsAdmin
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    round: json["round"],
    adsAdmin: json["ads"] == null ? null : LiveChallengeAds.fromJson(json["ads"]),
    questions: json["questions"] == null ? [] : List<SoloPlayQuestion>.from(json["questions"]!.map((x) => SoloPlayQuestion.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "round": round,
    "ads": adsAdmin?.toJson(),
    "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
  };
}

class LiveChallengeAds {
  String? type;
  String? ads;


  LiveChallengeAds({
    this.type,
    this.ads,
  });

  factory LiveChallengeAds.fromJson(Map<String, dynamic> json) => LiveChallengeAds(
    type: json["type"],
    ads: json["ads"],

  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "ads": ads,

  };
}
