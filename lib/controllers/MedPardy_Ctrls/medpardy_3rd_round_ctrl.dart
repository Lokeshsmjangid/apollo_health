import 'package:apollo/models/medpardy_board_cells.dart';
import 'package:apollo/models/medpardy_players_model.dart';
import 'package:apollo/resources/Apis/api_models/category_model.dart';
import 'package:get/get.dart';

class MedPardy3rdRoundCtrl extends GetxController{

  int? gameId;
  bool? initialTime;
  List<MedPardyPlayerModel> players = []; // Players as List<Player>
  int? selectedPlayerIndex;


  // final List<String> categories = ['Lub Dub Nation', 'Mind Matters', 'Snooze Control']; // Categories

  List<Category> categories = [];
  List<List<MedpardyBoardCellModel>>? board;

  List<MedpardySelectedCell> selectedCells = [];
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   if(Get.arguments!=null){
  //     selectedPlayerIndex = Get.arguments['selected_player']??0;
  //     players = Get.arguments['players_list'];
  //     selectedCells = Get.arguments['cells'];
  //     checkCells();
  //   }
  //
  //
  // }


  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      initialTime = Get.arguments['initialTime'];
      gameId = Get.arguments['game_id'];
      selectedPlayerIndex = Get.arguments['selected_player'] ?? 0;
      categories = Get.arguments['category_list'];
      players = Get.arguments['players_list'];

      final rawCells = Get.arguments['cells'];
      if (rawCells != null && rawCells is List) {
        selectedCells = rawCells.map((e) {
          if (e is MedpardySelectedCell) {
            return e; // Already typed
          } else if (e is Map<String, dynamic>) {
            return MedpardySelectedCell.fromMap(e);
          } else if (e is Map) {
            return MedpardySelectedCell.fromMap(Map<String, dynamic>.from(e));
          } else {
            throw Exception("Invalid selected cell data: $e");
          }
        }).toList();

      } else {
        selectedCells = [];
      }
      checkCells(selectedCells);
    }
  }


  List<int> pointsOrder = [100, 200, 400, 800, 1600];
  checkCells(selectedCells){
    if(selectedCells!=null){
      board = List.generate(3, (_) => List.generate(5, (row) => MedpardyBoardCellModel(points: pointsOrder[row])));
      updateBoardSelectionFromList(selectedCells);
    }else{
      Future.microtask((){

        board = List.generate(3, (_) => List.generate(5, (row) => MedpardyBoardCellModel(points: pointsOrder[row])));

      });
    }
  }


  MedpardySelectedCell? selectedCell;

  void selectCell(int col, int row) {

      // Mark the selected cell as selected
      // selectedCol = col;
      // selectedRow = row;
    selectedCell = MedpardySelectedCell(col: col, row: row);


      // Update board cells and Set isSelected = true only for selected cell; others false
      for (int c = 0; c < board!.length; c++) {
        for (int r = 0; r < board![c].length; r++) {
          if(board![c][r].permanentSelected==false){
            board![c][r].isSelected = c == col && r == row;
          }
        }
      }
      update();
  }

  //




  void updateBoardSelectionFromList(List<MedpardySelectedCell> selectedCells) {
      for (int c = 0; c < board!.length; c++) {
        for (int r = 0; r < board![c].length; r++) {
          board![c][r].isSelected = selectedCells.any((cell) => cell.col == c && cell.row == r);
          board![c][r].permanentSelected = selectedCells.any((cell) => cell.col == c && cell.row == r);
        }
      }
    update();
  }




}


