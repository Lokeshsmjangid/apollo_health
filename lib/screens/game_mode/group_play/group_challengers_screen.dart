import 'dart:async';

import 'package:apollo/bottom_sheets/winner_takes_all_one_table_bottom_sheet.dart';
import 'package:apollo/controllers/group_challengers_ctrl.dart';
import 'package:apollo/controllers/group_play_request_ctrl.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupChallengersScreen extends StatefulWidget {


  GroupChallengersScreen({super.key});

  @override
  State<GroupChallengersScreen> createState() => _GroupChallengersScreenState();
}

class _GroupChallengersScreenState extends State<GroupChallengersScreen> {


  int seconds = 5; // initial countdown value
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
        if(seconds==0){
          // Get.offNamed(AppRoutes.gMQuizScreen, arguments: {'screen': 'groupPlay'});
          Get.offNamed(AppRoutes.quizScreenNew, arguments: {'screen': 'groupPlay'});
        }
        // Optionally trigger game start here
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
    return Scaffold(
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
                  // addHeight(52),
                  // Top Bar
                  backBar(
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
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                        itemCount: logic.requests.length + 1, // +1 for the bottom text
                        itemBuilder: (context, index) {
                          if (index < logic.requests.length) {
                            final user = logic.requests[index];
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
                                        addText600(user['name'], fontSize: 16),
                                        const SizedBox(height: 2),
                                        addText400(user['hp'], fontSize: 12, color: AppColors.blackColor),
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
                                        color: user['isAccepted'] == true ? AppColors.primaryColor : null,
                                      ),
                                      child: addText500(
                                        user['isAccepted'] == true?'Accepted':'Pending',
                                        fontSize: 16,
                                        height: 22,
                                        color: user['isAccepted'] == true ? AppColors.whiteColor : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Last item: your text
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: gameStartBox(
                                  hug1: 195,
                                  hug2: 36,
                                  seconds: seconds,
                                ),
                              ),
                            );
                          }
                        },
                      ),
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

  Widget gameStartBox({
    required int hug1,
    required int hug2,
    required int seconds,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: addText700(
              'Game Starts in:',
              fontSize: 26
            ),
          ),
          const SizedBox(height: 12),

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
          ),
        ],
      ),
    );
  }
}
