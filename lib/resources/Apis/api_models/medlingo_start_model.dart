// To parse this JSON data, do
//
//     final startMedLingoModel = startMedLingoModelFromJson(jsonString);

import 'dart:convert';

StartMedLingoModel startMedLingoModelFromJson(String str) => StartMedLingoModel.fromJson(json.decode(str));

String startMedLingoModelToJson(StartMedLingoModel data) => json.encode(data.toJson());

class StartMedLingoModel {
  bool? status;
  int? statusCode;
  String? message;
  MedLingoData? data;

  StartMedLingoModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory StartMedLingoModel.fromJson(Map<String, dynamic> json) => StartMedLingoModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : MedLingoData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class MedLingoData {
  int? id;
  dynamic image;
  dynamic photoBy;
  String? photoByUrl;
  String? imageUrlUnsplash;
  String? imageUrl;
  String? hiddenTerm;
  dynamic term;
  String? clue;
  String? explanation;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? lenth;
  int? live;
  int? medlingoGameId;

  MedLingoData({
    this.id,
    this.image,
    this.photoBy,
    this.photoByUrl,
    this.imageUrlUnsplash,
    this.imageUrl,
    this.hiddenTerm,
    this.term,
    this.clue,
    this.explanation,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.lenth,
    this.live,
    this.medlingoGameId,
  });

  factory MedLingoData.fromJson(Map<String, dynamic> json) => MedLingoData(
    id: json["id"],
    image: json["image"],
    photoBy: json["photo_by"],
    photoByUrl: json["photo_by_url"],
    imageUrlUnsplash: json["image_url_unsplash"],
    imageUrl: json["image_url"],
    hiddenTerm: json["hidden_term"],
    term: json["term"],
    clue: json["clue"],
    explanation: json["explanation"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    lenth: json["lenth"],
    live: json["live"],
    medlingoGameId: json["medlingo_game_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "photo_by": photoBy,
    "photo_by_url": photoByUrl,
    "image_url_unsplash": imageUrlUnsplash,
    "image_url": imageUrl,
    "hidden_term": hiddenTerm,
    "term": term,
    "clue": clue,
    "explanation": explanation,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "lenth": lenth,
    "live": live,
    "medlingo_game_id": medlingoGameId,
  };
}
