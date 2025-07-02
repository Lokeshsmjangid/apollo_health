import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';

class SignUpCtrl extends GetxController{

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController confPassCtrl = TextEditingController();
  bool obscurePass = false;
  bool obscureCPass = false;
  bool isButtonDisable = true;

  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await _audioPlayer.play(AssetSource(sound));

  }

  onTapSuffix({bool isPass = true}){
    if(isPass){
      obscurePass = !obscurePass;
    }else if(!isPass){
      obscureCPass = !obscureCPass;
    }
    update();
  }

}