/*
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';

class CustomKeyboard extends StatefulWidget {
  final String correctAnswer;
  final void Function(String)? onSubmit;
  final void Function(String)? onKeyTap;
  final void Function()? onBackspace;


  const CustomKeyboard({
    super.key,
    required this.correctAnswer,
    this.onSubmit,
    this.onKeyTap,
    this.onBackspace,
  });

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  Set<String> correctLetters = {};
  Set<String> incorrectLetters = {};
  bool isUpperCase = true;
  String typedText = '';

  final List<String> row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  final List<String> row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  final List<String> row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

  // void onKeyPress(String letter) {
  //   setState(() {
  //     String lowerLetter = letter.toUpperCase();
  //     if (widget.correctAnswer.contains(lowerLetter)) {
  //       correctLetters.add(letter);
  //     } else {
  //       incorrectLetters.add(letter);
  //     }
  //     typedText += lowerLetter;
  //   });
  // }

  void onKeyPress(String letter) {
    setState(() {
      String lowerLetter = letter.toUpperCase();
      if (widget.correctAnswer.contains(lowerLetter)) {
        correctLetters.add(letter);
      } else {
        incorrectLetters.add(letter);
      }
      typedText += lowerLetter;
    });
    widget.onKeyTap?.call(letter); // <-- Add this line
  }


  // void onBackspace() {
  //   if (typedText.isNotEmpty) {
  //     setState(() {
  //       typedText = typedText.substring(0, typedText.length - 1);
  //     });
  //   }
  // }



  void onSubmit() {
    widget.onSubmit?.call(typedText);
    // Optionally clear typedText or keep it
  }

  Color? getKeyColor(String letter) {
    if (correctLetters.contains(letter)) return Colors.green[200];
    if (incorrectLetters.contains(letter)) return Colors.red[200];
    return AppColors.whiteColor;
  }

  Widget buildKey(String letter) {
    final display = isUpperCase ? letter.toUpperCase() : letter.toLowerCase();
    return GestureDetector(
      onTap: () => onKeyPress(display),
      child: Container(
        width: 32,
        height: 42,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: getKeyColor(letter),
          borderRadius: BorderRadius.circular(4),
          // border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18), // Shadow color
              offset: Offset(0, 1), // X: 0, Y: 4 for shadow below
              // blurRadius: 3,        // Softness of the shadow
              spreadRadius: 1,      // Optional: how much the shadow spreads
            ),
          ],
        ),
        alignment: Alignment.center,
        child: addText500(
          display,fontSize: 20
          // style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget buildRow(List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map(buildKey).toList(),
    );
  }

  Widget buildSpecialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Shift
        GestureDetector(
          onTap: () {
            // setState(() {
            //   isUpperCase = !isUpperCase;
            // });
          },
          child: Container(
            width: 50,
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),

            ),
            alignment: Alignment.center,
            child: const Icon(Icons.arrow_upward, size: 20),
          ),
        ),

        // Row 3
        ...row3.map(buildKey).toList(),

        // Backspace
        GestureDetector(
          onTap: widget.onBackspace,
          child: Container(
            width: 50,
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.backspace_outlined, size: 20),
          ),
        ),
      ],
    );
  }

  Widget buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Emoji/Mic
        Container(
          width: 50,
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.emoji_emotions, size: 20),
        ),

        // Space
        Expanded(
          child: GestureDetector(
            onTap: () => onKeyPress(' '),
            child: Container(
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text('space', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),

        // Return
        GestureDetector(
          onTap: onSubmit,
          child: Container(
            width: 70,
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.blue[300],
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text('return', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildRow(row1),
        buildRow(row2),
        buildSpecialRow(),
        // buildBottomRow(),
        const SizedBox(height: 10),
      ],
    );
  }
}
*/



import 'package:flutter/material.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';

class CustomKeyboard extends StatelessWidget {
  final String correctAnswer;
  final void Function(String)? onKeyTap;
  final Set<String> correctLetters;
  final Set<String> incorrectLetters;

  const CustomKeyboard({
    super.key,
    required this.correctAnswer,
    required this.onKeyTap,
    required this.correctLetters,
    required this.incorrectLetters,
  });

  Color getKeyColor(String letter) {
    if (correctLetters.contains(letter)) return Colors.green[200]!;
    if (incorrectLetters.contains(letter)) return Colors.red[200]!;
    return AppColors.whiteColor;
  }

  Widget buildKey(String letter) {
    return GestureDetector(
      onTap: () => onKeyTap?.call(letter),
      child: Container(
        width: 32,
        height: 42,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: getKeyColor(letter),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              offset: const Offset(0, 1),
              spreadRadius: 1,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: addText500(letter, fontSize: 20),
      ),
    );
  }

  Widget buildRow(List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map(buildKey).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
    final List<String> row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
    final List<String> row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

    return Column(
      children: [
        buildRow(row1),
        buildRow(row2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Disabled backspace button

            ...row3.map(buildKey).toList(),
            /*Container( // Hiding remove key button
              width: 50,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.backspace_outlined, size: 20, color: Colors.grey[600]),
            ),*/
          ],
        ),
      ],
    );
  }
}

