import 'dart:convert';
import 'dart:developer';
import 'package:apollo/resources/Apis/api_models/common_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:apollo/resources/utils.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_models/register_model.dart';


Future<CommonModel> liveChallengeFormApi({required String name, required String address, required String mobile}) async {
  bool checkInternet = await hasInternetConnection();
  if (!checkInternet) { // checkInternet is false
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'No Internet Connection');
    return CommonModel.fromJson({});
  }
  try{
    String url = ApiUrls.liveChallengeFormUrl;
    final Map<String, dynamic> map = {
      'name':name,
      'address':address,
      'phone':mobile,
    };
    apolloPrint(message: '$url\n $map \n ');
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
  // return CommonResponseModel.fromJson(data); // please UnComment to print data and remove try catch
}