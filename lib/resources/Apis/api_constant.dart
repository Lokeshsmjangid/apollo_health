import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:apollo/resources/utils.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';

class ApiUrls{
  // Old package name = com.example.apollo.demo
  // package name = com.apollomedgames.app

  /// admob ads
  static const String adUnitIdBanner = 'ca-app-pub-4001482360453796/9423537135';
  static const String adUnitIdBannerIos = 'ca-app-pub-4001482360453796/3518837285';
  static const String adUnitIdInterstitial = 'ca-app-pub-4001482360453796/4913446484';
  static const String adUnitIdInterstitialIos = 'ca-app-pub-4001482360453796/3544524492';

  /// unity ads
  static const String gameIdIOS = '5960682';
  static const String gameIdAndroid = '5960683';
  static const String unityBannerIOS = 'Banner_iOS';
  static const String unityBannerAndroid = 'Banner_Android';
  static const String unityInterstitialIOS = 'Interstitial_iOS';
  static const String unityInterstitialAndroid = 'Interstitial_Android';

  // Domain And Base Url
  // static const String domain = 'https://apollomedgames.com/';
  static const String baseUrl = '${domain}api/';
  static const String domain = 'https://v5.checkprojectstatus.com/apollo-health-app/';
  static const String emptyImgUrl = 'https://www.feed-image-editor.com/sites/default/files/perm/wysiwyg/image_not_available.png';

/*-------------------------------------------- API ENDPOINTS -----------------------------------------------------*/

  // guest login
  static const String guestLogin = '${baseUrl}disclaimerStatus'; // for guest
  static const String checkInstitutionalCode = '${baseUrl}Institutional'; // for guest


  static const String loginUrl = '${baseUrl}login';
  static const String logoutUrl = '${baseUrl}logout';
  static const String blurStatusUrl = '${baseUrl}blurStatus';
  static const String onboardingUrl = '${baseUrl}appSetting';
  static const String socialLoginUrl = '${baseUrl}socialLogin';
  static const String onlineStatusUrl = '${baseUrl}userActive'; // to update user online status
  static const String registerUrl = '${baseUrl}registerStepOne';
  static const String signUpBonusUrl = '${baseUrl}freeHpStatus';
  static const String profileDeleteUrl = '${baseUrl}ProfileDelete';
  static const String changePasswordUrl = '${baseUrl}changePassword';
  static const String homeBlurStatusUrl = '${baseUrl}homeBlurSatatus';
  static const String registerPersonalUrl = '${baseUrl}registerStepTwo';
  static const String registerDisclaimerUrl = '${baseUrl}registerStepThree';
  static const String registerEmailVerifyOtpUrl = '${baseUrl}registerOtpVerfy';
  static const String profileDeletePermanentUrl = '${baseUrl}ProfilePermanentDelete';

  // forgot password
  static const String otpVerifyUrl = '${baseUrl}otpVerify';
  static const String forgotPasswordUrl = '${baseUrl}forgotPassword';
  static const String updatePasswordUrl = '${baseUrl}updatePassword';

  // Notification list
  static const String notificationListUrl = '${baseUrl}NotificationList';
  static const String notificationDeleteUrl = '${baseUrl}notificationDelete';
  static const String clearAllNotificationUrl = '${baseUrl}clearAllNotification';

  // leaderboard
  static const String leaderBoardUrl = '${baseUrl}leaderboard';

  // Category
  static const String categoryUrl = '${baseUrl}category-list';
  static const String categoryPassUrl = '${baseUrl}categoryPass';

  // Profile
  static const String profileUrl = '${baseUrl}profile';
  static const String profileUpdateUrl = '${baseUrl}profileUpdate';

  static const String addFriendUrl = '${baseUrl}friendRequestSend';
  static const String friendRequestListUrl = '${baseUrl}friendRequestList';
  static const String acceptFriendRequestUrl = '${baseUrl}friendRequestUpdate';

  static const String mutualFriendUrl = '${baseUrl}mutualFriendList';
  static const String friendProfileUrl = '${baseUrl}friendProfileDetail';

  // Cms pages (about, privacy, terms)
  static const String cmsPageUrl = '${baseUrl}CmsSetting';

  // need help and submit topic
  static const String customFeedUrl = '${baseUrl}CustomerFeed';

  // Settings Customization
  static const String settingsUpdateUrl = '${baseUrl}settingUpdate';
  static const String notificationUpdateUrl = '${baseUrl}notificationUpdate';
  static const String settingsCustomizationUrl = '${baseUrl}getAllNotificationSettings';

  // deals
  static const String dealsServicesUrl = '${baseUrl}getAllServices';
  static const String dealsProductsUrl = '${baseUrl}getAllProducts';
  static const String dealsExperiencesUrl = '${baseUrl}getAllExperiences';

  // Daily Dose
  static const String dailyDoseUrl = '${baseUrl}dailyDoes';

  /*-------------------------------------------- GAMES API -----------------------------------------------------*/

  // Solo play
  static const String friendListUrl = '${baseUrl}friendList';
  static const String quitSoloPlayUrl = '${baseUrl}leaveQuiz';
  static const String submitAnswerUrl = '${baseUrl}submitAnswer';
  static const String submitResultUrl = '${baseUrl}submitResult';
  static const String startSoloPlayUrl = '${baseUrl}startSoloPlay';
  static const String quitGroupPlayUrl = '${baseUrl}groupLeaveQuiz';

  // Group play
  static const String playRequestUrl = '${baseUrl}playRequest';
  static const String sendPlayRequestUrl = '${baseUrl}sendRequest';
  static const String startGroupPlayUrl = '${baseUrl}startGroupPlay';
  static const String groupFriendListUrl = '${baseUrl}groupFriendList';
  static const String challengersListUrl = '${baseUrl}challengersList';
  static const String updateResultGroupUrl = '${baseUrl}getUpdateResult'; // only for group result
  static const String playRequestAcceptUrl = '${baseUrl}groupPlayRequest';
  static const String submitAnswerGroupUrl = '${baseUrl}submitAnswerGroup';
  static const String submitResultGroupUrl = '${baseUrl}submitResultGroup';
  static const String playRequestCancelUrl = '${baseUrl}friendRequestCancel';
  static const String groupPlayRequestCancelUrl = '${baseUrl}groupPlayRequestCancel';
  static const String pointDistributionGroupUrl = '${baseUrl}groupPointDistribution'; // only for group result

  // Wheel for wellness
  static const String  wheelForWellnessUrl= '${baseUrl}wellnessStart';
  static const String  wheelForWellnessResultUrl= '${baseUrl}submitAnswerWellness';
  static const String  dailyLimitWellForWellnessUrl= '${baseUrl}checkWellnessGameLimit';

  // Live - Challenge
  static const String  liveChallengeListUrl= '${baseUrl}liveChallengeList';
  static const String  liveChallengeFormUrl = '${baseUrl}liveChallengeFrom';
  static const String  liveChallengeListAllUrl= '${baseUrl}allLiveChallengeList';
  static const String  scoreLiveChallengeUrl = '${baseUrl}LiveChallengeYourScore';
  static const String  liveChallengeRegisterUrl= '${baseUrl}liveChallengeRagister';
  static const String  liveChallengeQuestionsUrl= '${baseUrl}liveChallengeQuestion';
  static const String  changeRoundLiveChallengeUrl= '${baseUrl}liveChallengeRoundEnd';
  static const String  submitAnswerLiveChallengeUrl= '${baseUrl}submitAnswerLiveChallenge';
  static const String  liveChallengeFinalResultUrl = '${baseUrl}LiveChallengeSubmitChallengeList';

  // medpardy
  static const String  medpardyStartGameUrl = '${baseUrl}medpardystart';
  static const String  medpardyRegisterUrl = '${baseUrl}medpardyRegister';
  static const String  medpardyResultUrl = '${baseUrl}submitResultMedpardy';
  static const String  medpardyChangeRoundUrl = '${baseUrl}medpardyStartRound';
  static const String  medpardySubmitAnswerUrl = '${baseUrl}submitAnswerMadely';

  // MedLingo
  static const String  startMedLingoUrl = '${baseUrl}medLingoStart';
  static const String  leaveQuizMedLingoUrl = '${baseUrl}leaveQuizMedLingo';
  static const String  submitAnswerMedLingoUrl = '${baseUrl}submitAnswerMedLingo';

  // oneDay premium
  static const String  oneDayPassUrl = '${baseUrl}oneDaySubscription';

  // Hp Transaction history
  static const String  hpTransactionUrl = '${baseUrl}xpHistory';

  // privacy page
  static const String  privacyUrl = '${domain}privacy';
  static const String  termsUrl = '${domain}terms';

  // payment related apis
  static const String getSubscriptionDetailUrl = '${baseUrl}fetchSubscriptionDetail';   ///. plan detail k liye
  static const String  sendSubscriptionDetailToBackend = '${baseUrl}PaymentWebhookAndroid';

  /// console urls for web hook
  /// https://apollomedgames.com/api/androidWebhook
  /// https://apollomedgames.com/api/iosWebhook // jab app Live ho jayegi apn ye wala use karenge
  /// https://apollomedgames.com/api/apple-webhook // sandbox
}

/*-------------------------------------------- API CALL METHODS -----------------------------------------------------*/

Future<http.Response> performGetRequest(String url) async {
  apolloPrint(message: '${AuthData().userToken}');
  final headers = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer ${AuthData().userToken}'
  };

  return await http.get(
    Uri.parse(url),
    headers: headers
  );
}

void handleErrorCases(http.Response response, dynamic data, String apiName) {

  if (response.statusCode == 202) {
    log('response.statusCode===>${response.statusCode}');
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: data['message']);
  }
  else if (response.statusCode == 401 || data['message'] == "Unauthorized") {
    apolloPrint(message: 'coming in 401 or Unauthorized in $apiName');
    LocalStorage().clearLocalStorage();
    Get.offAllNamed(AppRoutes.enterScreen);
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'Your session has expired. Please log in again.');
  }
  else {
    log('Yahaa aaya ApisUrl me');
    log('response.statusCode===>${response.statusCode}');
    CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: data['message']);

    // showLoader(false);
    throw Exception(response.body);
  }
}

Future<http.Response> performPostRequest(String url, Map<String, dynamic> map) async {
  apolloPrint(message: '${AuthData().userToken}');
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

