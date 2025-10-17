import 'dart:convert';
import 'dart:developer';
import 'package:apollo/resources/Apis/api_models/medpardy_models/medpardy_register_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:apollo/resources/utils.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';


Future<MedpardyRegisterModel> medpardyRegisterApi({
  String? player1,
  String? player2,
  String? player3,
}) async {
  bool checkInternet = await hasInternetConnection();
  if (!checkInternet) { // checkInternet is false
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'No Internet Connection');
    return MedpardyRegisterModel.fromJson({});
  }
  try{
    String url = ApiUrls.medpardyRegisterUrl;
    final Map<String, dynamic> map = {
      'player_1':player1,
      'player_2':player2,
      'player_3':player3,
    };

    apolloPrint(message: '$url\n map-->$map');
    http.Response response = await performPostRequest(url,map);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      log("\n response Start-->\n\n $data \n\n<--response End" );
      return MedpardyRegisterModel.fromJson(data);
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
  return MedpardyRegisterModel.fromJson({}); // please add try catch to use this
  // return MedpardyRegisterModel.fromJson(data); // please UnComment to print data and remove try catch
}