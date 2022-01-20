import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  RxList<ProjectWidget> myProjectList = <ProjectWidget>[].obs;
  RxList<ProjectWidget> otherProjectList = <ProjectWidget>[].obs;

  Rx<File> profileimage = File('').obs;
  Rx<User> myUserInfo = User(
    //id
    userid: 0,
    //0 : 학생, 1: 기업
    type: 0,
    realName: '',
    profileTag: [],
    totalposting: 0,
    loopcount: 0,
    department: '',
    //0 : 다른 프로필, 1 : 내 프로필
    isuser: 1,
    looped: 0,
  ).obs;

  RxList<User> mylooplist = <User>[].obs;

  late TabController profileTabController;

  RxBool isProfileLoading = true.obs;
  RxBool isLoopPeopleLoading = true.obs;

  void loadmyProfile() async {
    String? userId = await const FlutterSecureStorage().read(key: "id");

    await getProfile(userId).then((user) async {
      myUserInfo(user);
      isProfileLoading.value = false;
    });
    await getProjectlist(userId).then((projectlist) {
      myProjectList(projectlist
          .map((project) => ProjectWidget(
                project: project.obs,
              ))
          .toList());
    });
  }

  @override
  void onInit() {
    profileTabController = TabController(length: 2, vsync: this);
    // isProfileLoading.value = true;
    loadmyProfile();
    super.onInit();
  }
}
