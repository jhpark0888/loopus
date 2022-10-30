import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/modal_controller.dart';

import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OtherProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  OtherProfileController({
    required this.userid,
    required this.otherUser,
  });
  static OtherProfileController get to => Get.find();

  int userid;

  RxBool profileenablepullup = true.obs;

  RxInt currentIndex = 0.obs;

  RxList<Project> otherProjectList = <Project>[].obs;

  Rx<File> profileimage = File('').obs;
  Rx<Person> otherUser = Person.defaultuser().obs;
  RxList<Post> allPostList = <Post>[].obs;
  int postPageNum = 1;

  TextEditingController reportController = TextEditingController();

  RxList<Person> otherlooplist = <Person>[].obs;

  Rx<ScreenState> otherprofilescreenstate = ScreenState.loading.obs;

  KeyController keycontroller = Get.put(KeyController(isTextField: false.obs));

  Future loadotherProfile(int userid) async {
    await getProfile(userid).then((value) {
      if (value.isError == false) {
        otherUser.value.copywith(value.data);
        otherUser.refresh();
      } else {
        errorSituation(value, screenState: otherprofilescreenstate);
      }
    });
    await getProjectlist(userid).then((value) {
      if (value.isError == false) {
        List<Project> projectlist = List.from(value.data)
            .map((project) => Project.fromJson(project))
            .toList();

        otherProjectList(projectlist);
        otherprofilescreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: otherprofilescreenstate);
      }
    });
    getOtherPosting(userid);
  }

  Future<int> getOtherPosting(int userId) async {
    HTTPResponse httpResponse = await getAllPosting(userId, postPageNum);

    if (httpResponse.isError == false) {
      List<Post> postlist = List.from(httpResponse.data)
          .map((post) => Post.fromJson(post))
          .toList();

      allPostList.addAll(postlist);
      postPageNum += 1;

      otherprofilescreenstate(ScreenState.success);
    } else {
      if (httpResponse.errorData!["statusCode"] != 204) {
        errorSituation(httpResponse, screenState: otherprofilescreenstate);
      }
    }
    if (httpResponse.errorData == null) {
      return 200;
    } else {
      return httpResponse.errorData!["statusCode"];
    }
  }

  @override
  void onInit() async {
    await loadotherProfile(userid);

    super.onInit();
  }

  // Future<void> enterByClickCareer() async {
  //   SchedulerBinding.instance!.addPostFrameCallback((timeStamp) async {
  //     if (careerName != null) {
  //       double index = otherProjectList
  //           .indexWhere((element) => element.careerName == careerName)
  //           .toDouble();
  //       careerCurrentPage.value = index;
  //       // careertitleController.animateToPage(index.toInt(),
  //       //     duration: const Duration(milliseconds: 100), curve: Curves.ease);
  //       careertitleController.jumpToPage(index.toInt());
  //       careerPageController.jumpToPage(index.toInt());
  //       await Future.delayed(const Duration(milliseconds: 400));

  //       Scrollable.ensureVisible(keycontroller.viewKey.currentContext!,
  //           curve: Curves.easeOut, duration: const Duration(milliseconds: 250));
  //     }
  //   });
  // }
}
