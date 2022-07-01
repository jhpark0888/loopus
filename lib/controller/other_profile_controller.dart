import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';

import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OtherProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  OtherProfileController(this.userid);
  static OtherProfileController get to => Get.find();

  int userid;

  RxBool profileenablepullup = true.obs;

  final careertitleController = PageController(
    viewportFraction: 0.4,
  );
  final careerPageController = PageController();
  RxDouble careerCurrentPage = 0.0.obs;

  // RefreshController profilerefreshController =
  //     RefreshController(initialRefresh: false);

  // void onRefresh() async {
  //   careerCurrentPage(0.0);
  //   profileenablepullup.value = true;
  //   // loadmyProfile();
  //   profilerefreshController.refreshCompleted();
  // }

  // void onLoading() async {
  //   // await Future.delayed(Duration(seconds: 2));
  //   if (otherProjectList.isNotEmpty) {
  //     // getposting();
  //   }
  //   profilerefreshController.loadComplete();
  // }

  RxBool careerLoading = false.obs;

  RxList<Project> otherProjectList = <Project>[].obs;
  List<int> _careerPagenums = <int>[];

  Rx<File> profileimage = File('').obs;

  Rx<User> otherUser = User.defaultuser().obs;

  RxList<User> otherlooplist = <User>[].obs;

  // RxBool isLoopPeopleLoading = true.obs;
  Rx<ScreenState> otherprofilescreenstate = ScreenState.loading.obs;

  Future loadotherProfile(int userid) async {
    // isProfileLoading.value = true;

    ConnectivityResult result = await initConnectivity();
    if (result == ConnectivityResult.none) {
      otherprofilescreenstate(ScreenState.disconnect);
      showdisconnectdialog();
    } else {
      await getProfile(userid).then((value) {
        if (value.isError == false) {
          User user = User.fromJson(value.data);

          otherUser(user);
        } else {
          errorSituation(value, screenState: otherprofilescreenstate.value);
        }
      });
      await getProjectlist(userid).then((value) {
        if (value.isError == false) {
          List<Project> projectlist = List.from(value.data)
              .map((project) => Project.fromJson(project))
              .toList();
          _careerPagenums = List.generate(projectlist.length, (index) => 1);

          otherProjectList(projectlist);
        } else {
          errorSituation(value, screenState: otherprofilescreenstate.value);
        }
      });
      if (otherProjectList.isNotEmpty) {
        getProfilePost();
      }
    }
  }

  void getProfilePost() async {
    // print('현재 페이지 ${careerCurrentPage.value}');
    await getCareerPosting(otherProjectList[careerCurrentPage.value.toInt()].id,
            _careerPagenums[careerCurrentPage.value.toInt()])
        .then((value) {
      if (value.isError == false) {
        List<Post> postlist = value.data;

        if (postlist.isNotEmpty) {
          if (otherProjectList[careerCurrentPage.value.toInt()]
              .posts
              .where((post) => post.id == postlist.last.id)
              .isEmpty) {
            otherProjectList[careerCurrentPage.value.toInt()]
                .posts
                .addAll(postlist);
            _careerPagenums[careerCurrentPage.value.toInt()] += 1;
          } else {
            profileenablepullup(false);
          }
        } else {
          profileenablepullup(false);
        }

        otherprofilescreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: otherprofilescreenstate.value);
      }
    });
  }

  @override
  void onInit() async {
    await loadotherProfile(userid);

    ever(
      careerCurrentPage,
      (_) async {
        Project project = otherProjectList[careerCurrentPage.toInt()];
        profileenablepullup(true);
        if (project.posts.isEmpty) {
          careerLoading(true);
          getProfilePost();
          careerLoading(false);
        }
      },
      // time: const Duration(milliseconds: 300),
    );
    super.onInit();
  }

  List<PieChartSectionData> showingSections() {
    return otherProjectList.map((career) {
      int index =
          otherProjectList.indexWhere((element) => element.id == career.id);
      final isSelected = index == careerCurrentPage.value;
      final fontSize = isSelected ? 15.0 : 10.0;
      final radius = isSelected ? 40.0 : 25.0;
      return PieChartSectionData(
        color: colorgroup[index],
        value: career.postRatio,
        title: '',
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
    }).toList();
  }
}
