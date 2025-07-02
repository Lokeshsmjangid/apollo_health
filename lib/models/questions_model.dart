import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class Question {
  final String question;
  final String explanation;
  final String funFact;
  final String imagePath;
  final List<String> options;
  List<int> eliminatedOptions = [];
  final int correctIndex;
  bool isLike = false;
  bool isAnswered = false;
  int? selectedIndex;
  Key? flipKey;

  Question({
    required this.question,
    required this.explanation,
    required this.funFact,
    required this.imagePath,
    required this.options,
    required this.correctIndex,
    required this.isLike,
    required this.isAnswered,
    this.selectedIndex,
    this.flipKey,
  });
}