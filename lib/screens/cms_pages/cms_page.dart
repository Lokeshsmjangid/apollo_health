
import 'package:apollo/controllers/settings_ctrl.dart';
import 'package:apollo/resources/Apis/api_models/cms_model.dart';
import 'package:apollo/resources/Apis/api_repository/cms_page_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class CmsScreen extends StatefulWidget {
  String? appBar;


  CmsScreen({super.key,this.appBar});

  @override
  State<CmsScreen> createState() => _CmsScreenState();
}

class _CmsScreenState extends State<CmsScreen> {
  CmsResponseModel model = CmsResponseModel();
  bool isDataLoading = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCmsData();
  }

  getCmsData() async{
    isDataLoading=true;
    setState(() {});
    await cmsApi(setting:
    widget.appBar=='About Us'?1:
    widget.appBar=='Privacy Policy'?2:3).then((value){
      model = value;
      isDataLoading=false;
      setState(() {});
    });
  }



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
            child: Column(
              children: [
                addHeight(10),
                backBar(
                    title: "${widget.appBar}",
                    onTap: () {
                      Get.back();
                    },
                    trailing: true

                ).marginSymmetric(horizontal: 16),
                addHeight(24),
                Expanded(
                  child: isDataLoading? Center(child: buildCpiLoader()):model.data!=null? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 16,right: 16,top: 8),
                    child: SingleChildScrollView(child: Html(data: model.data?.content,style: {
                      "body": Style(
                        fontSize: FontSize(13.0),
                        fontFamily: 'Manrope',
                      ),
                    },)),
                  ) : Center(child: addText600('No data found',color: AppColors.whiteColor)),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
