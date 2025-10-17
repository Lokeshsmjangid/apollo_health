
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:apollo/controllers/login_controller.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/Apis/api_repository/login_repo.dart';
import 'package:apollo/resources/Apis/api_repository/sociallogin_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {



  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: GetBuilder<LoginController>(builder: (logic) {
          return Column(
            children: [
              // addHeight(52),
              // AppBar
              backBar(
                title: "Sign in",
                isBack: false,
                backButtonColor: AppColors.blackColor,
                titleColor: AppColors.blackColor,
                onTap: () { Get.back(); },
                // trailing: true
              ),
              // addHeight(32),
              addHeight(32),
              Expanded(
                  child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // addHeight(20),


                      Align(
                          alignment: Alignment.centerLeft,
                          child: addText500("Email", fontSize: 16,
                              color: AppColors.textColor,
                              height: 22)).marginOnly(left: 12, bottom: 6),
                      CustomTextField(
                        hintText: 'Enter Email',
                        controller: logic.emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => validateField(field: 'email', value: logic.emailCtrl.text),
                        onChanged: (val){
                          if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty){
                            logic.isButtonDisable=false;
                            logic.update();
                          } else {
                            logic.isButtonDisable=true;
                            logic.update();
                          }
                        },
                      ),
                      addHeight(20),

                      Align(
                          alignment: Alignment.centerLeft,
                          child: addText500("Password", fontSize: 16,
                              color: AppColors.textColor,
                              height: 22)).marginOnly(left: 12, bottom: 6),
                      CustomTextField(
                          hintText: 'Enter Password',
                          obscureText: logic.obscureText,
                          controller: logic.passCtrl,
                          helperText: 'Use at least 8 characters with one uppercase letter, one number, and one special character.',
                          validator: (value) => validateField(field: 'password', value: logic.passCtrl.text),
                          suffixIcon: GestureDetector(
                            onTap: logic.onTapSuffix,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                                height: logic.obscureText?24:16,
                                width: logic.obscureText?24:16,
                                child: Image.asset(
                                !logic.obscureText?AppAssets.eyeIcon : AppAssets.eyeOffIcon)
                                ),
                          ),
                        onChanged: (val){
                            if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty){
                              logic.isButtonDisable=false;
                              logic.update();
                            } else {
                              logic.isButtonDisable=true;
                              logic.update();
                            }
                        },

                      ),
                      addHeight(28),

                      Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(

                            onTap: () {
                              // effectSound(sound: AppAssets.actionButtonTapSound);
                              Get.toNamed(AppRoutes.forgotPasswordScreen);
                            },
                            child: addText500(
                                'Forgot password?', fontSize: 16,
                                height: 22,
                                color: AppColors.primaryColor,
                                decoration: TextDecoration.underline),
                          )),

                      addHeight(28),
                      AppButton(
                          buttonText: 'Sign in',
                          buttonColor: logic.isButtonDisable?AppColors.buttonDisableColor:AppColors.primaryColor,
                          onButtonTap: logic.isButtonDisable?(){}:() {
                            if (formKey.currentState?.validate() ?? false) {
                              showLoader(true);
                              loginApi(email: logic.emailCtrl.text,password: logic.passCtrl.text).then((value){
                                showLoader(false);
                                if(value.status==true){
                                  LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                  LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                  LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
                                  AuthData().getLoginData();
                                  if(value.data?.status == 1){
                                    apolloPrint(message: 'Is User Login---00---> ${value.data?.email}');
                                    if(value.data?.disclaimerStatus==1){
                                      Get.offAll(() =>DashBoardScreen());
                                      CustomSnackBar().showSnack(Get.context!, message: 'You’ve successfully logged in.');
                                    }
                                    else{
                                      Get.offAllNamed(AppRoutes.signUpDisclaimerScreen);
                                    }}
                                  else {
                                    apolloPrint(message: 'User Login but personal details not filled---11---> ${value.data?.email}');
                                    Get.offAllNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {'goBack': 'signIn'});
                                  }
                                  // LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                  // LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                  // AuthData().getLoginData();
                                  // Get.offAll(() => DashBoardScreen());
                                  // CustomSnackBar().showSnack(Get.context!, message: 'You’ve successfully logged in.');
                                } else if(value.status==false){
                                  CustomSnackBar().showSnack(Get.context!, isSuccess: false,message: '${value.message}');
                                }
                              });
                            }
                          }),
                      addHeight(20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  color: Color(0xffAAA4B3)
                              ),
                            ),
                          ),

                          addText400('or', fontSize: 12, color: Color(0xffAAA4B3))
                              .marginSymmetric(horizontal: 8),

                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                  color: Color(0xffAAA4B3)
                              ),
                            ),
                          ),
                        ],
                      ),
                      addHeight(20),


                      // Social Icons
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                showLoader(true);
                                logic.signInWithGoogle().then((googleData){
                                  showLoader(false);
                                  if(googleData!=null){
                                    List<String> nameParts = googleData.displayName!.split(" ");
                                    String firstName = nameParts.isNotEmpty ? nameParts.first : "";
                                    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
                                    apolloPrint(message: '${googleData.email}');
                                    apolloPrint(message: googleData.uid);
                                    showLoader(true);
                                    socialLoginApi(loginType: 'google',
                                      firstName: firstName,
                                      lastName: lastName,
                                      email: googleData.email,
                                      socialId: googleData.uid,
                                    ).then((value){
                                      showLoader(false);
                                      if(value.status==true){
                                        LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                        LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                        AuthData().getLoginData();
                                        LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
                                        if(value.data?.status == 1){
                                          apolloPrint(message: 'Is User Login---00---> ${value.data?.email}');

                                          if(value.data?.disclaimerStatus==1){

                                            Get.offAll(() =>DashBoardScreen());
                                            CustomSnackBar().showSnack(Get.context!, message: 'You’ve successfully logged in.');
                                          }else{
                                            Get.offAllNamed(AppRoutes.signUpDisclaimerScreen);
                                          }

                                        }
                                        else {
                                          apolloPrint(message: 'User Login but personal details not filled---11---> ${value.data?.email}');
                                          Get.offAllNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {'goBack': 'signIn'});
                                        }
                                        // LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                        // LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                        // AuthData().getLoginData();
                                        // Get.offAll(() => DashBoardScreen());
                                        // CustomSnackBar().showSnack(Get.context!, message: 'You’ve successfully logged in.');
                                      } else if(value.status==false){
                                        CustomSnackBar().showSnack(Get.context!, isSuccess: false,message: '${value.message}');
                                      }
                                    });
                                  }
                                });
                              },
                              child: SvgPicture.asset(AppAssets.googleIcon)),


                          if(Platform.isIOS)
                          addWidth(24),
                          if(Platform.isIOS)

                          GestureDetector(
                              onTap: (){
                                showLoader(true);
                                logic.signInWithApple().then((appleData){
                                  showLoader(false);
                                  if(appleData!=null){
                                    List<String> nameParts = appleData.givenName!.split(" ");
                                    String firstName = nameParts.isNotEmpty ? nameParts.first : "";
                                    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
                                    apolloPrint(message: '${appleData.email}');
                                    apolloPrint(message: '${appleData.userIdentifier}');
                                    showLoader(true);
                                    socialLoginApi(loginType: 'apple',
                                      firstName: firstName,
                                      lastName: lastName,
                                      email: appleData.email,
                                      socialId: appleData.userIdentifier,
                                    ).then((value){
                                      showLoader(false);
                                      if(value.status==true){
                                        LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                        LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                        AuthData().getLoginData();
                                        LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
                                        if(value.data?.status == 1){
                                          apolloPrint(message: 'Is User Login---00---> ${value.data?.email}');
                                          if(value.data?.disclaimerStatus==1){
                                            Get.offAll(() =>DashBoardScreen());
                                            CustomSnackBar().showSnack(Get.context!, message: 'You’ve successfully logged in.');
                                          }else{
                                            Get.offAllNamed(AppRoutes.signUpDisclaimerScreen);
                                          }

                                        }
                                        else {
                                          apolloPrint(message: 'User Login but personal details not filled---11---> ${value.data?.email}');
                                          Get.offAllNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {'goBack': 'signIn'});
                                        }
                                        // LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                        // LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                        // AuthData().getLoginData();
                                        // Get.offAll(() => DashBoardScreen());
                                        // CustomSnackBar().showSnack(Get.context!, message: 'You’ve successfully logged in.');
                                      } else if(value.status==false){
                                        CustomSnackBar().showSnack(Get.context!, isSuccess: false,message: '${value.message}');
                                      }
                                    });
                                  }
                                });
                              },

                              child: SvgPicture.asset(AppAssets.appleIcon)),
                          // addWidth(24),
                          // SvgPicture.asset(AppAssets.facebookIcon),
                        ],
                      ),*/


                      if(Platform.isIOS)
                      socialButton(label: 'Sign in with Apple',labelIcon: AppAssets.appleIcon,onPressed: (){

                        apolloPrint(message: 'Apple login');
                        showLoader(true);
                        logic.signInWithApple().then((appleData){
                          showLoader(false);
                          log('message---> $appleData');
                          log('message---> ${appleData?.userIdentifier}');
                          log('message---> ${appleData != null}');
                          if(appleData != null){

                            apolloPrint(message: '${appleData.userIdentifier}');
                            String firstName='';
                            String lastName="";
                            if(appleData.givenName != null){
                              List<String> nameParts = appleData.givenName!.split(" ");
                              firstName = nameParts.isNotEmpty ? nameParts.first : "";
                              lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
                              apolloPrint(message: '${appleData.email}');
                            }
                            showLoader(true);
                            socialLoginApi(loginType: 'apple',
                              firstName: firstName??"",
                              lastName: lastName??'',
                              email: appleData.email??"",
                              socialId: appleData.userIdentifier,
                            ).then((value){
                              showLoader(false);
                              if(value.status==true){
                                LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
                                AuthData().getLoginData();
                                if(value.data?.status == 1){
                                  apolloPrint(message: 'Is User Login---00---> ${value.data?.email}');
                                  if(value.data?.disclaimerStatus==1){
                                    Get.offAll(() =>DashBoardScreen());
                                    CustomSnackBar().showSnack(Get.context!, message: 'You’ve successfully logged in.');
                                  }else{
                                    Get.offAllNamed(AppRoutes.signUpDisclaimerScreen);
                                  }

                                }
                                else {
                                  apolloPrint(message: 'User Login but personal details not filled---11---> ${value.data?.email}');
                                  Get.offAllNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {'goBack': 'signIn'});
                                }
                                // LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                // LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                // AuthData().getLoginData();
                                // Get.offAll(() => DashBoardScreen());
                                // CustomSnackBar().showSnack(Get.context!, message: 'You’ve successfully logged in.');
                              }
                              else if(value.status==false){
                                CustomSnackBar().showSnack(Get.context!, isSuccess: false,message: '${value.message}');
                              }
                            });
                          }
                        });
                      }),
                      if(Platform.isIOS)
                      addHeight(16),
                      socialButton(label: 'Sign in with Google',labelIcon: AppAssets.googleIcon,onPressed: (){
                        showLoader(true);
                        logic.signInWithGoogle().then((googleData){
                          showLoader(false);
                          if(googleData!=null){
                            List<String> nameParts = googleData.displayName!.split(" ");
                            String firstName = nameParts.isNotEmpty ? nameParts.first : "";
                            String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
                            apolloPrint(message: '${googleData.email}');
                            apolloPrint(message: googleData.uid);
                            showLoader(true);
                            socialLoginApi(loginType: 'google',
                              firstName: firstName,
                              lastName: lastName,
                              email: googleData.email,
                              socialId: googleData.uid,
                            ).then((value){
                              showLoader(false);
                              if(value.status==true){
                                LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                LocalStorage().setBoolValue(LocalStorage.IS_PREMIUM, value.data!.subscription==1?true:false);
                                AuthData().getLoginData();
                                if(value.data?.status == 1){
                                  apolloPrint(message: 'Is User Login---00---> ${value.data?.email}');

                                  if(value.data?.disclaimerStatus==1){

                                    Get.offAll(() =>DashBoardScreen());
                                    CustomSnackBar().showSnack(Get.context!, message: 'You’ve successfully logged in.');
                                  }else{
                                    Get.offAllNamed(AppRoutes.signUpDisclaimerScreen);
                                  }

                                }
                                else {
                                  apolloPrint(message: 'User Login but personal details not filled---11---> ${value.data?.email}');
                                  Get.offAllNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {'goBack': 'signIn'});
                                }
                                // LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                // LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                // AuthData().getLoginData();
                                // Get.offAll(() => DashBoardScreen());
                                // CustomSnackBar().showSnack(Get.context!, message: 'You’ve successfully logged in.');
                              } else if(value.status==false){
                                CustomSnackBar().showSnack(Get.context!, isSuccess: false,message: '${value.message}');
                              }
                            });
                          }
                        });
                      }),
                      addHeight(26),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          addText400('Don’t have an account? ', fontSize: 14),
                          GestureDetector(
                              onTap: () {
                                // effectSound(sound: AppAssets.actionButtonTapSound);
                                Get.toNamed(AppRoutes.createAccountScreen);
                              },
                              child: addText500('Sign up', fontSize: 16,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline))
                        ],
                      ),
                      addHeight(40),

                    ],
                  ),
                ),
              )
              )

            ],
          );
        }).marginSymmetric(horizontal: 16),
      ),
    );
  }
}