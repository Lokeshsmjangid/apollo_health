import 'dart:async';
import 'package:apollo/resources/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordOtpCtrl extends GetxController{
  final AudioPlayer audioPlayer = AudioPlayer();
  TextEditingController emailController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  bool hasError = false;
  String hasErrorText = '';
  bool enabledButton = false;
  String? email;
  String? passwordResetToken;
  String? otp;

  RxInt timerVal = 0.obs ;
  Timer? _timer;

  Future<void> effectSound({required String sound}) async {

    await audioPlayer.play(AssetSource(sound));

  }

  @override
  void onInit() {
    // TODO: implement onInit
    startATimerFunc();
    super.onInit();
    if(Get.arguments!=null){
      email = Get.arguments['email'];
      passwordResetToken = Get.arguments['password_reset_token'];
      otp = Get.arguments['otp'];
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }
  //
  // @override
  // void onClose() {
  //   pinController.dispose();
  //   emailController.dispose();
  //   super.onClose();
  // }


  onButtonTap(value){
    apolloPrint(message: "OTP changed: $value");
    if (value.length >= 5) {
      enabledButton = true;
      hasError = false;
      hasErrorText = '';
      update();


    }else if(value.isEmpty || value==0){
      enabledButton = false;
      hasError = true;
      hasErrorText = 'OTP Required';
      update();
    } else{
      enabledButton = false;
      hasError = true;
      hasErrorText = 'All fields are required.';
      update();
    }
  }


  startATimerFunc() {
    _timer?.cancel(); // Cancel previous timer if running
    timerVal.value = 60; // Reset timer to 30 seconds
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerVal.value > 0) {
        timerVal.value--;
        // print("Timer val is :: ${timerVal.value}");
        // update();// Decrease the timer value
      } else {
        timer.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  String maskMobileNumber(String number) {
    if (number.length <= 2) return number; // not enough digits to mask
    String lastTwo = number.substring(number.length - 2);
    String masked = '*' * (number.length - 2);
    return '$masked$lastTwo';
  }


}