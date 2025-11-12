import 'package:apollo/resources/Apis/api_repository/notification_list_repo.dart';
import 'package:apollo/resources/Apis/api_models/notification_model.dart';
import 'package:apollo/models/notifications_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsCtrl extends GetxController{
  NotificationResponseModel model = NotificationResponseModel();
  bool isDataLoading = false;

  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {
    await audioPlayer.play(AssetSource(sound));
  }
  late PageController scaleController;
  final List<NotificationItem> notifications = [
    NotificationItem(
      type: NotificationType.groupPlayInvite,
      title: "Group Play Invite",
      createdAt: "Just now",
      message: "Dan Jones has invited you to a Group Play! ",
      isHighlighted: true,
    ),
    NotificationItem(
      type: NotificationType.friendRequest,
      title: "Friend Request",
      createdAt: "5m ago",
      message: "Sam Nichols has added you as a friend.",
      isHighlighted: true,
    ),
    NotificationItem(
      type: NotificationType.promotion,
      title: "Promotion",
      createdAt: "2h ago",
      message: "Your next Wheel of Wellness puzzle challenge awaits!",
    ),
    NotificationItem(
      type: NotificationType.system,
      title: "System",
      createdAt: "5d ago",

      message: "New category alert!",
    ),
    NotificationItem(
      type: NotificationType.promotion,
      title: "Promotion",
      createdAt: "3w ago",

      message: "Your next WoW puzzle challenge awaits!",
    ),
    NotificationItem(
      type: NotificationType.system,
      title: "System",
      createdAt: "3mo ago",
      message: "Your next quiz challenge awaits!",
    ),
    NotificationItem(
      type: NotificationType.promotion,
      title: "Promotion",
      createdAt: "5mo ago",
      message: "Your next Wheel of Wellness puzzle challenge awaits!",
    ),
    NotificationItem(
      type: NotificationType.system,
      title: "System",
      createdAt: "7mo ago",

      message: "New category alert!",
    ),
    NotificationItem(
      type: NotificationType.promotion,
      title: "Promotion",
      createdAt: "9mo ago",

      message: "Your next WoW puzzle challenge awaits!",
    ),
    NotificationItem(
      type: NotificationType.system,
      title: "System",
      createdAt: "1yr ago",

      message: "Your next quiz challenge awaits!",
    )
  ];

  @override
  void onInit() {
    scaleController = PageController();
    super.onInit();
    getNotificationData();
  }

  getNotificationData() async {
    isDataLoading=true;
    await notificationListApi().then((value){
      model = value;
      isDataLoading=false;
      update();
    });
  }

  @override
  void onClose() {
    scaleController.dispose();
    super.onClose();
  }
}

