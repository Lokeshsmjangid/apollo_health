import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class PlayRequestCtrl extends GetxController{
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }


  final List<Map<String, dynamic>> requests = [
    {
      'name': 'Madenyn Dias',
      'avatar': 'https://i.pravatar.cc/150?img=10',
      'flag': '🇧🇧',
      'hps': '630 HP',
    },
    {
      'name': 'Wade Warren',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'flag': '🇧🇧',
      'hps': '1,050 HP',
    },
  ];
}