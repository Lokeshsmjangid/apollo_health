
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:apollo/controllers/app_push_nottification.dart';
import 'package:apollo/controllers/home_ctrl.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;


void initMessaging() async {
  // Android Initialization Settings
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS Initialization Settings (Updated to DarwinInitializationSettings)
  var initializationSettingsDarwin = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    // onDidReceiveLocalNotification: onDidReceiveLocalNotification,

  );

  // Combine Android and iOS initialization settings
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onSelectNotification: onSelectNotification,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // showToast('lokesh10');
      print("jsonDecode(response.payload??"").toString()");
      log("jsonDecode(response.payload??"").toString()");
      log(jsonDecode(response.payload??"").toString());
      print(jsonDecode(response.payload??"").toString());
      onSelectNotification(response.payload);
      if (response.payload != null) {
        // Navigate to a new route
        // Navigator.pushNamed(context, notificationResponse.payload!);
        print("Payload: ${response.payload}");

      }
    },
  );

  // THIS for runtime permission
  if (Platform.isAndroid) {
    final androidImplementation = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    final isAllowed = await androidImplementation?.requestNotificationsPermission();

    print("🔔 Notification permission allowed: $isAllowed");
    if(isAllowed==false) {
      // CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'Please enable notifications in your app settings.');
      // openAppSettings();
    }
  }


  // Set iOS foreground notification presentation options
  if (Platform.isIOS) {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }



  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
    // showToast('lokesh20');
    apolloPrint(message: 'Message data onMessage.listen: ${remoteMessage.data}');
    print('A1 ${remoteMessage.notification?.title}');
    print('A2 ${remoteMessage.notification?.body}');
    apolloPrint(message: 'A3 ${remoteMessage.notification?.title}');
    apolloPrint(message: 'A4 ${remoteMessage.notification?.body}');


    String notificationTitle = remoteMessage.notification?.title ?? "";
    String notificationBody = remoteMessage.notification?.body ?? "";
    Get.find<AppPushNotification>().isNew.value = true;
    Get.find<AppPushNotification>().update();

    if(notificationTitle=="Friend Request"){
    // Get.find<AppPushNotification>().increaseFriendRequestCount();
    }


    if(Platform.isAndroid) {
      showNotification(notificationTitle, notificationBody, remoteMessage.data);
    }

  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // showToast('lokesh30');
    print("B1 new onMessageOpenedApp event was published!");
    // final notificationType = json.decode(message.data["notification_type"]);
    // final data = json.decode(message.data["data"]);
    final data = message.data;
    // Handle the notification type and data as needed


    apolloPrint(message: 'Notification payload data:\n ${data} \n');
    apolloPrint(message: 'Notification payload data:\n ${data.runtimeType} \n');
    print('B2 ${data.runtimeType}');

    Get.find<AppPushNotification>().isNew.value = false;
    Get.find<AppPushNotification>().update();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
      handleNavigationBasedOnData(data);
    // });

  });

  FirebaseMessaging.onBackgroundMessage(backgroundHandler); // background tap pe redirection

}

Future<void> backgroundHandler(RemoteMessage message) async {
  print('C1 Handling a background message ${message.messageId}');
  print('C2 Message data onMessage.listen: ${message.data}');
  print('C3 Message notification: ${message.notification?.body}');
  print('C4 ${message.notification?.body}');
  if(Platform.isIOS){
    await Firebase.initializeApp();
  }
  else {
    await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: 'AIzaSyAwSD5SBY_SKngpuN1H6JSv5S4Vjv_ZnmA',
        appId: '1:801266332539:android:ebabd6c5b0e17f85f143de',
        messagingSenderId: '801266332539',
        projectId: 'apollo-b6111'));}
  final data = message.data;

}

void showNotification(String title, String body, Map<String, dynamic> data) async {
  var androidChannel = AndroidNotificationChannel(
    'firebase-push-notification',
    'firebase-push-notification-channel',
    description: 'Channel Description',
    importance: Importance.high,
  );

  // Create the notification channel (for Android)
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);

  var notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      androidChannel.id,
      androidChannel.name,
      channelDescription: androidChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    ),
    iOS: DarwinNotificationDetails(),
  );


  // Define the data you want to pass
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
    payload: jsonEncode(data),
  );
}

// Handle when a local notification is selected (optional)
// Future onSelectNotification(String? payload) async {
//   print('Notification clicked with payload: $payload');
// }
Future onSelectNotification(String? payload) async {
  if (payload != null) {
    Map<String, dynamic> data = jsonDecode(payload);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleNavigationBasedOnData(data);
    });
  }
}

void handleNavigationBasedOnData(Map<String, dynamic> data) {
  final HomeController ctrl = Get.find<HomeController>();
  apolloPrint(message: 'D0 $data');
  print('D1 $data');
    ctrl.stopBackgroundSound();
  if (data['title'] == 'Friend Request Accepted'){
    Get.toNamed(AppRoutes.myFriendsScreen);
  } else if (data['title'] == 'Friend Request'){
    Get.toNamed(AppRoutes.playRequestScreen)?.then((valueee){
      ctrl.playBackgroundSound();
    });

  } else if(data['title'] == "Group Play Invite"){
    // ctrl.stopBackgroundSound();
    Get.toNamed(AppRoutes.groupPlayRequestScreen,arguments:
    {
      'group_game_id':int.parse(data['group_game_id']),
      'sender_id':int.parse(data['sender_id'])})?.then((valueee){
      ctrl.playBackgroundSound();
    });
  }
}

/*void handleNavigationBasedOnDataForTerminate(Map<String, dynamic> data) {

  final HomeController ctrl = Get.find<HomeController>();
  ctrl.stopBackgroundSound();
  Future.delayed(Duration(milliseconds: 2000),(){
    apolloPrint(message: 'D0 $data');
    print('D1 $data');
    if (data['title'] == 'Friend Request'){
      Get.toNamed(AppRoutes.playRequestScreen)?.then((valueee){
        // ctrl.playBackgroundSound();
      });

    } else if(data['title'] == "Group Play Invite"){

      Get.toNamed(AppRoutes.groupPlayRequestScreen,arguments: {'group_game_id':int.parse(data['group_game_id']),'sender_id':int.parse(data['sender_id'])})?.then((valueee){
        // ctrl.playBackgroundSound();
      });
    }
  });
}*/

// iOS-specific function for handling local notifications while the app is in the foreground
void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
  print('Local notification received: $title, $body');
}
