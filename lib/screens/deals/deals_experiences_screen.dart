
import 'package:apollo/models/deals_model.dart';
import 'package:apollo/resources/Apis/api_models/deals_services_model.dart';
import 'package:apollo/resources/Apis/api_repository/deals_searvices_repo.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/debouncer.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DealsExperiencesScreen extends StatefulWidget {
  const DealsExperiencesScreen({super.key});

  @override
  State<DealsExperiencesScreen> createState() => _DealsExperiencesScreenState();
}

class _DealsExperiencesScreenState extends State<DealsExperiencesScreen> {

  DealsServicesModel experienceModel = DealsServicesModel();
  TextEditingController searchCtrl = TextEditingController();
  final deBounce = Debouncer(milliseconds: 1000);
  bool isDataLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
      getDealsServices();
    });
  }

  getDealsServices({String? searchValue}) async{
    isDataLoading = true;
    setState(() {});
    await dealsServicesApi(apiFor: 'dealsExperience',search: searchValue).then((value){
      experienceModel = value;
      isDataLoading = false;
      setState(() {});
      glowSubscriptionIcon();
    });
  }


  final List<DealsModel> expList = [
    DealsModel(
      imageUrl: AppAssets.dE1,
      tag: 'WEEKEND ESCAPE',
      title: 'Get 15% off Weekend Wellness Retreats',
      description: 'Reset your body and mind in just two days.',
      expiry: 'Expires in 2 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dE2,
      tag: 'KITCHEN FUN',
      title: 'Book Sound Bath & Breathwork Events',
      description: 'Drop into deep calm through sound and breath.',
      expiry: 'Expires in 16 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dE3,
      tag: 'SPA TIME',
      title: 'Get 10% off Spa Day Packages',
      description: 'Indulge in full-body relaxation without travel.',
      expiry: 'Expires in 40 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dE4,
      tag: 'MOVE & WIN',
      title: 'Join Step Count Challenges with Rewards',
      description: 'Walk more, compete with friends, earn cool prizes.',
      expiry: 'Expires in 23 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dE5,
      tag: 'MINDFUL MOMENTS',
      title: 'Save 20% on Meditation & Mindfulness Pop-Ups',
      description: 'Drop in for calm, clarity, and quick resets.',
      expiry: 'Expires in 16 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dE6,
      tag: 'FITNESS GLOW',
      title: 'Join Glow-Up Fitness Bootcamps',
      description: 'Sweat, tone, and light up your motivation.',
      expiry: 'Expires in 82 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dE7,
      tag: 'TASTE & LEARN',
      title: 'Get 8% off Nutrition Tasting Tours',
      description: 'Discover smart food swaps your body will love.',
      expiry: 'Expires in 55 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dE8,
      tag: 'SELF-CARE SOCIALS',
      title: 'Find Self-Care Pop-Ups & Events',
      description: 'Treat yourself, connect with others, feel amazing.',
      expiry: 'Expires in 7 days',
    ),
  ];

  bool _showGlow = false;
  glowSubscriptionIcon() async{
    setState(() => _showGlow = true);
    await Future.delayed(Duration(milliseconds: 1000)); // Glow duration
    setState(() => _showGlow = false);
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF1CAD64),
      body: Stack(
        children: [
          Positioned(
            child: SvgPicture.asset(
              AppAssets.dealsExperienceBGEffect,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // addHeight(52),

                addHeight(10),
                backBar(
                  title: "Experiences",
                  trailing: true,
                  onTap: () {
                    Get.back();
                  },
                ).marginSymmetric(horizontal: 16),
                addHeight(44),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        ),
                        child: Column(
                          children: [

                            const SizedBox(height: 48),
                            Container(
                              height: 56, // Adjust height as per screenshot
                              decoration: BoxDecoration(
                                color: Colors.white, // White background for the search box
                                borderRadius: BorderRadius.circular(28), // Rounded corners
                                border: Border.all(color: Color(0xFF66E58A), width: 1.0), // Light grey border
                              ),
                              child: Center(
                                child: TextField(
                                  autocorrect: false,
                                  onChanged: (val){
                                    deBounce.run((){
                                      getDealsServices(searchValue: val);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Color(0XFF67656B),fontFamily: 'Manrope',fontSize: 16),
                                    prefixIcon: Image.asset(AppAssets.searchIcon).marginAll(16),
                                    border: InputBorder.none, // Remove default TextField border
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
                                  ),
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                                  cursorColor: Color(0xff66E58A), // Custom cursor color
                                ),
                              ),
                            ).marginSymmetric(horizontal: 16),

                            addHeight(8),
                            Expanded(
                              child: isDataLoading ? buildCpiLoader()
                                  : experienceModel.data!=null && experienceModel.data!.isNotEmpty
                                  ? ListView.builder(
                                itemCount: experienceModel.data!.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final product = experienceModel.data![index];

                                  return GestureDetector(
                                    onTap: (){
                                      var url = product.url!.contains('https://')?product.url: 'https://${product.url}';
                                      launchURL(url: '$url');
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 72,
                                            width: 72,
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            decoration: BoxDecoration(
                                                color: Color(0xFF1CAD64),
                                                borderRadius: BorderRadius.circular(8)
                                            ),
                                            // child: Image.asset(product.imageUrl),
                                            child: CachedImageCircle2(imageUrl: product.image,isCircular: false),
                                          ),
                                          addWidth(12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(

                                                      decoration: BoxDecoration(
                                                          color: Color(0xff1CAD64),
                                                          borderRadius: BorderRadius.circular(6)
                                                      ),
                                                      child: addText700('${product.pillbox?.toUpperCase()}',fontSize: 10,color: AppColors.whiteColor).marginSymmetric(horizontal: 8,vertical: 4),
                                                    ),
                                                    Spacer(),
                                                    IconButton(
                                                      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                                                      onPressed: (){
                                                        Share.share('Hi! Just spotted a great health deal on the Apollo app. Grab your discount here:\n${product.url}');

                                                      },
                                                      icon: _showGlow
                                                          ? AvatarGlow(
                                                        animate: true,
                                                        glowColor:  Color(0xFF1CAD64),
                                                        // endRadius: 30,
                                                        duration: Duration(milliseconds: 1000),
                                                        child: SvgPicture.asset(
                                                          AppAssets.dealShareIcon,
                                                          height: 24,
                                                          width: 24,
                                                          color:  Color(0xFF1CAD64),
                                                        ),
                                                      )
                                                          : SvgPicture.asset(AppAssets.dealShareIcon,
                                                        height: 24,
                                                        width: 24,
                                                        color:  Color(0xFF1CAD64),
                                                      ),
                                                    ),
                                                    /*GestureDetector(
                                                      onTap: (){
                                                        Share.share('Hi! Just spotted a great health deal on the Apollo app. Grab your discount here:\n${product.url}');

                                                      },
                                                      child: Container(
                                                          height: 28,
                                                          width: 28,
                                                          padding: EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                            // color: Colors.green,
                                                              shape: BoxShape.circle
                                                          ),
                                                          child: SvgPicture.asset(AppAssets.dealShareIcon,color: Color(0xFF1CAD64),)),
                                                    )*/
                                                  ],
                                                ),
                                                addText600('${product.title}',fontSize: 16),
                                                addText400('${product.description}',fontSize: 12),
                                                addText400('Expires in ${product.expiryDate} days',fontSize: 9,color: AppColors.redColor1),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).marginOnly(bottom: 10),
                                  );
                                },
                              ) : Center(child: addText500('No active oﬀers at the moment.\nStay tuned for fresh finds!',textAlign: TextAlign.center)),
                            ),
                            // AppButton(
                            //   buttonText: 'Start Free 7-Day Trial',
                            // onButtonTap: (){},
                            //
                            //
                            // ).marginSymmetric(horizontal: 16),
                            // addHeight(36),
                          ],
                        ),
                      ),

                      Positioned(
                        top: -48,

                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                                AppAssets.dealsExpImg,
                                width: 84,
                                height: 84
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


}
