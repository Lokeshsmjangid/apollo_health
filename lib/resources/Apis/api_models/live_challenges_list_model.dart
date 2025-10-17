// To parse this JSON data, do
//
//     final liveChallengeListModel = liveChallengeListModelFromJson(jsonString);

import 'dart:convert';

LiveChallengeListModel liveChallengeListModelFromJson(String str) => LiveChallengeListModel.fromJson(json.decode(str));

String liveChallengeListModelToJson(LiveChallengeListModel data) => json.encode(data.toJson());

class LiveChallengeListModel {
  bool? status;
  int? statusCode;
  String? message;
  List<LiveChallengeProduct>? data;

  LiveChallengeListModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LiveChallengeListModel.fromJson(Map<String, dynamic> json) => LiveChallengeListModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<LiveChallengeProduct>.from(json["data"]!.map((x) => LiveChallengeProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class LiveChallengeProduct {
  int? id;
  String? title;
  String? image;
  String? priceMoney;
  String? startDate;
  String? startTime;
  String? userName;
  String? pillBoxColor;
  int? isRegistered;

  LiveChallengeProduct({
    this.id,
    this.title,
    this.image,
    this.priceMoney,
    this.startDate,
    this.startTime,
    this.userName,
    this.pillBoxColor,
    this.isRegistered,
  });

  factory LiveChallengeProduct.fromJson(Map<String, dynamic> json) => LiveChallengeProduct(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    priceMoney: json["price_money"],
    startDate: json["start_date"],
    startTime: json["start_time"],
    userName: json["user_name"],
    pillBoxColor: json["pillbox_background_color"],
    isRegistered: json["is_registered"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "price_money": priceMoney,
    "start_date": startDate,
    "start_time": startTime,
    "user_name": userName,
    "pillbox_background_color":pillBoxColor,
    "is_registered":isRegistered
  };
}
