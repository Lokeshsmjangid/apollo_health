import 'dart:convert';
import 'dart:developer';
import 'package:apollo/resources/Apis/api_models/daily_dose_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:apollo/resources/utils.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';


Future<DailyDoseModel> dailyDoseApi({int? isRead}) async {
  bool checkInternet = await hasInternetConnection();
  if (!checkInternet) { // checkInternet is false
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'No Internet Connection');
    return DailyDoseModel.fromJson({});
  }
  try{

    String? url;
    if(isRead!=null){
      url = '${ApiUrls.dailyDoseUrl}?is_read=$isRead';
    }else{
    url = ApiUrls.dailyDoseUrl;
    }

    apolloPrint(message: '$url \n ');
    http.Response response = await performGetRequest(url);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      log("\n response Start-->\n\n $data \n\n<--response End" );
      return DailyDoseModel.fromJson(data);
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
  return DailyDoseModel.fromJson({}); // please add try catch to use this
  // return DailyDoseModel.fromJson(data); // please UnComment to print data and remove try catch
}