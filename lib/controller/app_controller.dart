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
  paper,
  bookmark,
  profile,
}

class AppController extends GetxService {
  static AppController get to => Get.find();
  final LocalDataController _localDataController =
      Get.put(LocalDataController());
  final HomeController _homeController = Get.put(HomeController());
  RxBool ismyprofile = false.obs;
  RxInt currentIndex = 0.obs;

  Future<void> changePageIndex(int index) async {
    if (index == 0) {
      if (_localDataController.isTagChanged == true) {
        _homeController.onPostingRefresh();
        _homeController.onQuestionRefresh();
        _localDataController.tagChange(false);
        // ModalController.to.showCustomDialog('관심 태그 변경한 뒤 홈 새로고침했다는 뜻', 1000);
      }

      if (currentIndex.value == 0) {
        CustomScrollController.to.scrollToTop();
        if (CustomScrollController.to.customScrollController.value.offset ==
            0.0) {
          HomeController.to.hometabcontroller.animateTo(
            0,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300),
          );
        }
      }
      currentIndex(index);
    }
    if (index == 1) {
      currentIndex(index);
    }
    if (index == 2) {
      if (currentIndex.value != 2) {
        ModalController.to.showBottomSheet();
      }
    }
    if (index == 3) {
      currentIndex(index);
    }
    if (index == 4) {
      ismyprofile.value = true;

      // if (currentIndex.value != 4) {
      //   //TODO: 임시
      //   ProfileController.to.isProfileLoading.value = true;
      //   ProfileController.to.loadmyProfile();
      // }
      currentIndex(index);
    }
  }
}
