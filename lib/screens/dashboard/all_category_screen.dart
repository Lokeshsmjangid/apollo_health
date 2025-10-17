import 'dart:async';
import 'dart:io';

import 'package:animated_item/animated_item.dart';
import 'package:apollo/bottom_sheets/category_play_sheet.dart';
import 'package:apollo/bottom_sheets/category_ready_more_bottom_sheet.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_repository/category_one_dp_repo.dart';
import 'package:apollo/resources/Apis/api_repository/category_repo.dart';
import 'package:apollo/resources/Apis/api_repository/start_solo_play_repo.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/utils.dart';
import 'package:apollo/screens/ads/free_pass_ads_screen.dart';
import 'package:apollo/screens/app_subscriptions/premium_plan_ctrl.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../resources/Apis/api_models/category_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Timer? _glowTimer;
  bool _showGlow = false;


  CategoryModel model = CategoryModel();
  List<Category> categories = [];
  bool isDataLoading = false;

  late ScrollController scaleController;
  /*final List<Map<String, dynamic>> categories = [
    {'isLock': false,'title': 'Lub Dub Nation', 'subtitle': 'Heart Health', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3)},
    {'isLock': false,'title': 'Plastic Perception', 'subtitle': 'Beauty Meets Medicine', 'color': Color(0xFFFFE0B2), 'border': Color(0xFFFF9800)},
    {'isLock': false,'title': 'Medical Pop Culture', 'subtitle': 'Medical Scenes in Movies/Media', 'color': Color(0xFFFFCDD2), 'border': Color(0xFFE57373)},
    {'isLock': true,'title': 'Skin Deep', 'subtitle': 'Skin, Hair & Nails', 'color': Color(0xFFE1BEE7), 'border': Color(0xFFAB47BC)},
    {'isLock': true,'title': 'Snooze Control', 'subtitle': 'Sleep, Pain & Recovery', 'color': Color(0xFFC8E6C9), 'border': Color(0xFF66BB6A)},
    {'isLock': true,'title': 'Mind Matters', 'subtitle': 'Mental & Emotional Health', 'color': Color(0xFFF8BBD0), 'border': Color(0xFFF06292)},

    {'isLock': true,'title': 'Apollo Spotlight', 'subtitle': 'Shining Light on Trending Topics', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3)},
    {'isLock': true,'title': 'Gut Feelings', 'subtitle': 'Digestive Tract & Gut Health', 'color': Color(0xFFFFE0B2), 'border': Color(0xFFFF9800)},
    {'isLock': true,'title': 'Meds & Miracles', 'subtitle': 'Cures: Past to Present', 'color': Color(0xFFFFCDD2), 'border': Color(0xFFE57373)},
    {'isLock': true,'title': 'Globetrotters', 'subtitle': 'Staying Healthy During Travel', 'color': Color(0xFFE1BEE7), 'border': Color(0xFFAB47BC)},
    {'isLock': true,'title': 'Ouch or A-Okay?', 'subtitle': 'Health Dos & Don’ts', 'color': Color(0xFFC8E6C9), 'border': Color(0xFF66BB6A)},
    {'isLock': true,'title': 'EpiCenter', 'subtitle': 'From Detection to Prevention', 'color': Color(0xFFF8BBD0), 'border': Color(0xFFF06292)},

    {'isLock': true,'title': 'Primary Focus', 'subtitle': 'Simple Health Basics', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3)},
    {'isLock': true,'title': 'Myth vs. Fact', 'subtitle': 'Fact Check: Health Edition', 'color': Color(0xFFFFE0B2), 'border': Color(0xFFFF9800)},
    {'isLock': true,'title': 'Little Bodies', 'subtitle': 'Child Health Essentials', 'color': Color(0xFFFFCDD2), 'border': Color(0xFFE57373)},
    {'isLock': true,'title': 'Women\'s Health', 'subtitle': 'Women\'s Wellness Guide', 'color': Color(0xFFE1BEE7), 'border': Color(0xFFAB47BC)},
    {'isLock': true,'title': 'Men\'s Health', 'subtitle': 'Men\'s Wellness Guide', 'color': Color(0xFFC8E6C9), 'border': Color(0xFF66BB6A)},
    {'isLock': true,'title': 'Sore Winners', 'subtitle': 'Sports Safety & Recovery', 'color': Color(0xFFF8BBD0), 'border': Color(0xFFF06292)},

    {'isLock': true,'title': 'Neuro Nexus', 'subtitle': 'Brain Health', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3)},
    {'isLock': true,'title': 'Infectious Intel', 'subtitle': 'All About Bugs & Vaccines', 'color': Color(0xFFFFE0B2), 'border': Color(0xFFFF9800)},
    {'isLock': true,'title': 'Gland Masters', 'subtitle': 'Hormones at Work', 'color': Color(0xFFFFCDD2), 'border': Color(0xFFE57373)},
    {'isLock': true,'title': 'Rapid Response', 'subtitle': 'Quick Life-Saving Skills', 'color': Color(0xFFE1BEE7), 'border': Color(0xFFAB47BC)},
    {'isLock': true,'title': 'Tumor Terminators', 'subtitle': 'Understanding Cancer Topics', 'color': Color(0xFFC8E6C9), 'border': Color(0xFF66BB6A)},
    {'isLock': true,'title': 'Kidney Korner', 'subtitle': 'Kidney Function & Disorders', 'color': Color(0xFFF8BBD0), 'border': Color(0xFFF06292)},

    {'isLock': true,'title': 'Golden Years', 'subtitle': 'Health in Older Adulthood', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3)},
    {'isLock': true,'title': 'Breathe Easy', 'subtitle': 'Lung Health', 'color': Color(0xFFFFE0B2), 'border': Color(0xFFFF9800)},
    {'isLock': true,'title': 'Bone Zone', 'subtitle': 'Bone Health & Mobility', 'color': Color(0xFFFFCDD2), 'border': Color(0xFFE57373)},
    {'isLock': true,'title': 'Joint Forces', 'subtitle': 'Joint & Immune Issues', 'color': Color(0xFFE1BEE7), 'border': Color(0xFFAB47BC)},
    {'isLock': true,'title': 'Suture Society', 'subtitle': 'All About Surgeries', 'color': Color(0xFFC8E6C9), 'border': Color(0xFF66BB6A)},
    {'isLock': true,'title': 'Lens Legends', 'subtitle': 'Eyesight & Eye Care', 'color': Color(0xFFF8BBD0), 'border': Color(0xFFF06292)},

    {'isLock': true,'title': 'Rare & Remarkable', 'subtitle': 'Strange But True Cases', 'color': Color(0xFFB9C9FF), 'border': Color(0xFF4663D3)},


  ];*/


  int _lastSoundedIndex = -1;
  static const double _itemExtent = 0.9 * 120; // ≈ 108 px

  @override
  void initState() {
    // TODO: implement initState

    scaleController = ScrollController();
    scaleController.addListener(_handleScroll);
    super.initState();
    startGlowTimer();
    Future.microtask((){
      getAllCategoryData();
    });
  }



  @override
  void dispose() {
    scaleController.dispose();
    _glowTimer?.cancel(); // Always clean up
    super.dispose();
  }

  getAllCategoryData() async{
    isDataLoading = true;
    setState(() {});
    showLoader(true);
    await getAllCategoryApi().then((value){
      model = value;
      isDataLoading = false;
      if(model.data !=null && model.data!.isNotEmpty){
        categories.addAll(model.data!);
      }
      setState(() {});
      showLoader(false);
    });
  }


  void _handleScroll() {
    // work out which item’s top edge is currently nearest to the top
    final currentIndex =
    (scaleController.offset / _itemExtent).round().clamp(0, categories.length - 1);

    if (currentIndex != _lastSoundedIndex) {
      _lastSoundedIndex = currentIndex;
      SystemSound.play(SystemSoundType.click);
      HapticFeedback.mediumImpact();
      // optional custom sound:
      // _audioPlayer.play(AssetSource(AppAssets.actionButtonTapSound));
    }
  }


  void startGlowTimer() {
    _glowTimer = Timer.periodic(Duration(seconds: 5), (_) {
      glowSubscriptionIcon();
    });
  }
  void glowSubscriptionIcon() async {
    setState(() => _showGlow = true);
    await Future.delayed(Duration(milliseconds: 600)); // Glow duration
    setState(() => _showGlow = false);
  }

  // Exit from app
  int time = 0;
  bool back = false;
  int duration = 1000;
  Future<bool> willPop() async{
    int now = DateTime.now().millisecondsSinceEpoch;
    if(back && time >= now){
      back = false;
      exit(0);
    }
    else{
      time =  DateTime.now().millisecondsSinceEpoch+ duration;
      print("again tap");
      back = true;
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Press again the button to exit")));
      showToastBack(context,'Press back again to exit.');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:  Container(
          // color: Colors.red,
          constraints: BoxConstraints(maxWidth: 200),
          child: Column(
            children: [
              addText400("Categories",
              fontSize: 32,
              height: 40,
              color: AppColors.primaryColor,
              fontFamily: 'Caprasimo'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  addText400("Play any category by tapping  ",
                  fontSize: 12,
                  color: AppColors.primaryColor),
                  SvgPicture.asset(AppAssets.forwardArrowIcon,height: 16)
                ],
              ).marginOnly(bottom: 2),
            ],
          ),
        ),
      actions: [
      IconButton(
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      onPressed: () async {
        PremiumPlanCtrl controller = Get.isRegistered<PremiumPlanCtrl>()
            ? Get.find<PremiumPlanCtrl>()
            : Get.put(PremiumPlanCtrl());
        WidgetsBinding.instance.addPostFrameCallback((_)async {
          controller.setupPurchaseListener();
          await controller.initStoreInfo();

          controller.restoreSubscription();
        });
        Get.toNamed(AppRoutes.subscriptionScreen);
      },
      icon: _showGlow
          ? AvatarGlow(
        animate: true,
        glowColor: AppColors.primaryColor,
        // endRadius: 30,
        duration: Duration(milliseconds: 600),
        child: SvgPicture.asset(
          AppAssets.waveCheckIcon,
          height: 26,
          width: 26,
          color: AppColors.primaryColor,
        ),
      )
          : SvgPicture.asset(
        AppAssets.waveCheckIcon,
        height: 26,
        width: 26,
        color: AppColors.primaryColor,
      ),
    ).marginOnly(right: 10),



        /*IconButton(
            visualDensity: VisualDensity(horizontal: -4,vertical: -4),
            onPressed: (){
              // logic.effectSound(sound: AppAssets.actionButtonTapSound);
              Get.toNamed(AppRoutes.subscriptionScreen);
            }, icon: Container(
            decoration: BoxDecoration(
              // boxShadow: [BoxShadow(color: AppColors.primaryColor, blurRadius: 8, spreadRadius: 0.2)]
            ),
            child: SvgPicture.asset(AppAssets.waveCheckIcon,height: 24,width: 24,color: AppColors.primaryColor,))).marginOnly(right: 10),*/
      ],

      ),
      body: WillPopScope(
        onWillPop: willPop,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage( AppAssets.disclaimerBg,), fit: BoxFit.cover)
          ),
          child: SafeArea(
              child:
              // isDataLoading ? buildCpiLoader() :
              !isDataLoading && categories.isEmpty
                  ? Center(child: addText500('Categories not found.').marginSymmetric(horizontal: 16))
                  : buildCategoryStack().marginSymmetric(horizontal: 16)),
        ),
      ),
    );
  }

  Widget buildCategoryStack() {
    final List<Color> bgColors = [
      hexToColor("C8E6C9"),
      hexToColor("FFE0B2"),
      hexToColor("F8BBD0"),
      hexToColor("B9C9FF"),
      hexToColor("FFCDD2"),
      hexToColor("E1BEE7"),
    ];

    final List<Color> borderColors = [
      hexToColor("66BB6A"),
      hexToColor("FF9800"),
      hexToColor("F06292"),
      hexToColor("4663D3"),
      hexToColor("E57373"),
      hexToColor("AB47BC"),
    ];
    return ListView.builder(
          controller: scaleController,
          itemCount: categories.length,
          padding: EdgeInsets.only(bottom: 5),
          itemBuilder: (context,index){
        final category = categories[index];
        // final bgColor = category.backgroundColor;
        // final borderColor = category.borderColor;

        final bgColor = bgColors[index % bgColors.length];
        final borderColor = borderColors[index % borderColors.length];
        return AnimatedItem(
          index: index,
          controller: scaleController,
          effect: ScaleEffect(type: AnimationType.end),
          child: Align(
              heightFactor: 0.9,
              child: categoryCard(category,bgColor,borderColor).marginOnly(
                  top:index==0?30:0,
              )),
        );
      }
    );
  }

  Widget categoryCard(Category category,Color bgColor,Color borderColor) {
    return Stack(
      children: [
        Container( // main container
          padding: EdgeInsets.only(left: 6,right: 6,top: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border(top: BorderSide(color: borderColor, width: 6)),
          ),
          child: Container( // inner container
            padding: EdgeInsets.only(left: 12,bottom: 1),// top: 12,right: 24,
            // inside border
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              border: Border(
                top: BorderSide(color: borderColor,width: 2),
                left: BorderSide(color: borderColor,width: 2),
                right: BorderSide(color: borderColor,width: 2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addText600(category.shortDescription??'', fontSize: 12,maxLines: 1,
                          color: AppColors.blackColor,height: 21.12),
                      addText400(category.title??'', fontSize: 20, fontFamily: 'Caprasimo', color: borderColor,height: 22),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Transform.scale(
                              scale: 1.3,
                              child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: category.paidStatus==1?null:Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),

                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50)
                      )
                      // shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: category.paidStatus==1?borderColor.withOpacity(0.2):bgColor,
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: (){

                          if(category.paidStatus==1){
                            showCategoryReadyMoreSheet(context,
                                onTapUpgrade: (){
                              Get.back();
                              PremiumPlanCtrl controller = Get.isRegistered<PremiumPlanCtrl>()
                                  ? Get.find<PremiumPlanCtrl>()
                                  : Get.put(PremiumPlanCtrl());
                              WidgetsBinding.instance.addPostFrameCallback((_)async {
                                controller.setupPurchaseListener();
                                await controller.initStoreInfo();

                                controller.restoreSubscription();
                              });
                              Get.toNamed(AppRoutes.subscriptionScreen);},
                                onTapDayPass: (){
                                  Get.back();
                                  showLoader(true);
                                  categoryOneDayPassApi(categoryId: category.id).then((pass){
                                    showLoader(false);
                                    if(pass.status==true){
                                      category.paidStatus=0;
                                      setState(() {});
                                    }
                                    else if(pass.status==false){
                                      CustomSnackBar().showSnack(Get.context!,message: '${pass.message}',isSuccess: false);
                                    }
                                  });
                                },
                              onTap10MinFree: (){
                              Get.back();
                              Get.to(FreePassAdsScreen(game: 'category',catId: category.id,));
                              }
                            );
                          } else{
                            showCategoryPlaySheet(context,onButtonTap: (){
                              Get.back();
                              showLoader(true);
                              startSoloPlayApi(categoryId: '${category.id}',
                                  numberOfQuestions: 5,
                                  showExplanation: 1,
                                  highStakesMode: 0,
                                  randomMix: 0

                              ).then((value){
                                showLoader(false);
                                if(value.status==true){
                                  if(value.data!=null && value.data!.isNotEmpty){
                                    Get.toNamed(AppRoutes.quizScreenNew, arguments: {'screen': 'soloPlay',
                                      'questions': value.data,
                                      'gameData':value.gameData});
                                  }
                                } else if(value.status==false){
                                  CustomSnackBar().showSnack(Get.context!,message: '${value.message}',isSuccess: false);
                                }
                              });
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: category.paidStatus==1?Image.asset(AppAssets.lockIcon,height: 20,width: 20,color: borderColor,) :Icon(
                            Icons.arrow_forward_ios,
                            color: borderColor,
                            size: 16,
                          ),),
                      ),
                    ))).marginOnly(right: 0,top: 0),
                    Positioned(// hide circle from upper border
                        top: -8,
                        right: 8,
                        child: Container(
                      height: 8,
                      width: 150,
                          decoration: BoxDecoration(
                            color: bgColor,
                            border: Border(bottom: BorderSide(color: borderColor,width: 2))

                          ),
                    )),

                  ],
                )
              ],
            ),
          ),
        ),
        Positioned( // hide circle from TOP
            top: 0,
            right: 8,
            child: Container(
              height: 6,
              width: 150,
              decoration: BoxDecoration(
                  color: borderColor,


              ),
            )),
        Positioned( // hide circle from left
            top: 20,
            right: 0,
            child: Container(
              height: 90,
              width: 8,
              decoration: BoxDecoration(
                  color: bgColor,
                border: Border(left: BorderSide(color: borderColor,width: 2)),



              ),
            )),
      ],
    );
  }



/*Widget buildCategoryStack() {
    return ListView.builder(
          controller: scaleController,
          itemCount: categories.length,
          padding: EdgeInsets.only(bottom: 5),
          itemBuilder: (context,index){
        final category = categories[index];
        final bgColor = category['color'];
        final borderColor = category['border'];
        return AnimatedItem(
          index: index,
          controller: scaleController,
          effect: ScaleEffect(type: AnimationType.end),
          child: Align(
              heightFactor: 0.9,
              child: categoryCard(category,bgColor,borderColor).marginOnly(
                  top:index==0?30:0,
              )),
        );
      }
    );
  }

  Widget categoryCard(Map<String, dynamic> category,Color bgColor,Color borderColor) {
    return Stack(
      children: [
        Container( // main container
          padding: EdgeInsets.only(left: 6,right: 6,top: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border(top: BorderSide(color: borderColor, width: 6)),
          ),
          child: Container( // inner container
            padding: EdgeInsets.only(left: 12,bottom: 1),// top: 12,right: 24,
            // inside border
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              border: Border(
                top: BorderSide(color: borderColor,width: 2),
                left: BorderSide(color: borderColor,width: 2),
                right: BorderSide(color: borderColor,width: 2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addText600(category['subtitle'], fontSize: 12,
                          color: AppColors.blackColor,height: 21.12),
                      // const SizedBox(height: 4),s
                      addText400(category['title'], fontSize: 20, fontFamily: 'Caprasimo', color: borderColor,height: 22),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Transform.scale(
                              scale: 1.3,
                              child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: category['isLock']?null:Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          bottomRight: Radius.circular(50),

                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50)
                      )
                      // shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: category['isLock']?borderColor.withOpacity(0.2):bgColor,
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: (){
                          // effectSound(sound: AppAssets.actionButtonTapSound);
                          if(category['isLock']){
                            showReadyMoreSheet(context,onTapUpgrade: (){
                              // effectSound(sound: AppAssets.actionButtonTapSound);
                              Get.back();
                              Get.toNamed(AppRoutes.subscriptionScreen);
                            });
                          } else{
                            // effectSound(sound: AppAssets.actionButtonTapSound);
                            // Get.toNamed(AppRoutes.gMQuizScreen, arguments: {'screen': 'soloPlay'});
                            Get.toNamed(AppRoutes.quizScreenNew, arguments: {'screen': 'soloPlay'});
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: category['isLock']?Image.asset(AppAssets.lockIcon,height: 20,width: 20,color: borderColor,) :Icon(
                            Icons.arrow_forward_ios,
                            color: borderColor,
                            size: 16,
                          ),),
                      ),
                    ))).marginOnly(right: 0,top: 0),
                    Positioned(// hide circle from upper border
                        top: -8,
                        right: 8,
                        child: Container(
                      height: 8,
                      width: 150,
                          decoration: BoxDecoration(
                            color: bgColor,
                            border: Border(bottom: BorderSide(color: borderColor,width: 2))

                          ),
                    )),

                  ],
                )
              ],
            ),
          ),
        ),
        Positioned( // hide circle from TOP
            top: 0,
            right: 8,
            child: Container(
              height: 6,
              width: 150,
              decoration: BoxDecoration(
                  color: borderColor,


              ),
            )),
        Positioned( // hide circle from left
            top: 20,
            right: 0,
            child: Container(
              height: 90,
              width: 8,
              decoration: BoxDecoration(
                  color: bgColor,
                border: Border(left: BorderSide(color: borderColor,width: 2)),



              ),
            )),
      ],
    );
  }*/

}

