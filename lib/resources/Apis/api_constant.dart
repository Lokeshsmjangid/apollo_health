import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiUrls{
  // static const String googleApiKey = 'AIzaSyD0nHOa2gwnhvIY5NSWK5DNU7Rp72ocfO0'; // AIzaSyCej2svCH9KHHIuSUJVyHKWp7RJRi7M4_8
/*--------------------------------------------Google Api Key-----------------------------------------------------*/

  static const String domain = 'https://v5.checkprojectstatus.com/';
  static const String baseUrl = '${domain}apollo-health-app/api/';
  static const String emptyImgUrl = 'https://www.feed-image-editor.com/sites/default/files/perm/wysiwyg/image_not_available.png';

/*--------------------------------------------Api EndPoints-----------------------------------------------------*/

  static const String register = '${baseUrl}register';
  static const String forgotPassword = '${baseUrl}forgot-password';
}


/*--------------------------------------------api call methods-----------------------------------------------------*/

Future<http.Response> performGetRequest(String url) async {
  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ${AuthData().userToken}'
  };



  return await http.get(
    Uri.parse(url),
    headers: headers,
  );
}

Future<http.Response> performPostRequest(String url, Map<String, dynamic> map) async {
  log('${AuthData().userToken}');
  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ${AuthData().userToken}'
  };
  return await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(map),
  );
}

void handleErrorCases(http.Response response, dynamic data, String apiName) {

  if (response.statusCode == 400) {
    log('response.statusCode===>${response.statusCode}');
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: data['message']);
  }
  else if (response.statusCode == 422 || data['message'] == "Unauthenticated.") {
    print('coming in 400 or Unauthenticated in $apiName');
    LocalStorage().clearLocalStorage();
    Get.offAllNamed(AppRoutes.signInScreen);
  }
  else {
    log('Yahaa aaya ApisUrl me');
    log('response.statusCode===>${response.statusCode}');
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: data['message']);
    // showLoader(false);
    throw Exception(response.body);
  }
}