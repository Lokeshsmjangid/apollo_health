import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:apollo/resources/utils.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_models/register_model.dart';

Future<RegisterResponseModel> profileApi() async {
  bool checkInternet = await hasInternetConnection();
  if (!checkInternet) { // checkInternet is false
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'No Internet Connection');
    return RegisterResponseModel.fromJson({});
  }
  try{
    String url = ApiUrls.profileUrl;

    apolloPrint(message: '$url\n ');
    http.Response response = await performGetRequest(url);
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

    } else {
      handleErrorCases(response, data, url);
    }
  }
  catch (e) {
    if (e.toString().contains('Failed host lookup')) {
      CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'Cannot connect to server. Check your network or domain.');

    } else {
      CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'ApiUrls.profileUrl-->\n Something went wrong:\n$e');
      log('Something went wrong: $e');
    }

  }
  return RegisterResponseModel.fromJson({}); // please add try catch to use this
  // return CommonResponseModel.fromJson(data); // please UnComment to print data and remove try catch
}