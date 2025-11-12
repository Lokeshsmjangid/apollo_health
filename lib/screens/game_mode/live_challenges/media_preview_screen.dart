import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';
import 'package:apollo/resources/Apis/api_repository/live_challenges_final_result_repo.dart';
import 'package:apollo/resources/Apis/api_models/live_challenge_final_result.dart';
import 'live_challenge_result_with_country_score.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'live_challenge_result.dart';
import 'package:get/get.dart';
import 'dart:async';

class MediaPreviewScreen extends StatefulWidget {
  final String url;
  final String type; // "video" or "image"
  int? round;
  int? livePlayId;
  int? countParticipants;
  List<SoloPlayQuestion> questionsApi;
  List<LiveChallengeFinalResult> resultData;

  MediaPreviewScreen({
    Key? key,
    required this.url,
    required this.type,
    this.round,
    this.livePlayId,
    this.countParticipants,
    this.questionsApi = const[],
    this.resultData=const []

  }) : super(key: key);

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  VideoPlayerController? _videoController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.type == "video") {
      _videoController = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
        });
    }

    _timer = Timer(const Duration(seconds: 10), () {
      if(widget.round==2){
        Get.offNamed(AppRoutes.liveChallengeRoundTwoScreen, // before ads
            arguments: {
              'live_play_id': widget.livePlayId,
              'questions': widget.questionsApi??[],
              'count_participants':widget.countParticipants});
      }
      if(widget.round==3){
        Get.offNamed(AppRoutes.liveChallengeRoundThreeScreen,
            arguments: {
              'live_play_id': widget.livePlayId,
              'questions': widget.questionsApi,
              'count_participants':widget.countParticipants});
      }
      if(widget.round==4){
        Get.offNamed(AppRoutes.liveChallengeRoundFourScreen,
            arguments: {
              'live_play_id': widget.livePlayId,
              'questions': widget.questionsApi,
              'count_participants':widget.countParticipants});
      }
      if(widget.round==-1){
        resultLiveChallengesApi(liveChallengeId: widget.livePlayId).then((value){
          if(value.status==true){
            widget.resultData = value.data!;
            setState(() {});

            if(widget.resultData.isNotEmpty){
              if(widget.resultData[0].userId==AuthData().userModel?.id){
                Get.off(LiveChallengeResultScreen(resultData: value.data));
              } else{
                Get.off(LivePlayResultWithScoreScreen(resultData: value.data));
              }
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: widget.type == "image"
            ? Image.network(widget.url, fit: BoxFit.contain)
            : _videoController != null && _videoController!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
