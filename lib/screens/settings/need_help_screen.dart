import 'package:apollo/resources/Apis/api_repository/need_help_repo.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class NeedHelpScreen extends StatefulWidget {
  const NeedHelpScreen({super.key});

  @override
  State<NeedHelpScreen> createState() => _NeedHelpScreenState();
}

class _NeedHelpScreenState extends State<NeedHelpScreen> {

  bool isButtonDisable = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController msgCtrl = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    msgCtrl.addListener(msgCtrlListner);

  }
  msgCtrlListner(){
    if(msgCtrl.text.isEmpty){
      isButtonDisable=true;
    }else{
      isButtonDisable = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // addHeight(52),
                  addHeight(10),
                  backBar(
                    title: "Need Help?",
                    trailing: true,
                    onTap: () {
                      Get.back();
                    },
                  ).marginSymmetric(horizontal: 16),
                  addHeight(24),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 16,right: 16,top: 24),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          addText500(
                              'Send us a message and our support team will get back to you shortly.',
                              fontSize: 16,height: 22),
                          addHeight(24),

                          CustomTextField(
                            maxLines: 10,
                            autocorrect: false,
                            controller: msgCtrl,
                            enableSuggestions: false,
                            hintText: 'Enter Message',
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value)=> validateField(field: 'message', value: msgCtrl.text),
                          ),
                          addHeight(24),


                          AppButton(
                            buttonText: 'Submit',
                            buttonColor: isButtonDisable==true?AppColors.buttonDisableColor:AppColors.primaryColor,
                            onButtonTap: isButtonDisable?(){}:() {
                            if(formKey.currentState?.validate()??false){

                              showLoader(true);
                              needHelpApi(topic: 'help',desc: msgCtrl.text).then((value){
                                showLoader(false);
                                if(value.status==true){
                                  Get.back();
                                  CustomSnackBar().showSnack(Get.context!,message: '${value.message}');
                                }
                              });
                            }

                          },)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
