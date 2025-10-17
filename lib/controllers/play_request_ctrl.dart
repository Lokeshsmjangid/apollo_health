import 'package:apollo/custom_widgets/custom_snakebar.dart';
import 'package:apollo/resources/Apis/api_models/friend_list_model.dart';
import 'package:apollo/resources/Apis/api_repository/friend_request_list_repo.dart';
import 'package:apollo/resources/debouncer.dart';
import 'package:apollo/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayRequestCtrl extends GetxController{
  FriendListModel friendModel = FriendListModel();
  final debounce = Debouncer(milliseconds: 1000);
  bool isDataLoading = false;

  // pagination
  int page = 1;
  int? maxPage;
  bool isPageLoading = false;
  ScrollController? paginationScrollController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFriendRequestList();
    paginationScrollController = new ScrollController()..addListener(_scrollListener);
  }

  getFriendRequestList({String? search}) async{
    isPageLoading = true;
    if(page==1) {
      isDataLoading =true;
    }
    update();
    await getFriendRequestApi(page: page,search: search).then((value){
      if(page==1){
        friendModel = value;
        isDataLoading =false;
        isPageLoading =false;
        if(value.pagination!=null){
          maxPage = value.pagination!.total;
        }

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
          getFriendRequestList();
        });
      } else{
        // showToastError('That\'s all for now.');
        CustomSnackBar().showSnack(Get.context!,message: 'No more page to load.',isSuccess: false);
      }

    }
  }


  /*final List<Map<String, dynamic>> requests = [
    {
      'name': 'Madenyn Dias',
      'avatar': 'https://i.pravatar.cc/150?img=10',
      'flag': '🇧🇧',
      'hps': '630 HP',
    },
    {
      'name': 'Wade Warren',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'flag': '🇧🇧',
      'hps': '1,050 HP',
    },
  ];*/
}