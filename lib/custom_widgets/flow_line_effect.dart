import 'dart:async';

import 'package:apollo/resources/app_color.dart';
import 'package:flutter/material.dart';

class FlowingLineEffect extends StatefulWidget {
  bool isGroupChallersList;
  FlowingLineEffect({Key? key,this.isGroupChallersList=false}) : super(key: key);

  @override
  State<FlowingLineEffect> createState() => _FlowingLineEffectState();
}


class _FlowingLineEffectState extends State<FlowingLineEffect> {
  int activeLength = 1; // kitne dashes fill hain current me
  final int totalDashes = 5;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) { // thoda slow animation
      setState(() {
        if (activeLength < totalDashes) {
          activeLength++;
        } else {
          // jab sab fill ho jaye to ek baar sab blank kar do, fir se start
          activeLength = 0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _getColor(int index) {
    if (index < activeLength) {
      return widget.isGroupChallersList
          ? AppColors.primaryColor
          : AppColors.yellowColor; // Filled color
    }
    return widget.isGroupChallersList
        ? AppColors.purpleLightColor
        : AppColors.whiteColor; // Empty color
  }

  Widget _buildDash(Color color) {
    return Container(
      width: 24,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDashes, (index) => _buildDash(_getColor(index))),
    );
  }
}


/*
class _FlowingLineEffectState extends State<FlowingLineEffect> {
  int activeStart = 0;
  final int totalDashes = 5;
  final int activeLength = 1;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) { // to animate fast and slow
      setState(() {
        activeStart = (activeStart + 1) % totalDashes;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _getColor(int index) {
    if ((index >= activeStart && index < activeStart + activeLength) ||
        (activeStart + activeLength > totalDashes && index < (activeStart + activeLength) % totalDashes)) {
      return widget.isGroupChallersList? AppColors.primaryColor:AppColors.yellowColor; // Flow color
    }
    return widget.isGroupChallersList? AppColors.purpleLightColor:AppColors.whiteColor; // Base color
  }

  Widget _buildDash(Color color) {
    return Container(
      width: 24,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDashes,
            (index) => _buildDash(_getColor(index)),
      ),
    );
  }
}*/
