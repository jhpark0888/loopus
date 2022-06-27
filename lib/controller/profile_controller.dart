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

  final careertitleController = PageController(
    viewportFraction: 0.4,
  );
  final careerPageController = PageController();
  RxDouble careerCurrentPage = 0.0.obs;

  RefreshController profilerefreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    careerCurrentPage(0.0);
    profileenablepullup.value = true;
    loadmyProfile();
    profilerefreshController.refreshCompleted();
  }

  void onLoading() async {
    // await Future.delayed(Duration(seconds: 2));
    if (myProjectList.isNotEmpty) {
      getProfilePost();
    }
    profilerefreshController.loadComplete();
  }

  RxBool careerLoading = false.obs;

  RxList<Project> myProjectList = <Project>[].obs;
  List<int> careerPagenums = <int>[];

  Rx<File> profileimage = File('').obs;
  Rx<User> myUserInfo = User.defaultuser().obs;

  RxList<User> mylooplist = <User>[].obs;

  RxBool isnewalarm = false.obs;
  RxBool isnewmessage = false.obs;

  RxBool isLoopPeopleLoading = true.obs;
  Rx<ScreenState> myprofilescreenstate = ScreenState.loading.obs;

  // ---
  late RxList<Widget> careerAnalysis;
  late RxList<CareerModel> career;
  late RxList<CareerTile> careerwidget;
  // --

  Future loadmyProfile() async {
    // isProfileLoading.value = true;
    myprofilescreenstate(ScreenState.loading);
    String? userId = await const FlutterSecureStorage().read(key: "id");

    ConnectivityResult result = await initConnectivity();
    if (result == ConnectivityResult.none) {
      myprofilescreenstate(ScreenState.disconnect);
      showdisconnectdialog();
    } else {
      await getProfile(userId, 1);
      await getProjectlist(userId, 1);
      if (myProjectList.isNotEmpty) {
        getProfilePost();
      }
    }
    // isProfileLoading.value = false;
  }

  void getProfilePost() async {
    // print('현재 페이지 ${careerCurrentPage.value}');
    await getCareerPosting(myProjectList[careerCurrentPage.value.toInt()].id,
            careerPagenums[careerCurrentPage.value.toInt()])
        .then((value) {
      if (value.isError == false) {
        List<Post> postlist = value.data;

        if (postlist.isNotEmpty) {
          if (myProjectList[careerCurrentPage.value.toInt()]
              .posts
              .where((post) => post.id == postlist.last.id)
              .isEmpty) {
            myProjectList[careerCurrentPage.value.toInt()]
                .posts
                .addAll(postlist);
            careerPagenums[careerCurrentPage.value.toInt()] += 1;
          } else {
            profileenablepullup(false);
          }
        } else {
          profileenablepullup(false);
        }

        myprofilescreenstate(ScreenState.success);
      } else {
        errorSituation(value);
        myprofilescreenstate(ScreenState.error);
      }
    });
  }

  @override
  void onInit() async {
    await loadmyProfile();

    //-----
    careerAnalysis = [
      careerAnalysisWidget('IT', 14, 2, 12, 12),
      careerAnalysisWidget('인공지능', 14, 2, 14, -12),
      careerAnalysisWidget('디자인', 14, 2, 30, 12),
    ].obs;

    ever(
      careerCurrentPage,
      (_) async {
        Project project = myProjectList[careerCurrentPage.toInt()];
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

  Widget careerAnalysisWidget(String title, int countrywide,
      int countryVariance, int campus, int campusVariance) {
    return Column(
      children: [
        const SizedBox(height: 14),
        Row(
          children: [
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: title, style: kBody2Style.copyWith(color: mainblue)),
              const TextSpan(text: ' 분야', style: kBody2Style)
            ])),
            const SizedBox(width: 37),
            Text('전국 $countrywide%', style: kBody2Style),
            rate(countryVariance),
            const SizedBox(width: 11),
            Text('교내 $campus%', style: kBody2Style),
            rate(campusVariance)
          ],
        )
      ],
    );
  }

  Widget rate(int variance) {
    return Row(children: [
      const SizedBox(width: 32),
      arrowDirection(variance),
      const SizedBox(width: 2),
      if (variance != 0)
        Text('${variance.abs()}%',
            style:
                k9normal.copyWith(color: variance >= 1 ? rankred : mainblue)),
    ]);
  }

  Widget arrowDirection(int variance) {
    if (variance == 0) {
      return const SizedBox.shrink();
    } else if (variance >= 1) {
      return SvgPicture.asset('assets/icons/upper_arrow.svg');
    } else {
      return SvgPicture.asset('assets/icons/down_arrow.svg');
    }
  }

  List<PieChartSectionData> showingSections() {
    return myProjectList.map((career) {
      int index =
          myProjectList.indexWhere((element) => element.id == career.id);
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
