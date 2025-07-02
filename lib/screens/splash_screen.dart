import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  double scale = 0.1;
  void _changeScale() {
    setState(() => scale = scale == 0.1 ? 1.0 : 0.1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _playConfettiSound(sound: AppAssets.splashSound);
    // Animate scale after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        scale = 1.0;
      });
    });
    Future.delayed(Duration(seconds: 3),(){
      Get.offAllNamed(AppRoutes.splashMainScreen);
    });
  }


  Future<void> _playConfettiSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(AppAssets.splashScreenBgImg,fit: BoxFit.fill),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                color: AppColors.whiteColor,
                ),
                child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 1500),
                    child: SvgPicture.asset(AppAssets.logo)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
