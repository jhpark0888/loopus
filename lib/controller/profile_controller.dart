import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/project_widget.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ProfileController get to => Get.find();

  RxList<ProjectWidget> projectlist = <ProjectWidget>[].obs;
  Rx<File> profileimage = File('').obs;
  Rx<User> user = User(
    user: 0,
    type: 0,
    realName: '',
    profileTag: [],
    department: '',
    isuser: 1,
  ).obs;

  late TabController profileTabController;

  RxBool isProfileLoading = true.obs;
  RefreshController profileRefreshController =
      RefreshController(initialRefresh: false);

  List<String> dropdownQanda = ["내가 답변한 질문", "내가 한 질문"];
  var selectqanda = 0.obs;

  void loadProfile() async {
    String? userId = await const FlutterSecureStorage().read(key: "id");

    await getProfile(userId).then((response) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));

      user(User.fromJson(responseBody));

      List projectmaplist = responseBody['project'];
      projectlist(projectmaplist
          .map((project) => Project.fromJson(project))
          .map((project) => ProjectWidget(
                project: project.obs,
              ))
          .toList());
      isProfileLoading.value = false;
    });
  }

  @override
  void onInit() {
    profileTabController = TabController(length: 2, vsync: this);
    loadProfile();
    super.onInit();
  }
}
