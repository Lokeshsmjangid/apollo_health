import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/resources/Apis/api_models/register_model.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<RegisterResponseModel> profileUpdateApi({
  required String firstName,
  required String lastName,
  required String ageGroup,
  required String country,
  required String countryFlag,
  File? image,
}) async {
  bool checkInternet = await hasInternetConnection();
  if (!checkInternet) { // checkInternet is false
    showToastError('No Internet Connection');
    return RegisterResponseModel.fromJson({});
  }
  try {
    String? url = ApiUrls.profileUpdateUrl;
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add headers
    request.headers.addAll({
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ${AuthData().userToken}',
    });

    // Add fields

    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['age_group'] = ageGroup;
    request.fields['country'] = country;
    request.fields['country_flag'] = countryFlag;



    // Add image if available
    if (image != null && await image.exists()) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', image.path));
    }

    // Log request before sending
    log("🔽 Profile Setup Request Fields:");
    request.fields.forEach((key, value) {
      log("  $key: $value");
    });

    if (request.files.isNotEmpty) {
      log("🖼️ Files:");
      for (var file in request.files) {
        log("  Field: ${file.field}, Filename: ${file.filename}, Path: ${file.filename}");
      }
    }
    else {
      log("🖼️ No files uploaded.");
    }

    // Send request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      log("$url \n✅ Response Start:\n$data\n✅ Response End");
      return RegisterResponseModel.fromJson(data);
    } else {
      handleErrorCases(response, data, url);
    }
  }
  catch (e) {
    if (e.toString().contains('Failed host lookup')) {
      CustomSnackBar().showSnack(Get.context!,message: 'Cannot connect to server. Check your network or domain.',isSuccess: false);

    } else {

      CustomSnackBar().showSnack(Get.context!,message:'Something went wrong',isSuccess: false);

      log('Something went wrong: $e');
    }
  }
  return RegisterResponseModel.fromJson({});
}
