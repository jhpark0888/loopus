import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/career_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/careertile_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static ProfileController get to => Get.find();

  RxBool profileenablepullup = true.obs;

  late TabController tabController;
  RxInt currentIndex = 0.obs;

  RefreshController profilerefreshController =
      RefreshController(initialRefresh: false);
  RefreshController postLoadingController =
      RefreshController(initialRefresh: false);

  RxList<Project> myProjectList = <Project>[].obs;

  Rx<File> profileimage = File('').obs;
  Rx<User> myUserInfo = User.defaultuser().obs;
  RxList<Post> allPostList = <Post>[].obs;
  int postPageNum = 1;

  RxList<User> mylooplist = <User>[].obs;

  RxBool isnewalarm = false.obs;
  // RxBool isnewmessage = false.obs;

  RxBool isLoopPeopleLoading = true.obs;
  Rx<ScreenState> myprofilescreenstate = ScreenState.loading.obs;

  // ---
  // late RxList<Widget> careerAnalysis;
  // late RxList<CareerModel> career;
  // late RxList<CareerTile> careerwidget;
  // --

  Future onRefresh() async {
    profileenablepullup.value = true;
    postPageNum = 1;
    allPostList.clear();
    loadmyProfile();
    profilerefreshController.refreshCompleted();
  }

  void onPostLoading() async {
    // await Future.delayed(Duration(seconds: 2));
    _getPosting(myUserInfo.value.userid);
  }

  Future loadmyProfile() async {
    // isProfileLoading.value = true;
    myprofilescreenstate(ScreenState.loading);
    String? userId = await const FlutterSecureStorage().read(key: "id");

    ConnectivityResult result = await initConnectivity();
    if (result == ConnectivityResult.none) {
      myprofilescreenstate(ScreenState.disconnect);
      showdisconnectdialog();
    } else {
      await getProfile(int.parse(userId!)).then((value) {
        if (value.isError == false) {
          User user = User.fromJson(value.data);
          myUserInfo(user);
          isnewalarm(value.data["new_alarm"]);
          // isnewmessage(value.data["new_message"]);
        } else {
          errorSituation(value, screenState: myprofilescreenstate);
        }
      });
      await getProjectlist(int.parse(userId)).then((value) {
        if (value.isError == false) {
          List<Project> projectlist = List.from(value.data)
              .map((project) => Project.fromJson(project))
              .toList();
          myProjectList(projectlist);
        } else {
          errorSituation(value, screenState: myprofilescreenstate);
        }
      });
      _getPosting(int.parse(userId));
    }
    // isProfileLoading.value = false;
  }

  void _getPosting(int userId) async {
    await getAllPosting(userId, postPageNum).then((value) {
      if (value.isError == false) {
        List<Post> postlist = value.data;

        allPostList.addAll(postlist);
        postPageNum += 1;

        myprofilescreenstate(ScreenState.success);
        postLoadingController.loadComplete();
      } else {
        if (value.errorData!["statusCode"] == 204) {
          postLoadingController.loadNoData();
        } else {
          errorSituation(value, screenState: myprofilescreenstate);
          postLoadingController.loadComplete();
        }
      }
    });
  }

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        currentIndex.value = tabController.index;
      });

    await loadmyProfile();
    super.onInit();
  }

  void tapLike(int careerId, int postId, int likeCount) {
    if (myProjectList.where((career) => career.id == careerId).isNotEmpty) {
      Project? career =
          myProjectList.where((career) => career.id == careerId).first;

      if (career.posts.where((post) => post.id == postId).isNotEmpty) {
        Post post = career.posts.where((post) => post.id == postId).first;

        post.isLiked(1);
        post.likeCount(likeCount);
      }
    }
  }

  void tapunLike(int careerId, int postId, int likeCount) {
    if (myProjectList.where((career) => career.id == careerId).isNotEmpty) {
      Project? career =
          myProjectList.where((career) => career.id == careerId).first;

      if (career.posts.where((post) => post.id == postId).isNotEmpty) {
        Post post = career.posts.where((post) => post.id == postId).first;

        post.isLiked(0);
        post.likeCount(likeCount);
      }
    }
  }
}
