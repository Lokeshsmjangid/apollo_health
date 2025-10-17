// To parse this JSON data, do
//
//     final notificationResponseModel = notificationResponseModelFromJson(jsonString);

import 'dart:convert';

NotificationResponseModel notificationResponseModelFromJson(String str) => NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseModelToJson(NotificationResponseModel data) => json.encode(data.toJson());

class NotificationResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  List<NotificationData>? data;

  NotificationResponseModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => NotificationResponseModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<NotificationData>.from(json["data"]!.map((x) => NotificationData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NotificationData {
  int? id;
  String? title;
  String? description;
  DateTime? sendAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? status;
  String? sentTime;
  int? groupGameId;
  int? notificationId;
  int? senderId;

  NotificationData({
    this.id,
    this.title,
    this.description,
    this.sendAt,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.sentTime,
    this.groupGameId,
    this.senderId,
    this.notificationId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    sendAt: json["send_at"] == null ? null : DateTime.parse(json["send_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
    sentTime: json["sent_time"],
    groupGameId: json["group_game_id"],
    senderId: json["sender_id"],
    notificationId: json["notification_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "send_at": sendAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
    "sent_time": sentTime,
    "group_game_id": groupGameId,
    "sender_id": senderId,
    "notification_id": notificationId,
  };
}
