// To parse this JSON data, do
//
//     final leaderBoardModel = leaderBoardModelFromJson(jsonString);

import 'dart:convert';

LeaderBoardModel leaderBoardModelFromJson(String str) => LeaderBoardModel.fromJson(json.decode(str));

String leaderBoardModelToJson(LeaderBoardModel data) => json.encode(data.toJson());

class LeaderBoardModel {
  bool? status;
  int? statusCode;
  String? message;
  List<LeaderBoard>? data;

  LeaderBoardModel({
    this.status,
    this.statusCode,
    this.message,
    this.data,
  });

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) => LeaderBoardModel(
    status: json["status"],
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<LeaderBoard>.from(json["data"]!.map((x) => LeaderBoard.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class LeaderBoard {
  int? id;
  String? firstName;
  String? lastName;
  dynamic xp;
  String? countryFlag;
  String? country;
  String? profileImage;
  int? rank;
  int? previousRank;
  String? movement;
  String? userActive;
  int? rankChange;
  int? onlineStatusVisible;
  int? myFriendStatus;
  int? subscription;

  LeaderBoard({
    this.id,
    this.firstName,
    this.lastName,
    this.xp,
    this.countryFlag,
    this.country,
    this.profileImage,
    this.rank,
    this.previousRank,
    this.movement,
    this.rankChange,
    this.userActive,
    this.onlineStatusVisible,
    this.myFriendStatus,
    this.subscription,
  });

  factory LeaderBoard.fromJson(Map<String, dynamic> json) => LeaderBoard(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    xp: json["xp"],
    countryFlag: json["country_flag"],
    country: json["country"],
    profileImage: json["profile_image"],
    rank: json["rank"],
    previousRank: json["previous_rank"],
    movement: json["movement"],
    rankChange: json["rank_change"],
    userActive: json["user_active"],
    onlineStatusVisible: json["online_status_visible"],
    myFriendStatus: json["myFriendStatus"],
    subscription: json["subscription"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "xp": xp,
    "country_flag": countryFlag,
    "country": country,
    "profile_image": profileImage,
    "rank": rank,
    "previous_rank": previousRank,
    "movement": movement,
    "rank_change": rankChange,
    "user_active": userActive,
    "online_status_visible": onlineStatusVisible,
    "myFriendStatus": myFriendStatus,
    "subscription": subscription,
  };
}
