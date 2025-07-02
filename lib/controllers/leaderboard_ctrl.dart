import 'package:apollo/models/leaderboard_users_model.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:get/get.dart';

class LeaderboardController extends GetxController{
  bool isWeeklyTab = true;

  List<LeaderboardUser> leaderboardUsers = [
    LeaderboardUser(rank: 4, name: "Madenyn Dias", flag: AppAssets.lFlag4Icon, hp: 590, change: -1),
    LeaderboardUser(rank: 5, name: "Zain Vaccaro", flag: AppAssets.lFlag5Icon, hp: 448, change: -1, highlight: true),
    LeaderboardUser(rank: 6, name: "Rafael Bagas", flag: AppAssets.lFlag6Icon, hp: 443, change: 1),
    LeaderboardUser(rank: 7, name: "Ted Putri", flag: AppAssets.lFlag7Icon, hp: 380, change: 2),

    LeaderboardUser(rank: 8, name: "Zain Vaccaro", flag: AppAssets.lFlag5Icon, hp: 448, change: -1, highlight: true),
    LeaderboardUser(rank: 9, name: "Rafael Bagas", flag: AppAssets.lFlag6Icon, hp: 443, change: 1),
    LeaderboardUser(rank: 10, name: "Ted Putri", flag: AppAssets.lFlag7Icon, hp: 380, change: 2),

    LeaderboardUser(rank: 11, name: "Zain Vaccaro", flag: AppAssets.lFlag5Icon, hp: 448, change: -1, highlight: true),
    LeaderboardUser(rank: 12, name: "Rafael Bagas", flag: AppAssets.lFlag6Icon, hp: 443, change: 1),
    LeaderboardUser(rank: 13, name: "Ted Putri", flag: AppAssets.lFlag7Icon, hp: 380, change: 2),
  ];

}

