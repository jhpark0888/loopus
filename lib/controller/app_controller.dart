import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/scroll_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/share_intent_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/screen/select_project_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

enum RouteName {
  home,
  search,
  upload,
  scout,
  careerboard,
}

class AppController extends GetxController {
  static AppController get to => Get.find();
  final LocalDataController _localDataController =
      Get.put(LocalDataController());
  final HomeController _homeController = Get.put(HomeController());
  RxInt currentIndex = 0.obs;
  GlobalKey<NavigatorState> searcnPageNaviationKey =
      GlobalKey<NavigatorState>();
  List<int> bottomHistory = [0];
  SQLController sqlcontroller = Get.put(SQLController());
  UserType userType = UserType.student;

  @override
  void onInit() async {
    // TODO: implement onInit
    String? tempUserType = await FlutterSecureStorage().read(key: "type");
    if (tempUserType == UserType.company.name) {
      userType = UserType.company;
    }
    super.onInit();
  }

  void changeBottomNav(int value, {bool hasGesture = true}) {
    var page = RouteName.values[value];
    switch (page) {
      case RouteName.upload:
        print(userType);
        if (userType == UserType.student) {
          Get.to(() => SelectProjectScreen());
        } else if (userType == UserType.company) {
          Get.to(() => PostingAddScreen(
              project_id: companyCareerId, route: PostaddRoute.bottom));
        }

        break;
      case RouteName.home:
        if (currentIndex.value == 0) {
          _homeController.scrollToTop();
        }
        _changePage(value, hasGesture: hasGesture);
        break;
      case RouteName.search:
        if (currentIndex.value == 1) {
          SearchController.to.scrollcontroller.animateTo(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear);
        }
        _changePage(value, hasGesture: hasGesture);
        break;
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
      if (bottomHistory.contains(value)) {
        if (!(value == 0 &&
            bottomHistory.where((element) => element == 0).length == 1)) {
          bottomHistory.remove(value);
        }
      }
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
