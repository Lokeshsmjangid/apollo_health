import 'package:animated_item/animated_item.dart';
import 'package:apollo/bottom_sheets/clear_all_notifications_bottom_sheet.dart';
import 'package:apollo/controllers/notification_ctrl.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/models/notifications_model.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import 'resources/Apis/api_models/notification_model.dart';
import 'resources/Apis/api_repository/notification_delete_repo.dart';
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
          leading: backButton(backButtonColor: AppColors.whiteColor,
              onTap: (){ Get.back();}).marginAll(10),

          title: addText400(
            "Notifications",
            fontSize: 32,
            height: 40,
            color: AppColors.whiteColor,
            fontFamily: 'Caprasimo',

          ),
          actions: [
            if(logic.model.data!=null && logic.model.data!.isNotEmpty)
            IconButton(
                tooltip: 'Clear all Notifications',
                onPressed: () {
                  showClearAllNotificationsSheet(context, () {
                    Get.back();
                    if(Get.find<NotificationsCtrl>().model.data!=null && Get.find<NotificationsCtrl>().model.data!.isNotEmpty){
                      showLoader(true);
                      notificationRemoveApi(apiFor: 'clear').then((value){
                        showLoader(false);
                        if(value.status==true){
                          Get.find<NotificationsCtrl>().model.data!.clear();
                          Get.find<NotificationsCtrl>().update();
                        }
                      });
                    }
                  });
                }, icon: SvgPicture.asset(AppAssets.binIcon,height: 30,width: 30,))
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

                      Expanded(
                          child: logic.isDataLoading
                          ? buildCpiLoader()
                          : logic.model.data!=null && logic.model.data!.isNotEmpty? ListView.builder(
                        controller: logic.scaleController,
                        scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        itemCount: logic.model.data!.length,
                        itemBuilder: (context, index) {

                          return AnimatedItem(
                              controller: logic.scaleController,
                              index: index,
                              effect: ScaleEffect(
                                snap: false,
                                type: AnimationType.end,
                              ),
                              child: buildNotificationTileApi(index: index,
                                  item: logic.model.data![index]).marginOnly(
                                  top: index == 0 ? 32 : 0)
                          );
                        },
                      )
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
                  ))

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
        image = AppAssets.checkCircleGreenIcon;
        // item.message.contains('alert') ? AppAssets.warningCircleIcon : AppAssets.checkCircleGreenIcon;
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
          case 'Friend Request Accepted':
            Get.toNamed(AppRoutes.myFriendsScreen);
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

  Widget buildNotificationTileApi({required int index, required NotificationData item}) {
    String? image;
    Color iconColor;
    // Color bgColor = item.isHighlighted ? AppColors.yellow10Color : AppColors.whiteColor;
    Color bgColor = item.title=="Group Play Invite" || item.title=="Friend Request" || item.title=="Friend Request Accepted" ? AppColors.yellow10Color : AppColors.whiteColor;

    switch (item.title) {
      case 'Group Play Invite':
        image = AppAssets.friendsIcon;
        break;
      case 'Friend Request':
        image = AppAssets.userAddIcon;
        break;
      case 'Friend Request Accepted':
        image = AppAssets.userAddIcon;
        break;
      case 'Promotion':
        image = AppAssets.tagIcon;
        break;
      case 'System':
        image = AppAssets.checkCircleGreenIcon;
        // image = item.description!.contains('alert') ? AppAssets.warningCircleIcon : AppAssets.checkCircleGreenIcon;
        break;
    }

    return GestureDetector(
      onTap: () {
        switch (item.title) {
          case 'Group Play Invite':
            Get.toNamed(AppRoutes.groupPlayRequestScreen,arguments: {'group_game_id':item.groupGameId,'sender_id':item.senderId});
            break;
          case 'Friend Request Accepted':
            Get.toNamed(AppRoutes.myFriendsScreen);
            break;
          case 'Friend Request':
            Get.toNamed(AppRoutes.playRequestScreen,arguments: {'group_game_id':item.groupGameId});
            // Get.toNamed(AppRoutes.groupPlayRequestScreen,arguments: {'group_game_id':item.groupGameId,'sender_id':item.senderId});
            break;
        }
      },
      child: Slidable(
        key: ValueKey(item.title), // Unique ID

        endActionPane: ActionPane(
          motion: const DrawerMotion(), // Slide animation
          extentRatio: 0.25, // Width of action area
          children: [
            SlidableAction(
              onPressed: (context) {

                showLoader(true);
                notificationRemoveApi(                 // Handle delete
                    apiFor: 'delete',
                    id: item.notificationId
                ).then((value){ showLoader(false);
                  if(value.status==true){
                    Get.find<NotificationsCtrl>().model.data!.removeAt(index);
                    Get.find<NotificationsCtrl>().update();
                  } else if(value.status==false){
                    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                  }
                });
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.zero,

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
            children: [
              Image.asset('$image', width: 30,color: item.title=='Group Play Invite'? AppColors.primaryColor: null,),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    addText600('${item.title}', fontSize: 16, maxLines: 2,overflow: TextOverflow.ellipsis,color: AppColors.blackColor),
                    const SizedBox(height: 4),
                    addText400('${item.description}', fontSize: 12, maxLines: 2,overflow:TextOverflow.ellipsis,color: AppColors.blackColor),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              addText400('${item.sentTime}',fontSize: 8)]))).marginOnly(bottom: 12),
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
}
