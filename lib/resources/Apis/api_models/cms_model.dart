// To parse this JSON data, do
//
//     final cmsResponseModel = cmsResponseModelFromJson(jsonString);

import 'dart:convert';

CmsResponseModel cmsResponseModelFromJson(String str) => CmsResponseModel.fromJson(json.decode(str));

String cmsResponseModelToJson(CmsResponseModel data) => json.encode(data.toJson());

class CmsResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  CmsData? data;

  CmsResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CmsResponseModel.fromJson(Map<String, dynamic> json) => CmsResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : CmsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class CmsData {
  String? title;
  String? content;

  CmsData({
    this.title,
    this.content,
  });

  factory CmsData.fromJson(Map<String, dynamic> json) => CmsData(
    title: json["title"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
  };
}
