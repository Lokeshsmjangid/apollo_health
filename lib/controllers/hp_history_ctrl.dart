import 'package:apollo/resources/Apis/api_models/hp_histroy_model.dart';
import 'package:apollo/resources/Apis/api_repository/hp_history_repo.dart';
import 'package:get/get.dart';

class HPHistoryCtrl extends GetxController{
  HealthPointHistoryModel model = HealthPointHistoryModel();
  bool isDataLoading = false;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    hpTransactionHistory();
  }


  hpTransactionHistory() async{
    isDataLoading = true;
    update();
    await getHPHistoryApi().then((transaction){
      model = transaction;
      isDataLoading = false;
      update();
    });
  }

}