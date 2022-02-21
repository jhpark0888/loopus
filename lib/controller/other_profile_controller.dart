import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OtherProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  OtherProfileController(this.userid);
  static OtherProfileController get to => Get.find();

  int userid;

  // List<String> dropdownQanda = ["답변한 질문", "내가 한 질문"];
  // var selectqanda = 0.obs;

  RxBool profileenablepullup = true.obs;
  ScrollController userscrollController = ScrollController();
  ScrollController projectscrollController = ScrollController();
  ScrollController questionscrollController = ScrollController();

  RxList<ProjectWidget> otherProjectList = <ProjectWidget>[].obs;

  Rx<User> otherUser = User(
    userid: 0,
    type: 0,
    realName: '',
    totalposting: 0,
    loopcount: 0.obs,
    profileTag: [],
    department: '',
    isuser: 0,
    looped: FollowState.normal.obs,
  ).obs;

  RxList<User> otherlooplist = <User>[].obs;

  late TabController profileTabController;

  // RxBool isProfileLoading = true.obs;
  RxBool isLoopPeopleLoading = true.obs;
  Rx<ScreenState> otherprofilescreenstate = ScreenState.loading.obs;

  Future loadotherProfile(int userid) async {
    otherprofilescreenstate(ScreenState.loading);
    // isProfileLoading.value = true;

    ConnectivityResult result = await initConnectivity();
    if (result == ConnectivityResult.none) {
      otherprofilescreenstate(ScreenState.disconnect);
      ModalController.to.showCustomDialog("네트워크가 불안정합니다", 1000);
    } else {
      await getProfile(userid, 0);
      await getProjectlist(userid, 0);
    }
  }

  @override
  void onInit() async {
    profileTabController = TabController(length: 2, vsync: this);
    loadotherProfile(userid);
    super.onInit();
  }
}
