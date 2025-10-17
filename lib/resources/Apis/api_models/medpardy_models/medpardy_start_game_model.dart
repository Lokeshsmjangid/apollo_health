// To parse this JSON data, do
//
//     final medpardyStartGameModel = medpardyStartGameModelFromJson(jsonString);

import 'dart:convert';

import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';

MedpardyStartGameModel medpardyStartGameModelFromJson(String str) => MedpardyStartGameModel.fromJson(json.decode(str));

String medpardyStartGameModelToJson(MedpardyStartGameModel data) => json.encode(data.toJson());

class MedpardyStartGameModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  MedpardyStartGameModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory MedpardyStartGameModel.fromJson(Map<String, dynamic> json) => MedpardyStartGameModel(
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
  List<SoloPlayQuestion>? question;
  User? user;

  Data({
    this.question,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    question: json["question"] == null ? [] : List<SoloPlayQuestion>.from(json["question"]!.map((x) => SoloPlayQuestion.fromJson(x))),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "question": question == null ? [] : List<dynamic>.from(question!.map((x) => x.toJson())),
    "user": user?.toJson(),
  };
}


class User {
  String? player;
  int? playerIndex;
  int? xp;

  User({
    this.player,
    this.playerIndex,
    this.xp,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    player: json["player"],
    playerIndex: json["playerIndex"],
    xp: json["xp"],
  );

  Map<String, dynamic> toJson() => {
    "player": player,
    "playerIndex": playerIndex,
    "xp": xp,
  };
}
