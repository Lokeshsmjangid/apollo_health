import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:apollo/resources/utils.dart';
import 'package:apollo/resources/Apis/api_constant.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_models/register_model.dart';


Future<RegisterResponseModel> notificationsUpdateApi({
  all,
  // dailyStreakEmail, dailyStreakPush,
  // liveEventPush, liveEventEmail,
  dailyDosePush,
  // dailyDoseEmail,
  newProductsPush,
  newFriendPush,systemNotificationPush
  // newProductsEmail,


}) async {
  bool checkInternet = await hasInternetConnection();
  if (!checkInternet) { // checkInternet is false
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'No Internet Connection');
    return RegisterResponseModel.fromJson({});
  }
  try{
    String url = ApiUrls.notificationUpdateUrl;


    Map<String, dynamic> map = {};
    if(all!=null){
      map = {
        'all':all,
      };
    }

    // daily Streak
    /*else if(dailyStreakEmail!=null){
      map = {
        'daily_streak_email':dailyStreakEmail,
      };
    }
    else if(dailyStreakPush !=null){
      map = {
        'daily_streak_push':dailyStreakPush,
      };
    }

    // live_event
    else if(liveEventPush!=null){
      map = {
        'live_event_push':liveEventPush,
      };
    }
    else if(liveEventEmail !=null){
      map = {
        'live_event_email':liveEventEmail,
      };
    }*/

    // daily dose
    else if(dailyDosePush!=null){
      map = {
        'daily_dose_push':dailyDosePush,
      };
    }
    // else if(dailyDoseEmail !=null){
    //   map = {
    //     'daily_dose_email':dailyDoseEmail,
    //   };
    // }

    // ye friendRequest/ Group play request
    else if(newProductsPush!=null){
      map = {
        'new_products_push':newProductsPush, // group play request
      };
    }
    else if(newFriendPush!=null){
      map = {
        'new_friend_push':newFriendPush, // friend request
      };
    }else if(systemNotificationPush!=null){
      map = {
        'system_notification_push':systemNotificationPush, // friend request
      };
    }
    // else if(newProductsEmail !=null){
    //   map = {
    //     'new_products_email':newProductsEmail,
    //   };
    // }







    apolloPrint(message: '$url\n $map \n ');
    http.Response response = await performPostRequest(url,map);
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      log("\n response Start-->\n\n $data \n\n<--response End" );
      return RegisterResponseModel.fromJson(data);
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
  return RegisterResponseModel.fromJson({}); // please add try catch to use this
  // return CommonResponseModel.fromJson(data); // please UnComment to print data and remove try catch
}