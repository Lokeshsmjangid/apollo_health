// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Category>? data;

  CategoryModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Category>.from(json["data"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Category {
  int? id;
  String? title;
  String? topic;
  String? slug;
  String? description;
  String? shortDescription;
  int? status;
  int? paidStatus;
  String? borderColor;
  String? backgroundColor;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool adPass;

  Category({
    this.id,
    this.title,
    this.topic,
    this.slug,
    this.description,
    this.shortDescription,
    this.status,
    this.paidStatus,
    this.borderColor,
    this.backgroundColor,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.adPass =false
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["title"],
    topic: json["topic"],
    slug: json["slug"],
    description: json["description"],
    shortDescription: json["short_description"],
    status: json["status"],
    paidStatus: json["paid_status"],
    borderColor: json["border_color"],
    backgroundColor: json["background_color"],
    image: json["image"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "topic": topic,
    "slug": slug,
    "description": description,
    "short_description": shortDescription,
    "status": status,
    "paid_status": paidStatus,
    "border_color": borderColor,
    "background_color": backgroundColor,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
