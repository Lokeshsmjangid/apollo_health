import 'package:apollo/bottom_sheets/winner_takes_all_one_table_bottom_sheet.dart';
import 'package:apollo/controllers/group_play_request_ctrl.dart';
import 'package:apollo/controllers/play_request_ctrl.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MutualFriendScreen extends StatelessWidget {


  MutualFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Purple background
      body: GetBuilder<PlayRequestCtrl>(builder: (logic) {
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
                  // Top Bar
                  backBar(
                    title: "Mutual Friends",
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
                      child: Column(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: addText400(
                                  'Mutual Friends (3)',
                                  fontSize: 20,
                                  height: 22,
                                  fontFamily: 'Caprasimo')),
                          addHeight(8),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: logic.requests.length,
                            padding: EdgeInsets.zero,
                            // padding: const EdgeInsets.symmetric(vertical: 20),
                            itemBuilder: (context, index) {
                              final user = logic.requests[index];
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
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(user['avatar']),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Image.asset(
                                            AppAssets.flag1Icon,
                                            height: 20,
                                            width: 24,
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
                                            user['name'],fontSize: 16,
                                          ),
                                          const SizedBox(height: 2),
                                          addText400(
                                            user['hps'],
                                            fontSize: 12
                                          ),
                                        ],
                                      ),
                                    ),


                                    GestureDetector(
                                      onTap: (){
                                        WinnerTakesAllOnOneTableSheet(context,
                                            onTapLetsGo: (){
                                          // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                        },
                                        onTapPass: (){
                                          // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                        });
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
