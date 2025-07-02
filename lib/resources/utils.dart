
import 'dart:developer';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'app_assets.dart';
import 'app_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'text_utility.dart';



boxShadow(){
  return BoxShadow(
    color: AppColors.containerBorderColor.withOpacity(0.4),
    spreadRadius: 0,
    blurRadius: 15,
    offset: Offset(0, 3), // changes position of shadow
  );
}
boxShadowTextField(){
  return BoxShadow(
    color: AppColors.containerBorderColor.withOpacity(0.2),
    spreadRadius: 0,
    blurRadius: 15,
    offset: Offset(4, 2), // changes position of shadow
  );
}

switchButton({bool value =false,void Function()? onTap}){
  return Stack(
    alignment: Alignment.centerLeft,
    children: [ GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.0, // Width of the switch button
        height: 20.0, // Height of the switch button
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          // border: Border.all(color: value?AppColors.primaryColor: AppColors.redColor,),
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
          color:value?AppColors.primaryColor.withOpacity(0.8):AppColors.buttonDisableColor, // Active and inactive colors
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft, // Position the switch
        child: Container(
          width: 18.0, // Width of the switch thumb
          height: 18.0, // Height of the switch thumb
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Circular thumb
            color: AppColors.whiteColor, // Thumb color
          ),
        ).marginAll(2),
      ),
    ) ],
  );
}

Widget backBar({
  bool isBack = true,
  bool isCancel = false,
  bool isMail = false,
  bool isLogout = false,

  void Function()? onTap,void Function()? onTapCancel,void Function()? onTapMail,void Function()? onTapLogout,
  String title ="",Color titleColor = AppColors.whiteColor,Color backButtonColor = AppColors.whiteColor}){ return // AppBar
    Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [

        if(isBack)
        backButton(onTap: onTap,backButtonColor: backButtonColor),
        Spacer(),
        addText400(title,fontSize: 32,fontFamily: 'Caprasimo',color: titleColor),
        Spacer(),
        isCancel ? GestureDetector(
            onTap: onTapCancel,
            child: Image.asset(AppAssets.closeIcon,height: 24)) : SizedBox.shrink(),

        if(isMail)
        GestureDetector(
            onTap: onTapMail,
            child: SvgPicture.asset(AppAssets.mailIcon,height: 24)),

        if(isLogout)
        GestureDetector(
            onTap: onTapLogout,
            child: SvgPicture.asset(AppAssets.exitIcon,height: 24)),
      ],
    );
}

Widget backButton({void Function()? onTap,Color? backButtonColor}){
  return GestureDetector(
  onTap: onTap,
    child: Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: backButtonColor??AppColors.blackColor,width: 2)
      ),
      child: Image.asset(AppAssets.backIcon,color: backButtonColor??AppColors.blackColor).marginAll(4),),
  );
}

// toast
showToast(String msg){ return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
  );}

showToastError(String msg){ return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );}

showToastBack(BuildContext context,String msg){
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add),
          SizedBox(width: 12.0),
          addText400(msg, color: Colors.white),
        ],
      ),
    );

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20.0,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: toast,
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });

}

Widget CustomImageNetwork(
    String imageUrl, {
      double? height,
      double? width,
      BoxFit fit = BoxFit.fill,
    }) {
  return Image.network(
    imageUrl,
    fit: fit,
    height: height ?? kMinInteractiveDimension,
    width: width ?? kMinInteractiveDimension,
    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child; // If loading is complete, show the image

      return Center(
        child: CircularProgressIndicator(
          color: Colors.blue.withOpacity(0.20), // Replace with your AppColors.secondaryColor
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    },
    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      return Center(
        child: Icon(Icons.error, color: Colors.red), // Display an error icon if the image fails to load
      );
    },
  );
}


apolloPrint({required String message}){
  return log(message);
}



// validate fields
String? validateField({
  required String field,
  required String? value,
  String? originalPassword, // Pass this only for confirm password
}) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $field';
  }

  if (field.toLowerCase() == 'email') {
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
  }

  if (field.toLowerCase() == 'password' || field.toLowerCase() == 'old password' || field.toLowerCase() == 'new password') {
    // Password must be at least 8 characters, contain one uppercase, one number, and one special character
    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$').hasMatch(value)) {
      return 'Use at least 8 characters with one uppercase letter, one number, and one special character.';
    }
  }

  if (field.toLowerCase() == 'confirm password') {
    if (originalPassword == null || value != originalPassword) {
      return 'Password don’t match';
    }
  }

  return null;
}










