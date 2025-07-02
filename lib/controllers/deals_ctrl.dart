import 'dart:ui';

import 'package:apollo/resources/app_assets.dart';
import 'package:get/get.dart';

class DealsController extends GetxController{
  final List<Map<String, dynamic>> servicesList = [
    {'image':AppAssets.dealsFrame1Img,'title': 'Products','color': Color(0xFF8A4CEB), 'border': Color(0xFF672BC0)},
    {'image':AppAssets.dealsFrame2Img,'title': 'Services','color': Color(0xFF4C9BF4), 'border': Color(0xFF126DE1)},
    {'image':AppAssets.dealsFrame3Img ,'title': 'Experiences','color': Color(0xFF35C87E), 'border': Color(0xFF0A9D58)},
  ];
}