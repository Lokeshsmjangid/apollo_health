import 'package:apollo/models/my_profile_badge_model.dart' as pm; // pm for profile model
import 'package:apollo/resources/app_assets.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileCtrl extends GetxController{

  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await audioPlayer.play(AssetSource(sound));

  }

  final List<pm.Badge> badges = [
    pm.Badge(
      title: "Grandmaster of Health",
      description: "You’ve reached 50,000 HP",
      date: "Dec. 29, 2025",
      color: Colors.red,
      icon: AppAssets.grandmasterOfHealthBadge,
    ),

    pm.Badge(
      title: "Health Whiz",
      description: "You’ve reached 25,000 HP",
      date: "Dec. 14, 2025",
      color: Colors.lightGreen,
      icon: AppAssets.healthBadge,
    ),

    pm.Badge(
      title: "Health Pro",
      description: "You’ve reached 15,000 HP",
      date: "Nov. 28, 2025",
      color: Colors.green,
      icon: AppAssets.healthProBadge,
    ),
    pm.Badge(
      title: "Wellness Watcher",
      description: "You’ve reached 10,000 HP",
      date: "Nov. 03, 2025",
      color: Colors.blueAccent,
      icon: AppAssets.wellnessWatcherBadge,
    ),
    pm.Badge(
      title: "Health Apprentice",
      description: "You’ve reached 5,000 HP",
      date: "Sep. 20, 2025",
      color: Colors.blue,
      icon: AppAssets.healthApprenticeBadge,
    ),
  ];

}