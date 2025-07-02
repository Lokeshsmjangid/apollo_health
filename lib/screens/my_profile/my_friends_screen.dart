import 'package:apollo/bottom_sheets/group_play_request_bottom_sheet.dart';
import 'package:apollo/controllers/group_play_frinds_ctrl.dart';
import 'package:apollo/controllers/my_frinds_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/game_mode/group_play/group_play_friends_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MyFriendsScreen extends StatefulWidget {
  const MyFriendsScreen({super.key});

  @override
  State<MyFriendsScreen> createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: GetBuilder<MyFriendsCtrl>(builder: (logic) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppAssets.notificationsBg,
                fit: BoxFit.fill,
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [

                  backBar(
                      title: "Friend Circle",
                      onTap: () {
                        Get.back();
                      },
                      isMail: true,
                      onTapMail: () {
                        Get.toNamed(AppRoutes.playRequestScreen);
                      }).marginSymmetric(horizontal: 16),

                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        buildTabButton("My Friends", logic.isMyFriendsTab, () {
                          // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                          logic.isMyFriendsTab = true;
                          logic.update();
                        }),
                        buildTabButton("Find Players", !logic.isMyFriendsTab, () {
                          // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                          logic.isMyFriendsTab = false;
                          logic.update();
                        }),
                      ],
                    ),
                  ).marginSymmetric(horizontal: 15),
                  const SizedBox(height: 24),

                  // Players List
                  logic.players.isEmpty
                      ? Column(
                    children: [
                      Lottie.asset('assets/Lottie/Appolo dance.json',
                          repeat: true,
                          reverse: false,
                          animate: true,
                          width: 308,
                          height: 322
                      ),
                      addText700('Your crew’s missing!', fontSize: 26,
                          color: AppColors.whiteColor),
                      addText500('Add friends and let the healthy fun begin.',
                          fontSize: 16, color: AppColors.whiteColor),
                      // Your crew’s missing!
                      // Add friends and let the healthy fun begin.
                    ],
                  )
                      : Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16)),
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [

                          // Search Bar
                          TextField(
                            autocorrect: false,
                            onChanged: (val){},
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
                          addHeight(24),

                          if(logic.isMyFriendsTab)
                          Align(
                              alignment: Alignment.centerLeft,
                              child: addText400(
                                  'All Friends (25)',
                                  fontSize: 20,
                                  height: 22,
                                  fontFamily: 'Caprasimo')),
                          if(logic.isMyFriendsTab)
                          addHeight(8),

                          ...List.generate(
                              growable: true,
                              logic.players.length, (index) {
                            final player = logic.players[index];
                            final isSelected = logic.selectedPlayers.contains(player['name']);
                            return GestureDetector(
                              onTap: () {
                                // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                Get.toNamed(AppRoutes.otherProfileScreen);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 14),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.yellow10Color
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                              player['avatar']),
                                        ),

                                        Positioned(
                                          // top: 2,
                                          right: 0,
                                          bottom: 0,
                                          child: Image.asset(
                                            AppAssets.flag1Icon, height: 20,
                                            width: 24,),
                                        ),
                                      ],
                                    ),
                                    addWidth(12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          addText600(
                                            player['name'],
                                            fontSize: 16,
                                          ),
                                          addHeight(2),
                                          addText400('${player['hp']}',
                                              fontSize: 12),
                                        ],
                                      ),
                                    ),
                                    buildAddPlayButton(isMyFriendsTab: logic.isMyFriendsTab,isRequested: player['requested'],onTap: (){
                                      if(logic.isMyFriendsTab){
                                        Get.to(()=>GroupPlayFriendsScreen());
                                      }
                                    }),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ).marginOnly(left: 16, right: 16, top: 24),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: GetBuilder<MyFriendsCtrl>(builder: (logic) {
        return logic.players.isEmpty?AppButton(
          buttonText: 'Invite a Friend',
          buttonTxtColor: AppColors.primaryColor,
          buttonColor: AppColors.whiteColor,).marginSymmetric(horizontal: 16, vertical: 20): SizedBox.shrink();
      }),
    );
  }

  Widget buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: addText600(
            text,
            fontSize: 16,
            height: 22,
            // color: isSelected ? Colors.black : Colors.grey,
            color: AppColors.blackColor,
          ),
        ),
      ),

    );
  }

  buildAddPlayButton({VoidCallback? onTap, bool isMyFriendsTab = true,bool isRequested = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isMyFriendsTab==false && isRequested==true?AppColors.primaryColor:null,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primaryColor)
        ),
        child: addText500(isMyFriendsTab ? 'Play' : isMyFriendsTab==false && isRequested==true?'Requested':'Add',
        color: isMyFriendsTab==false && isRequested==true?AppColors.whiteColor:null,),
      ),
    );
  }
}