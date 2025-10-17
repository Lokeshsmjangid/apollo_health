
import 'package:apollo/bottom_sheets/live_challenge_register_bottom_sheet.dart';

import 'package:apollo/resources/Apis/api_models/live_challenges_list_model.dart';
import 'package:apollo/resources/Apis/api_repository/live_challenge_list_all_repo.dart';
import 'package:apollo/resources/Apis/api_repository/live_challenger_register_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/debouncer.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/game_mode/live_challenges/register_live_challenge_screen.dart';
import 'package:apollo/screens/game_mode/live_challenges/timer_live_challenge_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'live_challenge_round_timer_screen.dart';

class ChallengesListScreen extends StatefulWidget {
  const ChallengesListScreen({super.key});

  @override
  State<ChallengesListScreen> createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen> {


  LiveChallengeListModel productModel = LiveChallengeListModel();
  TextEditingController searchCtrl = TextEditingController();
  final deBounce = Debouncer(milliseconds: 1000);
  bool isDataLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask((){
      getProducts();
    });
  }

  getProducts({String? searchValue}) async{
    isDataLoading = true;
    setState(() {});
    await liveChallengeAllListApi().then((value){
      productModel = value;
      isDataLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFF8A4CEB),
      resizeToAvoidBottomInset: false,
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
                // addHeight(52),

                addHeight(10),
                backBar(
                  title: "Live Challenge",
                  onTap: () {
                    Get.back();
                  },
                ).marginSymmetric(horizontal: 16),
                addHeight(10),
                Align(
                    alignment: Alignment.center,
                    child: addText400('Tap an event to register and secure your spot.',fontSize: 9,color: AppColors.whiteColor)),

                addHeight(15),
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

                          /*  const SizedBox(height: 52),
                            Container(
                              height: 56, // Adjust height as per screenshot
                              decoration: BoxDecoration(
                                color: Colors.white, // White background for the search box
                                borderRadius: BorderRadius.circular(28), // Rounded corners
                                border: Border.all(color: Color(0xFFD1B8F9), width: 1.0), // Light grey border
                              ),
                              child: Center(
                                child: TextField(
                                  autocorrect: false,
                                  onChanged: (val){
                                    deBounce.run((){
                                      getDeals(searchValue: val);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Color(0XFF67656B),fontFamily: 'Manrope',fontSize: 16),
                                    prefixIcon: Image.asset(AppAssets.searchIcon).marginAll(16),
                                    border: InputBorder.none, // Remove default TextField border
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
                                  ),
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                                  cursorColor: Colors.deepPurple, // Custom cursor color
                                ),
                              ),
                            ).marginSymmetric(horizontal: 16),*/

                            addHeight(8),
                            Expanded(
                              child: isDataLoading ? buildCpiLoader()
                                  : productModel.data!=null && productModel.data!.isNotEmpty
                                  ? ListView.builder(
                                itemCount: productModel.data!.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final product = productModel.data![index];

                                  return GestureDetector(
                                    onTap: (){
                                      if(product.isRegistered==1){
                                        showLoader(true);
                                        liveChallengeRegisterApi(liveChallengeId: product.id).then((value){
                                          showLoader(false);
                                          if(value.status==true){
                                            if(value.data!=null) {
                                              Get.to(()=>TimerLiveChallengeScreen(
                                                durationInMilliseconds: value.data!.milliseconds,data: value.data,));
                                            }
                                          } else if(value.status==false){
                                            showLiveChallengeRegisterSheet(Get.context!,onButtonTap: (){
                                              Get.back();
                                            });
                                          }
                                        });
                                      }else{

                                      Get.to(()=>RegisterLiveChallengeScreen(id: product.id,))?.then((value){});
                                      }



                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 72,
                                            width: 72,
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF8A4CEB),
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2), // Soft shadow
                                                  blurRadius: 20, // Smooth blur
                                                  offset: Offset(2, 8), // Slight downward-right shift
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            // child: Image.asset(product.imageUrl),
                                            child: CachedImageCircle2(imageUrl: product.image,isCircular: false),
                                          ),
                                          addWidth(12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(

                                                      decoration: BoxDecoration(
                                                        color: product.pillBoxColor!.isNotEmpty
                                                            ? hexToColor(product.pillBoxColor!)
                                                            : Color(0xff8A4CEB),
                                                        borderRadius: BorderRadius.circular(6)
                                                      ),
                                                      child: addText700('\$${product.priceMoney}',
                                                          fontSize: 10,color: AppColors.whiteColor).marginSymmetric(horizontal: 8,vertical: 4),
                                                    ),

                                                    Spacer(),
                                                    if(product.isRegistered==1)
                                                    GestureDetector(
                                                      onTap: (){
                                                        Get.to(()=>LiveChallengeRoundTimerScreen());
                                                      },
                                                      child: Container(
                                                          height: 28,
                                                          width: 28,
                                                          padding: EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle
                                                          ),
                                                          child: SvgPicture.asset(AppAssets.ticketIcon,color: hexToColor(product.pillBoxColor!))),
                                                    )
                                                  ],
                                                ),
                                                addText600('${product.title}',fontSize: 16),
                                                addText400('${product.startDate}',fontSize: 12),
                                                addText400('${product.startTime} EST (GMT-5)',fontSize: 12),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).marginOnly(bottom: 10),
                                  );
                                },
                              ) : Center(child: addText500('No active oﬀers at the moment. Stay tuned for fresh finds!',textAlign: TextAlign.center)),
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

                     /* Positioned(
                        top: -48,

                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                                AppAssets.dealsProductImg,
                                width: 84,
                                height: 84
                            ),
                          ],
                        ),
                      ),*/
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
