import 'package:apollo/controllers/leaderboard_ctrl.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/text_utility.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ScrollController _scrollController;
  bool showPodium = true;
  @override
  void initState() {
    super.initState();
    // _playConfettiSound(sound: AppAssets.leaderBoardSound);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels > 10 && showPodium) {
          setState(() => showPodium = false);
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              AppAssets.notificationsBg,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(

            child: GetBuilder<LeaderboardController>(builder: (logic) {
              return Column(
                children: [
                  // SizedBox(height: 24),
                  addText400(
                    "Leaderboard",

                    fontSize: 32,
                    height: 40,
                    color: Colors.white,
                    fontFamily: 'Caprasimo',

                  ),
                  SizedBox(height: 24),

                  // Toggle

                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        buildTabButton("Weekly", logic.isWeeklyTab, () {
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                            logic.isWeeklyTab = true;
                            showPodium = true;
                            logic.update();
                        }),
                        buildTabButton("All Time", !logic.isWeeklyTab, () {
                          // _playConfettiSound(sound: AppAssets.actionButtonTapSound);
                          logic.isWeeklyTab = false;
                          showPodium = true;
                          logic.update();
                        }),
                      ],
                    ),
                  ).marginSymmetric(horizontal: 15),

                  SizedBox(height: 32),

                  // Podium
                  /// Podium Section - Hide on Scroll
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1500),
                    child: showPodium
                        ? Container(
                      // color: Colors.red,
                      height: 224,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildPodium(
                                image: 'https://i.pravatar.cc/100?img=3',
                                name: 'Alena Donin',
                                score: 650,
                                flag: AppAssets.lFlag2Icon,
                                position: 2,
                                color: Color(0XFFC0C0C0),
                                stackColor: Color(0XFF999999),
                              ),
                              _buildPodium(
                                image: 'https://i.pravatar.cc/100?img=2',
                                name: 'Tassya Putri',
                                score: 1000,
                                flag: AppAssets.lFlag1Icon,
                                position: 1,
                                color: Color(0xFFFFD93B),
                                stackColor: Color(0xFFB69300),
                              ),
                              _buildPodium(
                                image: 'https://i.pravatar.cc/100?img=4',
                                name: 'Kate Bell',
                                score: 600,
                                flag: AppAssets.lFlag3Icon,
                                position: 3,
                                color: Color(0xFFCD7F32),
                                stackColor: Color(0xFFAD6C2B),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ) : SizedBox.shrink(),
                  ),

                  // SizedBox(height: 12),

                  // Leaderboard List
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16,right: 16, top: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10)),
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        controller: _scrollController,
                        // physics: BouncingScrollPhysics(),
                        physics: const SlowScrollPhysics(parent: BouncingScrollPhysics()),
                        itemCount: logic.isWeeklyTab?4:logic.leaderboardUsers.length,
                        itemBuilder: (context, index) {
                          final user = logic.leaderboardUsers[index];
                          return _buildListItem(
                            user.rank,
                            user.name,
                            user.flag,
                            user.hp,
                            user.change,
                            highlight: user.highlight,
                          );
                        },
                      ),
                    ),
                  ),
                  // addHeight(60)
                ],
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildPodium({
    required String image,
    required String name,
    required int score,
    required String flag,
    required int position,
    required Color color,
    required Color stackColor,
  }) {
    double height = [3, 2, 1][position - 1] * 40 + 80;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(image),
          radius: 25,
          child: Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(flag,width: 20,height: 15,),
          ),
        ),
        SizedBox(height: 12),
        addText700(
          "$name",
          textAlign: TextAlign.center,
          color: Colors.white, fontSize: 16,
        ),
        addText400(
          "$score HP",
          textAlign: TextAlign.center,
          color: Colors.white, fontSize: 12,
        ),
        addHeight(14),
        Container(
          decoration: BoxDecoration(
              color: stackColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(position == 2 ? 6 : 16),
                  topLeft: Radius.circular(position == 3 ? 6 : 16))
            // borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            height: position == 1 ? height * 0.5 : height * 0.45,
            width: 100,
            // alignment: Alignment.center,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16))
              // borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // addHeight(5),
                addText400("$position", fontSize: 34, fontFamily: 'Caprasimo',
                    color: stackColor).marginOnly(top: 10),
              ],
            ),
          ).marginOnly(top: 10),
        ),
      ],
    );
  }

  Widget _buildListItem(int rank, String name, String flag, int hp, int change,
      {bool highlight = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      // margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: highlight ? Color(0xFFFFF4C5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            children: [
              addText400(
                "$rank", fontFamily: 'Caprasimo', fontSize: 18, height: 22,
              ),
              addText400(
                change > 0 ? "+""${change.abs()}" : "-""${change.abs()}",
                fontSize: 10,
                color: change > 0 ? Colors.green : Colors.red,

              ),
              Icon(
                change > 0 ? Icons.arrow_drop_up_rounded : Icons
                    .arrow_drop_down_rounded,
                color: change > 0 ? Colors.green : Colors.red,
                size: 18,
              ),

            ],
          ),


          SizedBox(width: 24),
          Stack(
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/100?img=${rank + 10}")),
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: SvgPicture.asset(flag,width: 20,height: 15,))
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addText600(
                    name,
                    fontSize: 15,
                    color: AppColors.blackColor
                ),
                addHeight(2),
                addText400(
                  "$hp HP",
                  fontSize: 12,
                ),
              ],
            ),
          ),

        ],
      ),
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
    return offset * 0.3; // reduce scroll speed to 30%
  }
}