import 'package:animated_item/animated_item.dart';
import 'package:apollo/bottom_sheets/clear_all_notifications_bottom_sheet.dart';
import 'package:apollo/controllers/notification_ctrl.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/models/notifications_model.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import 'resources/app_routers.dart';
import 'resources/text_utility.dart';

class NotificationsPage extends StatelessWidget {

  const NotificationsPage({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsCtrl>(builder: (logic) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,

          title: addText400(
            "Notifications",
            fontSize: 32,
            height: 40,
            color: AppColors.whiteColor,
            fontFamily: 'Caprasimo',

          ),
          actions: [
            if(logic.notifications.isNotEmpty)
            IconButton(
                tooltip: 'Clear all Notifications',
                onPressed: () {
                  showClearAllNotificationsSheet(context, () {
                    
                    // Get.find<NotificationsCtrl>().effectSound(sound: AppAssets.actionButtonTapSound);
                    Get.back();
                    Get.find<NotificationsCtrl>().notifications.clear();
                    Get.find<NotificationsCtrl>().update();
                  });
                }, icon: Icon(Icons.cancel_outlined))
          ],

        ),
        backgroundColor: AppColors.primaryColor,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.notificationsBg),
                  fit: BoxFit.cover)
          ),
          child: Stack(
            children: [
              // Positioned.fill(
              //   child: Image.asset(
              //     AppAssets.notificationsBg,
              //     fit: BoxFit.cover,
              //   ),
              // ),

              GetBuilder<NotificationsCtrl>(builder: (logic) {
                return SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // const SizedBox(height: 52),

                      // Top Bar
                      // backBar(
                      //   title: "Notifications",
                      //   onTap: () {
                      //     Get.back();
                      //   },
                      // ).marginSymmetric(horizontal: 16),
                      // addHeight(32),

                      logic.notifications.isNotEmpty
                          ? Expanded(child: logic.isDataLoading
                          ? buildLoader()
                          : ListView.builder(
                        controller: logic.scaleController,
                        scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        itemCount: logic.notifications.length,
                        itemBuilder: (context, index) {

                          return AnimatedItem(
                              controller: logic.scaleController,
                              index: index,
                              effect: ScaleEffect(
                                snap: false,
                                type: AnimationType.end,
                              ),
                              child: buildNotificationTile(index: index,
                                  item: logic.notifications[index]).marginOnly(
                                  top: index == 0 ? 32 : 0)
                          );
                        },
                      ))
                          : Column(
                        children: [
                          Lottie.asset(
                              'assets/Lottie/Appolo dance.json',
                              repeat: true,
                              reverse: false,
                              animate: true,
                              width: 240,
                              height: 240
                          ).marginOnly(top: 30),
                          addText500('You don\'t have any notifications.',
                              textAlign: TextAlign.center,
                              color: AppColors.whiteColor, fontSize: 20)
                              .marginSymmetric(horizontal: 60),
                        ],
                      )
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      );
    });
  }




  Widget buildNotificationTile(
      {required int index, required NotificationItem item}) {
    String image;
    // Color iconColor;
    Color bgColor = item.isHighlighted ? AppColors.yellow10Color : AppColors.whiteColor;

    switch (item.type) {
      case NotificationType.groupPlayInvite:
        image = AppAssets.databaseIcon;
        break;
      case NotificationType.friendRequest:
        image = AppAssets.userAddIcon;
        break;
      case NotificationType.promotion:
        image = AppAssets.tagIcon;
        break;
      case NotificationType.system:
        image =
        item.message.contains('alert') ? AppAssets.warningCircleIcon : AppAssets
            .checkCircleGreenIcon;
        break;
    }

    return GestureDetector(
      onTap: () {
        switch (item.title) {
          case 'Group Play Invite':
            Get.toNamed(AppRoutes.gMGroupPlayScreen);
            break;
          case 'Friend Request':
            Get.toNamed(AppRoutes.playRequestScreen);

            break;
        }
      },
      child: Slidable(
        key: ValueKey(item.title), // Unique ID
        endActionPane: ActionPane(
          motion: const DrawerMotion(), // Slide animation
          extentRatio: 0.28, // Width of action area
          children: [
            SlidableAction(
              onPressed: (context) {
                // Handle delete
                
                // Get.find<NotificationsCtrl>().effectSound(sound: AppAssets.actionButtonTapSound);
                Get.find<NotificationsCtrl>().notifications.removeAt(index);
                Get.find<NotificationsCtrl>().update();
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              // icon: Icons.delete,
              label: 'Delete',
            ),

          ],
        ),
        child: Container(
          // height: 100,
          margin: const EdgeInsets.only(left: 16, right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(image, width: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addText600(
                        item.title, fontSize: 16, color: AppColors.blackColor),
                    const SizedBox(height: 4),
                    addText400(item.message, fontSize: 12,
                        color: AppColors.blackColor),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              addText400(item.createdAt,fontSize: 8),


            ],
          ),
        ),
      ).marginOnly(bottom: 12),
    );
  }


  buildShimmerLoader(){
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context,index){
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
              decoration: BoxDecoration(
            color: AppColors.whiteColor.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
          ),
              child: Row(
            children: [
              // Image shimmer (rounded)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // Text shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title shimmer (rounded)
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Message shimmer (rounded)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Date shimmer (rounded)
              Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        )
          ).marginOnly(top:index == 0 ? 32 : 0,bottom: 14);
    });
  }

  buildLoader(){
    return Center(
      child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle
                ),
                child: ClipRRect(child: SvgPicture.asset(AppAssets.logo).marginAll(6))),
            Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  // color: AppColors.primaryColor,
                  // borderRadius: BorderRadius.circular(4.0),
                  shape: BoxShape.circle,
                  // image: DecorationImage(image: AssetImage(AppAssets.commonLogo)),
                ),
                child: CircularProgressIndicator(color: AppColors.secondaryColor,strokeWidth: 4,).marginAll(1))
          ]
      ),
    );
  }

}
