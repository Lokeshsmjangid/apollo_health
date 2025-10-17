
import 'package:apollo/resources/Apis/api_models/friend_list_model.dart';
import 'package:apollo/resources/Apis/api_repository/group_friends_repo.dart';
import 'package:apollo/resources/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupPlayFriendsCtrl extends GetxController{
  TextEditingController searchCtrl = TextEditingController();
  FriendListModel friendModel = FriendListModel();
  final debounce = Debouncer(milliseconds: 1000);
  bool isFriendsTab = false;
  bool isDataLoading = false;
  List<int> selectedPlayers = [];

  int page = 1;
  int? maxPage;
  bool isPageLoading = false;
  ScrollController? paginationScrollController;




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
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

    await getFriendApi(page: page, type: isFriendsTab ? 'friend' : 'global', search: search)
        .then((value) {
      if (value.data != null) {
        if (Page == 1) {
          friendModel = value;
          maxPage = value.pagination?.total ?? 1;
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

  /*_scrollListener() {
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
          getFriendList();
        });
      } else{
        // showToastError('That\'s all for now.');
        CustomSnackBar().showSnack(Get.context!,message: 'No more page to load.',isSuccess: false);
      }

    }
  }*/





  /*List<String> selectedPlayers = [];
  final List<Map<String, dynamic>> players = [
    {
      'name': 'Devon Lane',
      'hp': '550 HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=1',
      'isOnline': true,
    },
    {
      'name': 'Leslie Alexander',
      'hp': '630 HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=2',
      'isOnline': false,
    },
    {
      'name': 'Madenyn Dias',
      'hp': '#HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=3',
      'isOnline': true,
    },
    {
      'name': 'Wade Warren',
      'hp': '#HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=4',
      'isOnline': true,
    },
    {
      'name': 'Theresa Webb',
      'hp': '1450 HP',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'isOnline': false,

    },
    {
      'name': 'Albert Flores',
      'hp': '',
      'flag': '🇧🇧',
      'avatar': 'https://i.pravatar.cc/150?img=6',
      'isOnline': false,
    },
  ];*/
}



