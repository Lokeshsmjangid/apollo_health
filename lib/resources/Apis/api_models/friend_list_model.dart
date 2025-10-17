// To parse this JSON data, do
//
//     final friendListModel = friendListModelFromJson(jsonString);

import 'dart:convert';

import 'package:apollo/resources/Apis/api_models/friends_model.dart';

FriendListModel friendListModelFromJson(String str) => FriendListModel.fromJson(json.decode(str));

String friendListModelToJson(FriendListModel data) => json.encode(data.toJson());

class FriendListModel {
  bool? status;
  int? senderId;
  int? friendRequestCount;
  Pagination? pagination;
  List<Friends>? data;

  FriendListModel({
    this.status,
    this.senderId,
    this.friendRequestCount,
    this.pagination,
    this.data,
  });

  factory FriendListModel.fromJson(Map<String, dynamic> json) => FriendListModel(
    status: json["status"],
    senderId: json["sender_id"],
    friendRequestCount: json["pendingRequestCount"],
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    data: json["data"] == null ? [] : List<Friends>.from(json["data"]!.map((x) => Friends.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "sender_id": senderId,
    "pendingRequestCount": friendRequestCount,
    "pagination": pagination?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Pagination {
  int? total;
  int? currentPage;
  dynamic nextPage;
  int? prevPage;
  int? limit;

  Pagination({
    this.total,
    this.currentPage,
    this.nextPage,
    this.prevPage,
    this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    currentPage: json["current_page"],
    nextPage: json["next_page"],
    prevPage: json["prev_page"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "current_page": currentPage,
    "next_page": nextPage,
    "prev_page": prevPage,
    "limit": limit,
  };
}
