import 'package:apollo/resources/app_color.dart';
import 'package:flutter/material.dart';

class SegmentedProgressBar extends StatelessWidget {
  final int totalSegments;
  final int filledSegments;

  const SegmentedProgressBar({
    Key? key,
    this.totalSegments = 10,
    required this.filledSegments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSegments, (index) {
        bool isFilled = index < filledSegments;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isFilled ? AppColors.primaryColor : AppColors.purpleLightColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        );
      }),
    );
  }
}