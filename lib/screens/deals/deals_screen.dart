import 'package:animated_item/animated_item.dart';
import 'package:apollo/bottom_sheets/clear_all_notifications_bottom_sheet.dart';
import 'package:apollo/controllers/deals_ctrl.dart';
import 'package:apollo/controllers/notification_ctrl.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/models/notifications_model.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class DealsScreen extends StatelessWidget {

  const DealsScreen({Key? key,}) : super(key: key);

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
              addText400(
                "Apollo Deals",
                fontSize: 38,
                // height: 40,
                color: AppColors.primaryColor,
                fontFamily: 'Caprasimo',
              ),
              addText400(
                "Discover healthier living—one deal at a time.",
                fontSize: 10,
                color: AppColors.primaryColor,
                fontFamily: 'Manrope',

              ),
            ],
          ),

        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.disclaimerBg),
                  fit: BoxFit.cover,opacity: 0.5)
          ),
          child: Stack(
            children: [
              // Positioned.fill(
              //   child: Image.asset(
              //     AppAssets.notificationsBg,
              //     fit: BoxFit.cover,
              //   ),
              // ),

              GetBuilder<DealsController>(builder: (logic) {
                return SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        addHeight(24),
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
                                      image: DecorationImage(image: AssetImage(logic.servicesList[index]['image']),fit: BoxFit.fitWidth,)
                                    ),
                                    child: addText400(logic.servicesList[index]['title'],color: AppColors.whiteColor,fontFamily: 'Caprasimo',fontSize: 30,height: 43).marginOnly(left: 12),
                                  ).marginAll(6),
                                ).marginOnly(top: 8),
                              ),
                            ),
                          );
                        })
                      ],
                    ).marginSymmetric(horizontal: 16),
                  ),
                );
              })
            ],
          ),
        ),
      );
    });
  }

}
