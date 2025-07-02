import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class GroupPlayRequestCtrl extends GetxController{

  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await audioPlayer.play(AssetSource(sound));

  }

  final List<Map<String, dynamic>> requests = [
    {
      'name': 'Madenyn Dias',
      'avatar': 'https://i.pravatar.cc/150?img=10',
      'flag': '🇧🇧',
      'timeLeft': '58 sec',
    },
    {
      'name': 'Wade Warren',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'flag': '🇧🇧',
      'timeLeft': '27 sec',
    },
  ];
}