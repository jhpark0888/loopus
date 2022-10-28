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

class ScoutReportController extends GetxController
    with GetTickerProviderStateMixin {
  Map<String, String> careerField = {
    "0": "전체",
    for (var entry in fieldList.entries)
      if (entry.key != "16") entry.key: entry.value
  };

  RxList<MapEntry<String, String>> careerFieldList =
      <MapEntry<String, String>>[].obs;

  Map<String, int> pageNumMap = {
    "0": 1,
    for (var key in fieldList.keys)
      if (key != "16") key: 1
  };

  Map<String, RxList<Company>> companyMap = {
    "0": <Company>[].obs,
    for (var key in fieldList.keys)
      if (key != "16") key: <Company>[].obs
  };

  Map<String, Rx<ScreenState>> screenStateMap = {
    "0": ScreenState.success.obs,
    for (var key in fieldList.keys)
      if (key != "16") key: ScreenState.success.obs
  };

  Map<String, RefreshController> refreshControllerMap = {
    "0": RefreshController(),
    for (var key in fieldList.keys)
      if (key != "16") key: RefreshController()
  };

  RefreshController refreshController = RefreshController();
  TextEditingController searchCompController = TextEditingController();
  RxMap<String, String> currentFieldMap = <String, String>{}.obs;
  late TabController tabController;

  RxList<Company> recommandCompList = <Company>[].obs;
  RxList<PaletteColor> colors = <PaletteColor>[].obs;
  RxInt curRcmdCompIndex = 0.obs;

  RxInt currentField = 1.obs;
  RxInt currentRecIndex = 0.obs;
  Rx<ScreenState> screenState = ScreenState.loading.obs;
  @override
  void onInit() async {
    super.onInit();

    screenState(ScreenState.loading);
    tabController = TabController(length: careerField.length, vsync: this);

    tabController.addListener(() {
      searchCompController.clear();
      currentField.value = tabController.index;
      currentFieldMap({
        careerFieldList[currentField.value].key:
            careerFieldList[currentField.value].value
      });

      if (screenStateMap[currentFieldMap.keys.first.toString()]!.value ==
          ScreenState.normal) {}
    });

    careerFieldList.value = careerField.entries.toList();
    currentFieldMap[careerFieldList[0].key] = careerFieldList[0].value;
    getRecommandCompanyList();
  }

  void onRefresh() {
    refreshControllerMap[currentFieldMap.keys.first]!.refreshCompleted();
  }

  void getCompanyList() async {
    await getScoutCompanySearch(
            page: pageNumMap[currentField.value.toString()]!,
            fieldId: currentField.value.toString(),
            query: searchCompController.text.trim())
        .then((value) {
      if (value.isError == false) {
        List templist = List.from(value.data);
        List<Company> companyList =
            templist.map((company) => Company.fromJson(company)).toList();
      } else {
        errorSituation(value);
      }
    });
  }

  void getRecommandCompanyList() async {
    await getRecommandCompanys().then((value) {
      if (value.isError == false) {
        List<Company> companyList = List.from(value.data)
            .map((company) => Company.fromJson(company))
            .toList();

        List<String> images =
            companyList.map((company) => company.images[0].image).toList();

        _updatePalettes(images);
        recommandCompList(companyList);
        screenState(ScreenState.success);
      } else {
        errorSituation(value);
      }
    });
  }

  void _updatePalettes(List<String> images) async {
    for (String image in images) {
      final PaletteGenerator generator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(image),
        size: const Size(200, 120),
      );
      colors.add(generator.lightMutedColor ?? PaletteColor(mainWhite, 2));
    }
  }
}
