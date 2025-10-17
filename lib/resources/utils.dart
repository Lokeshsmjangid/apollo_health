import 'dart:developer';
import 'package:apollo/controllers/app_push_nottification.dart';
import 'package:apollo/main.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_assets.dart';
import 'app_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'text_utility.dart';



String shareText="Hi! Ever wish learning about health felt more like a fun game? 🎯 Check out Apollo MedGames. It’s crafted by doctors for everyone and full of smart quizzes, fun facts, and brainy puzzles!\n\nTest yourself in categories like "
    "‘Myth vs. Fact’ and ‘Med Pop Culture’ "
    "(yep, medical moments in movies!).\n\nThink you can beat my score? Let’s find out! 👀💪\n\nHere’s my referral code — use it on the sign-up page: ${AuthData().userModel?.referralCode}\n\n"
    "Play now:\niOS 👉 https://apps.apple.com/us/app/apollo-medgames/id6751579578?refCode=${AuthData().userModel?.referralCode}\n\nAndroid 👉 https://play.google.com/store/apps/details?id=com.apollomedgames.app&refCode=${AuthData().userModel?.referralCode}";

boxShadow() {
  return BoxShadow(
    color: AppColors.containerBorderColor.withOpacity(0.4),
    spreadRadius: 0,
    blurRadius: 15,
    offset: Offset(0, 3), // changes position of shadow
  );
}

boxShadowTextField() {
  return BoxShadow(
    color: AppColors.containerBorderColor.withOpacity(0.2),
    spreadRadius: 0,
    blurRadius: 15,
    offset: Offset(4, 2), // changes position of shadow
  );
}

switchButton({bool value = false, void Function()? onTap}) {
  return Stack(
    alignment: Alignment.centerLeft,
    children: [ GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.0,
        // Width of the switch button
        height: 20.0,
        // Height of the switch button
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          // border: Border.all(color: value?AppColors.primaryColor: AppColors.redColor,),
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
          color: value ? AppColors.primaryColor.withOpacity(0.8) : AppColors
              .buttonDisableColor, // Active and inactive colors
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        // Position the switch
        child: Container(
          width: 18.0, // Width of the switch thumb
          height: 18.0, // Height of the switch thumb
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Circular thumb
            color: AppColors.whiteColor, // Thumb color
          ),
        ).marginAll(2),
      ),
    )
    ],
  );
}

Widget backBar({
  bool isBack = true,
  bool isCancel = false,
  bool trailing = false,
  bool isMail = false,
  bool isLogout = false,

  void Function()? onTap, void Function()? onTapCancel, void Function()? onTapMail, void Function()? onTapLogout,
  String title = "", Color titleColor = AppColors
      .whiteColor, Color backButtonColor = AppColors.whiteColor}) { return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [

        if(isBack)
          backButton(onTap: onTap, backButtonColor: backButtonColor),
        Spacer(),
        addText400(
            title, fontSize: 32, fontFamily: 'Caprasimo', color: titleColor),
        Spacer(),
        isCancel ? GestureDetector(
            onTap: onTapCancel,
            child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  // color: Colors.red,
                    shape: BoxShape.circle
                ),
                child: Image.asset(AppAssets.closeIcon, height: 24).marginAll(6))) : SizedBox.shrink(),
        if(trailing)
        GestureDetector(
            onTap: onTapCancel,
            child: Container(
                height: 36,
                width: 36,
                )),

        if(isMail)
          GestureDetector(
              onTap: onTapMail,
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  SvgPicture.asset(AppAssets.messageIcon, height: 28),
                    Positioned(
                        top: -1,
                        right: -2,
                        child: GetBuilder<AppPushNotification>(builder: (logic) {
                          return logic.friendRequestCount.value>0?Container(height: 10, width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.redColor,
                              // border: Border.all(width: 1,color: Colors.white)

                            ),
                            child: Center(child: Text('${logic.friendRequestCount.value}', textAlign: TextAlign
                                .center, style: TextStyle(height: 1.3,
                                fontSize: 8,
                                color: AppColors.whiteColor),)),
                          ):SizedBox.shrink();
                        }))
                ],
              )),

        if(isLogout)
          GestureDetector(
              onTap: onTapLogout,
              child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      shape: BoxShape.circle
                  ),
                  child: SvgPicture.asset(AppAssets.exitIcon).marginAll(6))),
      ],
    ); }

Widget backButton({void Function()? onTap, Color? backButtonColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
          // color: Colors.red,
          // shape: BoxShape.circle
      ),
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: Colors.red,
            border: Border.all(
                color: backButtonColor ?? AppColors.blackColor, width: 2)
        ),
        child: Image.asset(
            AppAssets.backIcon,
            color: backButtonColor ?? AppColors.blackColor).marginAll(4)).marginAll(6),
    ),
  );
}

Widget socialButton({
  required String label,
  required String labelIcon, // SVG or PNG path
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: onPressed,

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide( // 👈 Add border here
            color: AppColors.primaryColor,
            width: 1.0,
          ),
        ),
        elevation: 1,
      ),
      icon: Container(
        height: 24,
        width: 24,
        // margin: const EdgeInsets.only(right: 8),
        child: SvgPicture.asset(labelIcon),
      ).marginOnly(right: 12),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}


// toast
showToast(String msg) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

showToastError(String msg) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

showToastBack(BuildContext context, String msg) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.black,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppAssets.logo,height: 24,width: 24),
        SizedBox(width: 12.0),
        addText400(msg, color: Colors.white,),
      ],
    ),
  );

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) =>
        Positioned(
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


apolloPrint({required String message}) {
  return log(message);
}

// to check internet
Future<bool> hasInternetConnection() async {
  // final connectivityResult = await Connectivity().checkConnectivity();
  // bool isInternet = connectivityResult.first == ConnectivityResult.none
  //     ? false
  //     : true;
  // apolloPrint(message: 'internet Status:::$connectivityResult');
  // apolloPrint(message: 'internet :::$isInternet');
  // return isInternet;

  return await InternetConnection().hasInternetAccess;
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

  if (field.toLowerCase() == 'password' ||
      field.toLowerCase() == 'old password' ||
      field.toLowerCase() == 'new password') {
    // Password must be at least 8 characters, contain one uppercase, one number, and one special character
    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$').hasMatch(
        value)) {
      return 'Use at least 8 characters with one uppercase letter, one number, and one special character.';
    }
  }

  if (field.toLowerCase() == 'confirm password') {
    if (originalPassword == null || value != originalPassword) {
      return 'Confirm password does not match.';
    }
  }

  return null;
}


buildCpiLoader() {
  return Center(
    child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle
              ),
              child: ClipRRect(
                  child: SvgPicture.asset(AppAssets.logo).marginAll(6))),
          Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                // color: AppColors.primaryColor,
                // borderRadius: BorderRadius.circular(4.0),
                shape: BoxShape.circle,
                // image: DecorationImage(image: AssetImage(AppAssets.commonLogo)),
              ),
              child: CircularProgressIndicator(
                color: AppColors.secondaryColor, strokeWidth: 4,).marginAll(1))
        ]
    ),
  );
}

Widget CachedImageCircle2({
  required String? imageUrl,
  double? height,
  double? width,
  bool isCircular = true,
  BoxFit fit = BoxFit.cover,
}) {
  final bool isSvg = imageUrl != null && imageUrl.toLowerCase().endsWith('.svg');
  final double finalHeight = height ?? 150;
  final double finalWidth = width ?? 150;

  return Container(
    height: finalHeight,
    width: finalWidth,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: BoxDecoration(
      shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
    ),
    child: imageUrl == null || imageUrl.isEmpty
        ? _placeholderIcon()
        : isSvg
        ? SvgPicture.network(
      imageUrl,
      fit: fit,
      height: finalHeight,
      width: finalWidth,
      placeholderBuilder: (context) => _loader(),
      // You could also add errorBuilder in recent versions of flutter_svg
    )
        : CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      height: finalHeight,
      width: finalWidth,
      placeholder: (context, url) => _loader(),
      errorWidget: (context, url, error) => _errorIcon(),
    ),
  );
}

Widget apolloAvatar({double? height,double? width}){
  return Container(
      height: height??150,
      width: width??150,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.apolloGreyColor)),
      child: SvgPicture.asset(AppAssets.logo));
}

Widget _loader() {
  return Center(
    child: CircularProgressIndicator(
      color: Colors.blue.withOpacity(0.2),
    ),
  );
}

Widget _errorIcon() {
  return Center(
    child: Icon(Icons.broken_image, color: Colors.grey),
  );
}

// Widget _placeholderIcon() {
//   return Center(
//     child: Icon(Icons.image_not_supported, color: Colors.grey.shade400),
//   );
// }
Widget _placeholderIcon({
  double? height,
  double? width,
  bool isCircular = true,
  BoxFit fit = BoxFit.cover,
}) {
  return CachedNetworkImage(
    imageUrl: ApiUrls.emptyImgUrl,
    fit: fit,
    height: height ?? 150,
    width: width ?? 150,
    placeholder: (context, url) => _loader(),
    errorWidget: (context, url, error) => _errorIcon(),
  );
}

Color hexToColor(String hex) {
  return Color(int.parse("0xff$hex"));
}

Color hexToColor1(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex'; // Add opacity if not provided
  }
  return Color(int.parse(hex, radix: 16));
}

String getTruncatedName(String firstName, String lastName,{int maxlength = 20}) {
  int maxLength = maxlength??20;

  String fullName = '$firstName $lastName';

  if (fullName.length <= maxLength) {
    return fullName;
  }
  int allowedLastNameLength = maxLength - (firstName.length + 1);

  if (allowedLastNameLength <= 0) {
    return '${fullName.substring(0, maxLength)}…';
  }

  String truncatedLastName = lastName.substring(0, allowedLastNameLength);
  return '$firstName $truncatedLastName…';
}

String titleCase(String text) {
  return text.split(' ').map((word) {
    return word.split('-').map((part) {
      if (part.isEmpty) return part;
      return part[0].toUpperCase() + part.substring(1);
    }).join('-');
  }).join(' ');
}

String truncateWithEllipsis(String text, int length) {
  return text.length > length ? "${text.substring(0, length)}..." : text;
}

String formatLeaderBoardNamePodium(String firstName, String lastName) {
  // if (lastName.isEmpty) return firstName;
  // String lastInitial = lastName[0].toUpperCase();
  // return '$firstName $lastInitial.';

  String truncatedFirstName =
  firstName.length > 6 ? '${firstName.substring(0, 6)}.' : firstName;

  if (lastName.isEmpty) return truncatedFirstName;

  String lastInitial = lastName[0].toUpperCase();
  return '$truncatedFirstName $lastInitial.';

}

String formatLeaderBoardName(String firstName, String lastName) {
  if (lastName.isEmpty) return firstName;
  String lastInitial = lastName[0].toUpperCase();
  return '$firstName $lastInitial.';
}

Future<void> launchURL({required String url}) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

Widget buildTabButton(String text, bool isSelected, VoidCallback onTap) { return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 0),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFD700) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: addText600(
          text,
          fontSize: 16,
          height: 22,
          color: AppColors.blackColor,
        ),
      ),
    ),
  );}



