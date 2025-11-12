
import 'package:apollo/resources/Apis/api_repository/add_friend_repo.dart';
import 'package:apollo/custom_widgets/online_status_dot_screen.dart';
import 'package:apollo/controllers/group_play_frinds_ctrl.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/controllers/my_frinds_ctrl.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';


class MyFriendsScreen extends StatefulWidget {
  const MyFriendsScreen({super.key});

  @override
  State<MyFriendsScreen> createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: GetBuilder<MyFriendsCtrl>(builder: (logic) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(AppAssets.notificationsBg, fit: BoxFit.fill),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  addHeight(10),
                  backBar(
                    title: "Friend Circle",
                    onTap: () => Get.back(),
                    isMail: true,
                    onTapMail: () => Get.toNamed(AppRoutes.playRequestScreen),
                  ).marginSymmetric(horizontal: 16),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        buildTabButton("My Friends", logic.isMyFriendsTab, () {
                          logic.isMyFriendsTab = true;
                          logic.page = 1;
                          logic.friendModel.data = [];
                          logic.selectedPlayers.clear();
                          logic.searchCtrl.clear();
                          logic.update();
                          logic.getFriendList(Page: 1);
                        }),
                        buildTabButton("Global Players", !logic.isMyFriendsTab, () {
                          logic.isMyFriendsTab = false;
                          logic.page = 1;
                          logic.friendModel.data = [];
                          logic.selectedPlayers.clear();
                          logic.searchCtrl.clear();
                          logic.update();
                          logic.getFriendList(Page: 1);
                        }),
                      ],
                    ),
                  ).marginSymmetric(horizontal: 15),
                  const SizedBox(height: 24),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            autocorrect: false,
                            controller: logic.searchCtrl,
                            onChanged: (val) {
                              logic.debounce.run(() {
                                logic.page = 1;
                                logic.getFriendList(search: val, Page: 1);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search by name',
                              prefixIcon: Icon(Icons.search, color: Color(0xff67656B)),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: AppColors.primaryColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: AppColors.primaryColor),
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xff67656B),
                              ),
                            ),
                          ),
                          addHeight(10),
                          Expanded(
                            child: logic.isDataLoading
                                ? buildCpiLoader()
                                : logic.friendModel.data != null && logic.friendModel.data!.isNotEmpty
                                ? ListView.builder(
                              controller: logic.paginationScrollController,
                              padding: EdgeInsets.only(bottom: 20),
                              physics: BouncingScrollPhysics(),
                              itemCount: logic.friendModel.data!.length + (logic.isPageLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (logic.isPageLoading && index == logic.friendModel.data!.length) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(strokeWidth: 1),
                                          ),
                                          addWidth(10),
                                          addText400('Loading...')
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final player = logic.friendModel.data![index];
                                final isSelected = logic.selectedPlayers.contains(player.id);
                                return GestureDetector(
                                  onTap: () {
                                    if(player.selfAccountStatus==0) {
                                      Get.toNamed(AppRoutes.otherProfileScreen,arguments: {'friend_id':player.id});
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [


                                      if(index==0 && logic.isMyFriendsTab)
                                      IgnorePointer(child: addText400('All Friends (${logic.friendModel.data?.length})',
                                          fontFamily: 'Caprasimo',fontSize: 20,height: 22)).marginOnly(top: 10),


                                      Container(
                                        margin: const EdgeInsets.only(bottom: 2),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 14),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.yellow10Color
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.yellow10Color,
                                                      shape: BoxShape.circle
                                                  ),
                                                  child: player.selfAccountStatus==0
                                                      ? CachedImageCircle2(imageUrl: player.profileImage,isCircular: true)
                                                      : apolloAvatar(),
                                                ),
                                                if(player.selfAccountStatus==0)
                                                Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: player.countryFlag!=null?Container(
                                                    width: 22,height: 15,
                                                    decoration: BoxDecoration(
                                                      // border: Border.all(color: AppColors.whiteColor,width: 1.5),
                                                        borderRadius: BorderRadius.circular(2)

                                                    ),
                                                    child: ClipRRect(
                                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                                      borderRadius: BorderRadius.circular(2),
                                                      child: Image.network('${player.countryFlag}',fit: BoxFit.cover),
                                                    ),):SizedBox.shrink(),
                                                ),

                                                if(player.onlineStatusVisible==1 && (player.userActive!=null && player.userActive!.isNotEmpty))
                                                  Positioned(
                                                      top: 2,
                                                      right: 0,
                                                      child: OnlineStatusDot(lastActiveTime: DateTime.parse("${player.userActive}"))),
                                              ],
                                            ),
                                            addWidth(12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  addText600(
                                                player.selfAccountStatus==1 ||player.selfAccountStatus==2
                                                    ? "Apollo User":
                                                    getTruncatedName(player.firstName??'',player.lastName??""),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    fontSize: 16,
                                                  ),
                                                  if(player.selfAccountStatus==0)
                                                  addHeight(2),
                                                  if(player.selfAccountStatus==0)
                                                  addText400('${player.xp} HP', fontSize: 12),
                                                ],
                                              ),
                                            ),

                                            if(AuthData().userModel?.roleId !=4)
                                            player.selfAccountStatus==1 || player.selfAccountStatus==2
                                                ? buildAddPlayButtonGrey():
                                            buildAddPlayButton(isMyFriendsTab: logic.isMyFriendsTab,
                                                isRequested: player.isRequested!,
                                                onTap: (){
                                                  final myFCtrl = Get.find<GroupPlayFriendsCtrl>();
                                                  if(logic.isMyFriendsTab){

                                                    Future.delayed(Duration(milliseconds: 800),(){
                                                      myFCtrl.isFriendsTab = true;
                                                      myFCtrl.getFriendList(Page: 1);

                                                      myFCtrl.selectedPlayers.add(player.id!);
                                                      myFCtrl.update();
                                                    });


                                                    if(!logic.catLoading) {
                                                      Get.toNamed(AppRoutes.gMGroupPlayScreen,
                                                          arguments: {'categories': logic.categories??[]})?.then((value){
                                                      });
                                                    }
                                                  }else if(logic.isMyFriendsTab==false && player.isRequested==false){
                                                    showLoader(true);
                                                    addFriendApi(userId: player.id).then((value){
                                                      showLoader(false);
                                                      if(value.status==true){
                                                        player.isRequested=true;
                                                        logic.update();
                                                      }else if(value.status==false){
                                                        CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                                                      }
                                                    });
                                                  }
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/Lottie/Appolo stetoskope.json', width: 200, height: 200),
                                addText700('Your crew’s missing!', fontSize: 22),
                                addText500('Add friends and let the healthy fun begin.', fontSize: 14),
                              ],
                            ),
                          )
                        ],
                      ).marginOnly(left: 16, right: 16, top: 24),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }




  Widget buildAddPlayButton({VoidCallback? onTap, bool isMyFriendsTab = true, bool isRequested = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: !isMyFriendsTab && isRequested ? AppColors.primaryColor : null,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: addText500(
          isMyFriendsTab
              ? 'Play'
              : (!isMyFriendsTab && isRequested)
              ? 'Requested'
              : 'Add',
          color: !isMyFriendsTab && isRequested ? AppColors.whiteColor : null,
        ),
      ),
    );
  }

  Widget buildAddPlayButtonGrey(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.apolloGreyColor),
      ),
      child: addText500('Play',
        color: AppColors.apolloGreyColor,
      ),
    );
  }
}



/*
class MyFriendsScreen extends StatefulWidget {
  const MyFriendsScreen({super.key});

  @override
  State<MyFriendsScreen> createState() => _MyFriendsScreenState();
}

class _MyFriendsScreenState extends State<MyFriendsScreen> {

  // final GlobalKey<HomeScreenState> homeState = GlobalKey<HomeScreenState>();
  CategoryModel model = CategoryModel();
  List<Category> categories = [];
  bool catLoading = false;
  getAllCategoryData() async{
    catLoading = true;
    setState(() {});
    await getAllCategoryApi().then((value){
      model = value;
      if(model.data !=null && model.data!.isNotEmpty){
        categories.addAll(model.data!);
      }
      catLoading = false;
      setState(() {});
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllCategoryData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryColor,
      body: GetBuilder<MyFriendsCtrl>(builder: (logic) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppAssets.notificationsBg,
                fit: BoxFit.fill,
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  addHeight(10),
                  backBar(
                      title: "Friend Circle",
                      onTap: () {
                        Get.back();
                      },
                      isMail: true,
                      onTapMail: () {
                        Get.toNamed(AppRoutes.playRequestScreen);
                      }).marginSymmetric(horizontal: 16),

                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        buildTabButton("My Friends", logic.isMyFriendsTab, () {
                          logic.isMyFriendsTab = true; // or false
                          logic.page = 1;
                          logic.maxPage = null;
                          logic.friendModel = FriendListModel();
                          logic.selectedPlayers.clear();
                          logic.searchCtrl.clear();
                          logic.update();
                          logic.getFriendList(Page: 1);
                          */
/*logic.isMyFriendsTab = true;
                          logic.searchCtrl.clear();
                          // logic.page = 1;
                          logic.selectedPlayers.clear();

                          logic.friendModel.data!.clear();
                          logic.update();
                          logic.debounce.run((){
                            logic.getFriendList();
                          });*//*

                        }),
                        buildTabButton("Find Players", !logic.isMyFriendsTab, () {
                          // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                          logic.isMyFriendsTab = false;
                          logic.searchCtrl.clear();
                          // logic.page = 1;
                          logic.friendModel.data!.clear();
                          logic.selectedPlayers.clear();
                          logic.update();
                          logic.debounce.run((){
                            logic.getFriendList();
                          });
                        }),
                      ],
                    ),
                  ).marginSymmetric(horizontal: 15),
                  const SizedBox(height: 24),

                  // Players List
                  */
/*logic.players.isEmpty
                      ? Column(
                    children: [
                      Lottie.asset('assets/Lottie/Appolo dance.json',
                          repeat: true,
                          reverse: false,
                          animate: true,
                          width: 308,
                          height: 322
                      ),
                      addText700('Your crew’s missing!', fontSize: 26,
                          color: AppColors.whiteColor),
                      addText500('Add friends and let the healthy fun begin.',
                          fontSize: 16, color: AppColors.whiteColor),
                      // Your crew’s missing!
                      // Add friends and let the healthy fun begin.
                    ],
                  )
                      : *//*

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16)),
                      ),
                      child: Column(
                        children: [

                          // Search Bar
                          TextField(
                            controller: logic.searchCtrl,
                            autocorrect: false,
                            onChanged: (val){
                              logic.debounce.run((){
                                logic.getFriendList(search: logic.searchCtrl.text);
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'Search by name',
                                prefixIcon: const Icon(Icons.search, color: Color(0xff67656B)),
                                filled: true,
                                fillColor: Colors.white,
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xff67656B)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color: AppColors.primaryColor),
                                ),

                            ),
                          ),
                          addHeight(10),

                          Expanded(child:  logic.isDataLoading
                              ? buildCpiLoader()
                              : logic.friendModel.data !=null && logic.friendModel.data!.isNotEmpty
                              ? SingleChildScrollView(
                            controller: logic.paginationScrollController,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                addHeight(14),
                                if(logic.isMyFriendsTab)
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: addText400(
                                          'All Friends (${logic.friendModel.data!.length})',
                                          fontSize: 20,
                                          height: 22,
                                          fontFamily: 'Caprasimo')),
                                if(logic.isMyFriendsTab)
                                  addHeight(8),

                                ...List.generate(
                                    growable: true,
                                    logic.friendModel.data!.length + (logic.isPageLoading ? 1 : 0), (index) {

                                  if (logic.isPageLoading && index == logic.friendModel.data!.length) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Center(child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(color: AppColors.blackColor,strokeWidth: 1)),
                                          addWidth(10),
                                          addText400('Loading...',color: AppColors.blackColor)
                                        ],)),
                                    );
                                  }
                                  final player = logic.friendModel.data![index];
                                  final isSelected = logic.selectedPlayers.contains(player.id);
                                  return GestureDetector(
                                    onTap: () {
                                      // logic.effectSound(sound: AppAssets.actionButtonTapSound);
                                      Get.toNamed(AppRoutes.otherProfileScreen,arguments: {'friend_id':player.id});
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 2),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.yellow10Color
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: AppColors.yellow10Color,
                                                    shape: BoxShape.circle
                                                ),
                                                child: CachedImageCircle2(imageUrl: player.profileImage,isCircular: true),
                                              ),

                                              Positioned(
                                                // top: 2,
                                                right: 0,
                                                bottom: 0,
                                                child: Container(
                                                  width: 22,height: 15,
                                                  decoration: BoxDecoration(
                                                    // border: Border.all(color: AppColors.whiteColor,width: 1.5),
                                                      borderRadius: BorderRadius.circular(2)

                                                  ),
                                                  child: ClipRRect(
                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                    borderRadius: BorderRadius.circular(2),
                                                    child: Image.network('${player.countryFlag}',fit: BoxFit.cover),
                                                  ),),
                                              ),

                                              if(player.onlineStatusVisible==1)
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  // bottom: 0,
                                                  child: Container(
                                                    height: 12, width: 12,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(0xff41A43C)
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          addWidth(12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                addText600(getTruncatedName(player.firstName??'',player.lastName??""),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontSize: 16,
                                                ),
                                                addHeight(2),
                                                addText400('${player.xp} HP', fontSize: 12),
                                              ],
                                            ),
                                          ),
                                          buildAddPlayButton(isMyFriendsTab: logic.isMyFriendsTab,
                                              isRequested: player.isRequested!,onTap: (){
                                            if(logic.isMyFriendsTab){
                                              
                                              Get.find<GroupPlayFriendsCtrl>().isFriendsTab = true;
                                              Get.find<GroupPlayFriendsCtrl>().selectedPlayers.add(player.id!);
                                              Get.find<GroupPlayFriendsCtrl>().update();
                                              if(!catLoading) {
                                                Get.toNamed(AppRoutes.gMGroupPlayScreen,arguments: {'categories': categories??[]})?.then((value){
                                                });
                                              }
                                            }else if(logic.isMyFriendsTab==false && player.isRequested==false){
                                              showLoader(true);
                                              addFriendApi(userId: player.id).then((value){
                                                showLoader(false);
                                                if(value.status==true){
                                                  player.isRequested=true;
                                                  logic.update();
                                                }else if(value.status==false){
                                                  CustomSnackBar().showSnack(Get.context!,isSuccess: false,message: '${value.message}');
                                                }
                                              });
                                            }
                                          }),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                              ],
                            ),
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/Lottie/Appolo dance.json',
                                  repeat: true,
                                  reverse: false,
                                  animate: true,
                                  width: 308,
                                  height: 322
                              ),
                              addText700('Your crew’s missing!', fontSize: 26,
                                  color: AppColors.blackColor),
                              addText500('Add friends and let the healthy fun begin.',
                                  fontSize: 16, color: AppColors.blackColor),
                              // Your crew’s missing!
                              // Add friends and let the healthy fun begin.
                            ],
                          ))
                        ],
                      ).marginOnly(left: 16, right: 16, top: 24),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),

    );
  }

  Widget buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: addText600(
            text,
            fontSize: 16,
            height: 22,
            // color: isSelected ? Colors.black : Colors.grey,
            color: AppColors.blackColor,
          ),
        ),
      ),

    );
  }

  buildAddPlayButton({VoidCallback? onTap, bool isMyFriendsTab = true,bool isRequested = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isMyFriendsTab==false && isRequested==true?AppColors.primaryColor:null,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primaryColor)
        ),
        child: addText500(isMyFriendsTab ? 'Play' : isMyFriendsTab==false && isRequested==true?'Requested':'Add',
        color: isMyFriendsTab==false && isRequested==true?AppColors.whiteColor:null,),
      ),
    );
  }
}*/
