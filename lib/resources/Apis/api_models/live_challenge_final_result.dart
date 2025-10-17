// To parse this JSON data, do
//
//     final liveChallengeFinalResultModel = liveChallengeFinalResultModelFromJson(jsonString);

import 'dart:convert';

LiveChallengeFinalResultModel liveChallengeFinalResultModelFromJson(String str) => LiveChallengeFinalResultModel.fromJson(json.decode(str));

String liveChallengeFinalResultModelToJson(LiveChallengeFinalResultModel data) => json.encode(data.toJson());

class LiveChallengeFinalResultModel {
  bool? status;
  int? statusCode;
  String? message;
  List<LiveChallengeFinalResult>? data;

  LiveChallengeFinalResultModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LiveChallengeFinalResultModel.fromJson(Map<String, dynamic> json) => LiveChallengeFinalResultModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<LiveChallengeFinalResult>.from(json["data"]!.map((x) => LiveChallengeFinalResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class LiveChallengeFinalResult {
  int? userId;
  String? firstName;
  String? lastName;
  String? country;
  String? totalXp;
  String? totalTime;
  int? round4Time;

  LiveChallengeFinalResult({
    this.userId,
    this.firstName,
    this.lastName,
    this.country,
    this.totalXp,
    this.totalTime,
    this.round4Time,
  });

  factory LiveChallengeFinalResult.fromJson(Map<String, dynamic> json) => LiveChallengeFinalResult(
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    country: json["country"],
    totalXp: json["total_xp"],
    totalTime: json["total_time"],
    round4Time: json["round4_time"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "country": country,
    "total_xp": totalXp,
    "total_time": totalTime,
    "round4_time": round4Time,
  };
}
