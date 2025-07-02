import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class SettingsCtrl extends GetxController{
  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await audioPlayer.play(AssetSource(sound));

  }

  bool music = true;
  bool onlineStatus = true;



  // Notification Settings
  bool allNotifications = true;

  // daily-Dose
  bool ddPush = true;
  bool ddEmail = true;

  // Live-update
  bool luPush = true;
  bool luEmail = true;

  // friend-request
  bool frPush = true;
  bool frEmail = true;

  // daily-streak
  bool dsPush = true;
  bool dsEmail = true;



  // final List<SupportOption> supportOptions = [
  //   SupportOption(
  //     title: 'Submit a Quiz Topic',
  //     subtitle: 'Got a health topic in mind? Message us. It could be in our next feature!',
  //     color: Colors.pink[100]!,
  //   ),
  //   SupportOption(title: 'Rate Us', color: Colors.blue[100]!),
  //   SupportOption(title: 'Support', color: Colors.green[100]!),
  //   SupportOption(title: 'Privacy & Terms', color: Colors.orange[200]!),
  //   SupportOption(title: 'Sign out', color: Colors.red[100]!),
  // ];

}

class SupportOption {
  final String title;
  final String? subtitle;
  final Color color;
  final Color colorBG;

  SupportOption({
    required this.title,
    this.subtitle,
    required this.color,
    required this.colorBG,
  });
}