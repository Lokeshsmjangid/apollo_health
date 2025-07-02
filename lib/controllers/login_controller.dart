import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{

  bool obscureText = false;
  bool isButtonDisable = true;

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  onTapSuffix(){
    obscureText = !obscureText;
    update();
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
  }


  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> effectSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }




}