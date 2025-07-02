import 'package:apollo/models/my_profile_badge_model.dart' as pm; // pm for profile model
import 'package:apollo/resources/app_assets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherProfileCtrl extends GetxController{

  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await audioPlayer.play(AssetSource(sound));

  }

  final List<pm.Badge> badges = [
    pm.Badge(
      title: "Health Apprentice",
      description: "You’ve reached 5,000 HP",
      date: "Sep. 20, 2025",
      color: Colors.blue,
      icon: AppAssets.healthApprenticeBadge,
    ),
  ];

}