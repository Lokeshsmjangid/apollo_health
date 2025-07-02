import 'dart:io';

import 'package:apollo/bottom_sheets/group_play_request_bottom_sheet.dart';
import 'package:apollo/controllers/group_play_frinds_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupPlayFriendsScreen extends StatefulWidget {
  const GroupPlayFriendsScreen({super.key});

  @override
  State<GroupPlayFriendsScreen> createState() => _GroupPlayFriendsScreenState();
}

class _GroupPlayFriendsScreenState extends State<GroupPlayFriendsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
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
                  backBar(
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
                        buildTabButton("Friends", logic.isFriendsTab, () {
                          // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                          logic.isFriendsTab = true;
                          logic.update();
                        }),
                        buildTabButton(
                            "Global Players", !logic.isFriendsTab, () {
                          // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                          logic.isFriendsTab = false;
                          logic.update();
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Search Bar
                            TextField(
                              decoration: InputDecoration(
                                  hintText: 'Search by name',
                                  prefixIcon: const Icon(
                                      Icons.search, color: Color(0xff67656B)),
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
                                  )

                              ),
                            ),
                            addHeight(24),
                            ...List.generate(growable: true,
                                logic.players.length, (index) {
                                  final player = logic.players[index];
                                  final isSelected = logic.selectedPlayers
                                      .contains(
                                      player['name']);
                                  return GestureDetector(
                                    onTap: () {
                                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                      setState(() {
                                        if (isSelected) {
                                          logic.selectedPlayers.remove(
                                              player['name']);
                                        } else {
                                          logic.selectedPlayers.add(
                                              player['name']);
                                        }
                                      });
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
                                                  AppAssets.flag1Icon,
                                                  height: 20, width: 24,),
                                              ),

                                              if(player['isOnline'])
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
                                          addWidth(12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
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
                                          Checkbox(
                                            // shape: const CircleBorder(),
                                            visualDensity: VisualDensity(
                                                horizontal: -4, vertical: -4),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(4)),
                                            value: isSelected,
                                            side: MaterialStateBorderSide
                                                .resolveWith((states) {
                                              if (!states.contains(
                                                  MaterialState.selected)) {
                                                return BorderSide(
                                                    color: AppColors
                                                        .primaryColor
                                                        .withOpacity(0.8),
                                                    width: 1); // border color when unchecked
                                              }
                                              return null;
                                            }),
                                            onChanged: (val) {
                                              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                              setState(() {
                                                if (val == true) {
                                                  logic.selectedPlayers.add(
                                                      player['name']);
                                                } else {
                                                  logic.selectedPlayers.remove(
                                                      player['name']);
                                                }
                                              });
                                            },
                                            activeColor: AppColors.primaryColor
                                                .withOpacity(0.8),

                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                            /*ListView.builder(
                              itemCount: logic.players.length,
                              itemBuilder: (context, index) {

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        logic.selectedPlayers.remove(player['name']);
                                      } else {
                                        logic.selectedPlayers.add(player['name']);
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 6),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFFFF1C1) : Colors
                                          .transparent,
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
                                              top: 2,
                                              right: 0,
                                              // bottom: 0,
                                              child: CircleAvatar(
                                                radius: 6,
                                                backgroundColor: Colors.green,
                                              ),
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
                                              addText400('${player['hp']}',fontSize: 12),
                                            ],
                                          ),
                                        ),
                                        Checkbox(
                                          // shape: const CircleBorder(),
                                          visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                          value: isSelected,
                                          side: MaterialStateBorderSide.resolveWith((states) {
                                            if (!states.contains(MaterialState.selected)) {
                                              return BorderSide(color: AppColors.primaryColor.withOpacity(0.8), width: 1); // border color when unchecked
                                            }
                                            return null;
                                          }),
                                          onChanged: (val) {
                                            setState(() {
                                              if (val == true) {
                                                logic.selectedPlayers.add(player['name']);
                                              } else {
                                                logic.selectedPlayers.remove(player['name']);
                                              }
                                            });
                                          },
                                          activeColor: AppColors.primaryColor.withOpacity(0.8),

                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),*/
                          ],
                        ).marginOnly(left: 16, right: 16, top: 24),
                      ),
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
                // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                // Get.toNamed(AppRoutes.gMQuizScreen);

                if (logic.isFriendsTab) {
                  Get.offNamed(AppRoutes.groupChallengersScreen);
                } else {
                  showGroupPlayRequestSheet(context);
                }
              } : () {},
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
}
