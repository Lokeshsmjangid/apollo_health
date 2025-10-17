import 'package:apollo/resources/auth_data.dart';
import 'package:get/get.dart';

class ApolloAuthCtrl extends GetxController{



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  getAuthDetails(){
    AuthData().getLoginData();
  }

}