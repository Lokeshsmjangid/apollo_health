
import 'package:apollo/notifications_screen.dart';
import 'package:apollo/screens/auth_screens/forgot_password/forgot_password_screen.dart';
import 'package:apollo/screens/auth_screens/forgot_password/new_password_screen.dart';
import 'package:apollo/screens/auth_screens/forgot_password/new_password_success_screen.dart';
import 'package:apollo/screens/auth_screens/sign_up/sign_up_disclaimer_screen.dart';
import 'package:apollo/screens/auth_screens/sign_up/sign_up_personal_info.dart';
import 'package:apollo/screens/auth_screens/sign_up/sign_up_screen.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:apollo/screens/dashboard/home_screen.dart';
import 'package:apollo/screens/deals/deals_experiences_screen.dart';
import 'package:apollo/screens/deals/deals_product_screen.dart';
import 'package:apollo/screens/deals/deals_services_screen.dart';
import 'package:apollo/screens/enter_screen.dart';
import 'package:apollo/screens/auth_screens/sign_in_screen.dart';
import 'package:apollo/screens/game_mode/group_play/group_challengers_screen.dart';
import 'package:apollo/screens/game_mode/group_play/group_play_friends_screen.dart';
import 'package:apollo/screens/game_mode/group_play/group_play_request_screen.dart';
import 'package:apollo/screens/game_mode/group_play/group_play_result.dart';
import 'package:apollo/screens/game_mode/group_play/group_play_screen.dart';
import 'package:apollo/screens/game_mode/live_challenges/live_challenge_quiz_screen.dart';
import 'package:apollo/screens/game_mode/live_challenges/live_challenge_result.dart';
import 'package:apollo/screens/game_mode/live_challenges/live_challenge_result_precentage.dart';
import 'package:apollo/screens/game_mode/live_challenges/register_live_challenge_screen.dart';
import 'package:apollo/screens/game_mode/live_challenges/timer_live_challenge_screen.dart';
import 'package:apollo/screens/game_mode/medPardy/medpardy_board_screen.dart';
import 'package:apollo/screens/game_mode/medPardy/medpardy_choose_friend_screen.dart';
import 'package:apollo/screens/game_mode/medPardy/medpardy_second_round_board_screen.dart';
import 'package:apollo/screens/game_mode/medPardy/quiz_medpardy_screen.dart';
import 'package:apollo/screens/game_mode/solo_play/quiz_screen.dart';
import 'package:apollo/screens/game_mode/solo_play/quiz_screen_new.dart';
import 'package:apollo/screens/game_mode/solo_play/solo_play_result.dart';
import 'package:apollo/screens/game_mode/solo_play/solo_play_screen.dart';
import 'package:apollo/screens/level_up_screen.dart';
import 'package:apollo/screens/my_profile/edit_profile_screen.dart';
import 'package:apollo/screens/my_profile/mutual_friend_screen.dart';
import 'package:apollo/screens/my_profile/my_friends_screen.dart';
import 'package:apollo/screens/my_profile/my_profile_screen.dart';
import 'package:apollo/screens/my_profile/other_profile_screen.dart';
import 'package:apollo/screens/my_profile/play_request_screen.dart';
import 'package:apollo/screens/my_profile/subscription_screen.dart';
import 'package:apollo/screens/onboarding_screens/onboarding_screen.dart';
import 'package:apollo/screens/settings/need_help_screen.dart';
import 'package:apollo/screens/settings/settings_screen.dart';
import 'package:apollo/screens/settings/submit_topic_screen.dart';
import 'package:apollo/screens/splash_main_screen.dart';
import 'package:apollo/screens/splash_screen.dart';
import 'package:get/get.dart';

import '../screens/auth_screens/forgot_password/forgot_password_otp_screen.dart';

class AppRoutes {
  static String splashScreen = '/SPLASH_SCREEN';
  static String splashMainScreen = '/MAIN_SPLASH_SCREEN';
  static String onboardingScreen = '/ONBOARDING_SCREEN';
  static String enterScreen = '/ENTER_SCREEN';
  static String signInScreen = '/SIGN_IN_SCREEN';
  static String forgotPasswordScreen = '/FORGOT_PASSWORD_SCREEN';
  static String forgotPasswordOtpScreen = '/FORGOT_PASSWORD_OTP_SCREEN';
  static String newPasswordScreen = '/NEW_PASSWORD_SCREEN';
  static String newPasswordSuccessScreen = '/NEW_PASSWORD_SUCCESS_SCREEN';
  static String createAccountScreen = '/CREATE_ACCOUNT_SCREEN';
  static String signUpPersonalInfoScreen = '/SIGN_UP_PERSONAL_INFO_SCREEN';
  static String signUpDisclaimerScreen = '/SIGN_UP_DISCLAIMER_SCREEN';
  static String homeScreen = '/Home_Screen';
  static String dashboardScreen = '/DASHBOARD_SCREEN';


  // Game Mode
  // Solo-Play
  static String gMSoloPlayScreen = '/GM_SOLO_PLAY_SCREEN';
  static String gMQuizScreen = '/GM_QUIZ_SCREEN';
  static String soloResultScreen = '/SOLO_RESULT_SCREEN';
  static String quizScreenNew = '/QUIZ_SCREEN_NEW';

  // Group play
  static String gMGroupPlayScreen = '/GM_GROUP_PLAY_SCREEN';
  static String groupPlayFriendsScreen = '/GROUP_PLAY_FRIENDS_SCREEN';
  static String groupPlayRequestScreen = '/GROUP_PLAY_REQUEST_SCREEN';
  static String groupPlayResultScreen = '/GROUP_PLAY_RESULT_SCREEN';
  static String groupChallengersScreen = '/GROUP_CHALLENGERS_SCREEN';


  // MedPardy
  static String medpardyChooseFriendScreen = '/MEDPARDY_CHOOSE_FRIEND_SCREEN';
  static String medpardyBoardScreen = '/MEDPARDY_BOARD_SCREEN';
  static String medpardySecondRoundBoardScreen = '/MEDPARDYSECONDROUNDBOARDSCREEN';
  static String quizMedpardyScreen = '/QUIZ_MEDPARDY_SCREEN';


  // Live-Challenges
  static String registerLiveChallengeScreen = '/REGISTER_LIVE_CHALLENGE_SCREEN';
  static String timerLiveChallengeScreen = '/TIMER_LIVE_CHALLENGE_SCREEN';
  static String liveChallengeResultScreen = '/LIVE_CHALLENGE_RESULT_SCREEN';
  static String liveChallengeResultPrecentageScreen = '/LIVE_CHALLENGE_RESULT_PRECENTAGE_SCREEN';
  static String liveChallengeQuizScreen = '/LIVE_CHALLENGE_QUIZ_SCREEN';
  static String notificationsScreen = '/NOTIFICATIONS_SCREEN';
  static String settingsScreen = '/SETTINGS_SCREEN';
  static String myProfileScreen = '/MY_PROFILE_SCREEN';
  static String editProfileScreen = '/EDIT_PROFILE_SCREEN';
  static String howToLevelUpScreen = '/HOWTO_LEVEL_UP_SCREEN';
  static String subscriptionScreen = '/SUBSCRIPTION_SCREEN';
  static String submitTopicScreen = '/SUBMIT_TOPIC_SCREEN';
  static String needHelpScreen = '/Need_Help_SCREEN';

  // My Friends Screen
  static String myFriendsScreen = '/MY_FRIENDS_SCREEN';
  static String playRequestScreen = '/PLAY_REQUEST_SCREEN';
  static String otherProfileScreen = '/OTHER_PROFILE_SCREEN';
  static String mutualFriendScreen = '/MUTUAL_FRIEND_SCREEN';
  static String wheelOfWellnessScreen = '/WHEEL_OF_WELLNESS_SCREEN';
  static String dealsProductScreen = '/DEALS_PRODUCT_SCREEN';
  static String dealsServicesScreen = '/DEALS_SERVICES_SCREEN';
  static String dealsExperiencesScreen = '/DEALS_EXPERIENCES_SCREEN';





  // Car Station Screens

  static final getRoute = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(), // with logo
    ),

    GetPage(
      name: AppRoutes.dashboardScreen,
      page: () => const DashBoardScreen(), // with logo
    ),

    GetPage(
      name: AppRoutes.splashMainScreen,
      page: () => const SplashMainScreen(), // with text apollo
    ),

    GetPage(
      name: AppRoutes.onboardingScreen,
      page: () => OnboardingScreen(), // with text apollo
    ),

    GetPage(
      name: AppRoutes.enterScreen,
      page: () => const EnterScreen(),
    ),

    GetPage(
      name: AppRoutes.signInScreen,
      page: () => const SignInScreen(),
    ),

    GetPage(
      name: AppRoutes.forgotPasswordScreen,
      page: () => const ForgotPasswordScreen(),
    ),

    GetPage(
      name: AppRoutes.forgotPasswordOtpScreen,
      page: () => ForgotPasswordOtpScreen(),
    ),
    GetPage(
      name: AppRoutes.newPasswordScreen,
      page: () => NewPasswordScreen(),
    ),

    GetPage(
      name: AppRoutes.newPasswordSuccessScreen,
      page: () => NewPasswordSuccessScreen(),
    ),

    GetPage(
      name: AppRoutes.createAccountScreen,
      page: () => CreateAccountScreen(),
    ),

    GetPage(
      name: AppRoutes.signUpPersonalInfoScreen,
      page: () => SignUpPersonalInfoScreen(),
    ),

    GetPage(
      name: AppRoutes.signUpDisclaimerScreen,
      page: () => SignUpDisclaimerScreen(),
    ),

    GetPage(
      name: AppRoutes.homeScreen,
      page: () => HomeScreen(),
    ),

    // Game mode

    // Solo-Play
    GetPage(
      name: AppRoutes.gMSoloPlayScreen,
      page: () => SoloPlayScreen(),
    ),

    GetPage(
      name: AppRoutes.gMQuizScreen,
      page: () => QuizScreen(),
    ),

    GetPage(
      name: AppRoutes.soloResultScreen,
      page: () => SoloResultScreen(),
    ),

    // Group play

    GetPage(
      name: AppRoutes.gMGroupPlayScreen,
      page: () => GroupPlayScreen(),
    ),
    GetPage(
      name: AppRoutes.groupPlayFriendsScreen,
      page: () => GroupPlayFriendsScreen(),
    ),
    GetPage(
      name: AppRoutes.groupPlayRequestScreen,
      page: () => GroupPlayRequestScreen(),
    ),
    GetPage(
      name: AppRoutes.groupPlayResultScreen,
      page: () => GroupPlayResultScreen(),
    ),

    // Medpardy

    GetPage(
      name: AppRoutes.medpardyChooseFriendScreen,
      page: () => MedpardyChooseFriendScreen(),
    ),
    GetPage(
      name: AppRoutes.medpardyBoardScreen,
      page: () => MedpardyBoardScreen(),
    ),
    GetPage(
      name: AppRoutes.medpardySecondRoundBoardScreen,
      page: () => MedpardySecondRoundBoardScreen(),
    ),
    GetPage(
      name: AppRoutes.quizMedpardyScreen,
      page: () => QuizMedpardyScreen(),
    ),

    //live_challenges
    GetPage(
      name: AppRoutes.registerLiveChallengeScreen,
      page: () => RegisterLiveChallengeScreen(),
    ),

    GetPage(
      name: AppRoutes.timerLiveChallengeScreen,
      page: () => TimerLiveChallengeScreen(),
    ),

    GetPage(
      name: AppRoutes.liveChallengeResultScreen,
      page: () => LiveChallengeResultScreen(),
    ),

    GetPage(
      name: AppRoutes.liveChallengeResultPrecentageScreen,
      page: () => LiveChallengeResultPrecentageScreen(),
    ),

    GetPage(
      name: AppRoutes.liveChallengeQuizScreen,
      page: () => LiveChallengeQuizScreen(),
    ),

    // Notifications
    GetPage(
      name: AppRoutes.notificationsScreen,
      page: () => NotificationsPage(),
    ),

    // Settings
    GetPage(
      name: AppRoutes.settingsScreen,
      page: () => SettingsScreen(),
    ),


    GetPage(
      name: AppRoutes.myProfileScreen,
      page: () => MyProfileScreen(),
    ),

    GetPage(
      name: AppRoutes.editProfileScreen,
      page: () => EditProfileScreen(),
    ),

    GetPage(
      name: AppRoutes.subscriptionScreen,
      page: () => SubscriptionScreen(),
    ),

    GetPage(
      name: AppRoutes.howToLevelUpScreen,
      page: () => HowToLevelUpScreen(),
    ),

    GetPage(
      name: AppRoutes.submitTopicScreen,
      page: () => SubmitTopicScreen(),
    ),

    GetPage(
      name: AppRoutes.needHelpScreen,
      page: () => NeedHelpScreen(),
    ),

    GetPage(
      name: AppRoutes.myFriendsScreen,
      page: () => MyFriendsScreen(),
    ),

    GetPage(
      name: AppRoutes.playRequestScreen,
      page: () => PlayRequestScreen(),
    ),

    GetPage(
      name: AppRoutes.otherProfileScreen,
      page: () => OtherProfileScreen(),
    ),

    GetPage(
      name: AppRoutes.mutualFriendScreen,
      page: () => MutualFriendScreen(),
    ),


    GetPage(
      name: AppRoutes.groupChallengersScreen,
      page: () => GroupChallengersScreen(),
    ),

    GetPage(
      name: AppRoutes.quizScreenNew,
      page: () => QuizScreenNew(),
    ),

    GetPage(
      name: AppRoutes.dealsProductScreen,
      page: () => DealsProductScreen(),
    ),

    GetPage(
      name: AppRoutes.dealsProductScreen,
      page: () => DealsProductScreen(),
    ),

    GetPage(
      name: AppRoutes.dealsServicesScreen,
      page: () => DealsServicesScreen(),
    ),

    GetPage(
      name: AppRoutes.dealsExperiencesScreen,
      page: () => DealsExperiencesScreen(),
    ),




  ];
}
