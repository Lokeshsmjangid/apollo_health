import 'package:apollo/resources/Apis/api_models/hp_histroy_model.dart';
import 'package:apollo/controllers/hp_history_ctrl.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HpHistoryScreen extends StatefulWidget {
  const HpHistoryScreen({super.key});

  @override
  State<HpHistoryScreen> createState() => _HpHistoryScreenState();
}

class _HpHistoryScreenState extends State<HpHistoryScreen> {

  final hpHistoryCtrl = Get.put(HPHistoryCtrl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8A4CEB),
      extendBodyBehindAppBar: true,
      body: Stack(
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
                  backBar(
                    title: "HP History",
                    trailing: true,
                    onTap: () {
                      Get.back();
                    },
                  ).marginSymmetric(horizontal: 16),
                  addHeight(24),

                  Expanded(child: GetBuilder<HPHistoryCtrl>(builder: (logic) {
                    return Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10)),
                      ),
                      child: Column(
                        children: [

                          const SizedBox(height: 16),

                          Expanded(
                              child: logic.isDataLoading
                                  ? buildCpiLoader()
                                  : logic.model.data!=null && logic.model.data!.isNotEmpty? ListView.builder(
                                itemCount: logic.model.data!.length,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                itemBuilder: (context, index) {
                                  HpHistory history =  logic.model.data![index];


                                  return Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: AppColors.settingTxtColorBG2
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                              14)
                                      ),
                                      child: Row(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  addText600('${history.type}', fontSize: 15),
                                                  addText600('${history.activity}', color: AppColors.blackColor, fontSize: 12),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                addText600(
                                                    history.type =='HP Spent'?'- ${history.xp}':'+ ${history.xp}',
                                                    color:history.type =='HP Spent'? AppColors.redColor1 :
                                                AppColors.greenColor,
                                                    fontSize: 12),
                                                addText400(
                                                    DateFormat('MM/dd/yyyy').format(DateTime.parse(history.createdAt.toString())),
                                                    fontSize: 10)
                                              ],
                                            ),
                                          ])).marginOnly(bottom: 10);
                                },
                              ) : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset('assets/Lottie/Appolo stetoskope.json', width: 200, height: 200),
                                  addText600('No History Found'),
                                ],
                              )
                          ),
                        ],
                      ),
                    );
                  }))
                ],
              ))
        ],
      ),
    );
  }
}
