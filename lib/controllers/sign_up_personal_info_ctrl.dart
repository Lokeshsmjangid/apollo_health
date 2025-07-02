import 'package:apollo/bottom_sheets/location_bottom_sheet.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/models/country_model.dart';
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(Get.arguments!=null){
      email = Get.arguments['email'];
      password = Get.arguments['password'];
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