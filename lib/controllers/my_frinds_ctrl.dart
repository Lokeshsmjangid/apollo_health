
import 'package:apollo/controllers/app_push_nottification.dart';
import 'package:apollo/resources/Apis/api_models/category_model.dart';
import 'package:apollo/resources/Apis/api_models/friend_list_model.dart';
import 'package:apollo/resources/Apis/api_repository/category_repo.dart';
import 'package:apollo/resources/Apis/api_repository/group_friends_repo.dart';
import 'package:apollo/resources/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFriendsCtrl extends GetxController{
  TextEditingController searchCtrl = TextEditingController();
  FriendListModel friendModel = FriendListModel();
  final debounce = Debouncer(milliseconds: 1000);
  bool isDataLoading = false;
  List<int> selectedPlayers = [];

  int page = 1;
  int? maxPage;
  bool isPageLoading = false;
  ScrollController? paginationScrollController;

  bool isMyFriendsTab = true;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllCategoryData();
    getFriendList(Page: 1);
    paginationScrollController = new ScrollController()..addListener(_scrollListener);
  }







  getFriendList({String? search, int? Page}) async {
    if (Page == 1) {
      friendModel = FriendListModel(); // clear full model
      isDataLoading = true;
      isPageLoading = false;
      page = 1; // reset page
    }

    update();

    await getFriendApi(isFriendCircle: true,page: page, type: isMyFriendsTab ? 'friend' : 'global', search: search).then((value) {
      if (value.data != null) {
        if (Page == 1) {
          friendModel = value;
          maxPage = value.pagination?.total ?? 1;
          Get.find<AppPushNotification>().friendRequestCount.value = friendModel.friendRequestCount!.toInt();
        } else {
          friendModel.data ??= [];
          friendModel.data!.addAll(value.data!);
        }
      }
      isDataLoading = false;
      isPageLoading = false;
      update();
    }).catchError((e) {
      isDataLoading = false;
      isPageLoading = false;
      update();
      print('Friend list fetch failed: $e');
    });
  }

  _scrollListener() {
    if (paginationScrollController == null || paginationScrollController!.position.pixels == 0) return;

    final isAtBottom = paginationScrollController!.position.pixels >= paginationScrollController!.position.maxScrollExtent;

    final hasMore = page < (maxPage ?? 1);

    if (isAtBottom && !isPageLoading && hasMore) {
      page++;
      isPageLoading = true;
      update();
      getFriendList(Page: page);
    }
  }

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



// api fxn
/*getFriendList({String? search,int? Page}) async{
    isPageLoading = true;
    if(page==1) {
      isDataLoading =true;
    }
    update();
    await getFriendApi(page: page??1,type: isMyFriendsTab?'friend':'global',search: search).then((value){
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
  }*/

  // scroll code
/*
  _scrollListener() {
    bool isLoadingAll = page > maxPage!?true:false;
    apolloPrint(message: '${paginationScrollController?.position.atEdge}'); // allowImplicitScrolling,hasViewportDimension, keepScrollOffset
    bool isTop = paginationScrollController?.position.pixels == 0;
    apolloPrint(message: 'isTop:::${isTop}');
    apolloPrint(message: 'Page:::${page}');
    apolloPrint(message: 'maxPage:::${maxPage}');
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
          getFriendList(Page: page);
        });
      } else{
        // showToastError('That\'s all for now.');
        CustomSnackBar().showSnack(Get.context!,message: 'No more page to load.',isSuccess: false);
      }

    }
  }
*/



}