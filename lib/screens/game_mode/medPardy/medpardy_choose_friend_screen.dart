import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

import 'medpardy_board_screen.dart';

class MedpardyChooseFriendScreen extends StatefulWidget {
  @override
  State<MedpardyChooseFriendScreen> createState() =>
      _MedpardyChooseFriendScreenState();
}

class _MedpardyChooseFriendScreenState
    extends State<MedpardyChooseFriendScreen> {
  final TextEditingController loginUserController = TextEditingController(
      text: 'Madelyn');

  final TextEditingController player2Controller = TextEditingController();

  final TextEditingController player3Controller = TextEditingController();

  bool get isButtonEnabled =>
      player2Controller.text
          .trim()
          .isNotEmpty && player3Controller.text
          .trim()
          .isNotEmpty;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player2Controller.addListener(_onTextChanged);
    player3Controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    player2Controller.removeListener(_onTextChanged);
    player3Controller.removeListener(_onTextChanged);
    player2Controller.dispose();
    player3Controller.dispose();
    loginUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: AppColors.primaryColor,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(
              color: AppColors.primaryColor,
            ),
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
                  // Header with back button and title

                  // addHeight(52),
                  backBar(
                    title: "Medpardy",
                    onTap: () {
                      Get.back();
                    },
                  ).marginSymmetric(horizontal: 16),
                  addHeight(20),

                  // White rounded container
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16)),
                      ),
                      child: LayoutBuilder(
                          builder: (context, constraints)  {
                        return SingleChildScrollView(
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
                              .manual,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Select Players Title
                                  addText400(
                                      "Enter Players ", fontFamily: 'Caprasimo',
                                      fontSize: 32,
                                      height: 40,
                                      color: AppColors.primaryColor),
                                  SizedBox(height: 16),
                                  // Player 1 Box
                                  _playerBox(
                                      color: Color(0xFFFFE3B6),
                                      iconColor: AppColors.brownColor,
                                      playerLabel: "Player 1",
                                      labelColor: AppColors.brownColor,
                                      value: "Logged in user's name",
                                      enabled: false,
                                      controller: loginUserController
                                  ),
                                  SizedBox(height: 12),
                                  // Player 2 Box
                                  _playerBox(
                                    color: Color(0xFFCAEEDD),
                                    iconColor: AppColors.green500Color,
                                    playerLabel: "Player 2",
                                    labelColor: AppColors.green500Color,
                                    controller: player2Controller,
                                  ),
                                  SizedBox(height: 12),
                                  // Player 3 Box
                                  _playerBox(
                                    color: Color(0xFFFFCBF4),
                                    iconColor: AppColors.pink500Color,
                                    playerLabel: "Player 3",
                                    labelColor: AppColors.pink500Color,
                                    controller: player3Controller,
                                  ),
                                  const SizedBox(height: 40),

                                  // addHeight(100)
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  // SizedBox(height: 90),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MediaQuery.removePadding(
          context: context,
          removeBottom: Platform.isIOS ? true : false,
          removeTop: true,
          child: BottomAppBar(
            padding: EdgeInsets.zero,
            color: AppColors.whiteColor,
            child: AppButton(
              buttonColor: isButtonEnabled
                  ? AppColors.primaryColor : AppColors.buttonDisableColor,
              buttonText: 'Start Game',
              onButtonTap: () {
                if (isButtonEnabled) {
                  // Get.toNamed(AppRoutes.medpardyBoardScreen);
                  Get.to(() =>
                      MedpardyBoardScreen(
                    player1: loginUserController.text,
                    player2: player2Controller.text,
                    player3: player3Controller.text,));
                }
              },

            ).marginOnly(
                left: 16, right: 16,
                bottom: 32, top: 7),
          )),
      /*bottomSheet:  Container(
        height: 90,
        decoration: BoxDecoration(color: AppColors.whiteColor),
        width: double.infinity,
        child: AppButton(
          buttonText: 'Start Game',
          onButtonTap: (){
            Get.toNamed(AppRoutes.medpardyBoardScreen);
          },
          buttonColor: AppColors.buttonDisableColor,
        ).marginOnly(left: 16, right: 16, bottom: 24, top: 5),
      )*/
    );
  }

  Widget _playerBox({
    required Color color,
    required Color iconColor,
    required String playerLabel,
    required Color labelColor,
    TextEditingController? controller,
    String? value,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppAssets.starIcon, height: 24, width: 24, color: iconColor,),
              SizedBox(width: 11),
              addText400(
                  playerLabel, fontFamily: 'Caprasimo',
                  fontSize: 20,
                  height: 22,
                  color: labelColor
              ),
            ],
          ),
          SizedBox(height: 12),

          CustomTextField(
              enabled: enabled,
              controller: controller,
              fillColor: AppColors.whiteColor,
              hintText: enabled ? "Enter First Name" : value),

        ],
      ),
    );
  }
}
