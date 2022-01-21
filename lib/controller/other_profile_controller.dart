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
    loopcount: 0,
    profileTag: [],
    department: '',
    isuser: 0,
    looped: 0,
  ).obs;

  RxList<User> otherlooplist = <User>[].obs;

  late TabController profileTabController;

  RxBool isProfileLoading = true.obs;
  RxBool isLoopPeopleLoading = true.obs;

  void loadotherProfile(int userid) async {
    await getProfile(userid).then((user) async {
      otherUser(user);
      isProfileLoading.value = false;
    });
    await getProjectlist(userid).then((projectlist) {
      otherProjectList(projectlist
          .map((project) => ProjectWidget(
                project: project.obs,
                type: ProjectWidgetType.profile,
              ))
          .toList());
    });
    isProfileLoading.value = false;
  }

  @override
  void onInit() {
    profileTabController = TabController(length: 2, vsync: this);
    isProfileLoading.value = true;
    loadotherProfile(userid);
    super.onInit();
  }
}
