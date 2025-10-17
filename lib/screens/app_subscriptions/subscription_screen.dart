// import 'dart:io';
//
// import 'package:apollo/custom_widgets/app_button.dart';
// import 'package:apollo/custom_widgets/custom_snakebar.dart';
// import 'package:apollo/resources/app_assets.dart';
// import 'package:apollo/resources/app_color.dart';
// import 'package:apollo/resources/auth_data.dart';
// import 'package:apollo/resources/text_utility.dart';
// import 'package:apollo/resources/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:apollo/screens/app_subscriptions/subscription_ctrl.dart';
//
// import 'subscription_detail_screen.dart';
//
// class SubscriptionScreen extends StatefulWidget {
//   const SubscriptionScreen({super.key});
//
//   @override
//   State<SubscriptionScreen> createState() => _SubscriptionScreenState();
// }
//
// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // Get.find<SubscriptionCtrl>().onInit();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SubscriptionCtrl>(builder: (logic) {
//       return Scaffold(
//         backgroundColor: AppColors.primaryColor,
//         body: Stack(
//           children: [
//             Positioned.fill(
//               child: Image.asset(
//                 AppAssets.notificationsBg,
//                 fit: BoxFit.cover,
//               ),
//             ),
//
//             SafeArea(
//                 bottom: false,
//                 child: Column(
//                     children: [
//                       addHeight(10),
//
//                       backBar(
//                         title: "Subscription",
//                         trailing: true,
//                         onTap: () {
//                           Get.back();
//                         },
//                       ).marginSymmetric(horizontal: 16),
//                       addHeight(44),
//                       Expanded(
//                           child: Stack(
//                               clipBehavior: Clip.none,
//                               alignment: Alignment.center,
//                               children: [
//                                 Container(
//                                   decoration: const BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.vertical(
//                                         top: Radius.circular(10)),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       // Add your asset here
//                                       const SizedBox(height: 48),
//                                       Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 16),
//                                         child: Row(
//                                           children: [
//                                             Expanded(child: Column(
//                                                 children: [
//                                                   GestureDetector(
//                                                     onTap:(){
//                                                       // Get.to(() => PurchaseHistoryScreen());
//                                                     },
//                                                     child: addText400("Features",
//                                                         fontFamily: 'Caprasimo',
//                                                         fontSize: 20,
//                                                         height: 22),
//                                                   ),
//                                                   addText500("", fontSize: 12,
//                                                       color: Color(0xff67656B)),
//                                                 ],
//                                               )),
//                                             Expanded(child: Column(children: [
//                                                   addText400("Starter",
//                                                       fontFamily: 'Caprasimo',
//                                                       fontSize: 20, height: 22, color: AppColors.primaryColor),
//                                                   addText500("Always Free", fontSize: 10, color: Color(0xff67656B)),
//                                                 ])),
//                                             Expanded(child: Column(
//                                                 children: [
//                                                   Stack(
//                                                     clipBehavior: Clip.none,
//                                                     children: [
//                                                       addText400("Premium",
//                                                           fontFamily: 'Caprasimo',
//                                                           height: 22, fontSize: 20,
//                                                           color: AppColors.primaryColor),
//                                                       Positioned(
//                                                           right: -10,
//                                                           child: Image.asset(
//                                                         AppAssets.premiumProfileIcon, height: 11,width: 11))
//                                                     ],
//                                                   ),
//                                                   addText500("${logic.buttonMonth}/mo",
//                                                       textAlign: TextAlign.center, fontSize: 11,
//                                                       color: Color(0xff67656B)),
//                                                 ],
//                                               )),
//                                           ],
//                                         ),
//                                       ),
//
//                                       addHeight(8),
//                                       const Divider(
//                                           thickness: 1, color: AppColors.bottomSheetBGColor,
//                                           height: 0).marginSymmetric(horizontal: 16),
//
//                                       addHeight(10),
//                                       Expanded(
//                                         child: ListView.builder(
//                                           itemCount: logic.features.length,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 16),
//                                           itemBuilder: (context, index) {
//                                             final feature = logic.features[index];
//                                             return Padding(
//                                               padding: const EdgeInsets
//                                                   .symmetric(vertical: 10),
//                                               child: Row(
//                                                 children: [
//                                                   Expanded(child: addText400(
//                                                       feature[0] as String,
//                                                       fontSize: 13,
//                                                       height: 18)),
//                                                   Expanded(
//                                                       child: _buildFeatureIcon(
//                                                           feature[1])),
//                                                   Expanded(
//                                                       child: _buildFeatureIcon(
//                                                           feature[2])),
//                                                 ],
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                       // AppButton(
//                                       //   buttonText: 'Start Free 7-Day Trial',
//                                       // onButtonTap: (){},
//                                       //
//                                       //
//                                       // ).marginSymmetric(horizontal: 16),
//                                       // addHeight(36),
//                                     ],
//                                   ),
//                                 ),
//
//                                 Positioned(
//                                   top: -50,
//                                   child: Stack(
//                                     clipBehavior: Clip.none,
//                                     alignment: Alignment.center,
//                                     children: [
//                                       Lottie.asset(
//                                           'assets/Lottie/Appolo strength.json',
//                                           repeat: true,
//                                           reverse: false,
//                                           animate: true,
//                                           width: 100,
//                                           height: 100
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ]))
//                     ]))
//           ],
//         ),
//         bottomNavigationBar: logic.products.isNotEmpty?MediaQuery.removePadding(
//           removeTop: true,
//           context: context,
//           removeBottom: Platform.isIOS ? true : false,
//           child: BottomAppBar(
//             child: Row(
//               children: [
//                 if( AuthData().userModel?.subscriptionDetail==null || AuthData().userModel?.subscriptionDetail?.planId == "monthly_plan")
//                 Expanded(
//                   child: AppButton(
//                     buttonColor: logic.loadingMplan ?AppColors.apolloGreyColor:null,
//                     buttonText:
//                     AuthData().userModel?.subscriptionDetail?.planId == "monthly_plan"
//                         ? 'Cancel Monthly'
//                         : 'Start Monthly\n${logic.buttonMonth}',
//                     onButtonTap:
//                         (){
//                       if(Platform.isIOS && AuthData().userModel?.subscriptionDetail?.planId == "monthly_plan"){
//                         logic.cancelSubscription();
//                       }else{
//                         logic.apiCallDone = false;
//                         logic.activePlan.value = 'monthly_plan';
//                         logic.update();
//                         logic.buySubscription(planId: logic.monthlyId);
//                       }
//                         }),
//                 ),
//                 if( AuthData().userModel?.subscriptionDetail==null || AuthData().userModel?.subscriptionDetail?.planId == "monthly_plan")
//                 addWidth(10),
//                 Expanded(
//                   child: AppButton(
//                     buttonColor: logic.loadingYplan?AppColors.apolloGreyColor:null,
//                     buttonText: AuthData().userModel?.subscriptionDetail?.planId == 'yearly_plan'
//                         ? 'Cancel'
//                         : 'Go Annual\n ${logic.buttonAnnual}', //: 'Go Annual\n\$19.99',
//                     onButtonTap: (){
//                       if(Platform.isIOS && AuthData().userModel?.subscriptionDetail?.planId == 'yearly_plan'){
//                         logic.cancelSubscription();
//                       } else{
//                         logic.apiCallDone = false;
//                         logic.activePlan.value = 'yearly_plan';
//                         logic.update();
//                         logic.buySubscription(planId: logic.yearlyId);
//                       }
//                     },
//                       ),
//                 )
//               ]).marginOnly(left: 12, right: 12, bottom: 32),
//           )):SizedBox.shrink());
//     });
//   }
//
//   Widget _buildFeatureIcon(dynamic value) {
//     if (value == true) {
//       return Image.asset(AppAssets.starIcon, height: 20,);
//     } else if (value == false) {
//       return Icon(Icons.close, color: AppColors.purpleLightColor);
//     } else {
//       return Center(
//           child: addText600(value.toString(), fontSize: 11, height: 21.12));
//     }
//   }
// }
