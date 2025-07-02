import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class MyFriendsCtrl extends GetxController{

  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await audioPlayer.play(AssetSource(sound));

  }

  bool isMyFriendsTab = true;
  List<String> selectedPlayers = [];

  final List<Map<String, dynamic>> players = [
    {
      'name': 'Devon Lane',
      'hp': '550 HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'requested': true
    },
    {
      'name': 'Leslie Alexander',
      'hp': '630 HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=2',
    'requested': false
    },
    {
      'name': 'Madenyn Dias',
      'hp': '#HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=3',
    'requested': false
    },
    {
      'name': 'Wade Warren',
      'hp': '#HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'requested': true
    },
    {
      'name': 'Theresa Webb',
      'hp': '1450 HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=5',
    'requested': false
    },
    {
      'name': 'Albert Flores',
      'hp': '',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=6',
    'requested': false
    },
  ];

}