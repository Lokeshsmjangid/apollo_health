// To parse this JSON data, do
//
//     final dealsServicesModel = dealsServicesModelFromJson(jsonString);

import 'dart:convert';

DealsServicesModel dealsServicesModelFromJson(String str) => DealsServicesModel.fromJson(json.decode(str));

String dealsServicesModelToJson(DealsServicesModel data) => json.encode(data.toJson());

class DealsServicesModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Services>? data;

  DealsServicesModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory DealsServicesModel.fromJson(Map<String, dynamic> json) => DealsServicesModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Services>.from(json["data"]!.map((x) => Services.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Services {
  int? id;
  int? userId;
  dynamic editedBy;
  String? url;
  String? title;
  String? pillbox;
  String? description;
  dynamic expiryDate;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? image;

  Services({
    this.id,
    this.userId,
    this.editedBy,
    this.url,
    this.title,
    this.pillbox,
    this.description,
    this.expiryDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  factory Services.fromJson(Map<String, dynamic> json) => Services(
    id: json["id"],
    userId: json["user_id"],
    editedBy: json["edited_by"],
    url: json["url"],
    title: json["title"],
    pillbox: json["pillbox"],
    description: json["description"],
    expiryDate: json["expiry_date"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "edited_by": editedBy,
    "url": url,
    "title": title,
    "pillbox": pillbox,
    "description": description,
    "expiry_date": expiryDate,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image": image,
  };
}
