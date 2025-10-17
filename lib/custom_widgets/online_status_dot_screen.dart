import 'package:apollo/resources/app_color.dart';
import 'package:flutter/material.dart';

class OnlineStatusDot extends StatelessWidget {
  final DateTime lastActiveTime;

  OnlineStatusDot({required this.lastActiveTime});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(lastActiveTime);
    final diffInMinutes = difference.inMinutes;

    Color dotColor;

    if (diffInMinutes <= 60) {
      dotColor = Colors.green; // Online within last 1 hour
    } else if (diffInMinutes <= 180) {
      dotColor = AppColors.yellowColor; // Apollo orange (1-3 hours)
    } else {
      dotColor = AppColors.containerBorderColor; // Offline > 3 hours
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: dotColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
