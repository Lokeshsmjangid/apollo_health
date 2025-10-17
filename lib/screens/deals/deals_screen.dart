import 'dart:io';

import 'package:apollo/controllers/deals_ctrl.dart';
import 'package:apollo/controllers/notification_ctrl.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealsScreen extends StatefulWidget {

  DealsScreen({super.key,});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  // Exit from app
  int time = 0;

  bool back = false;

  int duration = 1000;

  Future<bool> willPop() async{
    int now = DateTime.now().millisecondsSinceEpoch;
    if(back && time >= now){
      back = false;
      exit(0);
    }
    else{
      time =  DateTime.now().millisecondsSinceEpoch+ duration;
      print("again tap");
      back = true;
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Press again the button to exit")));
      showToastBack(context,'Press back again to exit.');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsCtrl>(builder: (logic) {
      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,

          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              addHeight(6),
              addText400(
                "Apollo Deals",
                fontSize: 32,
                height: 0,
                color: AppColors.primaryColor,
                fontFamily: 'Caprasimo',
              ),
              addText400(
                "Discover healthy living—one deal at a time.",
                fontSize: 10,
                height: 0,
                color: AppColors.primaryColor,
                fontFamily: 'Manrope',

              ),
            ],
          ),

        ),
        body: WillPopScope(
          onWillPop: willPop,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage( AppAssets.homeEffectBg,), fit: BoxFit.fill)
            ),
            child: Stack(
              children: [
                // Positioned.fill(
                //   child: SizedBox.expand(
                //     child: Image.asset(
                //       AppAssets.notificationsBg,
                //       fit: BoxFit.fill,
                //       // height: double.maxFinite,
                //       // width: double.maxFinite,
                //       color: AppColors.primaryColor,
                //     ),
                //   ),
                // ),


                GetBuilder<DealsController>(builder: (logic) {
                  return SafeArea(
                    bottom: false,

                    child: Column(
                      children: [
                        // Column(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     addText400(
                        //       "Apollo Deals",
                        //       fontSize: 32,
                        //       height: 40,
                        //       color: AppColors.primaryColor,
                        //       fontFamily: 'Caprasimo',
                        //     ),
                        //     addText400(
                        //       "Discover healthier living—one deal at a time.",
                        //       fontSize: 10,
                        //       color: AppColors.primaryColor,
                        //       fontFamily: 'Manrope',
                        //
                        //     ),
                        //   ],
                        // ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              addHeight(20),
                              ...List.generate(logic.servicesList.length, (index){
                                return GestureDetector(
                                  onTap: (){
                                    if(logic.servicesList[index]['title'].toString().toLowerCase()=="products"){
                                      Get.toNamed(AppRoutes.dealsProductScreen);
                                    }
                                    if(logic.servicesList[index]['title'].toString().toLowerCase()=="services"){
                                      Get.toNamed(AppRoutes.dealsServicesScreen);
                                    }
                                    if(logic.servicesList[index]['title'].toString().toLowerCase()=="experiences"){
                                      Get.toNamed(AppRoutes.dealsExperiencesScreen);
                                    }
                                  },
                                  child: Align(
                                    heightFactor: 0.9,
                                    child: Container(
                                      height: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24,),bottomLeft: Radius.circular(24),bottomRight: Radius.circular(24,)),
                                        color: logic.servicesList[index]['border'],
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: logic.servicesList[index]['color'],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Container(

                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: logic.servicesList[index]['color'],
                                              border: Border.all(color:logic.servicesList[index]['border'],width: 2),
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    logic.servicesList[index]['image'],),
                                                  fit: BoxFit.fitWidth)
                                          ),
                                          child: addText400(
                                              logic.servicesList[index]['title'],color: AppColors.whiteColor,
                                              fontFamily: 'Caprasimo',fontSize: 30,height: 43).marginOnly(left: 12),
                                        ).marginAll(6),
                                      ).marginOnly(top: 8),
                                    ),
                                  ),
                                );
                              })
                            ],
                          ).marginSymmetric(horizontal: 16),
                        ),
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      );
    });
  }
}
