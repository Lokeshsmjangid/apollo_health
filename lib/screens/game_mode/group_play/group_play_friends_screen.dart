import 'dart:io';
import 'package:apollo/controllers/group_play_frinds_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/custom_widgets/online_status_dot_screen.dart';
import 'package:apollo/resources/Apis/api_models/solo_play_models/solo_play_questions_model.dart';
import 'package:apollo/resources/Apis/api_repository/send_play_request_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'group_challengers_screen.dart';

class GroupPlayFriendsScreen extends StatefulWidget {
  List<SoloPlayQuestion>? questionsApi;
  GameData? gameData;

  GroupPlayFriendsScreen({super.key,this.questionsApi,this.gameData});

  @override
  State<GroupPlayFriendsScreen> createState() => _GroupPlayFriendsScreenState();
}

class _GroupPlayFriendsScreenState extends State<GroupPlayFriendsScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      body: GetBuilder<GroupPlayFriendsCtrl>(builder: (logic) {
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
                  // addHeight(52),
                  addHeight(10),
                  backBar(
                    trailing: true,
                    title: "Group Play",
                    onTap: () {
                      Get.back();
                    },
                  ).marginSymmetric(horizontal: 16),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        buildTabButton("My Friends", logic.isFriendsTab, () {
                          logic.isFriendsTab = true;
                          logic.page = 1;
                          logic.friendModel.data = [];
                          // logic.selectedPlayers.clear();
                          logic.searchCtrl.clear();
                          logic.update();
                          logic.getFriendList(Page: 1);
                        }),
                        buildTabButton(
                            "Global Players", !logic.isFriendsTab, () {
                          logic.isFriendsTab = false;
                          logic.page = 1;
                          logic.friendModel.data = [];
                          // logic.selectedPlayers.clear();
                          logic.searchCtrl.clear();
                          logic.update();
                          logic.getFriendList(Page: 1);
                        }),
                      ],
                    ),
                  ).marginSymmetric(horizontal: 15),
                  const SizedBox(height: 24),

                  // Players List
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16)),
                      ),
                      child: Column(
                        children: [
                          // Search Bar
                          TextField(
                            autocorrect: false,
                            controller: logic.searchCtrl,
                            onChanged: (val){
                              logic.page = 1;
                              logic.debounce.run((){
                                logic.getFriendList(search: val, Page: 1);
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'Search by name',
                                prefixIcon: const Icon(Icons.search, color: Color(0xff67656B)),
                                filled: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xff67656B)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor),
                                ),


                            ),
                          ),
                          addHeight(10),

                          Expanded(
                              child: logic.isDataLoading
                                  ? buildCpiLoader()
                                  : logic.friendModel.data !=null && logic.friendModel.data!.isNotEmpty
                                  ? ListView.builder(
                                controller: logic.paginationScrollController,
                                padding: EdgeInsets.only(bottom: 20),
                                physics: BouncingScrollPhysics(),
                                itemCount: logic.friendModel.data!.length + (logic.isPageLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (logic.isPageLoading && index == logic.friendModel.data!.length) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(strokeWidth: 1),
                                            ),
                                            addWidth(10),
                                            addText400('Loading...')
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  final player = logic.friendModel.data![index];
                                  final isSelected = logic.selectedPlayers.contains(player.id);
                                  return GestureDetector(
                                    onTap: () {
                                      if(player.selfAccountStatus==0) {
                                        setState(() {
                                        if (isSelected) {
                                          logic.selectedPlayers.remove(player.id);
                                        } else if( logic.selectedPlayers.length<9){
                                          logic.selectedPlayers.add(player.id!);
                                        } else{
                                          CustomSnackBar().showSnack(context,isSuccess: false,message: 'You can play a Battle with up to 10 friends.');
                                        }
                                      });
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 2),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors
                                            .yellow10Color : Colors.transparent,
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
                                                child:player.selfAccountStatus==0
                                                    ? CachedImageCircle2(imageUrl: player.profileImage,isCircular: true)
                                                    : apolloAvatar()
                                                    // apolloAvatar(),
                                              ),

                                              if(player.selfAccountStatus==0)
                                              Positioned(
// top: 2,
                                                right: 0,
                                                bottom: 0,
                                                child: player.countryFlag!=null?Container(
                                                  width: 22,height: 15,
                                                  decoration: BoxDecoration(
// border: Border.all(color: AppColors.whiteColor,width: 1.5),
                                                      borderRadius: BorderRadius.circular(2)

                                                  ),
                                                  child: ClipRRect(
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    borderRadius: BorderRadius.circular(2),
                                                    child: Image.network('${player.countryFlag}',fit: BoxFit.cover),
                                                  ),):SizedBox.shrink(),
                                              ),

                                              if(player.onlineStatusVisible==1 && (player.userActive!=null && player.userActive!.isNotEmpty))
                                              Positioned(
                                                    top: 2,
                                                    right: 0,
                                                    // bottom: 0,
                                                    child: OnlineStatusDot(lastActiveTime: DateTime.parse("${player.userActive}"))),
                                            ],
                                          ),
                                          addWidth(12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                addText600(
                                            player.selfAccountStatus==1 || player.selfAccountStatus==2?"Apollo User":
                                                  getTruncatedName(player.firstName??'',player.lastName??""),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: 16,
                                                ),

                                                if(player.selfAccountStatus==0)
                                                addHeight(2),
                                                if(player.selfAccountStatus==0)
                                                addText400('${player.xp} HP', fontSize: 12),
                                              ],
                                            ),
                                          ),
                                          Checkbox(
                                            visualDensity: VisualDensity(
                                                horizontal: -4, vertical: -4),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4)),
                                            value: isSelected,
                                            side: MaterialStateBorderSide.resolveWith((states) {
                                              if (!states.contains(
                                                  MaterialState.selected)) {
                                                return BorderSide(
                                                    color: player.selfAccountStatus==0
                                                        ? AppColors.primaryColor.withOpacity(0.8)
                                                        : AppColors.apolloGreyColor,
                                                    width: 1); // border color when unchecked
                                              }
                                              return null;
                                            }),
                                            onChanged: (val) {
                                              setState(() {
                                                if(player.selfAccountStatus==0){
                                                  if (isSelected) {
                                                    logic.selectedPlayers.remove(player.id);
                                                  }
                                                  else if( logic.selectedPlayers.length<9){
                                                    logic.selectedPlayers.add(player.id!);
                                                  }
                                                  else{
                                                    CustomSnackBar().showSnack(context,isSuccess: false,message: 'You can play a Battle with up to 10 friends.');
                                                  }
                                                }

                                              });
                                            },
                                            activeColor: player.selfAccountStatus==0
                                                ? AppColors.primaryColor.withOpacity(0.8)
                                                : AppColors.apolloGreyColor,

                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                                  : Center(child: addText500(logic.isFriendsTab ?'No friends found':'No players found')))


                        ],
                      ).marginOnly(left: 16, right: 16, top: 24),
                    ),
                  ),
                  // Bottom Start Game Button
                  /*Container(
                    color: AppColors.whiteColor,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20,right: 20, bottom: MediaQuery.of(context).viewInsets.bottom != 0 ? MediaQuery.of(context).viewInsets.bottom*0.08 : 10),
                      child: AppButton(
                        buttonText: 'Start Game',
                        onButtonTap: logic.selectedPlayers.isNotEmpty?(){
                          // Get.toNamed(AppRoutes.gMQuizScreen);

                          if(logic.isFriendsTab){
                            Get.toNamed(AppRoutes.gMQuizScreen,arguments: {'screen':'groupPlay'});
                          }else{
                            showGroupPlayRequestSheet(context);
                          }

                        }:(){},
                        buttonColor:
                        logic.selectedPlayers.isNotEmpty
                            ? AppColors.primaryColor
                            : AppColors.buttonDisableColor,
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: Platform.isIOS ? true : false,
        removeTop: true,
        child: GetBuilder<GroupPlayFriendsCtrl>(builder: (logic) {
          return BottomAppBar(
            elevation: 0,

            color: AppColors.whiteColor,
            child: AppButton(
              buttonText: 'Invite to Game',
              onButtonTap: logic.selectedPlayers.isNotEmpty ? () {
                showLoader(true);
                sendPlayRequestApi(groupGameId: widget.gameData?.id,receiverId: logic.selectedPlayers.join(',')).then((value){
                  showLoader(false);
                  if(value.status==true){
                    // CustomSnackBar().showSnack(Get.context!,isSuccess: true,message: 'Group Play request sent.');
                    Get.off(()=>GroupChallengersScreen(questionsApi: widget.questionsApi,gameData: widget.gameData));
                  }else if(value.status==false){
                    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                  }
                });

                /*showGroupPlayRequestSheet(context,onButtonTap: (){
                    Get.back();
                    showLoader(true);
                    sendPlayRequestApi(groupGameId: widget.gameData?.id,receiverId: logic.selectedPlayers.join(',')).then((value){
                      showLoader(false);
                      if(value.status==true){
                        Get.off(()=>GroupChallengersScreen(questionsApi: widget.questionsApi,gameData: widget.gameData));
                      }else if(value.status==false){
                        CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                      }
                    });


                  });*/
                }
             : () {},
              buttonColor:
              logic.selectedPlayers.isNotEmpty
                  ? AppColors.primaryColor
                  : AppColors.buttonDisableColor,
            ).marginOnly(left: 16, right: 16, bottom: 35),
          );
        }),
      ),
    );
  }
}
