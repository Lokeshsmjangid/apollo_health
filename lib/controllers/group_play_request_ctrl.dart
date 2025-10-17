import 'dart:async';

import 'package:apollo/resources/Apis/api_models/play_request_model.dart';
import 'package:apollo/resources/Apis/api_repository/play_request_repo.dart';
import 'package:get/get.dart';

class GroupPlayRequestCtrl extends GetxController{

  PlayRequestModel playRequestModel = PlayRequestModel();
  bool isDataLoading = false;
  int? gameId;
  int? senderId;
  String? status;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(Get.arguments!=null){
     gameId = Get.arguments['group_game_id'];
     senderId = Get.arguments['sender_id'];
     getPlayRequestData();
    }
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  getPlayRequestData() async{
    isDataLoading = true;
    update();
    playRequestApi(groupGameId: gameId,senderId: senderId).then((value){
      playRequestModel = value;
      isDataLoading = false;
      if(playRequestModel.data!=null) {
        status='${playRequestModel.data?.status}';
        seconds = playRequestModel.data!=null?playRequestModel.data!.remainingSeconds! :60;
        startTimer();
      }
      update();
    });
  }

  // timer
  int seconds = 60; // initial countdown value
  Timer? _timer;
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {

        seconds--;
        update();
      } else {
        timer.cancel();
        if(seconds<1){

        }

      }
    });
  }


  /*final List<Map<String, dynamic>> requests = [
    {
      'name': 'Madenyn Dias',
      'avatar': 'https://i.pravatar.cc/150?img=10',
      'flag': '🇧🇧',
      'timeLeft': '58 sec',
    },
    {
      'name': 'Wade Warren',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'flag': '🇧🇧',
      'timeLeft': '27 sec',
    },
  ];*/
}