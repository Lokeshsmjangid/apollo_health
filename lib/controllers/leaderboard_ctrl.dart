
import 'package:apollo/resources/Apis/api_models/leaderbord_model.dart';
import 'package:apollo/resources/Apis/api_repository/leaderboard_repo.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:get/get.dart';

class LeaderboardController extends GetxController {
  bool isWeeklyTab = true;


  List<LeaderBoard> podiumUsers = []; // Podium ke liye top 3 users


  List<LeaderBoard> restUsers = []; //  users not available in podium

  bool isDataLoading = false;

  LeaderBoardModel model = LeaderBoardModel();

  @override
  void onInit() {
    super.onInit();
    Future.microtask((){
      getLeaderBoardData();
    });
  }

  getLeaderBoardData() async {
    isDataLoading = true;
    update();
    showLoader(true);

    // API call
    await leaderBoardApi(isWeeklyTab: isWeeklyTab).then((value) {
      model = value;

      final allUsers = model.data ?? [];

      podiumUsers = allUsers.take(3).toList(); // take only 3 for podium
      restUsers = allUsers.length > 3 ? allUsers.sublist(3) : []; // restUsers

      isDataLoading = false;
      update();
      showLoader(false);
    });
  }
}
