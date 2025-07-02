import 'dart:io';

import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/models/deals_model.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/level_up_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DealsServicesScreen extends StatefulWidget {
  const DealsServicesScreen({super.key});

  @override
  State<DealsServicesScreen> createState() => _DealsServicesScreenState();
}

class _DealsServicesScreenState extends State<DealsServicesScreen> {


  final List<DealsModel> servicesList = [
    DealsModel(
      imageUrl: AppAssets.ds1,
      tag: 'Online Classes',
      title: 'Get 20% off Core Yoga classes',
      description: 'Flow through movement and find calm right at home.',
      expiry: 'Expires in 16 days',
    ),
    DealsModel(
      imageUrl: AppAssets.ds2,
      tag: 'ONLINE THERAPY',
      title: 'Get 15% off Guided Meditation App',
      description: 'Clear your mind and reset your energy anytime.',
      expiry: 'Expires in 29 days',
    ),
    DealsModel(
      imageUrl: AppAssets.ds3,
      tag: 'ONLINE THERAPY',
      title: 'Save 10% on Mental Health Counseling',
      description: 'Speak with a pro and start feeling better.',
      expiry: 'Expires in 86 days',
    ),
    DealsModel(
      imageUrl: AppAssets.ds4,
      tag: 'COACHING',
      title: '10% off Personalized Nutrition Coaching',
      description: 'Eat in a way that fuels your lifestyle.',
      expiry: 'Expires in 2 days',
    ),
    DealsModel(
      imageUrl: AppAssets.ds5,
      tag: 'COACHING',
      title: '15% off Sleep Coaching Sessions',
      description: 'Tired of tossing and turning? Let’s fix your sleep!',
      expiry: 'Expires in 55 days',
    ),
    DealsModel(
      imageUrl: AppAssets.ds6,
      tag: 'COACHING',
      title: '\$10 off Telemedicine Consults',
      description: 'See a doctor from your couch — no waiting rooms',
      expiry: 'Expires in 6 days',
    ),
    DealsModel(
      imageUrl: AppAssets.ds7,
      tag: 'OFFLINE THERAPY',
      title: 'Get 10% on Local Massage Therapy Deals',
      description: 'Ease muscle pain after a long week.',
      expiry: 'Expires in 32 days',
    ),
    DealsModel(
      imageUrl: AppAssets.ds8,
      tag: 'VIRTUAL WELLNESS',
      title: 'Free trial for Fitness App Premium',
      description: 'Track your workouts and stay on top of progress',
      expiry: 'Expires in 23 days',
    ),
    DealsModel(
      imageUrl: AppAssets.ds9,
      tag: 'VIRTUAL WELLNESS',
      title: 'Start Online Habit Coaching for \$1',
      description: 'Break bad habits and build better routines that stick',
      expiry: 'Expires in 7 days',
    ),
    DealsModel(
      imageUrl:  AppAssets.ds10,
      tag: 'ALLERGY/ HORMONE',
      title: 'Lab Test Discounts',
      description: 'Boost energy. Support immunity. Enjoy daily wellness in one tasty gummy.',
      expiry: 'Expires in 26 days',
    ),
    DealsModel(
      imageUrl: AppAssets.ds11,
      tag: 'COACHING',
      title: 'Career & Burnout Coaching',
      description: 'Boost energy. Support immunity. Enjoy daily wellness in one tasty gummy.',
      expiry: 'Expires in 16 days',
    ),
  ];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFF4C9BF4),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: SvgPicture.asset(
              AppAssets.dealsServiceBGEffect,
              fit: BoxFit.fitWidth,
              width: 390,
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // addHeight(52),

                backBar(
                  title: "Services",
                  onTap: () {
                    Get.back();
                  },
                ).marginSymmetric(horizontal: 16),
                addHeight(44),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: Column(
                          children: [

                            const SizedBox(height: 48),
                            Container(
                              height: 56, // Adjust height as per screenshot
                              decoration: BoxDecoration(
                                color: Colors.white, // White background for the search box
                                borderRadius: BorderRadius.circular(28), // Rounded corners
                                border: Border.all(color: Color(0xFF9AACFF), width: 1.0), // Light grey border
                              ),
                              child: Center(
                                child: TextField(
                                  // controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Color(0XFF67656B),fontFamily: 'Manrope',fontSize: 16),
                                    prefixIcon: Image.asset(AppAssets.searchIcon).marginAll(16),
                                    border: InputBorder.none, // Remove default TextField border
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
                                  ),
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                                  cursorColor: Color(0xff9AACFF), // Custom cursor color
                                ),
                              ),
                            ).marginSymmetric(horizontal: 16),

                            addHeight(8),
                            Expanded(
                              child: ListView.builder(
                                itemCount: servicesList.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final product = servicesList[index];

                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 72,
                                          width: 72,
                                          decoration: BoxDecoration(
                                              color: Color(0xFF4C9BF4),
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Image.asset(product.imageUrl),
                                        ),
                                        addWidth(12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(

                                                decoration: BoxDecoration(
                                                    color: Color(0xFF4C9BF4),
                                                    borderRadius: BorderRadius.circular(6)
                                                ),
                                                child: addText700(product.tag,fontSize: 10,color: AppColors.whiteColor).marginSymmetric(horizontal: 8,vertical: 4),
                                              ),
                                              addText600(product.title,fontSize: 16),
                                              addText400(product.description,fontSize: 12),
                                              addText400(product.expiry,fontSize: 9,color: AppColors.redColor1),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).marginOnly(bottom: 10);
                                },
                              ),
                            ),
                            // AppButton(
                            //   buttonText: 'Start Free 7-Day Trial',
                            // onButtonTap: (){},
                            //
                            //
                            // ).marginSymmetric(horizontal: 16),
                            // addHeight(36),
                          ],
                        ),
                      ),

                      Positioned(
                        top: -50,

                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Lottie.asset(
                                'assets/Lottie/Appolo strength.json',
                                repeat: true,
                                reverse: false,
                                animate: true,
                                width: 100,
                                height: 100
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
