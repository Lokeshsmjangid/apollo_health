
class UserModel {
  int? id;
  int? roleId;
  String? appleId;
  String? googleId;
  dynamic firstName;
  dynamic lastName;
  dynamic name;
  dynamic email;
  dynamic phone;
  dynamic ageGroup;
  dynamic profileImage;
  dynamic otp;
  dynamic emailVerifiedAt;
  dynamic genderPre;
  dynamic deviceToken;
  dynamic country;
  dynamic countryFlag;
  dynamic city;
  int? status;
  int? subscription;
  int? xp;
  String? referralCode;
  int? musicEnabled;
  int? allNotification;
  int? onlineStatusVisible;
  int? medpardyPremium;
  int? wellnessPremium;
  int? medlingoPremium;
  String? passwordResetToken;
  DateTime? passwordResetTokenExpiresAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic description;
  dynamic disclaimerStatus;


  // for profile data
  int? rank;
  int? friendRank;
  int? friendCount;
  int? mutualFriendCount;
  int? myFriendStatus;
  int? blurStatus;
  int? homeBlurStatus;
  String? joinDate;
  String? userActive;
  String? badgeAchived;
  List<Badge>? badges;
  List<StreakCalendar>? streakCalendar;
  SubscriptionDetail? subscriptionDetail;

  UserModel({
    this.id,
    this.roleId,
    this.appleId,
    this.googleId,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
    this.phone,
    this.ageGroup,
    this.profileImage,
    this.otp,
    this.emailVerifiedAt,
    this.genderPre,
    this.deviceToken,
    this.country,
    this.countryFlag,
    this.city,
    this.status,
    this.xp,
    this.referralCode,
    this.passwordResetToken,
    this.passwordResetTokenExpiresAt,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.disclaimerStatus,
    this.musicEnabled,
    this.allNotification,
    this.onlineStatusVisible,
    this.userActive,
    this.subscription,


    // for profile data
    this.rank,
    this.friendRank,
    this.friendCount,
    this.mutualFriendCount,
    this.myFriendStatus,
    this.joinDate,
    this.badgeAchived,
    this.badges,
    this.streakCalendar,
    this.medpardyPremium,
    this.wellnessPremium,
    this.medlingoPremium,
    this.blurStatus,
    this.homeBlurStatus,
    this.subscriptionDetail
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    roleId: json["role_id"],
    appleId: json["apple_id"],
    googleId: json["google_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    ageGroup: json["age_group"],
    profileImage: json["profile_image"],
    otp: json["otp"],
    emailVerifiedAt: json["email_verified_at"],
    genderPre: json["gender_pre"],
    deviceToken: json["device_token"],
    country: json["country"],
    countryFlag: json["country_flag"],
    city: json["city"],
    status: json["status"],
    xp: json["xp"],
    referralCode: json["referral_code"],
    medpardyPremium: json["medpardy_status"],
    wellnessPremium: json["wellness_status"],
    medlingoPremium: json["medlingo_status"],
    passwordResetToken: json["password_reset_token"],
    passwordResetTokenExpiresAt: json["password_reset_token_expires_at"] == null ? null : DateTime.parse(json["password_reset_token_expires_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    description: json["description"],
    disclaimerStatus: json["disclaimer_status"],
    musicEnabled: json["music_enabled"],
    allNotification: json["all_notification"],
    onlineStatusVisible: json["online_status_visible"],
    userActive: json["user_active"],
    myFriendStatus: json["myFriendStatus"],
    blurStatus: json["blur_status"],
    homeBlurStatus: json["home_blur_status"],
    subscription: json["subscription"],

    // for profile data
    rank: json["rank"],
    friendRank: json["friend_rank"],
    friendCount: json["friend_count"],
    mutualFriendCount: json["mutualFriendCount"],
    joinDate: json["join_date"],
    badgeAchived: json["badge_achived"]==""? null : json["badge_achived"],
    badges: json["badges"] == null ? [] : List<Badge>.from(json["badges"]!.map((x) => Badge.fromJson(x))),
    streakCalendar: json["streakCalendar"] == null ? [] : List<StreakCalendar>.from(json["streakCalendar"]!.map((x) => StreakCalendar.fromJson(x))),
    subscriptionDetail: json["subscription_detail"] == null ? null : SubscriptionDetail.fromJson(json["subscription_detail"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_id": roleId,
    "apple_id":appleId,
    "google_id": googleId,
    "first_name": firstName,
    "last_name": lastName,
    "name": name,
    "email": email,
    "phone": phone,
    "age_group": ageGroup,
    "profile_image": profileImage,
    "otp": otp,
    "email_verified_at": emailVerifiedAt,
    "gender_pre": genderPre,
    "device_token": deviceToken,
    "country": country,
    "country_flag": countryFlag,
    "city": city,
    "status": status,
    "xp": xp,
    "referral_code": referralCode,
    "medpardy_status": medpardyPremium,
    "wellness_status": wellnessPremium,
    "medlingo_status": medlingoPremium,
    "password_reset_token": passwordResetToken,
    "password_reset_token_expires_at": passwordResetTokenExpiresAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "description": description,
    "disclaimer_status": disclaimerStatus,
    "music_enabled": musicEnabled,
    "all_notification": allNotification,
    "online_status_visible": onlineStatusVisible,
    "user_active": userActive,
    "myFriendStatus": myFriendStatus,
    "blur_status": blurStatus,
    "home_blur_status": homeBlurStatus,

    // for profile data
    "rank": rank,
    "friend_rank": friendRank,
    "friend_count": friendCount,
    "mutualFriendCount": mutualFriendCount,
    "join_date": joinDate,
    "subscription": subscription,
    "badge_achived": badgeAchived,
    "badges": badges == null ? [] : List<dynamic>.from(badges!.map((x) => x.toJson())),
    "streakCalendar": streakCalendar == null ? [] : List<dynamic>.from(streakCalendar!.map((x) => x.toJson())),
    "subscription_detail": subscriptionDetail?.toJson(),
  };
}

class Badge {
  int? id;
  String? badge;
  String? description;
  String? createdAt;

  Badge({
    this.id,
    this.badge,
    this.description,
    this.createdAt,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    id: json["id"],
    badge: json["badge"],
    description: json["description"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "badge": badge,
    "description": description,
    "created_at": createdAt,
  };
}

class StreakCalendar {
  DateTime? date;
  String? weekDay;
  bool? active;

  StreakCalendar({
    this.date,
    this.weekDay,
    this.active,
  });

  factory StreakCalendar.fromJson(Map<String, dynamic> json) => StreakCalendar(
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    weekDay: json['week_day'],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "active": active,
    "week_day": weekDay,
  };
}
class SubscriptionDetail {
  int? id;
  int? userId;
  String? purchaseId;
  String? purchaseToken;
  String? planId;
  String? userName;
  String? amount;
  int? isPaid;
  String? planName;
  DateTime? startDate;
  DateTime? endDate;
  dynamic date;
  String? transactionDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  SubscriptionDetail({
    this.id,
    this.userId,
    this.purchaseId,
    this.purchaseToken,
    this.planId,
    this.userName,
    this.amount,
    this.isPaid,
    this.planName,
    this.startDate,
    this.endDate,
    this.date,
    this.transactionDate,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionDetail.fromJson(Map<String, dynamic> json) => SubscriptionDetail(
    id: json["id"],
    userId: json["user_id"],
    purchaseId: json["purchaseID"],
    purchaseToken: json["purchaseToken"],
    planId: json["plan_id"],
    userName: json["user_name"],
    amount: json["amount"],
    isPaid: json["is_paid"],
    planName: json["plan_name"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    date: json["date"],
    transactionDate: json["transactionDate"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "purchaseID": purchaseId,
    "purchaseToken": purchaseToken,
    "plan_id": planId,
    "user_name": userName,
    "amount": amount,
    "is_paid": isPaid,
    "plan_name": planName,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "date": date,
    "transactionDate": transactionDate,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}