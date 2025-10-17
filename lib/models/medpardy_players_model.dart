import 'package:flutter/animation.dart';

class MedPardyPlayerModel {
  final String name;
  final Color color;
  final Color borderColor;
  final Color textColor;
  int hp;
  int round;
  int gamePlayed;


  MedPardyPlayerModel({
    required this.name,
    required this.color,
    required this.borderColor,
    required this.textColor,
    this.hp = 0,
    this.round = 0,
    this.gamePlayed = 0,
  });
}