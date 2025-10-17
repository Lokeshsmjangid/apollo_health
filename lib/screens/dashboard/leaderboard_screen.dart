import 'dart:async';
import 'dart:io';

import 'package:apollo/controllers/bottom_bar_ctrl.dart';
import 'package:apollo/controllers/leaderboard_ctrl.dart';
import 'package:apollo/custom_widgets/online_status_dot_screen.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/auth_data.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:apollo/resources/utils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

  class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

  class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ScrollController _scrollController;
  bool showPodium = true;

  Timer? _glowTimer;
  bool _showGlow = false;

  @override
  void initState() {
    startGlowTimer();
    super.initState();
    _scrollController =
        ScrollController()..addListener(() {
          if (_scrollController.position.pixels > 10 && showPodium) {
            setState(() => showPodium = false);
          // } else if (_scrollController.position.pixels <= 10 && !showPodium) {
          } else if (_scrollController.position.pixels <= 10 && !showPodium) {
            setState(() => showPodium = true);
          }
        });
  }

  Future<void> _playConfettiSound({required String sound}) async {
    await _audioPlayer.play(AssetSource(sound));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _glowTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: addText400(
          "Leaderboard",
          fontSize: 32,
          height: 40,
          color: AppColors.whiteColor,
          fontFamily: 'Caprasimo',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Share.share(
                  shareText
              );
            },
            icon: _showGlow
                ? AvatarGlow(
              animate: true,
              glowColor: AppColors.whiteColor,
              // endRadius: 30,
              duration: Duration(milliseconds: 600),
              child: Image.asset(
                AppAssets.shareIcon,
                height: 24,
                width: 24,
                color: AppColors.whiteColor,
              ),
            ):Image.asset(AppAssets.shareIcon, height: 24, width: 24),
          ).marginOnly(right: 10),
        ],
      ),
      backgroundColor: AppColors.primaryColor,
      body:  WillPopScope(
        onWillPop: willPop,
        child: Stack(
          children: [
            Positioned.fill(
              child: SizedBox.expand(
                child: Image.asset(
                  AppAssets.notificationsBg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: GetBuilder<LeaderboardController>(
                builder: (logic) {
                  return Column(
                    children: [
                      SizedBox(height: 14),

                      // Toggle tab buttons
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            buildTabButton("Weekly", logic.isWeeklyTab, () {
                              logic.isWeeklyTab = true;
                              showPodium = true;
                              logic.update();
                              logic.getLeaderBoardData();
                            }),
                            buildTabButton("All Time", !logic.isWeeklyTab, () {
                              logic.isWeeklyTab = false;
                              showPodium = true;
                              logic.update();
                              logic.getLeaderBoardData();
                            }),
                          ],
                        ),
                      ).marginSymmetric(horizontal: 15),

                      SizedBox(height: 32),

                      /// Smooth animated Podium START
                      // Container(
                      //   width: double.infinity,
                      //   height: MediaQuery.sizeOf(context).height * 0.627,
                      //   child:
                      //       logic.isDataLoading
                      //           ? buildCpiLoader()
                      //           : logic.model.data != null && logic.model.data!.isNotEmpty
                      //           // ?

                      if(logic.podiumUsers.isNotEmpty)
                  AnimatedSize(
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: showPodium ? 1.0 : 0.0,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      curve: Curves.easeInOut,
                      child: AnimatedSlide(
                        offset:
                            showPodium
                                ? Offset.zero
                                : const Offset(0, -0.15),
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        curve: Curves.easeInOut,
                        child: showPodium
                                ? SizedBox(
                                  height: 224,
                                  child: Stack(
                                    alignment:
                                        Alignment.bottomCenter,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if(logic.podiumUsers.isNotEmpty && logic.podiumUsers.length>=2)
                                          _buildPodium(
                                            userId: int.parse('${logic.podiumUsers[1].id}'),
                                            image: '${logic.podiumUsers[1].profileImage}',
                                            name: truncateWithEllipsis('${logic.podiumUsers[1].firstName}',8),
                                            // name: formatLeaderBoardNamePodium('${logic.podiumUsers[1].firstName}', '${logic.podiumUsers[1].lastName}'),
                                            score: int.parse('${logic.podiumUsers[1].xp}'),
                                            flag: '${logic.podiumUsers[1].countryFlag}',
                                            position: 2,
                                            color: const Color(0XFFC0C0C0,),
                                            stackColor: const Color(0XFF999999),
                                            onlineStatus: logic.podiumUsers[1].userActive??'',
                                            isOnline: logic.podiumUsers[1].onlineStatusVisible??0,
                                            subscription: logic.podiumUsers[1].subscription??0,

                                          ),
                                          if(logic.podiumUsers.isNotEmpty && logic.podiumUsers.length>=1)
                                          _buildPodium(
                                            userId: int.parse('${logic.podiumUsers[0].id}'),
                                            image: '${logic.podiumUsers[0].profileImage}',
                                            name: truncateWithEllipsis('${logic.podiumUsers[0].firstName}',8),
                                            // name: formatLeaderBoardNamePodium('${logic.podiumUsers[0].firstName}', '${logic.podiumUsers[0].lastName}'),
                                            score: int.parse('${logic.podiumUsers[0].xp}'),
                                            flag: '${logic.podiumUsers[0].countryFlag}',
                                            position: 1,
                                            color: const Color(0xFFFFD93B),
                                            stackColor: const Color(0xFFB69300),
                                            onlineStatus: logic.podiumUsers[0].userActive??'',
                                            isOnline: logic.podiumUsers[0].onlineStatusVisible??0,
                                            subscription: logic.podiumUsers[0].subscription??0,
                                          ),
                                          if(logic.podiumUsers.isNotEmpty && logic.podiumUsers.length==3)
                                          _buildPodium(
                                            userId: int.parse('${logic.podiumUsers[2].id}'),
                                            image: '${logic.podiumUsers[2].profileImage}',
                                            name: truncateWithEllipsis('${logic.podiumUsers[2].firstName}',8),
                                            // name: formatLeaderBoardNamePodium('${logic.podiumUsers[2].firstName}', '${logic.podiumUsers[2].lastName}'),
                                            score: int.parse('${logic.podiumUsers[2].xp}'),
                                            flag: '${logic.podiumUsers[2].countryFlag}',
                                            position: 3,
                                            color: const Color(0xFFCD7F32),
                                            stackColor: const Color(0xFFAD6C2B),
                                            onlineStatus: logic.podiumUsers[2].userActive??'',
                                            isOnline: logic.podiumUsers[2].onlineStatusVisible??0,
                                            subscription: logic.podiumUsers[2].subscription??0,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                                : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  // Leaderboard List
                  if(!logic.isDataLoading)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                      ),
                      child: logic.restUsers.isNotEmpty?ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        controller: _scrollController,
                        physics: const SlowScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: logic.restUsers.length,
                        itemBuilder: (context, index) {
                          final user = logic.restUsers[index]; // return SizedBox();
                          return _buildListItem(
                              userId:user.id,
                              rank: user.rank??0,
                              image:user.profileImage??'',
                              flag: user.countryFlag??'',
                              highlight: false,
                              hp: int.parse('${user.xp??0}'),
                              name: formatLeaderBoardName('${user.firstName??''} ',user.lastName??''),
                              change: user.movement??'',
                              rankChange: user.rankChange,onlineStatus: user.userActive,isOnline: user.onlineStatusVisible??0,
                              subSubscription: user.subscription);
                        },
                      ):Center(child: addText600('No participants found.')),
                    ),
                  ),

                                // if(logic.isDataLoading && (logic.podiumUsers.isEmpty && logic.restUsers.isEmpty))
                                // Expanded(child: buildCpiLoader()),

                                if(!logic.isDataLoading && (logic.podiumUsers.isEmpty && logic.restUsers.isEmpty))
                                Expanded(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset('assets/Lottie/Appolo stetoskope.json', width: 200, height: 200),
                                    addText600('No leaderboard found.',color: AppColors.whiteColor),
                                    addHeight(60)
                                  ],
                                ))

                      // ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium({
    required int userId,
    required String image,
    required String name,
    required int score,
    required String flag,
    required int position,
    required Color color,
    required Color stackColor,
    required String onlineStatus, // for greeen ,yellow & gray
    required int isOnline,
    required int subscription,
  }) { double height = [3, 2, 1][position - 1] * 40 + 80;
    return GestureDetector(
      onTap: (){
        if(userId==AuthData().userModel?.id){
          Future.microtask((){
            Get.find<BottomBarController>().selectedIndex = 4;
            Get.find<BottomBarController>().update();
          });

          apolloPrint(message: 'message:${Get.find<BottomBarController>().selectedIndex}');

        }else{
          Get.toNamed(AppRoutes.otherProfileScreen,arguments: {
            'friend_id':userId});
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: AppColors.yellow10Color,
                    shape: BoxShape.circle,
                  border: Border.all(width: 2,color: position==1?Color(0XFFFFD93B):position==2?Color(0XFFD9D9D9):Color(0XFFDB8B00))
                ),
                child: CachedImageCircle2(imageUrl: image,isCircular: true),
              ),
              Positioned(
      // top: 2,
                right: 0,
                bottom: 0,
                child: flag.isNotEmpty?Container(
                  width: 22,height: 15,
                  decoration: BoxDecoration(
      // border: Border.all(color: AppColors.whiteColor,width: 1.5),
                      borderRadius: BorderRadius.circular(2)

                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(2),
                    child: Image.network(flag,fit: BoxFit.cover),
                  ),):SizedBox.shrink(),
              ),

              if(isOnline==1 && (onlineStatus!=null && onlineStatus.isNotEmpty))
              Positioned(
                    top: 2,
                    right: 0,
                    // bottom: 0,
                    child: OnlineStatusDot(lastActiveTime: DateTime.parse(onlineStatus))),

            ],
          ),
          const SizedBox(height: 12),

          addText700(
            name,
            textAlign: TextAlign.center,
            color: Colors.white,
            fontSize: 15,
          ),
          addText400(
            "$score HP",
            textAlign: TextAlign.center,
            color: Colors.white,
            fontSize: 12,
          ),

          addHeight(14),
          Container(
            decoration: BoxDecoration(
              color: stackColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(position == 2 ? 6 : 16),
                topLeft: Radius.circular(position == 3 ? 6 : 16),
              ),
            ),
            child: Container(
              height: position == 1 ? height * 0.5 : height * 0.45,
              width: 100,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addText400(
                    "$position",
                    fontSize: 34,
                    fontFamily: 'Caprasimo',
                    color: stackColor,
                  ).marginOnly(top: 10),
                ],
              ),
            ).marginOnly(top: 10),
          ),

        ],
      ),
    );
  }

  Widget _buildListItem({
       int? userId,
       int? rank,
       String? name,
       String? image,
       String? flag,
       int? hp,
       String? change,
       String? onlineStatus,
       int? rankChange,
       int? isOnline, bool highlight = false,
       int? subSubscription,
  }) { return GestureDetector(
      onTap: (){
        if(userId==AuthData().userModel?.id){
          Get.find<BottomBarController>().selectedIndex = 4;
          Get.find<BottomBarController>().update();
        }else{
        Get.toNamed(AppRoutes.otherProfileScreen,arguments: {'screen':'leaderboard','friend_id':userId});}
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFFFFF4C5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Column(
              children: [
                addText400(
                  "$rank",
                  fontFamily: 'Caprasimo',
                  fontSize: 18,
                  height: 22,
                ),
                addText400(
                  // change > 0 ? "+${change.abs()}" : "-${change.abs()}",
                  '$rankChange',
                  fontSize: 10,
                  color: change =="same"? AppColors.secondaryColor:change =="up" ? Colors.green : Colors.red,
                ),
                Icon(
                  change =="same"?Icons.arrow_right_rounded :change =="up"
                      ? Icons.arrow_drop_up_rounded
                      : Icons.arrow_drop_down_rounded,
                  color: change =="same"? AppColors.secondaryColor:change =="up" ? Colors.green : Colors.red,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(width: 24),
            Stack(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: AppColors.yellow10Color,
                      shape: BoxShape.circle
                  ),
                  child: CachedImageCircle2(imageUrl: image,isCircular: true),
                ),
                Positioned(
      // top: 2,
                  right: 0,
                  bottom: 0,
                  child: flag!=""?Container(
                    width: 22,height: 15,
                    decoration: BoxDecoration(
      // border: Border.all(color: AppColors.whiteColor,width: 1.5),
                        borderRadius: BorderRadius.circular(2)

                    ),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      borderRadius: BorderRadius.circular(2),
                      child: Image.network('$flag',fit: BoxFit.cover),
                    ),):SizedBox.shrink(),
                ),

                if(isOnline==1 && (onlineStatus!=null && onlineStatus.isNotEmpty))
                Positioned(
                  top: 2,
                  right: 0,
                  // bottom: 0,
                  child: OnlineStatusDot(lastActiveTime: DateTime.parse(onlineStatus))),
              ],
            ),

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addText600('$name', fontSize: 15, color: AppColors.blackColor),
                  addHeight(2),
                  addText400("$hp HP", fontSize: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );}

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
            color: AppColors.blackColor,
          ),
        ),
      ),
    );
  }
}

  class SlowScrollPhysics extends ClampingScrollPhysics {

  const SlowScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  SlowScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return offset * 0.5; // reduce scroll speed to 50%
  }
}
