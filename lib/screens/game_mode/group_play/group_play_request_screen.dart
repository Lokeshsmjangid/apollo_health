import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'group_challengers_screen.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/controllers/group_play_request_ctrl.dart';
import 'package:apollo/resources/Apis/api_repository/play_request_accept_repo.dart';
import 'package:apollo/resources/Apis/api_repository/play_request_decline_repo.dart';

class GroupPlayRequestScreen extends StatelessWidget {


  const GroupPlayRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Purple background
      body: GetBuilder<GroupPlayRequestCtrl>(builder: (logic) {
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
                    title: "Play Request",
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
                      child: logic.isDataLoading?buildCpiLoader(): logic.playRequestModel.data!=null
                          ? ListView.builder(
                        // itemCount: logic.requests.length,
                        itemCount: 1,
                        padding: EdgeInsets.zero,
                        // padding: const EdgeInsets.symmetric(vertical: 20),
                        itemBuilder: (context, index) {
                          final user = logic.playRequestModel.data;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            padding: const EdgeInsets.only(left: 14,top: 12,bottom: 12),
                            decoration: BoxDecoration(
                              // color: Colors.green,
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
                                      child: CachedImageCircle2(imageUrl: user?.profileImage??'',isCircular: true),
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
                                              child: Image.network('${user?.countryFlag}',fit: BoxFit.cover),
                                    ),))
                                  ],
                                ),

                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      addText600(
                                        '${user?.firstName??''} ${user?.lastName??''}',fontSize: 16,
                                        maxLines: 1,overflow: TextOverflow.ellipsis
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Image.asset(AppAssets.timerIcon,height: 16,width: 16,),
                                          const SizedBox(width: 4),
                                          addText400(
                                            '${logic.seconds} sec',
                                            fontSize: 12,color: AppColors.redColor
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [

                                          if(user!.gameData!.winnerTakeMode == 1 || user.gameData!.winnerTakeMode =="1")
                                          addText400('Winner Take All. ', fontSize: 11,color: AppColors.green500Color),
                                          if(user.gameData!.winnerTakeMode == 1)
                                          const SizedBox(width: 4),

                                          Container(
                                              // color: Colors.green,
                                              constraints: BoxConstraints(maxWidth: 58,minWidth: 58),
                                              child: addText400('${user.inviteCount} invited.',maxLines: 1,overflow: TextOverflow.ellipsis, fontSize: 11,color: AppColors.textColor3)),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                if(logic.status=='pending' || logic.status=='accepted')
                                GestureDetector(
                                  onTap: (){
                                    if(logic.seconds>0 && logic.status!='accepted'){
                                      showLoader(true);
                                      playRequestAcceptApi(groupGameId: logic.gameId).then((value){
                                        showLoader(false);
                                        if(value.status==true){
                                          logic.status = value.data;
                                          logic.update();

                                          Get.off(()=>GroupChallengersScreen(
                                            isPlayRequest: true,
                                              questionsApi: logic.playRequestModel.data!.questions,
                                              gameData: logic.playRequestModel.data!.gameData));
                                        }
                                      });}
                                    else if(logic.seconds>0 && logic.status=='accepted'){
                                      Get.off(()=>GroupChallengersScreen(
                                          isPlayRequest: true,
                                          questionsApi: logic.playRequestModel.data!.questions,
                                          gameData: logic.playRequestModel.data!.gameData));
                                    }

                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                    decoration: BoxDecoration(
                                      color: logic.status=='accepted'?AppColors.primaryColor:null,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.primaryColor)
                                    ),
                                    child: Row(
                                      children: [
                                        addText500(logic.status=="pending"?'Accept':'${logic.status?.capitalizeFirst}',
                                            color: logic.status=='accepted'?AppColors.whiteColor:null,
                                            fontSize: 16,height: 22)
                                      ],
                                    ),

                                  ),
                                ),

                                if(logic.status!='accepted')
                                const SizedBox(width: 8),
                                if(logic.status != 'accepted' || logic.status != 'rejected' )

                                GestureDetector(
                                  onTap: (){ if(logic.seconds>0 && logic.status=='pending'){
                                      showLoader(true);
                                      playRequestDeclineApi(groupGameId: logic.gameId).then((value){
                                        showLoader(false);
                                        if(value.status==true){
                                          logic.status = value.data;
                                          logic.playRequestModel.data = null;
                                          logic.update();
                                        }
                                      });
                                    } },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.redColor),
                                      borderRadius: BorderRadius.circular(8),),
                                    child: Icon(Icons.close, color: AppColors.redColor).marginAll(5),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ).marginOnly(left: 16,right: 16,top: 24)
                          : Center(child: addText500('No play request found')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
