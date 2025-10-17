import 'dart:convert';
import 'dart:developer';

import 'package:apollo/resources/Apis/api_models/common_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:apollo/resources/utils.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';


Future<CommonModel> medpardySubmitAnswerApi({
  int? gameID, int? xp,
  String? player, int? qId,
  String? selectedOption, int? qTimeTaken,
  int?round ,favorite,
  isStuck}) async {
  bool checkInternet = await hasInternetConnection();
  if (!checkInternet) { // checkInternet is false
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'No Internet Connection');
    return CommonModel.fromJson({});
  }
  try{
    String url = ApiUrls.medpardySubmitAnswerUrl;
    final Map<String, dynamic> map = {
      "projection_mode_game_id":gameID,
      "xp":xp,
      "player":player,
      "question_id":qId,
      "selected_option": selectedOption,
      "time_taken_seconds": qTimeTaken,
      "round": round,
      'favorite':favorite,
      'is_stuck':isStuck,

    };

    apolloPrint(message: '$url\n $map');
    http.Response response = await performPostRequest(url,map);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      log("\n response Start-->\n\n $data \n\n<--response End" );
      return CommonModel.fromJson(data);
    } else {
      handleErrorCases(response, data, url);
    }
  }
  catch (e) {
    if (e.toString().contains('Failed host lookup')) {
      CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'Cannot connect to server. Check your network or domain.');

    } else {
      CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'Something went wrong:\n$e');
      log('Something went wrong: $e');
    }
  }
  return CommonModel.fromJson({}); // please add try catch to use this
  // return CommonModel.fromJson(data); // please UnComment to print data and remove try catch
}