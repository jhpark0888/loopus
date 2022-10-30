import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/user_model.dart';

class MyCompanyController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static MyCompanyController get to => Get.find();

  RxBool profileenablepullup = true.obs;

  late TabController tabController;
  RxInt currentIndex = 0.obs;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  RefreshController postLoadingController =
      RefreshController(initialRefresh: false);

  Rx<File> companyimage = File('').obs;
  Rx<Company> myCompanyInfo = Company.defaultCompany().obs;
  RxList<Post> allPostList = <Post>[].obs;
  int postPageNum = 1;

  RxBool isnewalarm = false.obs;
  // RxBool isnewmessage = false.obs;

  RxBool isLoopPeopleLoading = true.obs;
  Rx<ScreenState> myprofilescreenstate = ScreenState.loading.obs;

  // RxList<User> followerList = <User>[].obs;

  Future onRefresh() async {
    profileenablepullup.value = true;
    postPageNum = 1;
    allPostList.clear();
    loadmyProfile();
    refreshController.refreshCompleted();
  }

  void onPostLoading() async {
    // await Future.delayed(Duration(seconds: 2));
    // _getPosting(myCompanyInfo.value.userid);
  }

  Future loadmyProfile() async {
    // isProfileLoading.value = true;
    myprofilescreenstate(ScreenState.loading);
    String? userId = await const FlutterSecureStorage().read(key: "id");

    await getCorpProfile(int.parse(userId!)).then((value) async {
      if (value.isError == false) {
        myCompanyInfo.value = Company.fromJson(value.data);
        // isNewAlarm.value = value.data['new_alarm'];
        print(myCompanyInfo.value.images);
      } else {
        errorSituation(value, screenState: myprofilescreenstate);
      }
    });

    _getPosting(int.parse(userId));
    // getfollowPeople(int.parse(userId));
    // isProfileLoading.value = false;
  }

  void _getPosting(int userId) async {
    await getAllPosting(userId, postPageNum).then((value) {
      if (value.isError == false) {
        List<Post> postlist =
            List.from(value.data).map((post) => Post.fromJson(post)).toList();

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
    tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        currentIndex.value = tabController.index;
      });

    await loadmyProfile();
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
