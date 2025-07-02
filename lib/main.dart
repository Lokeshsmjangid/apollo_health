
import 'package:get/get.dart';
import 'resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'resources/app_routers.dart';
import 'resources/dependencies.dart' as de;
import 'package:scaled_app/scaled_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async{
  ScaledWidgetsFlutterBinding.ensureInitialized(
    scaleFactor: (deviceSize) {
      const double widthOfDesign = 375; // screen width used in your UI design
      return deviceSize.width / widthOfDesign;
    },
  );

  /*if(Platform.isIOS){ await Firebase.initializeApp();}
  else { await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: 'AIzaSyCnyBP4n_Kt3dD3qz4APEDLLXSnNzlvXKQ',
      appId: '1:237317545931:android:40987e4bc8555b4c3ce04e',
      messagingSenderId: '237317545931',
      projectId: 'levicon-carpooling-32563'));}*/
  await de.init();
  await GetStorage.init();
  // initMessaging();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light
        ));
    return GestureDetector(
      onTap: () {
        if (FocusManager.instance.primaryFocus!.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        title: 'Apollo',
        locale: Get.deviceLocale,
        getPages: AppRoutes.getRoute,
        debugShowCheckedModeBanner: false,
        // initialRoute: AppRoutes.splashScreen,
        initialRoute: AppRoutes.dashboardScreen,
        defaultTransition: Transition.noTransition,
        theme: ThemeData(
            primarySwatch: primaryColorShades,
            fontFamily: 'Manrope',
            useMaterial3: false
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), // Set the desired text scaling factor here
            child: child!,
          );
        },
      ),
    );
  }
}
// command to generate SHA key
// keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
// firebase hosting for dynamic link---> levicon-carpooling-32563.web.app