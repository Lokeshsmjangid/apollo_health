
import 'package:apollo/controllers/MedPardy_Ctrls/medpardy_1st_round_ctrl.dart';
import 'package:apollo/controllers/MedPardy_Ctrls/medpardy_2nd_round_ctrl.dart';
import 'package:apollo/controllers/MedPardy_Ctrls/medpardy_3rd_round_ctrl.dart';
import 'package:apollo/controllers/app_push_nottification.dart';
import 'package:apollo/controllers/auth_controller.dart';
import 'package:apollo/controllers/bottom_bar_ctrl.dart';
import 'package:apollo/controllers/categories_ctrl.dart';
import 'package:apollo/controllers/category_ctrl.dart';
import 'package:apollo/controllers/change_password_ctrl.dart';
import 'package:apollo/controllers/create_account_ctrl.dart';
import 'package:apollo/controllers/deals_ctrl.dart';
import 'package:apollo/controllers/edit_profile_ctrl.dart';
import 'package:apollo/controllers/email_verify_otp_ctrl.dart';
import 'package:apollo/controllers/forgot_password_otp_ctrl.dart';
import 'package:apollo/controllers/gm_group_play_ctrl.dart';
import 'package:apollo/controllers/gm_solo_play_ctrl.dart';
import 'package:apollo/controllers/group_challengers_ctrl.dart';
import 'package:apollo/controllers/group_play_frinds_ctrl.dart';
import 'package:apollo/controllers/group_play_request_ctrl.dart';
import 'package:apollo/controllers/home_ctrl.dart';
import 'package:apollo/controllers/leaderboard_ctrl.dart';
import 'package:apollo/controllers/live_challenge_quiz_ctrl.dart';
import 'package:apollo/controllers/live_challenge_round_four_ctrl.dart';
import 'package:apollo/controllers/live_challenge_round_three_ctrl.dart';
import 'package:apollo/controllers/live_challenge_round_two_ctrl.dart';
import 'package:apollo/controllers/login_controller.dart';
import 'package:apollo/controllers/madlingo_ctrls/medlingo_ctrl.dart';
import 'package:apollo/controllers/medPardy_final_round_quiz_ctrl.dart';
import 'package:apollo/controllers/medPardy_quiz_all_ctrl.dart';
import 'package:apollo/controllers/medPardy_quiz_ctrl.dart';
import 'package:apollo/controllers/mutual_friend_ctrl.dart';
import 'package:apollo/controllers/my_frinds_ctrl.dart';
import 'package:apollo/controllers/my_profile_ctrl.dart';
import 'package:apollo/controllers/new_password_ctrl.dart';
import 'package:apollo/controllers/notification_ctrl.dart';
import 'package:apollo/controllers/onboard_ctrl.dart';
import 'package:apollo/controllers/other_profile_ctrl.dart';
import 'package:apollo/controllers/play_request_ctrl.dart';
import 'package:apollo/controllers/profile_ctrl.dart';
import 'package:apollo/controllers/settings_ctrl.dart';
import 'package:apollo/controllers/sign_in_ctrl.dart';
import 'package:apollo/controllers/sign_up_controller.dart';
import 'package:apollo/controllers/sign_up_personal_info_ctrl.dart';
import 'package:apollo/screens/app_subscriptions/new_subscription_ctrl.dart';
import 'package:apollo/screens/app_subscriptions/premium_plan_ctrl.dart';
import 'package:apollo/screens/app_subscriptions/subscription_ctrl.dart';
import 'package:apollo/screens/game_mode/medPardy/round_1/medpardy_1st_round_quiz_ctrl.dart';
import 'package:apollo/screens/game_mode/medPardy/round_2/medpardy_2nd_round_quiz_ctrl.dart';
import 'package:apollo/screens/game_mode/medPardy/round_3/medpardy_3rd_round_quiz_ctrl.dart';
import 'package:get/get.dart';

Future<void> init() async {

  Get.lazyPut<AppPushNotification>(() => AppPushNotification(), fenix: true);
  Get.lazyPut<ApolloAuthCtrl>(() => ApolloAuthCtrl(), fenix: true);
  Get.lazyPut<BottomBarController>(() => BottomBarController(), fenix: true);
  Get.lazyPut<ForgotPasswordOtpCtrl>(() => ForgotPasswordOtpCtrl(), fenix: true);
  Get.lazyPut<OnboardingController>(() => OnboardingController(), fenix: true);
  Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
  Get.lazyPut<CreateAccountController>(() => CreateAccountController(), fenix: true);
  Get.lazyPut<NewPasswordController>(() => NewPasswordController(), fenix: true);
  Get.lazyPut<SignUpPersonalInfoController>(() => SignUpPersonalInfoController(), fenix: true);
  Get.lazyPut<CategoriesController>(() => CategoriesController(), fenix: true);
  // Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  Get.put(HomeController(), permanent: true);
  Get.lazyPut<CategoriesController>(() => CategoriesController(), fenix: true);
  Get.lazyPut<LeaderboardController>(() => LeaderboardController(), fenix: true);
  Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  Get.lazyPut<GmSoloPlayController>(() => GmSoloPlayController(), fenix: true);
  Get.lazyPut<GmGroupPlayController>(() => GmGroupPlayController(), fenix: true);
  Get.lazyPut<GroupPlayFriendsCtrl>(() => GroupPlayFriendsCtrl(), fenix: true);
  Get.lazyPut<GroupPlayRequestCtrl>(() => GroupPlayRequestCtrl(), fenix: true);
  // Get.lazyPut<GMQuizCtrl>(() => GMQuizCtrl(), fenix: true);
  Get.lazyPut<MedpardyQuizCtrl>(() => MedpardyQuizCtrl(), fenix: true);
  Get.lazyPut<MedpardyAllQuizCtrl>(() => MedpardyAllQuizCtrl(), fenix: true);
  Get.lazyPut<LiveChallengeQuizCtrl>(() => LiveChallengeQuizCtrl(), fenix: true);
  Get.lazyPut<NotificationsCtrl>(() => NotificationsCtrl(), fenix: true);
  Get.lazyPut<SettingsCtrl>(() => SettingsCtrl(), fenix: true);
  Get.lazyPut<MyProfileCtrl>(() => MyProfileCtrl(), fenix: true);
  Get.lazyPut<EditProfileController>(() => EditProfileController(), fenix: true);
  Get.lazyPut<CategoryController>(() => CategoryController(), fenix: true);
  Get.lazyPut<MyFriendsCtrl>(() => MyFriendsCtrl(), fenix: true);
  Get.lazyPut<PlayRequestCtrl>(() => PlayRequestCtrl(), fenix: true);
  Get.lazyPut<OtherProfileCtrl>(() => OtherProfileCtrl(), fenix: true);
  Get.lazyPut<GroupChallengersCtrl>(() => GroupChallengersCtrl(), fenix: true);
  Get.lazyPut<MedpardyFinalRoundQuizCtrl>(() => MedpardyFinalRoundQuizCtrl(), fenix: true);
  Get.lazyPut<MutualFriendCtrl>(() => MutualFriendCtrl(), fenix: true);

  // Live Challenges Round Ctrl
  Get.lazyPut<LiveChallengeRoundTwoCtrl>(() => LiveChallengeRoundTwoCtrl(), fenix: true);
  Get.lazyPut<LiveChallengeRoundThreeCtrl>(() => LiveChallengeRoundThreeCtrl(), fenix: true);
  Get.lazyPut<LiveChallengeRoundFourCtrl>(() => LiveChallengeRoundFourCtrl(), fenix: true);


  // auth
  Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
  Get.lazyPut<SignUpCtrl>(() => SignUpCtrl(), fenix: true);
  Get.lazyPut<ChangePasswordCtrl>(() => ChangePasswordCtrl(), fenix: true);
  Get.lazyPut<DealsController>(() => DealsController(), fenix: true);
  Get.lazyPut<EmailVerifyOtpCtrl>(() => EmailVerifyOtpCtrl(), fenix: true);


  // medpardy game
  Get.lazyPut<MedPardy1stRoundCtrl>(() => MedPardy1stRoundCtrl(), fenix: true);
  Get.lazyPut<Medpardy1stRoundQuizCtrl>(() => Medpardy1stRoundQuizCtrl(), fenix: true);
  Get.lazyPut<MedPardy2ndRoundCtrl>(() => MedPardy2ndRoundCtrl(), fenix: true);
  Get.lazyPut<Medpardy2ndRoundQuizCtrl>(() => Medpardy2ndRoundQuizCtrl(), fenix: true);
  Get.lazyPut<MedPardy3rdRoundCtrl>(() => MedPardy3rdRoundCtrl(), fenix: true);
  Get.lazyPut<Medpardy3rdRoundQuizCtrl>(() => Medpardy3rdRoundQuizCtrl(), fenix: true);

  //
  Get.lazyPut<MedlingoCtrl>(() => MedlingoCtrl(), fenix: true);


  // App-Subscription
  // Get.lazyPut<SubscriptionCtrl>(() => SubscriptionCtrl(), fenix: true);
  Get.lazyPut<PremiumPlanCtrl>(() => PremiumPlanCtrl(), fenix: true);
  // Get.lazyPut<NewSubscriptionCtrl>(() => NewSubscriptionCtrl(), fenix: true);


}

