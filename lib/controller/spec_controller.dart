import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/rank_api.dart';
import 'package:loopus/api/spec_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/activity_model.dart';
import 'package:loopus/model/class_model.dart';
import 'package:loopus/model/comment_model.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/univ_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SpecController extends GetxController with GetTickerProviderStateMixin {
  static SpecController get to => Get.find();

  List<RefreshController> rfControllerList =
      List.generate(2, (index) => RefreshController());
  List<Rx<ScreenState>> scStateList =
      List.generate(2, (index) => ScreenState.loading.obs);

  RxInt currentIndex = 0.obs;

  late TabController tabController;

  RxString univName = "-".obs;
  RxString univLogo = "".obs;

  String get shortUnivName => univName.replaceAll("학교", "");

  //교내
  RxList<SchoolClass> classLsit = <SchoolClass>[].obs;
  RxList<SchoolActi> scActiList = <SchoolActi>[].obs;

  //교외
  RxInt curCatIndex = 0.obs;
  RxInt curGroupIndex = 0.obs;

  Map<int, RxList<OutActi>> popActiListMap = {
    for (int i = 0; i < 4; i++) i: <OutActi>[].obs
  };

  Map<int, Map<int, RxList<OutActi>>> catActiListMap = {
    for (int i = 0; i < 4; i++)
      i: {
        for (int j = 0; j < schoolOutCatMap[i]!.length; j++) j: <OutActi>[].obs
      }
  };

  int get curPopActiListLength => popActiListMap[curCatIndex.value]!.length;
  int get curGroupActiListLength =>
      catActiListMap[curCatIndex.value]![curGroupIndex.value]!.length;

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      currentIndex.value = tabController.index;
    });

    schoolSpecLoad();
    outPopNotiLoad();
    outGroupNotiLoad();

    super.onInit();
  }

  void onRefresh() {
    rfControllerList[currentIndex.value].refreshCompleted();
  }

  void schoolSpecLoad() {
    getSchoolSpec().then((value) {
      if (value.isError == false) {
        univName.value = value.data["school"]["school"];
        univLogo.value = value.data["school"]["logo"];

        classLsit.value = List.from(value.data["class"])
            .map((schoolClass) => SchoolClass.fromJson(schoolClass))
            .toList();

        scActiList.value = List.from(value.data["activity"])
            .map((scActi) => SchoolActi.fromJson(scActi))
            .toList();

        scStateList[0].value = ScreenState.success;
      } else {
        errorSituation(value);
      }
    });
  }

  void outPopNotiLoad() {
    getSchoolOutPopNotice(curCatIndex.value).then((value) {
      if (value.isError == false) {
        List<OutActi> actiList = List.from(value.data)
            .map((acti) => OutActi.fromJson(acti))
            .toList();

        popActiListMap[curCatIndex.value]!.value = actiList;
      } else {
        errorSituation(value);
      }
    });
  }

  void outGroupNotiLoad() {
    getSchoolOutGroupNoti(curCatIndex.value,
            schoolOutCatMap[curCatIndex.value]![curGroupIndex.value])
        .then((value) {
      if (value.isError == false) {
        List<OutActi> actiList = List.from(value.data)
            .map((acti) => OutActi.fromJson(acti))
            .toList();

        catActiListMap[curCatIndex.value]![curGroupIndex.value]!.value =
            actiList;

        scStateList[1].value = ScreenState.success;
      } else {
        errorSituation(value);
      }
    });
  }
}
