import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/user_model.dart';

class OtherCompanyController extends GetxController
    with GetSingleTickerProviderStateMixin {
  OtherCompanyController({
    required this.companyId,
    required this.otherCompany,
  });
  static OtherCompanyController get to => Get.find();

  int companyId;

  RxBool profileenablepullup = true.obs;

  RxInt currentIndex = 0.obs;

  Rx<File> companyimage = File('').obs;
  Rx<Company> otherCompany = Company.defaultCompany().obs;
  RxList<Post> allPostList = <Post>[].obs;
  int postPageNum = 1;

  RxBool isnewalarm = false.obs;
  TextEditingController reportController = TextEditingController();

  RxBool isLoopPeopleLoading = true.obs;
  Rx<ScreenState> otherprofilescreenstate = ScreenState.loading.obs;

  RxBool isBanned = false.obs;

  // 가짜 : 1 , 진짜 : 0
  RxInt isFake = 0.obs;

  // RxList<User> followerList = <User>[].obs;

  // Future onRefresh() async {
  //   profileenablepullup.value = true;
  //   postPageNum = 1;
  //   allPostList.clear();
  //   loadOtherCompany();
  //   refreshController.refreshCompleted();
  // }

  // void onPostLoading() async {
  //   // await Future.delayed(Duration(seconds: 2));
  //   // _getPosting(myCompanyInfo.value.userid);
  // }

  Future loadOtherCompany(int companyId) async {
    // isProfileLoading.value = true;
    otherprofilescreenstate(ScreenState.loading);

    await getCorpProfile(companyId).then((value) async {
      if (value.isError == false) {
        otherCompany.value.copywith(value.data);
        isFake.value = value.data["type"] ?? 0;

        otherCompany.refresh();
      } else {
        if (value.errorData!["statusCode"] == 204) {
          isBanned.value = true;
        } else {
          errorSituation(value, screenState: otherprofilescreenstate);
        }
      }
    });

    getCompanyPosting(companyId);
    // getfollowPeople(companyId);
    // isProfileLoading.value = false;
  }

  Future<int> getCompanyPosting(int userId) async {
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

  // void getfollowPeople(int userId) {
  //   getfollowlist(userId, FollowListType.follower).then((value) {
  //     if (value.isError == false) {
  //       List<User> templist = List.from(value.data["follow"])
  //           .map((friend) => Person.fromJson(friend))
  //           .toList();

  //       followerList(templist);
  //     } else {
  //       errorSituation(value);
  //     }
  //   });
  // }

  @override
  void onInit() async {
    await loadOtherCompany(companyId);
    super.onInit();
  }

  // void tapLike(int careerId, int postId, int likeCount) {
  //   if (myProjectList.where((career) => career.id == careerId).isNotEmpty) {
  //     Project? career =
  //         myProjectList.where((career) => career.id == careerId).first;

  //     if (career.posts.where((post) => post.id == postId).isNotEmpty) {
  //       Post post = career.posts.where((post) => post.id == postId).first;

  //       post.isLiked(1);
  //       post.likeCount(likeCount);
  //     }
  //   }
  // }

  // void tapunLike(int careerId, int postId, int likeCount) {
  //   if (myProjectList.where((career) => career.id == careerId).isNotEmpty) {
  //     Project? career =
  //         myProjectList.where((career) => career.id == careerId).first;

  //     if (career.posts.where((post) => post.id == postId).isNotEmpty) {
  //       Post post = career.posts.where((post) => post.id == postId).first;

  //       post.isLiked(0);
  //       post.likeCount(likeCount);
  //     }
  //   }
  // }
}
