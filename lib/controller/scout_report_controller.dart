import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/rank_api.dart';
import 'package:loopus/api/scout_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:palette_generator/palette_generator.dart';
import 'career_board_controller.dart';

// class ScoutReportController extends GetxController
//     with GetTickerProviderStateMixin {
//   Map<String, RxList<Company>> companyMap = {
//     "0": <Company>[].obs,
//     for (var key in fieldList.keys)
//       if (key != "10") key: <Company>[].obs
//   };

//   RxBool isSearchLoading = false.obs;
//   TextEditingController searchContactController = TextEditingController();
//   RxMap<String, String> currentFieldMap = <String, String>{}.obs;
//   late TabController tabController;

//   RxInt currentField = 1.obs;
// }

class ScoutReportController extends GetxController
    with GetTickerProviderStateMixin {
  Map<String, String> careerField = {
    "0": "전체",
    for (var entry in fieldList.entries)
      if (entry.key != "10") entry.key: entry.value
  };

  RxList<MapEntry<String, String>> careerFieldList =
      <MapEntry<String, String>>[].obs;

  Map<String, RxBool> isSearchFocusMap = {
    "0": false.obs,
    for (var key in fieldList.keys)
      if (key != "10") key: false.obs
  };

  Map<String, int> pageNumMap = {
    "0": 1,
    for (var key in fieldList.keys)
      if (key != "10") key: 1
  };

  Map<String, RxList<Contact>> searchContactMap = {
    "0": <Contact>[].obs,
    for (var key in fieldList.keys)
      if (key != "10") key: <Contact>[].obs
  };

  Map<String, RxList<Contact>> companyMap = {
    "0": <Contact>[].obs,
    for (var key in fieldList.keys)
      if (key != "10") key: <Contact>[].obs
  };

  Map<String, RxList<Contact>> contactMap = {
    "0": <Contact>[].obs,
    for (var key in fieldList.keys)
      if (key != "10") key: <Contact>[].obs
  };

  Map<String, Rx<ScreenState>> screenStateMap = {
    "0": ScreenState.success.obs,
    for (var key in fieldList.keys)
      if (key != "10") key: ScreenState.success.obs
  };

  Map<String, RefreshController> refreshControllerMap = {
    "0": RefreshController(),
    for (var key in fieldList.keys)
      if (key != "10") key: RefreshController()
  };

  RxBool isSearchLoading = false.obs;
  TextEditingController searchContactController = TextEditingController();
  RxMap<String, String> currentFieldMap = <String, String>{}.obs;
  late TabController tabController;

  RxList<Contact> recommandCompList = <Contact>[].obs;

  RxInt currentField = 1.obs;
  RxInt currentRecIndex = 0.obs;

  @override
  void onInit() async {
    tabController = TabController(length: careerField.length, vsync: this);

    tabController.addListener(() {
      searchContactController.clear();
      isSearchFocusMap[careerFieldList[currentField.value].key]!(false);
      currentField.value = tabController.index;
      currentFieldMap({
        careerFieldList[currentField.value].key:
            careerFieldList[currentField.value].value
      });

      if (screenStateMap[currentFieldMap.keys.first.toString()]!.value ==
          ScreenState.normal) {
        careerBoardLoad(currentFieldMap.keys.first);
      }
    });
    scoutreportLoad("1", "10", "");

    careerFieldList.value = careerField.entries.toList();
    currentFieldMap[careerFieldList[0].key] = careerFieldList[0].value;
    careerBoardLoad(currentFieldMap.keys.first);
    await getRecommandCompanyList();
    super.onInit();
  }

  void onRefresh() {
    careerBoardLoad(currentFieldMap.keys.first, isloading: false);
    refreshControllerMap[currentFieldMap.keys.first]!.refreshCompleted();
  }

  void careerBoardLoad(String fieldId, {bool isloading = true}) async {
    if (isloading) {
      screenStateMap[fieldId]!.value = ScreenState.loading;
    }
  }

  //  void scoutonRefresh() {
  //   scoutreportLoad(currentFieldMap.keys.first, isloading: false);
  //   refreshControllerMap[currentFieldMap.keys.first]!.refreshCompleted();
  // }

  void scoutreportLoad(String page, String type, String query) async {
    super.onInit();
  }

  Future<void> getCompanyList() async {
    await getCompanyInfo(
            page: pageNumMap[currentField.value.toString()]!,
            fieldId: currentField.value.toString())
        .then((value) {
      if (value.isError == false) {
        print(value.data);
        List templist = List.from(value.data);
        List<Contact> companyList =
            templist.map((company) => Contact.fromJson(company)).toList();
      } else {
        errorSituation(value);
      }
    });
  }

  Future<void> getRecommandCompanyList() async {
    await getRecommandCompanys(
            fieldId: HomeController.to.myProfile.value.fieldId)
        .then((value) {
      if (value.isError == false) {
        List<Contact> companyList = List.from(value.data)
            .map((company) => Contact.fromJson(company))
            .toList();
        recommandCompList(companyList);
      } else {
        errorSituation(value);
      }
    });
  }
}
