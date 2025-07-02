
import 'package:apollo/controllers/bottom_bar_ctrl.dart';
import 'package:apollo/controllers/categories_ctrl.dart';
import 'package:apollo/controllers/category_ctrl.dart';
import 'package:apollo/controllers/change_password_ctrl.dart';
import 'package:apollo/controllers/create_account_ctrl.dart';
import 'package:apollo/controllers/deals_ctrl.dart';
import 'package:apollo/controllers/edit_profile_ctrl.dart';
import 'package:apollo/controllers/forgot_password_otp_ctrl.dart';
import 'package:apollo/controllers/gM_quiz_ctrl.dart';
import 'package:apollo/controllers/gm_group_play_ctrl.dart';
import 'package:apollo/controllers/gm_solo_play_ctrl.dart';
import 'package:apollo/controllers/group_challengers_ctrl.dart';
import 'package:apollo/controllers/group_play_frinds_ctrl.dart';
import 'package:apollo/controllers/group_play_request_ctrl.dart';
import 'package:apollo/controllers/home_ctrl.dart';
import 'package:apollo/controllers/leaderboard_ctrl.dart';
import 'package:apollo/controllers/live_challenge_quiz_ctrl.dart';
import 'package:apollo/controllers/login_controller.dart';
import 'package:apollo/controllers/medPardy_final_round_quiz_ctrl.dart';
import 'package:apollo/controllers/medPardy_quiz_all_ctrl.dart';
import 'package:apollo/controllers/medPardy_quiz_ctrl.dart';
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
import 'package:get/get.dart';

Future<void> init() async {

  Get.lazyPut<BottomBarController>(() => BottomBarController(), fenix: true);
  Get.lazyPut<ForgotPasswordOtpCtrl>(() => ForgotPasswordOtpCtrl(), fenix: true);
  Get.lazyPut<OnboardingController>(() => OnboardingController(), fenix: true);
  Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
  Get.lazyPut<CreateAccountController>(() => CreateAccountController(), fenix: true);
  Get.lazyPut<NewPasswordController>(() => NewPasswordController(), fenix: true);
  Get.lazyPut<SignUpPersonalInfoController>(() => SignUpPersonalInfoController(), fenix: true);
  Get.lazyPut<CategoriesController>(() => CategoriesController(), fenix: true);
  Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
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


  // auth
  Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
  Get.lazyPut<SignUpCtrl>(() => SignUpCtrl(), fenix: true);
  Get.lazyPut<ChangePasswordCtrl>(() => ChangePasswordCtrl(), fenix: true);
  Get.lazyPut<DealsController>(() => DealsController(), fenix: true);

}

