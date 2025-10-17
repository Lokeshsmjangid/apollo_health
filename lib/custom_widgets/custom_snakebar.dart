import 'package:flutter/material.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';

class CustomSnackBar {
  // Method to show a success Snackbar
  void showSnack(
      BuildContext context, {
        String message = "Thanks for using the Apollo",
        bool isSuccess = true,
        Duration duration = const Duration(seconds: 2)}) {
    // Fluttertoast.showToast(
    //   msg: message,
    //
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: isSuccess ? AppColors.correctAnsColor : AppColors.wrongAnsColor,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
    if(message.isNotEmpty)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: addText500( message, textAlign: TextAlign.center),
        duration: duration,
        backgroundColor: isSuccess?AppColors.correctAnsColor:AppColors.wrongAnsColor, // Change color to green for success
      ));
  }
}
