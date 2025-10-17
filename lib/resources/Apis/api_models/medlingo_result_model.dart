// To parse this JSON data, do
//
//     final medLingoResultModel = medLingoResultModelFromJson(jsonString);

import 'dart:convert';

MedLingoResultModel medLingoResultModelFromJson(String str) => MedLingoResultModel.fromJson(json.decode(str));

String medLingoResultModelToJson(MedLingoResultModel data) => json.encode(data.toJson());

class MedLingoResultModel {
  bool? status;
  int? statusCode;
  String? message;
  MedLingoResultData? data;

  MedLingoResultModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory MedLingoResultModel.fromJson(Map<String, dynamic> json) => MedLingoResultModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : MedLingoResultData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class MedLingoResultData {
  int? id;
  String? hiddenTerm;
  String? clue;
  String? explanation;
  int? xp;

  MedLingoResultData({
    this.id,
    this.hiddenTerm,
    this.clue,
    this.explanation,
    this.xp,
  });

  factory MedLingoResultData.fromJson(Map<String, dynamic> json) => MedLingoResultData(
    id: json["id"],
    hiddenTerm: json["hidden_term"],
    clue: json["clue"],
    explanation: json["explanation"],
    xp: json["xp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "hidden_term": hiddenTerm,
    "clue": clue,
    "explanation": explanation,
    "xp": xp,
  };
}
