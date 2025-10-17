import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignUpCtrl extends GetxController {

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController confPassCtrl = TextEditingController();
  TextEditingController referralCtrl = TextEditingController();
  bool obscurePass = true;
  bool obscureCPass = true;
  bool isButtonDisable = true;

  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> effectSound({required String sound}) async {

    await _audioPlayer.play(AssetSource(sound));

  }

  onTapSuffix({bool isPass = true}){
    if(isPass){
      obscurePass = !obscurePass;
    }else if(!isPass){
      obscureCPass = !obscureCPass;
    }
    update();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<User?> signInWithGoogle() async {
    try {
      // Sign out if a user is already signed in
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // If the user cancels the login process
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Google login error::$e:::');
      CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: 'Authentication failed');
      // showSnackBar(subtitle: 'Google login error: $e');
      return null;
    }
  }

  Future<AuthorizationCredentialAppleID?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      // print('User ID: ${credential.userIdentifier}');
      // print('Email: ${credential.email}');
      // print('Full Name: ${credential.givenName} ${credential.familyName}');
      return credential;
    } catch (e) {
      print('Apple login error::$e:::');
      CustomSnackBar().showSnack(Get.context!,message: 'Authentication failed',isSuccess: false);
      return null;
    }
  }

}