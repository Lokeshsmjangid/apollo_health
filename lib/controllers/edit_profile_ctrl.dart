import 'dart:io';

import 'package:apollo/bottom_sheets/location_bottom_sheet.dart';
import 'package:apollo/models/country_model.dart';
import 'package:apollo/resources/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'sign_up_personal_info_ctrl.dart';

class EditProfileController extends GetxController{

  final AudioPlayer audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await audioPlayer.play(AssetSource(sound));

  }

  TextEditingController firstName = TextEditingController(text: 'Zain');
  TextEditingController lastName = TextEditingController(text: 'Vaccaro');
  TextEditingController emailCtrl = TextEditingController(text: 'test@gmail.com');
  TextEditingController locationCtrl = TextEditingController(text: 'USA ');

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
      locationCtrl.text = selected.name;
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
      print('Image selected: ${image.path}');
      selectedFile.add(File(image.path)) ;
      update();
    } else {
      print('No image selected.');
    }
  }

}