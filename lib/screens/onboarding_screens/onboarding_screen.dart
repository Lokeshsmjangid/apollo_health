/*
import 'package:apollo/controllers/onboard_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardingScreen extends StatelessWidget {
  final controller = Get.put(OnboardingController());
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffDDCFF2),
      body: Stack(
        children: [

          Container(
            child: Image.asset(
              AppAssets.onboardingBg,
              width: double.infinity,fit: BoxFit.cover,colorBlendMode: BlendMode.clear,
            ),
          ),
          Column(
            children: [
              addHeight(50),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skip,
                  child: addText500("Skip", color: AppColors.blackColor,fontSize: 16,height: 22),
                ),
              ),
              Expanded(
                // height: MediaQuery.sizeOf(context).height*0.65,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.pages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 800),
                          tween: Tween<double>(begin: 0.0, end: 200.0),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Lottie.asset(
                                controller.pages[index]['image']!,
                                repeat: true,
                                reverse: false,
                                animate: true,
                                width: 300,
                                height: 313
                            );
                          },
                        ),
                        SizedBox(height: 17),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: addText400(
                            controller.pages[index]['title']!,
                            textAlign: TextAlign.center,
                            fontSize: 32,
                            height: 40,
                            fontFamily: 'Caprasimo'
                          ),
                        ),
                        SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: addText500(
                            controller.pages[index]['desc']!,
                            textAlign: TextAlign.center,
                            fontSize: 16,
                            // height: 22,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
             Obx(() {
            final _ = controller.currentIndex.value;
            return SmoothPageIndicator(
              controller: pageController,
              count:controller. pages.length,
              effect: ExpandingDotsEffect(
                dotColor: Colors.white,
                activeDotColor: Colors.deepPurple,
                expansionFactor: 3,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 8,
                strokeWidth: 1.5,
              ),
            );
          }),

              SizedBox(height: 44),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: AppButton(buttonText: 'Next',onButtonTap: ()=>controller.nextPage(pageController),),
              ),
              SizedBox(height: 33),
            ],
          ),
        ],
      ),
    );
  }
}

*/


import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/controllers/onboard_ctrl.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {

  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // final controller = Get.put(OnboardingController());

  // late final PageController pageController;
  @override
  void initState() {
    super.initState();
    // pageController = PageController();
  }

  // @override
  // void dispose() {
  //   pageController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDDCFF2),
      body: GetBuilder<OnboardingController>(builder: (controller) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppAssets.onboardingBg,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.clear,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: controller.skip,
                      child: addText500(
                        "Skip",
                        color: AppColors.blackColor,
                        fontSize: 16,
                        height: 22,
                      ),
                    ),
                  ),

                  Expanded(
                    child: controller.isDataLoading? buildCpiLoader(): controller.pages.isEmpty
                        ? Center(child: addText600('No On-Boarding found'))
                        : PageView.builder(
                      
                      controller: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                      itemCount: controller.pages.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 800),
                                tween: Tween<double>(begin: 0.0, end: 200.0),
                                curve: Curves.easeOutBack,
                                builder: (context, value, child) {
                                  return Container(
                                    // color: Colors.red,
                                    child: Lottie.asset(
                                      index == 0
                                          ? 'assets/Lottie/Appolo stetoskope.json'
                                          : index == 1
                                          ? 'assets/Lottie/Apollo magic.json'
                                          : 'assets/Lottie/Appolo dance.json',
                                      width: 300,
                                      height: 313,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 17),
                              addText400(
                                controller.pages[index].title ?? '',
                                textAlign: TextAlign.center,
                                fontSize: 32,
                                height: 40,
                                fontFamily: 'Caprasimo',
                              ),
                              SizedBox(height: 24),
                              addText500(
                                controller.pages[index].desc ?? '',
                                textAlign: TextAlign.center,
                                fontSize: 16,
                                height: 22,
                                color: AppColors.blackColor,
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  if(controller.pages.isNotEmpty)
                  SmoothPageIndicator(
                    controller: controller.pageController!,
                    count: controller.pages.length,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.white,
                      activeDotColor: Colors.deepPurple,
                      expansionFactor: 3,
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 8,
                      strokeWidth: 1.5,
                    ),
                  ),
                  // Obx(() {
                  //   final _ = controller.currentIndex.value;
                  //   return SmoothPageIndicator(
                  //     controller: pageController,
                  //     count: controller.pages.length,
                  //     effect: ExpandingDotsEffect(
                  //       dotColor: Colors.white,
                  //       activeDotColor: Colors.deepPurple,
                  //       expansionFactor: 3,
                  //       dotHeight: 10,
                  //       dotWidth: 10,
                  //       spacing: 8,
                  //       strokeWidth: 1.5,
                  //     ),
                  //   );
                  // }),
                  SizedBox(height: 44),
                  if(controller.pages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: AppButton(
                      buttonText: 'Next',
                      onButtonTap: () => controller.nextPage(controller.pageController!),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

