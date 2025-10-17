// To parse this JSON data, do
//
//     final commonResponseModel = commonResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:apollo/resources/Apis/api_models/user_model.dart';


RegisterResponseModel commonResponseModelFromJson(String str) => RegisterResponseModel.fromJson(json.decode(str));

String commonResponseModelToJson(RegisterResponseModel data) => json.encode(data.toJson());

class RegisterResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  String? token;
  UserModel? data;

  RegisterResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
    this.token,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) => RegisterResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : UserModel.fromJson(json["data"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
    "token": token,
  };
}

