import 'dart:convert';
import 'dart:io';

import 'package:apollo/bottom_sheets/location_bottom_sheet.dart';
import 'package:apollo/models/country_model.dart';
import 'package:apollo/resources/Apis/api_repository/profile_update_repo.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'sign_up_personal_info_ctrl.dart';

class EditProfileController extends GetxController{

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();
  String? profileImage;
  String? countryFlag;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(AuthData().isLogin){
      final user = AuthData().userModel;
      firstName.text = user?.firstName??'';
      lastName.text = user?.lastName??'';
      emailCtrl.text = user?.email??'';
      locationCtrl.text = user?.country??'';
      countryFlag = user?.countryFlag??'';
      profileImage = user?.profileImage??'';
      Future.delayed(Duration(milliseconds: 800), (){
        // AgeGroupModel age = ageGroupList.firstWhere((e)=> e.age==user?.ageGroup);
        // ageGroup = age;
        // update();
        AgeGroupModel? age = ageGroupList.firstWhere(
              (e) => e.age == user?.ageGroup,
          orElse: () => ageGroupList.first, // default value if not found
        );
        ageGroup = age;
        update();
      } );

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
    final Country? selected = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationBottomSheet(),
    );

    if (selected != null) {
      apolloPrint(message: "Selected Country: $selected");
      locationCtrl.text = selected.name;
      countryFlag = selected.emoji;
      update();
    }
  }

  List<File?> selectedFile = [];
  void showCameraGalleryDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  pickImage(ImageSource.camera); // Open the camera
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Open Gallery'),
                onTap: () {
                  Navigator.pop(context); // Close the dialog
                  pickImage(ImageSource.gallery); // Open the gallery
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      selectedFile.clear();
      // Handle the selected image
      apolloPrint(message: 'Image selected: ${image.path}');
      selectedFile.add(File(image.path)) ;
      update();
      showLoader(true);
      profileUpdateApi(
          firstName: firstName.text, lastName: lastName.text,
          ageGroup: '${ageGroup?.age}', country: locationCtrl.text,countryFlag: '$countryFlag',
        image: selectedFile[0]

      ).then((value){
        showLoader(false);
        if(value.status==true){
          LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
          AuthData().getLoginData();
          LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
          profileImage = value.data?.profileImage;
          update();
        }
      });
    } else {
      apolloPrint(message: 'No image selected.');
    }
  }

  String formatDate(int timestamp) {
    // timestamp = milliseconds
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
  }

}