
import 'package:apollo/resources/Apis/api_repository/wheel_for_wellness_result_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/screens/game_mode/medlingo/medlingo_result_screen.dart';
import 'package:apollo/screens/game_mode/wheel_of_wellness/wheel_of_wellness_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MedlingoGameOverDialog extends StatefulWidget {
  String? showText;
  Map<String, dynamic> gameStates;
  MedlingoGameOverDialog({super.key,this.showText ,this.gameStates=const {}});

  @override
  State<MedlingoGameOverDialog> createState() => _MedlingoGameOverDialogState();
}

class _MedlingoGameOverDialogState extends State<MedlingoGameOverDialog> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goBack();
  }
  goBack(){
    Future.delayed(
        Duration(milliseconds: widget.showText=="wrongPosition"?1500:5000),
            (){
          // var showText = widget.showText
          Get.back();
          if(widget.showText=='terrific'){
            // Get.to(WheelOfWellnessResult(showText: widget.showText,correctAns: widget.correctAnswer,));
          } else if(widget.showText=="tryAgain"){
            // Get.to(WheelOfWellnessResult(showText: widget.showText,correctAns: widget.correctAnswer,));
          } else if(widget.showText=="gameOver"){
            // Get.to(WheelOfWellnessResult(showText: widget.showText,correctAns: widget.correctAnswer,hP: hp));
            Get.to(()=>MedLingoResult(
                showText: 'tryAgain',
                correctAns: widget.gameStates['correctAns'],
                hP: 0,
                showDesc: widget.gameStates['showDesc']));
          }

        });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: AlertDialog(

        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Color.fromRGBO(39, 35, 44, 0.70),
        // surfaceTintColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        title: SizedBox.shrink(),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(widget.showText=='terrific')
              SvgPicture.asset(AppAssets.textTerrificImg),
              if(widget.showText=='tryAgain')
              SvgPicture.asset(AppAssets.textTryAgainImg),
              if(widget.showText=='wrongPosition')
              SvgPicture.asset(AppAssets.textWrongPositionImg),
              if(widget.showText=='gameOver')
              SvgPicture.asset(AppAssets.textGameOverImg),
              addHeight(300),
            ],
          ).marginSymmetric(horizontal: 16),
        ),
      ),
    );
  }
}
