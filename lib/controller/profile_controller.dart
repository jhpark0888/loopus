import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ProfileController get to => Get.find();

  List<String> dropdownQanda = ["답변한 질문", "내가 한 질문"];
  var selectqanda = 0.obs;
  RxBool profileenablepullup = true.obs;
  ScrollController userscrollController = ScrollController();
  ScrollController projectscrollController = ScrollController();
  ScrollController questionscrollController = ScrollController();

  RefreshController profilerefreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    profileenablepullup.value = true;
    loadmyProfile();
    profilerefreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(Duration(milliseconds: 10));
    profilerefreshController.loadComplete();
  }

  RxList<Project> myProjectList = <Project>[].obs;

  Rx<File> profileimage = File('').obs;
  Rx<User> myUserInfo = User.defaultuser().obs;

  RxList<User> mylooplist = <User>[].obs;

  late TabController profileTabController;

  RxBool isnewalarm = false.obs;
  RxBool isnewmessage = false.obs;

  // RxBool isProfileLoading = true.obs;
  RxBool isLoopPeopleLoading = true.obs;
  // RxBool isNetworkConnect = false.obs;
  Rx<ScreenState> myprofilescreenstate = ScreenState.loading.obs;

  void loadmyProfile() async {
    // isProfileLoading.value = true;
    myprofilescreenstate(ScreenState.loading);
    String? userId = await const FlutterSecureStorage().read(key: "id");

    ConnectivityResult result = await initConnectivity();
    if (result == ConnectivityResult.none) {
      myprofilescreenstate(ScreenState.disconnect);
      ModalController.to.showdisconnectdialog();
    } else {
      await getProfile(userId, 1);
      myUserInfo.value.profileTag = [
        Tag(tagId: 1, tag: '인공지능', count: 3),
        Tag(tagId: 1, tag: '데이터분석', count: 3),
        Tag(tagId: 1, tag: '앱개발', count: 3),
      ];
      await getProjectlist(userId, 1);
    }
    // isProfileLoading.value = false;
  }

  @override
  void onInit() {
    profileTabController = TabController(length: 2, vsync: this);
    loadmyProfile();
    super.onInit();
  }
}
