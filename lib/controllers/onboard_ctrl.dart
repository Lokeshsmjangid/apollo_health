
import 'package:apollo/resources/Apis/api_models/onboarding_model.dart';
import 'package:apollo/resources/Apis/api_repository/onboarding_pages_repo.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {




  final AudioPlayer effectPlayer = AudioPlayer();

  var currentIndex = 0.obs;

  void nextPage(PageController controller) {
    // effectSound(sound: AppAssets.actionButtonTapSound);
    if (currentIndex.value < 2) {
      controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Get.offAllNamed(AppRoutes.enterScreen);
    }
  }

  void skip() {
    // effectSound(sound: AppAssets.actionButtonTapSound);
    Get.offAllNamed(AppRoutes.enterScreen);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  Future<void> effectSound({required String sound}) async {

    await effectPlayer.play(AssetSource(sound));

  }

  bool isDataLoading = false;
  OnboardingModel model = OnboardingModel();
  getOnBoardingData() async{
    isDataLoading = true;
    update();
    await onBoardingApi().then((value){
      model = value;
      isDataLoading = false;
      pages = model.data??[];
      update();
    });
  }

  PageController? pageController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // if(Get.arguments!=null){
    //   pages = Get.arguments['pages'];
    // }
    pageController = PageController();
    getOnBoardingData();

  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    pageController?.dispose();
  }
  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  List<Pages> pages = [];

  /*final List<Map<String, String>> pages = [
    {
      'title': 'Welcome to Apollo MedGames!',
      'desc': 'Where learning health feels like play. \nFrom medical pop culture to emergency care, test your brain, one game at a time.',
      'image': 'assets/Lottie/Appolo stetoskope.json'
    },
    {
      'title': 'Crafted by Doctors. Designed for You.',
      'desc': 'Health. Simplified. Gamified.\nFrom solo plays to game night showdowns, it’s health made fun & addictive (the good kind).',
      'image': 'assets/Lottie/Apollo magic.json'
    },
    {
      'title': 'Hit Play. Boost Your Health IQ.',
      'desc': 'Every round makes you sharper, savvier, and more in control of your health.\nBecause better info → better choices → better you.',
      'image': 'assets/Lottie/Appolo dance.json'
    }
  ];*/
}
