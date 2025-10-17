import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:apollo/resources/utils.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_models/register_model.dart';

Future<RegisterResponseModel> sendPaymentToBackendApi({purchaseStatus,
  startDate,endDate,customerId,purchaseID,plan_id,amount,source,List<Map<String,dynamic>> customerIds=const []}) async {
  print('Api Call For Backend');
  bool checkInternet = await hasInternetConnection();
  if (!checkInternet) { // checkInternet is false
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'No Internet Connection');
    return RegisterResponseModel.fromJson({});
  }
  try{
    String url = ApiUrls.sendSubscriptionDetailToBackend;
    final Map<String, dynamic> map = {
      'PurchaseStatus':purchaseStatus,
      'transactionDate':startDate,
      'verificationData':customerId,
      'purchaseID':purchaseID,
      'plan_id':plan_id,
      'amount':amount,
      'end_date':endDate,
      'buy_source':source,
    };
    if(customerIds.isNotEmpty) { map['extra_ids'] = customerIds;}
    print( '$url\n $map \n ');
    log( '$url\n $map \n ');
    http.Response response = await performPostRequest(url,map);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      log("\n response Start-->\n\n $data \n\n<--response End" );
      return RegisterResponseModel.fromJson(data);
      // try {
      //   return RegisterResponseModel.fromJson(data);
      // } catch (e, s) {
      //   log('❌ RegisterResponseModel parsing failed: $e');
      //
      //   // 🔍 Try to find which key caused the issue
      //   data.forEach((key, value) {
      //     try {
      //       // Attempt to encode/decode each field like model would
      //       jsonEncode(value);
      //     } catch (innerError) {
      //       log('❌ Problematic key detected → $key | value: $value | type: ${value.runtimeType}');
      //     }
      //
      //     // You can also check types manually if your model expects String
      //     if (value is! String && value != null) {
      //       // This will catch the case: int instead of String
      //       showToast('⚠️ Suspicious key: $key | value: $value | type: ${value.runtimeType}');
      //     }
      //   });
      //
      //   log('📄 Stacktrace: $s');
      //   rethrow;
      // }
    }
    else { handleErrorCases(response, data, url);}}
  catch (e) {
    if (e.toString().contains('Failed host lookup')) {
      CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'Cannot connect to server. Check your network or domain.');

    }
    else {
      CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'ApiUrls.sendSubscriptionDetailToBackend-->Something went wrong:\n$e');
      log('Something went wrong: $e');
    }
  }
  return RegisterResponseModel.fromJson({}); // please add try catch to use this
  // return RegisterResponseModel.fromJson(data); // please UnComment to print data and remove try catch
}