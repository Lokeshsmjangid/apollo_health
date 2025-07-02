
import 'package:apollo/bottom_sheets/sign_out_bottom_sheet.dart';
import 'package:apollo/controllers/settings_ctrl.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/custom_text_field.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class CmsScreen extends StatelessWidget {
  String? appBar;

  String description = """
<h1>Welcome to <strong>Apollo MedGames</strong>!</h1>
<p>Inspired by Apollo—the Greek god of medicine, knowledge, and light—our app brings health education to life through the power of game play...</p>
<ul>
  <li>Powered by reputable sources like WHO, CDC and medical society guidelines.</li>
  <li>Designed for everyone—no med school required.</li>
  <li>Real health facts with a side of smiles and “wait, what?!” moments.</li>
</ul>
<p>Whether you’re brushing up on basics or craving quirky medical gems, we’ve got a quiz that’s just your style.</p>
<p>Ready to boost your health IQ—with a smile? 😁💡</p>
""";

  CmsScreen({super.key,this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      body: GetBuilder<SettingsCtrl>(
        builder: (logic) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppAssets.notificationsBg,
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // addHeight(52),
                    backBar(
                      title: "$appBar",
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
                        child: Html(data: description),
                        ),
                      ),

                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }


}
