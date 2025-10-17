import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangePasswordCtrl extends GetxController{

  TextEditingController oldPassCtrl = TextEditingController();
  TextEditingController newPassCtrl = TextEditingController();
  TextEditingController confPassCtrl = TextEditingController();



  bool obscureOldPass = true;
  bool obscureNewPass = true;
  bool obscureConfPass = true;
  bool isButtonDisable = true;



}