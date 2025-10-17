import 'dart:async';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';

import 'app_assets.dart';
import 'app_color.dart';

class CountdownTimerWidgetWellness extends StatefulWidget {
  String? correctWord;
  final int duration; // Number of minutes or seconds
  final bool isInSecondsMode; // true = seconds, false = minutes
  final void Function(int secondsLeft)? onTick;

  CountdownTimerWidgetWellness({
    Key? key,
    required this.duration,
    this.isInSecondsMode = false,
    this.correctWord,
    this.onTick,
  }) : super(key: key);

  @override
  CountdownTimerWidgetWellnessState createState() => CountdownTimerWidgetWellnessState();
}

class CountdownTimerWidgetWellnessState extends State<CountdownTimerWidgetWellness> with WidgetsBindingObserver {
  late int _secondsLeft;
  Timer? timer;
  bool _isRunning = false;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.isInSecondsMode ? widget.duration : widget.duration * 60;
    WidgetsBinding.instance.addObserver(this);
    // startTimer();
  }

  void startTimer() {
    _secondsLeft = widget.isInSecondsMode ? widget.duration : widget.duration * 60;
    _endTime = DateTime.now().add(Duration(seconds: _secondsLeft));
    _isRunning = true;

    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), _onTick);
    setState(() {});
  }

  void _onTick(Timer timer) {
    final now = DateTime.now();
    if (now.isAfter(_endTime)) {
      timer.cancel();
      _isRunning = false;
      setState(() {
        _secondsLeft = 0;
      });
      if (widget.onTick != null) widget.onTick!(0);
    } else {
      setState(() {
        _secondsLeft = _endTime.difference(now).inSeconds;
      });
      if (widget.onTick != null) widget.onTick!(_secondsLeft);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      if (_isRunning && _secondsLeft > 0) {
        timer?.cancel();
        timer = Timer.periodic(Duration(seconds: 1), _onTick);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
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
