import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_models/category_model.dart';
import 'package:apollo/resources/Apis/api_models/friend_list_model.dart';
import 'package:apollo/resources/Apis/api_repository/category_repo.dart';
import 'package:apollo/resources/Apis/api_repository/mutual_frieend_list_repo.dart';
import 'package:apollo/resources/debouncer.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MutualFriendCtrl extends GetxController{
  FriendListModel friendModel = FriendListModel();
  final debounce = Debouncer(milliseconds: 1000);
  bool isDataLoading = false;

  // pagination
  int page = 1;
  int? maxPage;
  bool isPageLoading = false;
  ScrollController? paginationScrollController;

  int? friendId;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllCategoryData();
    if(Get.arguments!=null){
      friendId = Get.arguments['friend_id'];
      getFriendRequestList();
    }
    // paginationScrollController = new ScrollController()..addListener(_scrollListener);
  }

  getFriendRequestList() async{
    isPageLoading = true;
    if(page==1) {
      isDataLoading =true;
    }
    update();
    await mutualFriendListApi(friendId: friendId).then((value){
      if(page==1){
        friendModel = value;
        isDataLoading =false;
        isPageLoading =false;
        // if(value.pagination!=null){
        //   maxPage = value.pagination!.total;
        // }

      }else{
        friendModel.data!.addAll(value.data??[]);
      }
      update();
    });
  }

  _scrollListener() {
    bool isLoadingAll = page > maxPage!?true:false;
    apolloPrint(message: '${paginationScrollController?.position.atEdge}'); // allowImplicitScrolling,hasViewportDimension, keepScrollOffset
    bool isTop = paginationScrollController?.position.pixels == 0;
    apolloPrint(message: 'isTop:::${isTop}');
    apolloPrint(message: 'Page:::$page');
    apolloPrint(message: 'maxPage:::$maxPage');
    apolloPrint(message: 'isLoadingAll:::$isLoadingAll');
    if(paginationScrollController!=null && paginationScrollController!.position.atEdge && isTop==false && isLoadingAll==false){
      Future.microtask((){
        debounce.run(() {
          isPageLoading = false;
          page++;
          update();
        });

      });
    }
    if (paginationScrollController!.position.atEdge && isTop==false && isPageLoading == false) {
      // if (paginationScrollController!.position.extentAfter <= 0 && isPageLoading == false) {
      if(isLoadingAll==false){
        Future.microtask((){
          // getFriendRequestList();
        });
      } else{
        // showToastError('That\'s all for now.');
        CustomSnackBar().showSnack(Get.context!,message: 'No more page to load.',isSuccess: false);
      }

    }
  }

// for onTap play
  List<int> selectedPlayers = [];
  List<Category> categories = [];
  bool catLoading = false;
  getAllCategoryData() async {
    catLoading = true;
    update();
    final model = await getAllCategoryApi();
    if (model.data != null && model.data!.isNotEmpty) {
      categories = model.data!;
    }
    catLoading = false;
    update();
  }



}