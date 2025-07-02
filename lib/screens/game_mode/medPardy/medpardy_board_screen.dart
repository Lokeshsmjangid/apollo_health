import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/jeo_pardy_border.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:widgets_easier/widgets_easier.dart';

import 'medpardy_second_round_board_screen.dart';

class MedpardyBoardScreen extends StatefulWidget {
  String? player1;
  String? player2;
  String? player3;
  MedpardyBoardScreen({this.player1,this.player2,this.player3});

  @override
  State<MedpardyBoardScreen> createState() => _MedpardyBoardScreenState();
}

class _MedpardyBoardScreenState extends State<MedpardyBoardScreen> {
  // Example player data
  int selectedPlayerIndex = 0;

  final List<Map<String, dynamic>> players = const [
    {
      'name': 'Madelyn',
      'color': Color(0xFFFFF3C4),
      'border': Color(0xFFFFE066),
      'text': AppColors.brownColor,
    },
    {
      'name': 'Player 2',
      'color': Color(0xFFE5F7EF),
      'border': Color(0xFFB9F6CA),
      'text': AppColors.green500Color,
    },
    {
      'name': 'Player 3',
      'color': Color(0xFFF8E6F6),
      'border': Color(0xFFF7C8FF),
      'text': AppColors.pink500Color,
    },
  ];

  // Example categories and points
  final categories = ['Lub Dub Nation', 'Mind Matters', 'Snooze Control'];

  final List<List<int>> points = [
    [100, 200, 300, 400, 500],
    [100, 200, 300, 400, 500],
    [100, 200, 300, 400, 500],
  ];

  List<List<bool>> selected = List.generate(3, (_) => List.generate(5, (_) => false));
  int? selectedRow, selectedCol;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              AppAssets.splashScreenBgImg,fit: BoxFit.cover,
            ),
          ),
          // Main content
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar with back arrow and title
                // addHeight(52),
                backBar(
                  title: "Medpardy",
                  onTap: () {
                    Get.back();
                  },
                ).marginSymmetric(horizontal: 16),
                addHeight(32),
                // Players row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(players.length, (i) {
                    final p = players[i];
                    final isSelected = i == selectedPlayerIndex;

                    return GestureDetector(
                      onTap: (){
                        setState(() {
                        selectedPlayerIndex = i;});
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 106,
                          minWidth: 106
                        ),
                        margin: EdgeInsets.symmetric(horizontal: i == 1 ? 12 : 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: p['color'] as Color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Color(0xFFFFE066) : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: isSelected
                              ? [ BoxShadow(
                              color: Color(0xFFFFE066).withOpacity(0.8),
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: const Offset(0, 2),
                            )]
                              : [],
                        ),
                        child: Column(
                          children: [
                            addText400(i==2?"${widget.player3}":i==1?"${widget.player2}":'${widget.player1}',
                                // p['name'] as String,
                                fontFamily: 'Caprasimo', color: p['text'] as Color, fontSize: 18,maxLines: 1,overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            addText600("0 HP", color: AppColors.blackColor, fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 34),
                // First Round heading
                addText400(
                  "First Round",
                    fontFamily: 'Caprasimo',
                    fontSize: 32,
                    height: 40,
                    color: Colors.white,

                ).marginSymmetric(horizontal: 16),
                SizedBox(height: 16),
                // Game board
                DecoratedJeopardyContainer(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10,left: 2,right: 2),
                    child: Column(
                      children: [
                        // Header Row
                        Row(
                          children: categories.map((title) {
                            return Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: addText400(
                                  title,
                                  textAlign: TextAlign.center,
                                  fontSize: 16,
                                  height: 20,
                                  color: AppColors.whiteColor,
                                  fontFamily: 'Caprasimo',
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        addHeight(12),
                        // Grid of points
                        SizedBox(
                          height: 296,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.94,
                            ),
                            itemCount: 15,
                            itemBuilder: (context, index) {
                              int col = index % 3;
                              int row = index ~/ 3;

                              bool isSelected = selectedCol == col && selectedRow == row;
                              bool isDisabled = selected[col][row] && !isSelected;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedRow = row;
                                    selectedCol = col;
                                    selected[col][row] = true;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF253EA8),
                                          const Color(0xFF4A60B8),
                                          const Color(0xFF253EA8),
                                          //
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        tileMode: TileMode.clamp),
                                    color: Colors.blue.shade700,
                                    // border: isSelected lokesh
                                    //     ? Border.all(color: Colors.purpleAccent, width: 3)
                                    //     : null,
                                  ),
                                  child: Center(
                                    child: addText400(
                                      '${points[col][row]}', fontSize: 20,
                                        color:
                                        isDisabled
                                            ? AppColors.buttonDisableColor :
                                        AppColors.yellowColor, fontFamily: 'Caprasimo',
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ).marginAll(16),
                // Play button
                // addHeight(40),

              ],
            ),
          ),

        ],
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: Platform.isIOS ? true : false,
        removeTop: true,
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: AppButton(
            onButtonTap: (){
              Get.offNamed(AppRoutes.quizMedpardyScreen, arguments: {'round': 1,'fromPlayer':players[selectedPlayerIndex]['name']});

            },
            buttonText: 'Play',
            buttonTxtColor: AppColors.primaryColor,buttonColor: AppColors.whiteColor,),
        ).marginOnly(left: 16,right: 16,bottom: 35),
      ),
    );
  }
}
