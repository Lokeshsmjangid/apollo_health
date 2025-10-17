import 'package:apollo/bottom_sheets/live_challenge_register_bottom_sheet.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/Apis/api_models/live_challenge_model.dart';
import 'package:apollo/resources/Apis/api_repository/live_challenge_list_repo.dart';
import 'package:apollo/resources/Apis/api_repository/live_challenger_register_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/game_mode/live_challenges/timer_live_challenge_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class RegisterLiveChallengeScreen extends StatefulWidget {
  int? id;
  RegisterLiveChallengeScreen({super.key,this.id});

  @override
  State<RegisterLiveChallengeScreen> createState() => _RegisterLiveChallengeScreenState();
}

class _RegisterLiveChallengeScreenState extends State<RegisterLiveChallengeScreen> {

  final AudioPlayer audioPlayer = AudioPlayer();

  Future<void> effectSound({required String sound}) async {
    await audioPlayer.play(AssetSource(sound));
  }


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
      getLiveChallengeData();
    });
  }

  bool isDataLoading = false;
  LiveChallengeModel model = LiveChallengeModel();
  getLiveChallengeData() async{

    showLoader(true);

    await liveChallengeDataApi(id: widget.id).then((value){
      model =value;
      showLoader(false);
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              AppAssets.liveChBg,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Top Bar
                backBar(
                  title: "Live Challenge",
                  onTap: () {
                    Get.back();
                  },
                ).marginSymmetric(horizontal: 16),
                // addHeight(10),


                // Emoji/Character
                Lottie.asset(
                    'assets/Lottie/Appolo stetoskope.json',
                    repeat: true,
                    reverse: false,
                    animate: true,
                    width: 230,
                    height: 241
                ),
                // White Box with Players
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16,right: 16, top: 24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: addText500('Reserve Your Spot to',fontSize: 16,color: AppColors.blackColor,height: 22)),
                        // addHeight(4),

                        Align(
                            alignment: Alignment.center,
                            child: addText400('Win a Cash Prize!',fontSize: 32,height: 40,color: AppColors.primaryColor,fontFamily: 'Caprasimo')),
                        addHeight(27),
                        if(model.data!=null)
                        buildUserInfo(
                            prize: 'US \$${model.data!.priceMoney}',
                            date: model.data!.startDate??'',
                            username: model.data!.userName??'',
                            time: '${model.data!.startTime} EST (GMT-5)',
                        ),
                        addHeight(38),


                        if(model.data!=null)
                        // Play Again Button
                        AppButton(
                            buttonText: 'Register with Tokens (${model.data!.useToken} HP)',
                        onButtonTap: (){
                          showLoader(true);
                          liveChallengeRegisterApi(liveChallengeId: model.data?.id).then((value){
                            showLoader(false);
                            if(value.status==true){
                              if(value.data!=null) {
                                Get.to(()=>TimerLiveChallengeScreen(durationInMilliseconds: value.data!.milliseconds,data: value.data,));
                              }
                            } else if(value.status==false){
                              showLiveChallengeRegisterSheet(Get.context!,onButtonTap: (){
                                Get.back();
                              });
                            }
                          });

                        },
                        ),

                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1.5,
                                decoration: BoxDecoration(
                                    color: Color(0xffAAA4B3)
                                ),
                              ),
                            ),

                            addText400('or',fontSize: 12,color: Color(0xffAAA4B3)).marginSymmetric(horizontal: 12),

                            Expanded(
                              child: Container(
                                height: 1.5,
                                decoration: BoxDecoration(
                                    color: Color(0xffAAA4B3)
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        AppButton(
                          onButtonTap: (){

                            // Get.toNamed(AppRoutes.liveChallengeQuizScreen);

                          },
                            buttonColor: AppColors.purpleLightColor,
                            buttonTxtColor: AppColors.primaryColor,
                            buttonText: 'Secure your spot for \$0.99.'),
                        const SizedBox(height: 10),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            addText500('Apollo Premium Member? ',fontSize: 16,height: 22),
                            addText500('Join Free',fontSize: 16,decoration:TextDecoration.underline,height: 22,color: AppColors.primaryColor)

                          ],
                        ),
                        addHeight(40)
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

  Widget buildUserInfo({
    required String username,
    required String date,
    required String time,
    required String prize,
  }) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Labels
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // addText500("User Name:", fontSize: 16, color: AppColors.primaryColor,height: 22),
              // SizedBox(height: 8),
              addText500("Date:", fontSize: 16, color: AppColors.primaryColor,height: 22),
              SizedBox(height: 8),
              addText500("Time:", fontSize: 16, color: AppColors.primaryColor,height: 22),
              SizedBox(height: 8),
              addText500("Prize Money:", fontSize: 16, color: AppColors.primaryColor,height: 22),
            ],
          ),
          const SizedBox(width: 39),
          // Values
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // addText500(username, fontSize: 16, color: AppColors.blackColor,height: 22),
              // const SizedBox(height: 8),
              addText500(date, fontSize: 16, color: AppColors.blackColor,height: 22),
              const SizedBox(height: 8),
              addText500(time, fontSize: 16, color: AppColors.blackColor,height: 22),
              const SizedBox(height: 8),
              addText500(prize, fontSize: 16, color: AppColors.blackColor,height: 22),
            ],
          ),
        ],
      ),
    );
  }
}
