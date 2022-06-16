import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/career_model.dart';
import 'package:loopus/widget/careertile_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';

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

  RxList<Project> myProjectList = <Project>[].obs;

  Rx<File> profileimage = File('').obs;
  Rx<User> myUserInfo = User.defaultuser().obs;

  RxList<User> mylooplist = <User>[].obs;

  late TabController profileTabController;

  RxBool isnewalarm = false.obs;
  RxBool isnewmessage = false.obs;

  // RxBool isProfileLoading = true.obs;
  RxBool isLoopPeopleLoading = true.obs;
  // RxBool isNetworkConnect = false.obs;
  Rx<ScreenState> myprofilescreenstate = ScreenState.loading.obs;

  // ---
  late RxList<Widget> careerAnalysis;
  late RxList<CareerModel> career;
  late RxList<CareerTile> careerwidget;
  TextEditingController careerAddController = TextEditingController();
  TextEditingController careerUpdateController = TextEditingController();
  final RxBool isDelete = false.obs;
  final RxBool isUpdate = false.obs;
  // --

  void loadmyProfile() async {
    // isProfileLoading.value = true;
    myprofilescreenstate(ScreenState.loading);
    String? userId = await const FlutterSecureStorage().read(key: "id");

    ConnectivityResult result = await initConnectivity();
    if (result == ConnectivityResult.none) {
      myprofilescreenstate(ScreenState.disconnect);
      ModalController.to.showdisconnectdialog();
    } else {
       await getProfile(userId, 1);
      await getProjectlist(userId, 1);
    }
    // isProfileLoading.value = false;
  }

  @override
  void onInit() {
    profileTabController = TabController(length: 2, vsync: this);
    loadmyProfile();


    //-----
    careerAnalysis = [
      careerAnalysisWidget('IT', 14, 2, 12, 12),
      careerAnalysisWidget('인공지능', 14, 2, 14, -12),
      careerAnalysisWidget('디자인', 14, 2, 30, 12),
      careerAnalysisWidget('산업경영공학', 14, 2, 30, 0)
    ].obs;
    career = [
      CareerModel(title: '3학년 인공지능 스터디 기록', time: DateTime.parse('2021-08-11')),
      CareerModel(title: '루프어스 프로젝트', time: DateTime.parse('2021-10-11')),
      CareerModel(title: '4학년 데이터 분석 졸업작품', time: DateTime.parse('2021-12-11')),
      CareerModel(title: '교내 홈페이지 제작', time: DateTime.parse('2022-02-11')),
    ].obs;
    // await Future.delayed(const Duration(seconds: 1));
    careerwidget = career
        .map((element) =>
            CareerTile(title: element.title.obs, time: element.time))
        .toList()
        .obs;
    //-----
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
                k9normal.copyWith(color: variance >= 1 ? mainred : mainblue)),
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
}
