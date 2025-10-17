import 'dart:async';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';

class CountdownTimerWidgetMedlingo extends StatefulWidget {
  final int duration; // duration in minutes or seconds based on isInSecondsMode
  final bool isInSecondsMode;
  final void Function(int secondsLeft)? onTick;
  final String? correctWord;

  CountdownTimerWidgetMedlingo({
    Key? key,
    required this.duration,
    this.isInSecondsMode = false,
    this.onTick,
    this.correctWord,
  }) : super(key: key);

  @override
  _CountdownTimerWidgetMedlingoState createState() => _CountdownTimerWidgetMedlingoState();
}

class _CountdownTimerWidgetMedlingoState extends State<CountdownTimerWidgetMedlingo> with WidgetsBindingObserver{
  late int _secondsLeft;
  Timer? _timer;
  bool _isRunning = false;
  late DateTime _endTime;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // app backgrounded
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      // app foregrounded, resume timer
      if (_isRunning && _secondsLeft > 0) {
        _timer?.cancel();
        _timer = Timer.periodic(Duration(seconds: 1), _onTick);
      }
    }
  }
  void _onTick(Timer timer) {
    final now = DateTime.now();
    if (now.isAfter(_endTime)) {
      timer.cancel();
      _isRunning = false;
      setState(() {
        _secondsLeft = 0;
      });
      if(widget.onTick!=null) widget.onTick!(0);
    } else {
      setState(() {
        _secondsLeft = _endTime.difference(now).inSeconds;
      });
      if(widget.onTick!=null) widget.onTick!(_secondsLeft);
    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();
    startTimer(); // auto start timer on widget load
  }

  void _resetTimer() {
    _secondsLeft = widget.isInSecondsMode ? widget.duration : widget.duration * 60;
    _isRunning = false;
    _timer?.cancel();
    setState(() {});
  }

  void startTimer() {
    _secondsLeft = widget.isInSecondsMode ? widget.duration : widget.duration * 60;
    _endTime = DateTime.now().add(Duration(seconds: _secondsLeft));
    _isRunning = true;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
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
          addText400( // Or just use Text(_timeString, style: ...)
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
