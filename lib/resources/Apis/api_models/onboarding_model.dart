// To parse this JSON data, do
//
//     final onboardingModel = onboardingModelFromJson(jsonString);

import 'dart:convert';

OnboardingModel onboardingModelFromJson(String str) => OnboardingModel.fromJson(json.decode(str));

String onboardingModelToJson(OnboardingModel data) => json.encode(data.toJson());

class OnboardingModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Pages>? data;

  OnboardingModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) => OnboardingModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Pages>.from(json["data"]!.map((x) => Pages.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Pages {
  String? title;
  String? desc;

  Pages({
    this.title,
    this.desc,
  });

  factory Pages.fromJson(Map<String, dynamic> json) => Pages(
    title: json["title"],
    desc: json["desc"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "desc": desc,
  };
}
