import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    playBackgroundSound();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopBackgroundSound();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer backgroundPlayer = AudioPlayer();

  Future<void> effectSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }

  Future<void> playBackgroundSound() async {
    if (AuthData().musicONOFF) {
      await backgroundPlayer.setReleaseMode(ReleaseMode.loop); // Loop the sound
      await backgroundPlayer.play(AssetSource(AppAssets.backGroundGameSound));
    }
  }

  void stopBackgroundSound() {
    print('Stopping background sound');
    backgroundPlayer.stop();
  }




}