// To parse this JSON data, do
//
//     final medpardyRegisterModel = medpardyRegisterModelFromJson(jsonString);

import 'dart:convert';

import 'package:apollo/resources/Apis/api_models/category_model.dart';

MedpardyRegisterModel medpardyRegisterModelFromJson(String str) => MedpardyRegisterModel.fromJson(json.decode(str));

String medpardyRegisterModelToJson(MedpardyRegisterModel data) => json.encode(data.toJson());

class MedpardyRegisterModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  MedpardyRegisterModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory MedpardyRegisterModel.fromJson(Map<String, dynamic> json) => MedpardyRegisterModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Users? users;
  List<Category>? categoryList;

  Data({
    this.users,
    this.categoryList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    categoryList: json["categoryList"] == null ? [] : List<Category>.from(json["categoryList"]!.map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "users": users?.toJson(),
    "categoryList": categoryList == null ? [] : List<dynamic>.from(categoryList!.map((x) => x.toJson())),
  };
}


class Users {
  String? categorySelected;
  String? player1;
  String? player2;
  String? player3;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Users({
    this.categorySelected,
    this.player1,
    this.player2,
    this.player3,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    categorySelected: json["category_selected"],
    player1: json["player_1"],
    player2: json["player_2"],
    player3: json["player_3"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "category_selected": categorySelected,
    "player_1": player1,
    "player_2": player2,
    "player_3": player3,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
