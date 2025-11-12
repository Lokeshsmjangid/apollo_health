import 'dart:convert';
import 'dart:io';

import 'package:apollo/controllers/sign_up_controller.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/Apis/api_repository/register_repo.dart';
import 'package:apollo/resources/Apis/api_repository/sociallogin_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/local_storage.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/cms_pages/cms_page.dart';
import 'package:apollo/screens/cms_pages/cms_page_webview.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {

  final formKey = GlobalKey<FormState>();
  bool isAcknowledge = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: GetBuilder<SignUpCtrl>(builder: (logic) {
          return Column(
            children: [
              // addHeight(52),

              backBar(
                title: "Create an Account",
                backButtonColor: AppColors.blackColor,
                titleColor: AppColors.blackColor,
                isBack: true,
                onTap: () {
                  Get.back();
                },
              ),
              Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          addHeight(32),
                         /* Align(
                              alignment: Alignment.centerLeft,
                              child: addText500("Email", fontSize: 16,
                                  color: AppColors.textColor)).marginOnly(
                              left: 12, bottom: 6),*/

                          CustomTextField(
                            hintText: 'Enter Email',
                            controller: logic.emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (val){
                              if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty && logic.confPassCtrl.text.isNotEmpty && isAcknowledge){
                                logic.isButtonDisable=false;
                                logic.update();
                              } else {
                                logic.isButtonDisable=true;
                                logic.update();
                              }
                            },
                            validator: (value) => validateField(field: 'email', value: logic.emailCtrl.text),
                          ),
                          addHeight(20),

                         /* Align(
                              alignment: Alignment.centerLeft,
                              child: addText500("Password", fontSize: 16,
                                  color: AppColors.textColor)).marginOnly(
                              left: 12, bottom: 6),*/

                          CustomTextField(
                              hintText: 'Enter Password',
                              controller: logic.passCtrl,
                              obscureText: logic.obscurePass,
                              validator: (value) => validateField(field: 'password', value: logic.passCtrl.text),
                              helperText: "Use at least 8 characters with one uppercase letter, one number, and one special character.",
                              onChanged: (val){
                              if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty && logic.confPassCtrl.text.isNotEmpty && isAcknowledge){
                                logic.isButtonDisable=false;
                                logic.update();
                              } else {
                                logic.isButtonDisable=true;
                                logic.update();
                              }
                            },
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  logic.onTapSuffix(isPass: true);
                                },
                                child: SizedBox(
                                    height: logic.obscurePass?24:16,
                                    width: logic.obscurePass?24:16,
                                    child: Image.asset(!logic.obscurePass?AppAssets.eyeIcon:AppAssets.eyeOffIcon))

                              ),

                          ),
                          addHeight(20),

                         /* Align(
                              alignment: Alignment.centerLeft,
                              child: addText500(
                                  "Confirm Password", fontSize: 16,
                                  color: AppColors.textColor)).marginOnly(
                              left: 12, bottom: 6),*/
                          CustomTextField(
                              controller: logic.confPassCtrl,
                              obscureText: logic.obscureCPass,
                              hintText: 'Enter Password Again',
                              onChanged: (val){
                                if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty && logic.confPassCtrl.text.isNotEmpty && isAcknowledge){
                                  logic.isButtonDisable=false;
                                  logic.update();
                                } else {
                                  logic.isButtonDisable=true;
                                  logic.update();
                                }
                              },
                              validator: (value) => validateField(field: 'Confirm Password', value: logic.passCtrl.text,originalPassword: logic.confPassCtrl.text),
                              suffixIcon: GestureDetector(
                                  onTap: (){
                                    logic.onTapSuffix(isPass: false);
                                  },
                                  child: SizedBox(
                                      height: logic.obscureCPass?24:16,
                                      width:  logic.obscureCPass?24:16,
                                      child: Image.asset(
                                          !logic.obscureCPass?AppAssets.eyeIcon:AppAssets.eyeOffIcon))

                              )),
                          addHeight(20),

                          CustomTextField(
                              hintText: 'Referral Code (Optional)',
                              controller: logic.referralCtrl,

                          ),
                          addHeight(20),
                          // addHeight(76),

                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  isAcknowledge = !isAcknowledge;
                                  setState(() {});
                                  if(logic.emailCtrl.text.isNotEmpty && logic.passCtrl.text.isNotEmpty && logic.confPassCtrl.text.isNotEmpty && isAcknowledge){
                                    logic.isButtonDisable=false;
                                    logic.update();
                                  } else {
                                    logic.isButtonDisable=true;
                                    logic.update();
                                  }

                                },
                                child: Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                    // color: red,
                                    border: Border.all(
                                        color: isAcknowledge
                                            ? AppColors.primaryColor
                                            : AppColors.blackColor,
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: isAcknowledge
                                      ? Center(
                                    child:
                                    Image.asset(AppAssets.checkIcon).marginAll(3),
                                  )
                                      : null,
                                ),
                              ),
                              addWidth(12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Manrope'
                                    ),
                                    children: [
                                      const TextSpan(text: "I accept the "),
                                      TextSpan(
                                        text: "Terms",
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: AppColors.primaryColor,
                                            fontFamily: 'Manrope'
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = () => Get.to(()=>CmsView(page: 'terms',)),
                                      ),
                                      const TextSpan(text: " and "),
                                      TextSpan(
                                        text: "Privacy Policy.",
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: AppColors.primaryColor,
                                            fontFamily: 'Manrope'
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = () => Get.to(()=>CmsView(page: 'privacy')),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          addHeight(14),

                          AppButton(
                            buttonText: 'Sign up',
                            buttonColor: logic.isButtonDisable?AppColors.buttonDisableColor:AppColors.primaryColor,
                            onButtonTap: logic.isButtonDisable
                                ? (){} :
                                () {// effectSound(sound: AppAssets.actionButtonTapSound);

                              if(formKey.currentState?.validate()??false) {


                                showLoader(true);
                                // StepOne api
                                registerApi(
                                    email: logic.emailCtrl.text,
                                    password: logic.passCtrl.text,
                                    passwordConfirm: logic.confPassCtrl.text,
                                    refCode: logic.referralCtrl.text.trim().toString().toUpperCase()
                                ).then((value){
                                  showLoader(false);
                                  if(value.status==true){
                                    LocalStorage().setValue(LocalStorage.USER_TOKEN, value.token.toString());
                                    LocalStorage().setValue(LocalStorage.USER_DATA, jsonEncode(value.data));
                                    AuthData().getLoginData();
                                    Get.toNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {
                                      'goBack': 'signUp',
                                      'email':logic.emailCtrl.text,
                                      'password':logic.confPassCtrl.text,
                                    });
                                  }
                                });}}),
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
                              addText400(
                                  'or', fontSize: 12, color: Color(0xffAAA4B3))
                                  .marginSymmetric(horizontal: 12),

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

                         /* Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: (){
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
                                              Get.offAllNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {'goBack': 'signUp',});
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
                                                Get.offAllNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {'goBack': 'signUp'});
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
                              showLoader(true);
                              logic.signInWithApple().then((appleData){
                                showLoader(false);
                                if(appleData!=null){
                                  apolloPrint(message: '${appleData.userIdentifier}');
                                  String firstName='';
                                  String lastName="";
                                  if(appleData.givenName != null){
                                    List<String> nameParts = appleData.givenName!.split(" ");
                                    firstName = nameParts.isNotEmpty ? nameParts.first : "";
                                    lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
                                    apolloPrint(message: '${appleData.email}');
                                  }
                                  // List<String> nameParts = appleData.givenName!.split(" ");
                                  // String firstName = nameParts.isNotEmpty ? nameParts.first : "";
                                  // String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
                                  // apolloPrint(message: '${appleData.email}');
                                  // apolloPrint(message: '${appleData.userIdentifier}');
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
                                        Get.offAllNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {'goBack': 'signUp'});
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
                                      }}
                                    else {
                                      apolloPrint(message: 'User Login but personal details not filled---11---> ${value.data?.email}');
                                      Get.offAllNamed(AppRoutes.signUpPersonalInfoScreen,arguments: {'goBack': 'signUp',});
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
                              addText400('Have an account? ', fontSize: 14),
                              GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.signInScreen);
                                  },
                                  child: addText500('Sign in', fontSize: 16,
                                      color: AppColors.primaryColor,
                                      decoration: TextDecoration.underline))
                            ],
                          ),
                          addHeight(40),
                        ],
                      ),
                    ),
                  ))

            ],
          );
        }).marginSymmetric(horizontal: 16),
      ),
    );
  }
}