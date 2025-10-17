import 'package:get/get.dart';

class CmsPageWebViewCtrl extends GetxController {

  var isLoading = true.obs;
  void setLoading(bool value) {
    isLoading(value);
  }

}
