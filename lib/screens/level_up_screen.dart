import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HowToLevelUpScreen extends StatelessWidget {
  const HowToLevelUpScreen({super.key});

  final Color purple = const Color(0xFF7B3EFF);

  final List<Map<String, String>> tips = const [
    {
      'title': 'Refer a Friend',
      'desc': 'Get 1,000 HP when they join!',
    },
    {
      'title': '5-Day Streak',
      'desc': 'Play daily for 5 days = 10% bonus on all scores.',
    },
    {
      'title': 'Speed Bonus',
      'desc': 'Answer in under 8 sec? Boom, +20% HP!',
    },
    {
      'title': 'Group Play',
      'desc': 'Join a session, score 10% extra per game.',
    },
    {
      'title': 'Medpardy',
      'desc': 'Play & earn a 10% bonus on next Solo or Group Play.',
    },
    {
      'title': 'Wheel of Wellness Puzzle',
      'desc': 'Spin daily, guess perfectly, and earn a 20% boost!',
    },
    {
      'title': 'Live Challenge',
      'desc': 'Scores are doubled. That’s a 100% bonus!',
    },
    {
      'title': 'Apollo Spotlight',
      'desc': 'Special themed events = +20% per game.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purple,
      body: Stack(
        clipBehavior: Clip.none,
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
                // addHeight(52),

                backBar(
                  title: "How to Level Up",
                  onTap: () {
                    Get.back();
                  },
                ).marginSymmetric(horizontal: 16),
                addHeight(18),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16,right: 16,top: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addText500(
                          "Want to level up fast? Score big with these boosts:",
                          fontSize: 20,
                          height: 28
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: tips.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final item = tips[index];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 Image.asset(AppAssets.starIcon,height: 18,width: 18,),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w700,height: getLineHeight(fontSize: 16,lineHeightPx: 24)),
                                        children: [
                                          TextSpan(
                                            text: '${item['title']} – ',
                                            style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16,fontFamily: 'Manrope'),
                                          ),
                                          TextSpan(text: item['desc'],style: const TextStyle(fontFamily: 'Manrope',fontWeight: FontWeight.w500,fontSize: 16),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
