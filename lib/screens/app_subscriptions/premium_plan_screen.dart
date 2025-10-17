import 'dart:io';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/cms_pages/cms_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:apollo/screens/app_subscriptions/subscription_ctrl.dart';

import 'premium_plan_ctrl.dart';

class PremiumPlanScreen extends StatefulWidget {
  const PremiumPlanScreen({super.key});

  @override
  State<PremiumPlanScreen> createState() => _PremiumPlanScreenState();
}

class _PremiumPlanScreenState extends State<PremiumPlanScreen> {
  final planCtrl=Get.find<PremiumPlanCtrl>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async {

       planCtrl.setupPurchaseListener();
      await planCtrl.initStoreInfo();
      // await planCtrl.checkSubscription();
      //
      // planCtrl.restoreSubscription();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PremiumPlanCtrl>(builder: (logic) {
      return Scaffold(
        backgroundColor: AppColors.primaryColor,
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
                    title: "Subscription",
                    trailing: true,
                    onTap: () {
                      Get.back();
                      setState(() {});
                    },
                  ).marginSymmetric(horizontal: 16),
                  addHeight(20),

                  /// White Bottom Container (Your Old Code)
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            /// 🔥 Premium Card Box Added Here
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [AppColors.primaryColor, AppColors.primaryLightColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.amber.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 1)
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title Row
                                  Row(
                                    children: [
                                      addText700("Premium",
                                          fontSize: 20, color: Colors.amber),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orangeAccent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: addText600("AD FREE",
                                            fontSize: 10, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  addHeight(6),

                                  // Plan Options
                                  Row(
                                    children: [
                                      if( AuthData().userModel?.subscriptionDetail==null || AuthData().userModel?.subscriptionDetail?.planId == "monthly_plan")
                                        Expanded(
                                          child: _planTile("1 Month", logic.buttonMonth, "₹165 per month",
                                              logic.selectedPlan == "1m", () {
                                                logic.selectedPlan = "1m";
                                                logic.update();
                                              }),
                                        ),
                                      if( AuthData().userModel?.subscriptionDetail==null || AuthData().userModel?.subscriptionDetail?.planId == "monthly_plan")
                                      addWidth(10),
                                      Expanded(
                                        child: _planTile("12 Months", logic.buttonAnnual, "₹125 per month",
                                            logic.selectedPlan == "1y", () {
                                              logic.selectedPlan = "1y";
                                              logic.update();
                                            }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                            // const SizedBox(height: 48),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Get.to(() => PurchaseHistoryScreen());
                                          },
                                          child: addText400("Features",
                                              fontFamily: 'Caprasimo',
                                              fontSize: 20,
                                              height: 22),
                                        ),
                                        addText500("",
                                            fontSize: 12,
                                            color: Color(0xff67656B)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        addText400("Starter",
                                            fontFamily: 'Caprasimo',
                                            fontSize: 20,
                                            height: 22,
                                            color: AppColors.primaryColor),
                                        addText500("Always Free",
                                            fontSize: 10,
                                            color: Color(0xff67656B)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            addText400("Premium",
                                                fontFamily: 'Caprasimo',
                                                height: 22,
                                                fontSize: 20,
                                                color:
                                                AppColors.primaryColor),
                                            Positioned(
                                              right: -10,
                                              child: Image.asset(
                                                AppAssets.premiumProfileIcon,
                                                height: 11,
                                                width: 11,
                                              ),
                                            )
                                          ],
                                        ),
                                        addText500(
                                            "Paid Plan",
                                            textAlign: TextAlign.center,
                                            fontSize: 11,
                                            color: Color(0xff67656B)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            addHeight(8),
                            const Divider(
                              thickness: 1,
                              color: AppColors.bottomSheetBGColor,
                              height: 0,
                            ).marginSymmetric(horizontal: 16),
                            addHeight(10),

                            SizedBox(
                              height: 340,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: logic.features.length,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                itemBuilder: (context, index) {
                                  final feature = logic.features[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: addText600(feature[0] as String,
                                              fontSize: 13, height: 18,fontFamily: 'Manrope'),
                                        ),
                                        Expanded(
                                            child: _buildFeatureIcon(
                                                feature[1])),
                                        Expanded(
                                            child: _buildFeatureIcon(
                                                feature[2])),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            addHeight(10),

                            Padding(
                              padding:  const EdgeInsets.symmetric(horizontal: 16),
                              child: RichText(
                                text: TextSpan(
                                  text:
                                  "By selecting any of these packages, your payment will be charged to your ${Platform.isIOS?"Apple Store":"Google Play Store"} account and your subscription will automatically renew for the same package length at the same price until you cancel in Settings in the ${Platform.isIOS?"Apple App Store":"Google App Store"}.\n\nBy selecting any of these packages, you also agree to our ",
                                  style: TextStyle(fontFamily: 'Manrope',color: Colors.black, fontSize: 12),

                                  children: [
                                    TextSpan(
                                      text: "Privacy Policy",
                                      recognizer: TapGestureRecognizer()..onTap = () => Get.to(()=>CmsScreen(appBar: 'Privacy Policy',)),
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontFamily: 'Manrope',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    const TextSpan(text: " and ",style: TextStyle(fontFamily: 'Manrope')),
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()..onTap = () => Get.to(()=>CmsScreen(appBar: 'T & C',)),
                                      text: "Terms of Use (EULA).",
                                      style: const TextStyle(
                                        color: Colors.blueAccent,fontFamily: 'Manrope',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            addHeight(45),

                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: logic.selectedPlan.isNotEmpty
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          decoration: BoxDecoration(

            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: Offset(0, -3),
              ),
            ],
          ),

          child: Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  addText600(logic.selectedPlan=='1m'?logic.buttonMonth:logic.selectedPlan=='1y'?logic.buttonAnnual:"Not Selected",fontFamily: 'Manrope'),
                  addText400(logic.selectedPlan=='1m'?'1 Month':logic.selectedPlan=='1y'?'12 Months':"Not Selected",fontFamily: 'Manrope'),
                ],
              )),
              Expanded(
                child: AppButton(
                    buttonText:
                    AuthData().userModel?.subscriptionDetail?.planId == "monthly_plan" && logic.selectedPlan == "1m" ? 'Cancel Subscription' :
                    AuthData().userModel?.subscriptionDetail?.planId == 'yearly_plan'?"Cancel Subscription":'Upgrade',
                  onButtonTap: (){
                      if(AuthData().userModel?.subscriptionDetail==null && logic.selectedPlan == "1m"){
                        // CustomSnackBar().showSnack(context,message: "buy monthly");
                        logic.apiCallDone = false;
                        logic.activePlan.value = 'monthly_plan';
                        logic.update();
                        logic.buySubscription(planId: logic.monthlyId);

                      } else if(AuthData().userModel?.subscriptionDetail==null || AuthData().userModel?.subscriptionDetail?.planId==logic.monthlyId && logic.selectedPlan == "1y"){
                        logic.apiCallDone = false;
                        logic.activePlan.value = 'yearly_plan';
                        logic.update();
                        logic.buySubscription(planId: logic.yearlyId);
                        // CustomSnackBar().showSnack(context,message: "buy Yearly");
                      } else if(
                      Platform.isIOS &&
                          AuthData().userModel?.subscriptionDetail?.planId == "monthly_plan" || AuthData().userModel?.subscriptionDetail?.planId == 'yearly_plan'){
                        logic.cancelSubscription();
                        // CustomSnackBar().showSnack(context,message: "Cancel Monthly",isSuccess: false);
                      }
                  },

                ),
              )
            ],
          ),
        )
            : SizedBox.shrink(),
      );
    });
  }

  Widget _buildFeatureIcon(dynamic value) {
    if (value == true) {
      return Image.asset(AppAssets.starIcon, height: 20);
    } else if (value == false) {
      return Icon(Icons.close, color: AppColors.purpleLightColor);
    } else {
      return Center(
        child: addText600(value.toString(), fontSize: 11, height: 21.12),
      );
    }
  }

  Widget _planTile(String duration, String price, String subtitle,
      bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? Colors.amber : Colors.grey.shade700, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.amber.withOpacity(0.1) : Colors.black,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addText600(duration, fontSize: 14, color: Colors.white),
                  // addText400(subtitle, fontSize: 11, color: Colors.grey),
                  addText700(price, fontSize: 14, color: Colors.white),
                ],
              ),
            ),
            // addText700(price, fontSize: 14, color: Colors.white),
            // const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? Colors.amber : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
