class Friends {
  int? id;
  dynamic name;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? country;
  String? countryFlag;
  int? xp;
  int? onlineStatusVisible;
  String? status;
  int? remainingSeconds;
  int? selfAccountStatus;
  bool? isRequested;
  String? userActive;
  int? subscription;

  Friends({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.country,
    this.countryFlag,
    this.xp,
    this.onlineStatusVisible,
    this.status,
    this.remainingSeconds,
    this.isRequested,
    this.userActive,
    this.selfAccountStatus,
    this.subscription
  });

  factory Friends.fromJson(Map<String, dynamic> json) => Friends(
    id: json["id"],
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    profileImage: json["profile_image"],
    country: json["country"],
    countryFlag: json["country_flag"],
    xp: json["xp"],
    onlineStatusVisible: json["online_status_visible"],
    status: json["status"],
    remainingSeconds: json["remaining_seconds"],
    selfAccountStatus: json["self_account_status"],
    isRequested: json["isRequested"] ?? false, //  to add friend
    userActive: json["user_active"],
    subscription: json["subscription"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "profile_image": profileImage,
    "country": country,
    "country_flag": countryFlag,
    "xp": xp,
    "online_status_visible": onlineStatusVisible,
    "status": status,
    "remaining_seconds": remainingSeconds,
    "self_account_status": selfAccountStatus,
    "isRequested": isRequested,
    "user_active": userActive,
    "subscription": subscription,
  };
}