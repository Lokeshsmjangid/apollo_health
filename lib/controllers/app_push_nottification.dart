import 'package:get/get.dart';

class AppPushNotification extends GetxController {
  RxBool isNew = false.obs;
  RxInt friendRequestCount = 0.obs;

  void increaseFriendRequestCount() {
    friendRequestCount.value++;
    update();
  }

  void decreaseFriendRequestCount() {
    friendRequestCount.value--;
    update();
  }
}