
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

class DealsProductScreen extends StatefulWidget {
  const DealsProductScreen({super.key});

  @override
  State<DealsProductScreen> createState() => _DealsProductScreenState();
}

class _DealsProductScreenState extends State<DealsProductScreen> {


  DealsServicesModel productModel = DealsServicesModel();
  TextEditingController searchCtrl = TextEditingController();
  final deBounce = Debouncer(milliseconds: 1000);
  bool isDataLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask((){
      getDeals();
    });
  }

  getDeals({String? searchValue}) async{
    isDataLoading = true;
    setState(() {});
    await dealsServicesApi(apiFor: 'dealsProduct',search: searchValue).then((value){
      productModel = value;
      isDataLoading = false;
      setState(() {});
      glowSubscriptionIcon();
    });
  }


  final List<DealsModel> productList = [
    DealsModel(
      imageUrl: AppAssets.dp1,
      tag: 'DAILY BOOST',
      title: 'Get 15% off Multivitamin Gummies',
      description: 'Boost energy. Support immunity. Enjoy daily wellness in one tasty gummy.',
      expiry: 'Expires in 6 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp2,
      tag: 'CHILL MODE',
      title: 'Get 20% off Ashwagandha Caps.',
      description: 'Reduce stress. Balance mood. Feel more grounded each day.',
      expiry: 'Expires in 23 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp3,
      tag: 'HYDRATION HACKER',
      title: 'Save 15% on Smart Water Bottles',
      description: 'Track hydration. Stay refreshed. Drink more, effortlessly.',
      expiry: 'Expires in 40 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp4,
      tag: 'SCREEN SAVIORS',
      title: 'Get 10% off Blue Light Glasses',
      description: 'Block strain. Protect eyes. Work longer, feel better.',
      expiry: 'Expires in 22 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp5,
      tag: 'MUSCLE MELT',
      title: 'Save 25% on Massage Guns',
      description: 'Soothe muscles. Boost circulation. Recover anytime.',
      expiry: 'Expires in 12 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp6,
      tag: 'ZEN ZONE',
      title: 'Get 15% off Diffusers',
      description: 'Fill your space. Lift your mood. Breathe in calm.',
      expiry: 'Expires in 11 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp7,
      tag: 'DESK HERO',
      title: 'Save 20% on Posture Correctors',
      description: 'Align your spine. Ease tension. Improve posture daily.',
      expiry: 'Expires in 35 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp8,
      tag: 'DREAM TEAM',
      title: 'Get 15% off Sleep Devices',
      description: 'Fall asleep faster. Sleep deeper. Wake up refreshed.',
      expiry: 'Expires in 3 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp9,
      tag: 'SMILE UPGRADE',
      title: 'Save 20% on Whitening Kits',
      description: 'Whiten safely. Smile confidently. Glow in every photo.',
      expiry: 'Expires in 76 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp10,
      tag: 'GLOW GOALS',
      title: 'Get 20% off Skin Care Sets',
      description: 'Cleanse. Hydrate. Glow daily with simple routines, made your skin shiny.',
      expiry: 'Expires in 9 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp11,
      tag: 'BACK SAVER',
      title: 'Save 15% on Ergonomic Cushions',
      description: 'Ease pressure. Improve posture. Work in comfort.',
      expiry: 'Expires in 18 days',
    ),
    DealsModel(
      imageUrl: AppAssets.dp12,
      tag: 'MOVE MORE',
      title: 'Get 25% off Fitness Trackers',
      description: 'Track progress. Stay motivated. Crush your goals.',
      expiry: 'Expires in 6 days',
    ),
  ];

  bool _showGlow = false;
  glowSubscriptionIcon() async{
    setState(() => _showGlow = true);
    await Future.delayed(Duration(milliseconds: 600)); // Glow duration
    setState(() => _showGlow = false);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFF8A4CEB),
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
                // addHeight(52),

                addHeight(10),
                backBar(
                  title: "Products",
                  trailing: true,
                  onTap: () {
                    Get.back();
                  },
                ).marginSymmetric(horizontal: 16),
                addHeight(48),
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

                            const SizedBox(height: 52),
                            Container(
                              height: 56, // Adjust height as per screenshot
                              decoration: BoxDecoration(
                                color: Colors.white, // White background for the search box
                                borderRadius: BorderRadius.circular(28), // Rounded corners
                                border: Border.all(color: Color(0xFFD1B8F9), width: 1.0), // Light grey border
                              ),
                              child: Center(
                                child: TextField(
                                  autocorrect: false,
                                  onChanged: (val){
                                    deBounce.run((){
                                      getDeals(searchValue: val);
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
                                  cursorColor: Colors.deepPurple, // Custom cursor color
                                ),
                              ),
                            ).marginSymmetric(horizontal: 16),

                            addHeight(8),
                            Expanded(
                              child: isDataLoading ? buildCpiLoader()
                                  : productModel.data!=null && productModel.data!.isNotEmpty
                                  ? ListView.builder(
                                itemCount: productModel.data!.length,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemBuilder: (context, index) {
                                  final product = productModel.data![index];

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
                                              color: Color(0xFF8A4CEB),
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
                                                        color: Color(0xff8A4CEB),
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
                                                        glowColor: AppColors.primaryColor,
                                                        // endRadius: 30,
                                                        duration: Duration(milliseconds: 1000),
                                                        child: SvgPicture.asset(
                                                          AppAssets.dealShareIcon,
                                                          height: 24,
                                                          width: 24,
                                                          color: AppColors.primaryColor,
                                                        ),
                                                      )
                                                          : SvgPicture.asset(AppAssets.dealShareIcon,
                                                        height: 24,
                                                        width: 24,
                                                        color: AppColors.primaryColor,
                                                      ),
                                                    ),
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
                                AppAssets.dealsProductImg,
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
