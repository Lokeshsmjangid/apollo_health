import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:apollo/resources/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';


class WheelOfWellnessResult extends StatefulWidget {
  String? showText;
  Map<String, dynamic> correctAns;
  int hP;
  WheelOfWellnessResult({super.key,this.showText,this.correctAns = const{},this.hP=0});

  @override
  State<WheelOfWellnessResult> createState() => _WheelOfWellnessResultState();
}

class _WheelOfWellnessResultState extends State<WheelOfWellnessResult> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _playConfettiSound(sound: AppAssets.confettiWave);
    getConfiti();
    _startPeriodicTimer();
  }

  Future<void> _playConfettiSound({required String sound}) async {
    if(widget.showText != 'gameOver') {
      // if(AuthData().musicONOFF) {
        await _audioPlayer.play(AssetSource(sound));
      // }
    }
  }

  Future<void> effectSound({required String sound}) async {

    // if(AuthData().musicONOFF) {
      await _audioPlayer.play(AssetSource(sound));
    // }

  }



  @override
  void dispose() {
    _audioPlayer.dispose();
    _timerNew?.cancel();
    super.dispose();
  }


  bool isConfiti = true;
  getConfiti() async {
    await Future.delayed(Duration(seconds: 4));
    if (!mounted) return;

    setState(() {
      isConfiti = false;
    });
  }
  // getConfiti(){
  //   Future.delayed(Duration(seconds: 4),(){
  //     Future.microtask((){
  //       isConfiti = false;
  //       setState(() {});
  //     });
  //
  //   });
  // }


  // for remove all screens and to back to home
  Timer? _timerNew;
  int _counter = 10;
  void _startPeriodicTimer() {
    _timerNew = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter--; // Update your logic here
      });
      if(_counter==0){
        Get.offAll(()=>DashBoardScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.primaryColor,
        body: WillPopScope(
          onWillPop: () async{
            return false;
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppAssets.notificationsBg,
                  fit: BoxFit.cover,
                ),
              ),
              if(widget.showText=='terrific' && isConfiti)
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  AppAssets.confettiGif,
                  fit: BoxFit.fill,
                  height: double.infinity,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [

                    addHeight(10),
                    Row(
                      children: [
                        Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                // color: Colors.red,
                                shape: BoxShape.circle
                            ),
                            child: Image.asset(AppAssets.circleQuestionIcon).marginAll(6)),
                        // const SizedBox(width: 6),
                        GestureDetector(
                            onTap: (){
                              Get.toNamed(AppRoutes.howToLevelUpScreen);
                            },
                            child: addText500('Level up'.capitalize.toString(), fontSize: 16, color: AppColors.whiteColor)),
                        const Spacer(),
                        GestureDetector(
                            onTap: (){
                              Share.share(
                                  AuthData().userModel?.roleId==4?shareTextGuest:shareText                           );
                            },
                            child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    // color: Colors.red,
                                    shape: BoxShape.circle
                                ),
                                child: Image.asset(AppAssets.shareIcon).marginAll(6))),
                        // const SizedBox(width: 10),
                        GestureDetector(
                            onTap: (){
                              Get.offAll(()=>DashBoardScreen());
                            },
                            child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    // color: Colors.red,
                                    shape: BoxShape.circle
                                ),
                                child: Image.asset(AppAssets.closeIcon).marginAll(5))),
                      ],
                    ),
                    addHeight(14),

                    addText400(
                      widget.showText=='terrific'?"Great job!": "You're learning!",
                      fontSize: 32,
                      fontFamily: 'Caprasimo',
                      color: Colors.white,
                    ),



                    FittedBox(
                      child: Lottie.asset(
                          'assets/Lottie/Appolo dance.json',
                          repeat: true,
                          reverse: false,
                          animate: true,
                          // width: 310,
                          // height: 240
                      ),
                    ).marginSymmetric(horizontal: 20),

                    addText500('The word is:',color: AppColors.whiteColor,fontSize: 20,height: 28),
                    addText400('${widget.correctAns['revealed_medical_term'].toUpperCase()}',fontFamily: 'Caprasimo',color: AppColors.whiteColor,fontSize: 32,height: 40),
                    addHeight(12),

                    // Question
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.yellowColor),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: addText700( // bold
                          widget.correctAns['description']??"",
                          textAlign: TextAlign.center,
                          fontSize: 16, color: AppColors.whiteColor,
                      ),
                    ).marginSymmetric(horizontal: 26),

                    addHeight(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.coinIcon, height: 24, width: 24),
                        addWidth(8),
                        addText500(widget.showText=='gameOver'?'${widget.hP} HP':'${widget.hP} HP',
                            fontSize: 20,
                            color: AppColors.whiteColor)
                      ])]).marginSymmetric(horizontal: 16),
              )
            ],
          ),
        ),
        bottomNavigationBar: MediaQuery.removePadding(
          context: context,
          removeBottom: Platform.isIOS ? true : false,
          removeTop: true,
          child: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            child: AppButton(
              buttonTxtColor: AppColors.primaryColor,
              buttonColor: AppColors.whiteColor,
              buttonText: 'Play Another Game',
              onButtonTap: (){
                Get.offAll(()=>DashBoardScreen());
              }),
          ).marginOnly(left: 16,right: 16,bottom: 35))),
    );
  }
}


