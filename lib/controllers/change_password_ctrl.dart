import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangePasswordCtrl extends GetxController{

  TextEditingController oldPassCtrl = TextEditingController();
  TextEditingController newPassCtrl = TextEditingController();
  TextEditingController confPassCtrl = TextEditingController();



  bool obscureOldPass = false;
  bool obscureNewPass = false;
  bool obscureConfPass = false;
  bool isButtonDisable = true;



}