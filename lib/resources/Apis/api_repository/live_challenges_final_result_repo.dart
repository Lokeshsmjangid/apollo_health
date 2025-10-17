import 'dart:convert';
import 'dart:developer';
import 'package:apollo/resources/Apis/api_models/live_challenge_final_result.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:apollo/resources/utils.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';


Future<LiveChallengeFinalResultModel> resultLiveChallengesApi({liveChallengeId}) async {
  bool checkInternet = await hasInternetConnection();
  if (!checkInternet) { // checkInternet is false
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'No Internet Connection');
    return LiveChallengeFinalResultModel.fromJson({});
  }

  try{
    String url = ApiUrls.liveChallengeFinalResultUrl;

    final Map<String, dynamic> map = {
      'live_challenge_id':liveChallengeId
    };



    apolloPrint(message: '$url\n');
    http.Response response = await performPostRequest(url,map);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      log("\n response Start-->\n\n $data \n\n<--response End" );
      return LiveChallengeFinalResultModel.fromJson(data);
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
  return LiveChallengeFinalResultModel.fromJson({}); // please add try catch to use this
  // return LiveChallengeFinalResultModel.fromJson(data); // please UnComment to print data and remove try catch
}