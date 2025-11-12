import 'package:apollo/controllers/group_play_frinds_ctrl.dart';
import 'package:apollo/controllers/mutual_friend_ctrl.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class MutualFriendScreen extends StatelessWidget {


  const MutualFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Purple background
      body: GetBuilder<MutualFriendCtrl>(builder: (logic) {
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
                  // Top Bar
                  backBar(
                    title: "Mutual Friends",
                    onTap: () {
                      Get.back();
                    },
                    // isCancel: true
                  ).marginSymmetric(horizontal: 16),
                  const SizedBox(height: 24),
                  // White rounded container
                  Expanded(
                    child:  logic.isDataLoading? buildCpiLoader()
                        : logic.friendModel.data!=null && logic.friendModel.data!.isNotEmpty
                        ? Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: addText400(
                                  'Mutual Friends (${logic.friendModel.data!.length??0})',
                                  fontSize: 20,
                                  height: 22,
                                  fontFamily: 'Caprasimo')),
                          addHeight(8),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: logic.friendModel.data!.length,
                            padding: EdgeInsets.zero,
                            // padding: const EdgeInsets.symmetric(vertical: 20),
                            itemBuilder: (context, index) {
                              final player =logic.friendModel.data![index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 2),
                                padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 12),
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
                                          child: CachedImageCircle2(imageUrl: player.profileImage,isCircular: true),
                                        ),

                                        Positioned(
                                          // top: 2,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 22,height: 15,
                                            decoration: BoxDecoration(
                                              // border: Border.all(color: AppColors.whiteColor,width: 1.5),
                                                borderRadius: BorderRadius.circular(2)

                                            ),
                                            child: ClipRRect(
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              borderRadius: BorderRadius.circular(2),
                                              child: Image.network('${player.countryFlag}',fit: BoxFit.cover),
                                            ),),
                                        ),

                                        if(player.onlineStatusVisible==1)
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
                                          addText600(getTruncatedName(player.firstName??'',player.lastName??""),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16,
                                          ),
                                          addHeight(2),
                                          addText400('${player.xp} HP', fontSize: 12),
                                        ],
                                      ),
                                    ),


                                    GestureDetector(
                                      onTap: (){
                                        Get.find<GroupPlayFriendsCtrl>().isFriendsTab = true;
                                        Get.find<GroupPlayFriendsCtrl>().selectedPlayers.add(player.id!);
                                        Get.find<GroupPlayFriendsCtrl>().update();
                                        if(!logic.catLoading) {
                                          Get.toNamed(AppRoutes.gMGroupPlayScreen,arguments: {'categories': logic.categories??[]})?.then((value){
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: AppColors.primaryColor)
                                        ),
                                        child: Row(
                                          children: [
                                            addText500('Play',fontSize: 16,height: 22)
                                          ],
                                        ),

                                      ),
                                    ),


                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ).marginOnly(left: 16, right: 16, top: 24),
                    )
                        : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/Lottie/Appolo stetoskope.json', width: 200, height: 200),
                            addText500('No connections yet.',color: Colors.white),
                            addHeight(50)
                          ],
                        )),
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
