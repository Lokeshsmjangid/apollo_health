import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:flutter/material.dart';


class AppButton extends StatefulWidget {
  final String buttonText;
  final Color? buttonColor;
  final Color? buttonTxtColor;
  void Function()? onButtonTap;
  AppButton({super.key, required this.buttonText,this.onButtonTap,this.buttonColor,this.buttonTxtColor});

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onButtonTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 52,
        decoration: BoxDecoration(
            color: widget.buttonColor??AppColors.primaryColor,
            borderRadius: BorderRadius.circular(1000)),
        child: Center(child: addText500(widget.buttonText,color: widget.buttonTxtColor??AppColors.whiteColor,fontSize: 16)),
      ),
    );
  }
}
