import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/scroll_controller.dart';

enum RouteName {
  home,
  search,
  upload,
  scout,
  careerboard,
}

class AppController extends GetxService {
  static AppController get to => Get.find();
  final LocalDataController _localDataController =
      Get.put(LocalDataController());
  final HomeController _homeController = Get.put(HomeController());
  RxBool ismyprofile = false.obs;
  RxInt currentIndex = 0.obs;
  GlobalKey<NavigatorState> searcnPageNaviationKey =
      GlobalKey<NavigatorState>();
  List<int> bottomHistory = [0];

  void changeBottomNav(int value, {bool hasGesture = true}) {
    var page = RouteName.values[value];
    switch (page) {
      case RouteName.upload:
        showCustomBottomSheet();
        break;
      case RouteName.home:
      case RouteName.search:
      case RouteName.scout:
      case RouteName.careerboard:
        _changePage(value, hasGesture: hasGesture);
        break;
    }
  }

  void _changePage(int value, {bool hasGesture = true}) {
    currentIndex(value);
    if (!hasGesture) return;
    if (bottomHistory.last != value) {
      bottomHistory.add(value);
    }
  }

  Future<bool> willPopAction() async {
    if (bottomHistory.length == 1) {
      // showDialog(
      //   context: Get.context!,
      //   builder: (context) => MessagePopup(
      //     message: '종료하시겠습니까?',
      //     okCallback: () {
      //       exit(0);
      //     },
      //     cancelCallback: Get.back,
      //     title: '시스템',
      //   ),
      // );
      return true;
    } else {
      var page = RouteName.values[bottomHistory.last];
      if (page == RouteName.search) {
        var value = await searcnPageNaviationKey.currentState!.maybePop();
        if (value) return false;
      }

      bottomHistory.removeLast();
      var index = bottomHistory.last;
      changeBottomNav(index, hasGesture: false);
      return false;
    }
  }

  // Future<void> changePageIndex(int index) async {
  //   if (index == 0) {
  //     if (_localDataController.isTagChanged == true) {
  //       _homeController.onPostingRefresh();
  //       // _homeController.onQuestionRefresh();
  //       _localDataController.tagChange(false);
  //       // .showCustomDialog('관심 태그 변경한 뒤 홈 새로고침했다는 뜻', 1000);
  //     }

  //     if (currentIndex.value == 0) {
  //       _homeController.scrollController.animateTo(0,
  //           duration: const Duration(milliseconds: 500), curve: Curves.linear);
  //     }
  //     currentIndex(index);
  //   }
  //   if (index == 1) {
  //     currentIndex(index);
  //   }
  //   if (index == 2) {
  //     if (currentIndex.value != 2) {
  //       showCustomBottomSheet();
  //     }
  //   }
  //   if (index == 3) {
  //     currentIndex(index);
  //   }
  //   if (index == 4) {
  //     ismyprofile.value = true;

  //     // if (currentIndex.value != 4) {
  //     //   //TODO: 임시
  //     //   ProfileController.to.isProfileLoading.value = true;
  //     //   ProfileController.to.loadmyProfile();
  //     // }
  //     currentIndex(index);
  //   }
  // }
}
