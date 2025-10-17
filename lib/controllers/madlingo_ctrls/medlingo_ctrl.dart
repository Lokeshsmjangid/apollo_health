import 'package:apollo/resources/Apis/api_models/medlingo_start_model.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/game_mode/medlingo/medlingo_result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedlingoCtrl extends GetxController{
  String? word; // Correct answer
  String? imageUrl;
  MedLingoData? gameData;
  List<String?>? answerBoxes;
  List<String> ?availableLetters;

  bool timeOver = false;

  // for hand
  bool isStuck = false;
  int attemptCount= 0;
  bool attemptStarted = false;

  //
  bool hasQuit = false; // sec==0 api hit 2 time

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments!=null){
      word = Get.arguments['word'];
      imageUrl = Get.arguments['imageUrl'];
      gameData = Get.arguments['gameData'];

      answerBoxes = List.generate(word!.length, (_) => null);

      // Split letters and shuffle to display in circle
      availableLetters = word!.split('');
      availableLetters!.shuffle();
    }
  }

  bool _hasNavigated = false;
  bool get isAnswerComplete => !answerBoxes!.contains(null);
  void _checkAndNavigate() {
    if (isAnswerComplete && !_hasNavigated) {
      _hasNavigated = true;
      final userAnswer = answerBoxes!.map((e) => e ?? '').join('');
      final correct = userAnswer == word;
      if (correct) {
        Get.to(MedLingoResult(showText: 'terrific', correctAns: word));
      } else {
        Get.to(MedLingoResult(showText: 'tryAgain', correctAns: word));
      }
    }
  }

  void onLetterDroppedToBox(int boxIndex, String letter, {int? fromBox}) {
    // setState(() {
    //   attemptStarted = true;
      if (fromBox != null) {
        final prevLetter = answerBoxes![boxIndex];
        answerBoxes![boxIndex] = letter;
        answerBoxes![fromBox] = prevLetter;
      } else {
        if (answerBoxes![boxIndex] != null) {
          availableLetters!.add(answerBoxes![boxIndex]!);
        }
        answerBoxes![boxIndex] = letter;
        availableLetters!.remove(letter);
      }
      // _checkAndNavigate();  // Check after updating
    // });
    update();
  }

  onLetterDroppedToPad(String letter) {

    apolloPrint(message: 'Flutter lokesh $letter');
    // setState(() {
      int idx = answerBoxes!.indexOf(letter);
      if (idx != -1) {
        answerBoxes![idx] = null;
        availableLetters!.add(letter);
      }
    // });
      update();
    _hasNavigated = false;
  }



// below code according to client feedbacks
  /*Widget dragLetter(String letter, {Color bg = const Color(0xFF7952C3), Color textColor = Colors.black}) => Container(
    width: 34,
    height: 34,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      // color: bg,
      // Uncomment below if you want colored circles
      // color: bg,
      // boxShadow: [
      //   BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 3, offset: Offset(0, 2))
      // ],
      // border: Border.all(color: Colors.white, width: 2)
    ),
    child: addText400(letter.toUpperCase(),
        fontFamily: 'Caprasimo',
      fontSize: 26,
      height: 34,
      decoration: TextDecoration.none,
      color: textColor,
    ),
  );*/


  RxSet<int> activeIndexes = <int>{}.obs;
  void onLetterPressed(int idx) {
    activeIndexes.add(idx);
    update();
  }

  void onLetterReleased(int idx) {
    activeIndexes.remove(idx);
    update();
  }

  Widget dragLetter(String letter, int idx) {
    final isActive = activeIndexes.contains(idx);
    return GestureDetector(
      onTapDown: (_) => onLetterPressed(idx),
      onTapUp: (_) => onLetterReleased(idx),
      onTapCancel: () => onLetterReleased(idx),

      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.orange : Colors.transparent,
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: Colors.orange.withOpacity(0.5),
                blurRadius: 6,
                spreadRadius: 1,
              ),
          ],
          // border: Border.all(color: Colors.white, width: 2),
        ),
        child: addText400(
          letter.toUpperCase(),
          fontFamily: 'Caprasimo',
          fontSize: 26,
          height: 34,
          decoration: TextDecoration.none,
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget dragLetterDisplay(String letter, {Color bg = const Color(0xFF7952C3), Color textColor = Colors.black, bool isActive = false}) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.orange : Colors.transparent,
        boxShadow: isActive
            ? [BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 6, spreadRadius: 1)]
            : [],
        // border: Border.all(color: Colors.white, width: 2),
      ),
      child: addText400(
        letter.toUpperCase(),
        fontFamily: 'Caprasimo',
        fontSize: 26,
        height: 34,
        decoration: TextDecoration.none,
        color: isActive ? Colors.white : textColor,
      ),
    );
  }


}