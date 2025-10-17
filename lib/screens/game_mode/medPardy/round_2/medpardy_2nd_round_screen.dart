import 'package:apollo/controllers/MedPardy_Ctrls/medpardy_2nd_round_ctrl.dart';
import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/models/medpardy_board_cells.dart';
import 'package:apollo/models/medpardy_players_model.dart';
import 'package:apollo/resources/Apis/api_models/category_model.dart';
import 'package:apollo/resources/Apis/api_repository/medpardy_start_game_repo.dart';
import 'package:apollo/resources/custom_loader.dart';
import 'package:apollo/screens/dashboard/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:apollo/bottom_sheets/leave_quiz_bottom_sheet.dart';
import 'package:apollo/custom_widgets/app_button.dart';
import 'package:apollo/custom_widgets/jeo_pardy_border.dart';
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:apollo/resources/app_routers.dart';
import 'package:apollo/resources/text_utility.dart';


class Medpardy2ndRoundScreen extends StatefulWidget {

  Medpardy2ndRoundScreen();

  @override
  State<Medpardy2ndRoundScreen> createState() => _Medpardy2ndRoundScreenState();
}

class _Medpardy2ndRoundScreenState extends State<Medpardy2ndRoundScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: addText400(
            "Medpardy",
            fontSize: 32,
            height: 40,
            color: AppColors.whiteColor,
            fontFamily: 'Caprasimo'),
        actions: [

          GestureDetector(
            onTap: (){
              showLeaveQuizSheet(context, () {
                Get.delete<MedPardy2ndRoundCtrl>(force: true);
                Get.to(() => DashBoardScreen());
              }, isWheelOfWellness: false);
            },
            child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  // color: Colors.red,
                    shape: BoxShape.circle
                ),
                child: Image.asset(AppAssets.closeIcon, color: AppColors.whiteColor,).marginAll(5)),
          ).marginOnly(right: 5)
        ],

      ),
      body: GetBuilder<MedPardy2ndRoundCtrl>(builder: (logic) {
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.splashScreenBgImg),
                  fit: BoxFit.cover)
          ),
          child: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  addHeight(10),
                  // Players row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(logic.players.length, (i) {
                      final player = logic.players[i];
                      final isSelected = i == logic.selectedPlayerIndex;

                      return GestureDetector(
                        onTap: () {
                            // logic.selectedPlayerIndex = i;
                            // logic.update();
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 106,
                            minWidth: 106,
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: i == 1 ? 12 : 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: player.color,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFFFE066) : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: const Color(0xFFFFE066).withOpacity(0.8),
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: const Offset(0, 2),
                              )
                            ] : [],
                          ),
                          child: Column(
                            children: [
                              addText400(
                                player.name,
                                fontFamily: 'Caprasimo',
                                color: player.textColor,
                                fontSize: 18,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              addText600(
                                "${player.hp}",
                                color: AppColors.blackColor,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 34),
                  // First Round heading
                  addText400(
                    "Second Round",
                    fontFamily: 'Caprasimo',
                    fontSize: 32,
                    height: 40,
                    color: AppColors.whiteColor,
                  ).marginSymmetric(horizontal: 16),
                  const SizedBox(height: 16),

                  // Game board
                  DecoratedJeopardyContainer(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 2, right: 2),
                      child: Column(
                        children: [
                          // Header Row with categories
                          Row(
                            children: logic.categories.map((title) {
                              return Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: addText400(
                                    title.title??'',
                                    textAlign: TextAlign.center,
                                    fontSize: 16,
                                    height: 20,
                                    color: AppColors.whiteColor,
                                    fontFamily: 'Caprasimo')),
                              );
                            }).toList(),
                          ),
                          addHeight(12),


                          SizedBox( // Grid of points cells (3 columns × 5 rows)
                            height: 296,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.94,
                              ),
                              itemCount: 15,
                              itemBuilder: (context, index) {
                                int col = index % 3;
                                int row = index ~/ 3;

                                final cell = logic.board![col][row];
                                bool isSelected = cell.isSelected;

                                return GestureDetector(
                                  onTap: () => logic.selectCell(col, row),
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF253EA8),
                                          const Color(0xFF4A60B8),
                                          const Color(0xFF253EA8),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        tileMode: TileMode.clamp,
                                      ),
                                      color: isSelected
                                          ? Colors.grey[400]
                                          : Colors.blue.shade700,
                                    ),
                                    child: Center(
                                      child: addText400(
                                        '${cell.points}',
                                        fontSize: 20,
                                        color: cell.permanentSelected?AppColors.buttonDisableColor:isSelected
                                            ? AppColors.green500Color
                                            : AppColors.yellowColor,
                                        fontFamily: 'Caprasimo',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).marginAll(16),

                  addHeight(16),
                  // Play button
                  AppButton(
                    onButtonTap: () {
                      if (logic.selectedCell!=null) {
                        // logic.selectedCells.clear();

                        logic.update();
                        final gameID = logic.gameId;
                        final catID = logic.categories[logic.selectedCell!.col].id;
                        final selectedPoints = logic.board![logic.selectedCell!.col][logic.selectedCell!.row].points;
                        print('selectedCell: ${logic.selectedCell!.col},${logic.selectedCell!.row}');
                        print('categoryID: $catID');
                        print('selectedPoints or XP: ${selectedPoints}');
                        print('Multiple Cells: ${logic.selectedCells.length}');
                        logic.selectedCells.forEach((cell) {
                          print('Cell: col=${cell.col}, row=${cell.row}');
                        });


                        if (logic.selectedCells.any((element) =>
                        element.row == logic.selectedCell?.row && element.col == logic.selectedCell?.col)) {
                          logic.selectedCell=null;
                          logic.update();
                          CustomSnackBar().showSnack(context,message: 'You cannot pick a point that is already selected.',isSuccess: false);
                        }else{
                          logic.selectedCells.add(logic.selectedCell!);
                          logic.update();

                          bool initialTime = logic.initialTime!;
                          int playerIndex = logic.selectedPlayerIndex!;
                          List<Category> categories = logic.categories;
                          List<MedPardyPlayerModel> players = logic.players;
                          List<MedpardySelectedCell> selectedCells = logic.selectedCells;
                          showLoader(true);
                          startMedpardyApi(gameId: gameID, round: 1,categoryId: catID,playerIndex: 0, playerName: players[0].name,
                              xp: selectedPoints).then((value){
                            showLoader(false);
                            if(value.status==true && value.data!=null){
                              Get.offNamed(AppRoutes.medpardy2ndRoundQuizScreen, arguments: {
                                'initialTime': false,
                                'game_id': gameID,
                                'round': 2,
                                'category_list': categories,
                                'selected_player': playerIndex==0?0:playerIndex==1?1:playerIndex==2?2:-1,
                                'players_list':players,
                                'questions': value.data?.question??[],
                                'cells':selectedCells,
                                'selectedXp': selectedPoints,
                              });
                            }
                          });
                        }





                      } else{
                        CustomSnackBar().showSnack(context,message: 'Pick a question to play.',isSuccess: false);
                      }
                    },
                    buttonText: 'Play',
                    buttonTxtColor: AppColors.primaryColor,
                    buttonColor: AppColors.whiteColor,
                  ).marginAll(16),
                  addHeight(24),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}