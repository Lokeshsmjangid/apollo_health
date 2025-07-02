import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class GroupPlayFriendsCtrl extends GetxController{
  bool isFriendsTab = true;
  List<String> selectedPlayers = [];


  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await audioPlayer.play(AssetSource(sound));

  }

  final List<Map<String, dynamic>> players = [
    {
      'name': 'Devon Lane',
      'hp': '550 HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'isOnline': true,
    },
    {
      'name': 'Leslie Alexander',
      'hp': '630 HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'isOnline': false,
    },
    {
      'name': 'Madenyn Dias',
      'hp': '#HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': true,
    },
    {
      'name': 'Wade Warren',
      'hp': '#HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'isOnline': true,
    },
    {
      'name': 'Theresa Webb',
      'hp': '1450 HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'isOnline': false,

    },
    {
      'name': 'Albert Flores',
      'hp': '',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=6',
      'isOnline': false,
    },
  ];
}