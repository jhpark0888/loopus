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
import 'package:loopus/model/company_model.dart';
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

  RxList<Project> otherProjectList = <Project>[].obs;

  Rx<File> profileimage = File('').obs;
  Rx<Person> otherUser = Person.defaultuser().obs;
  RxList<Post> allPostList = <Post>[].obs;
  int postPageNum = 1;
   int companyPageNum = 1;
  RxList<Person> otherlooplist = <Person>[].obs;
 RxList<Company> interestedCompanies = <Company>[].obs;
  Rx<ScreenState> otherprofilescreenstate = ScreenState.loading.obs;
  RxString userUnivName = ''.obs;
  KeyController keycontroller = Get.put(KeyController(isTextField: false.obs));
  RxBool isBanned = false.obs;
  // 진짜 : 0, 공식계정 : 1, 가짜 : 2
  RxInt isOfficial = 0.obs;

  Future loadotherProfile(int userid) async {
    await getProfile(userid).then((value) {
      if (value.isError == false) {
        otherUser.value.copywith(value.data);
        isOfficial.value = value.data["type"] ?? 0;
        otherUser.refresh();
      } else {
        if (value.errorData!["statusCode"] == 204) {
          isBanned(true);
        } else {
          errorSituation(value, screenState: otherprofilescreenstate);
        }
      }
    });
    if (isBanned.value == false) {
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
      _getinterestedCompany(userid);
      getOtherPosting(userid);
      userUnivName.value = (otherUser.value.univName).replaceAll('학교', '');
    }
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

  void _getinterestedCompany(int userId)async{
    await getInterestedCompany(userId, companyPageNum).then((value){
      if(value.isError != true){
        print(value.data);
        List<Company> temp = List.from(value.data).map((e) => Company.fromJson(e)).toList();
        companyPageNum += 1;
        interestedCompanies.addAll(temp);
      }else{
        errorSituation(value, screenState: otherprofilescreenstate);
      }
    });
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
