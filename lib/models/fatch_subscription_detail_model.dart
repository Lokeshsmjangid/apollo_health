// To parse this JSON data, do
//
//     final mySubscriptionDetailResponse = mySubscriptionDetailResponseFromJson(jsonString);

import 'dart:convert';

import 'package:apollo/resources/Apis/api_models/user_model.dart';

MySubscriptionDetailResponse mySubscriptionDetailResponseFromJson(String str) => MySubscriptionDetailResponse.fromJson(json.decode(str));

String mySubscriptionDetailResponseToJson(MySubscriptionDetailResponse data) => json.encode(data.toJson());

class MySubscriptionDetailResponse {
  bool? status;
  int? statusCode;
  String? message;
  UserModel? data;

  MySubscriptionDetailResponse({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory MySubscriptionDetailResponse.fromJson(Map<String, dynamic> json) => MySubscriptionDetailResponse(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : UserModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

