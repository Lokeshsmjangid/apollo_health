import 'dart:async';
import 'package:apollo/Dialogues/transparent_dialogue.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';

import 'app_assets.dart';
import 'app_color.dart';

class CountdownTimerWidgetWellness extends StatefulWidget {
  String? correctWord;
  final int duration; // Number of minutes or seconds
  final bool isInSecondsMode; // true = seconds, false = minutes

  CountdownTimerWidgetWellness({
    Key? key,
    required this.duration,
    this.isInSecondsMode = false,
    this.correctWord
  }) : super(key: key);

  @override
  CountdownTimerWidgetWellnessState createState() => CountdownTimerWidgetWellnessState();
}

class CountdownTimerWidgetWellnessState extends State<CountdownTimerWidgetWellness> {
  late int _secondsLeft;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  void _resetTimer() {
    _secondsLeft = widget.isInSecondsMode
        ? widget.duration
        : widget.duration * 60;
    _isRunning = false;
    _timer?.cancel();
    setState(() {});
  }

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
        _isRunning = false;
        showDialog(
          useSafeArea: false,
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return DialogScreen(showText: 'gameOver',correctAnswer: widget.correctWord);
          },
        );
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
    setState(() {});
  }

  String get _timeString {
    if (widget.isInSecondsMode) {
      return '$_secondsLeft sec';
    } else {
      final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
      final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.yellowColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(
            AppAssets.clockIcon,
            height: 16,
            width: 16,
          ),
          const SizedBox(width: 4),
          addText400(
            _timeString,
            fontSize: 16,
            height: 22,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}
