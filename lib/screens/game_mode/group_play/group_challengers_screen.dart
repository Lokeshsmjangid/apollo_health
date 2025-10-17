import 'dart:async';
import 'package:apollo/controllers/group_challengers_ctrl.dart';
import 'package:apollo/custom_widgets/flow_line_effect.dart';
import 'package:apollo/resources/Apis/api_models/friend_list_model.dart';
import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';
import 'package:apollo/resources/Apis/api_repository/group_challengers_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupChallengersScreen extends StatefulWidget {
  // int seconds;
  bool isPlayRequest;
  List<SoloPlayQuestion>? questionsApi;
  GameData? gameData;

  GroupChallengersScreen({super.key,this.isPlayRequest=false,this.questionsApi,this.gameData});

  @override
  State<GroupChallengersScreen> createState() => _GroupChallengersScreenState();
}

class _GroupChallengersScreenState extends State<GroupChallengersScreen> {
  FriendListModel challengersModel = FriendListModel();

  bool isDataLoading =false;
  bool againDataLoading = false;


  int seconds = 60; // initial countdown value
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    Future.microtask((){
      getChallengersList();
      // startTimer();
    });

  }



  getChallengersList() async{
    if(!againDataLoading){
      isDataLoading = true;
      setState(() {});
    }
    await getChallengersApi(groupGameId: widget.gameData!.id).then((value){
      challengersModel = value;
      if(!againDataLoading){
      isDataLoading = false;
      seconds = value.data!=null ? value.data![0].remainingSeconds!:60;
      // seconds =  5;
      startTimer();
      }
      againDataLoading = true;
      setState(() {});
    });
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
        // to call api
        if((seconds > 40 && seconds % 5 == 0) || (seconds <= 40 && seconds % 3 == 0)){
          getChallengersList();
        }
        if (challengersModel.data != null &&
            challengersModel.data!.isNotEmpty &&
            challengersModel.data!.every((user) => user.status?.toLowerCase() != 'pending')) {

          // uncomment for accept all players
          timer.cancel();
          Get.toNamed(AppRoutes.quizScreenNew, arguments: {
            'isPlayRequest': widget.isPlayRequest,
            'screen': 'groupPlay',
            'questions': widget.questionsApi,
            'gameData': widget.gameData,
          });
        }

      } else {
        timer.cancel();
        if(seconds<1){
          // Get.offNamed(AppRoutes.quizScreenNew, arguments: {'screen': 'groupPlay'});


          // if(challengersModel.data != null && challengersModel.data!.isNotEmpty) { players not koin
            Get.toNamed(AppRoutes.quizScreenNew, arguments: {
              'isPlayRequest': widget.isPlayRequest,
              'screen': 'groupPlay',
            'questions': widget.questionsApi,
            'gameData':widget.gameData});
          // }else{
          //   CustomSnackBar().showSnack(Get.context!,message: '');
          // }
        }

      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor, // Purple background
        body: GetBuilder<GroupChallengersCtrl>(builder: (logic) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppAssets.notificationsBg,
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    addHeight(10),
                    // Top Bar
                    backBar(
                      trailing: true,
                      title: "Challengers",
                      onTap: () {
                        Get.back();
                      },
                    ).marginSymmetric(horizontal: 16),
                    const SizedBox(height: 24),
                    // White rounded container
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: isDataLoading
                            ? buildCpiLoader()
                            : Column(
                          children: [
                            Expanded(
                              child: challengersModel.data != null && challengersModel.data!.isNotEmpty
                                  ? ListView.builder(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                                itemCount: challengersModel.data!.length,
                                itemBuilder: (context, index) {
                                  final user = challengersModel.data![index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 2),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: AppColors.yellow10Color,
                                                  shape: BoxShape.circle
                                              ),
                                              child: CachedImageCircle2(imageUrl: user.profileImage,isCircular: true),
                                            ),

                                            Positioned(
                                              // top: 2,
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                width: 22,height: 15,
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: AppColors.whiteColor,width: 1.5),
                                                    borderRadius: BorderRadius.circular(2)

                                                ),
                                                child: ClipRRect(
                                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                                  borderRadius: BorderRadius.circular(2),
                                                  child: Image.network('${user.countryFlag}',fit: BoxFit.cover),
                                                ),),
                                            ),

                                            if(user.onlineStatusVisible==1)
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                // bottom: 0,
                                                child: Container(
                                                  height: 12, width: 12,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color(0xff41A43C)
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              addText600(
                                                getTruncatedName(user.firstName??'',user.lastName??""),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 16,
                                              ),
                                              const SizedBox(height: 2),
                                              addText400('${user.xp} HP', fontSize: 12, color: AppColors.blackColor),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // WinnerTakesAllOnOneTableSheet(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: AppColors.primaryColor),
                                              color: user.status == "accepted" ? AppColors.primaryColor : null,
                                            ),
                                            child: addText500(
                                              user.status == "accepted" ? 'Accepted'
                                                  : user.status == "rejected" ? 'Declined' : user.status?.capitalize??'',
                                              fontSize: 16,
                                              height: 22,
                                              color: user.status == "accepted"? AppColors.whiteColor : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                                  : Center(child: addText500('Players not found.')),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24,left: 24,right: 24),
                              child: Center(
                                child: gameStartBox(
                                  hug1: 195,
                                  hug2: 36,
                                  seconds: seconds,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget gameStartBox({
    required int hug1,
    required int hug2,
    required int seconds,
  }) { return Container(
      padding: const EdgeInsets.only(bottom: 12,top: 12,right: 12,left: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          // Divider(height: 0,endIndent: 0,thickness: 2,color: AppColors.blueColor,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: addText700(
              'Game auto-starts once all players join...',
              textAlign: TextAlign.center,
              fontSize: 20
            ),
          ),

          addHeight(30),
          FlowingLineEffect(isGroupChallersList: true,),
          addHeight(12),


          /*const SizedBox(height: 12),

          // Countdown Number
          Container(
            height: 60,
            width: 60,
            // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.yellow[700],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12,width: 1),
            ),
            child: Center(
              child: addText400(
                '$seconds',
                fontSize: 32,fontFamily: 'Caprasimo'
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Seconds Text
           addText400(
            'Seconds',
            fontSize: 12,
          ),*/
        ],
      ),
    ); }
}
