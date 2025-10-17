import 'package:apollo/bottom_sheets/location_bottom_sheet.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/models/country_model.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPersonalInfoController extends GetxController{

  String? email;
  String? password;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController location = TextEditingController();

  bool isButtonDisable = true;
  bool isDropdownOpen = false;



  String? goBack;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // if(Get.arguments!=null){
    //   email = Get.arguments['email'];
    //   password = Get.arguments['password'];
    // }
    if(Get.arguments!=null){
      goBack = Get.arguments['goBack'];
    }
    if (AuthData().isLogin) {
      final user = AuthData().userModel;
      firstName.text = user?.firstName??'';
      lastName.text = user?.lastName??'';
      location.text = user?.country??'';
      countryFlag = user?.countryFlag??'';

      if(user?.ageGroup!=null) {
        Future.delayed(Duration(milliseconds: 800),(){
        AgeGroupModel age = ageGroupList.firstWhere((e)=> e.age==user?.ageGroup);
        ageGroup = age;
        update();
        if(firstName.text.isNotEmpty && lastName.text.isNotEmpty && ageGroup!=null && location.text.isNotEmpty){
          isButtonDisable = false;
          update();

        }
      });
      }

    }

  }
  AgeGroupModel? ageGroup;
  List<AgeGroupModel> ageGroupList = [
    AgeGroupModel(age: "13-20"),
    AgeGroupModel(age: "21-30"),
    AgeGroupModel(age: "31-40"),
    AgeGroupModel(age: "41-50"),
    AgeGroupModel(age: "51-60"),
    AgeGroupModel(age: "61-70"),
    AgeGroupModel(age: "70+"),
  ];

  String countryFlag = '';
  void openLocationPicker(BuildContext context) async {
    Country selected = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationBottomSheet(),
    );

    if (selected != null) {
      apolloPrint( message: "Selected Country: $selected");
      location.text = selected.name;
      countryFlag = selected.emoji;
      if(firstName.text.isNotEmpty && lastName.text.isNotEmpty && ageGroup!=null){
        isButtonDisable = false;

      }else{
        isButtonDisable = true;
      }
      update();
    }else{
      CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'Country not selected');
    }
  }


}

class AgeGroupModel{
  String? age;
  AgeGroupModel({this.age});
}