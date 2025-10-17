import 'dart:async';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';

import 'app_assets.dart';
import 'app_color.dart';

class CountdownTimerWidget extends StatefulWidget {
  final int duration; // Number of minutes or seconds
  final bool isInSecondsMode; // true = seconds, false = minutes
  final VoidCallback? onTimerEnd;
  final void Function(int secondsLeft)? onTick;
  final bool shouldStop;

  const CountdownTimerWidget({
    Key? key,
    required this.duration,
    this.isInSecondsMode = false,
    this.onTimerEnd,
    this.onTick,
    this.shouldStop = false,
  }) : super(key: key);

  @override
  State<CountdownTimerWidget> createState() => CountdownTimerWidgetState();
}

class CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late int _secondsLeft;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.isInSecondsMode
        ? widget.duration
        : widget.duration * 60; // Convert minutes to seconds if needed
    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
        if (widget.onTimerEnd != null) {
          widget.onTimerEnd!();
        }
      } else {
        setState(() {
          _secondsLeft--;
        });
        if (widget.onTick != null) {
          widget.onTick!(_secondsLeft); // <-- Call onTick with seconds left
        }
      }
    });
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
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CountdownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldStop && timer != null) {
      timer?.cancel();timer = null;
      apolloPrint(message: 'Countdown timer');
    }
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
