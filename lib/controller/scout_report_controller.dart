import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  // Map<String, String> careerField = {
  //   "0": "전체",
  //   for (var entry in fieldList.entries)
  //     if (entry.key != "16") entry.key: entry.value
  // };

  // RxList<MapEntry<String, String>> careerFieldList =
  //     <MapEntry<String, String>>[].obs;

  // Map<String, int> pageNumMap = {
  //   "0": 1,
  //   for (var key in fieldList.keys)
  //     if (key != "16") key: 1
  // };

  // Map<String, RxList<Company>> companyMap = {
  //   "0": <Company>[].obs,
  //   for (var key in fieldList.keys)
  //     if (key != "16") key: <Company>[].obs
  // };

  // Map<String, Rx<ScreenState>> screenStateMap = {
  //   "0": ScreenState.success.obs,
  //   for (var key in fieldList.keys)
  //     if (key != "16") key: ScreenState.success.obs
  // };

  // Map<String, RefreshController> refreshControllerMap = {
  //   "0": RefreshController(),
  //   for (var key in fieldList.keys)
  //     if (key != "16") key: RefreshController()
  // };
  RxList<String> fieldIdList = <String>[].obs;
  RxList<List<Company>> companyFieldList = <List<Company>>[].obs;
  int pageNum = 1;

  RefreshController refreshController = RefreshController();
  TextEditingController searchCompController = TextEditingController();
  RxMap<String, String> currentFieldMap = <String, String>{}.obs;

  //추천 기업
  late final PageController pController;
  RxList<Company> recommendCompList = <Company>[].obs;
  RxList<PaletteColor> colors = <PaletteColor>[].obs;
  RxInt curRcmdCompIndex = 0.obs;

  Rx<ScreenState> screenState = ScreenState.loading.obs;
  int isCorp = 0;

  @override
  void onInit() async {
    screenState(ScreenState.loading);
    String? userType = await FlutterSecureStorage().read(key: "type");
    if (userType == "student") {
      isCorp = 0;
    } else {
      isCorp = 1;
    }

    getCompanyList("main");
    await getRecommandCompanyList(isCorp.toString());
    pController = PageController(
        viewportFraction: 0.8, initialPage: recommendCompList.length * 300);
    screenState(ScreenState.success);
    super.onInit();
  }

  void onRefresh() {
    pageNum = 1;
    fieldIdList.clear();
    companyFieldList.clear();
    refreshController.loadComplete();
    getCompanyList("main");
    getRecommandCompanyList(isCorp.toString());
    refreshController.refreshCompleted();
  }

  void onLoading() {
    getCompanyList("main");
  }

  void getCompanyList(String type) async {
    await getScoutCompanySearch(
      page: pageNum,
      fieldId: type,
    ).then((value) {
      if (value.isError == false) {
        List<Map<String, dynamic>> tempList = List.from(value.data);

        for (var element in tempList) {
          fieldIdList.add((element)["id"].toString());
          companyFieldList.add(List.from((element)["companies"])
              .map((company) => Company.fromJson(company))
              .toList());
        }
        pageNum += 1;
        refreshController.loadComplete();
      } else {
        if (value.errorData!["statusCode"] == 204) {
          refreshController.loadNoData();
        } else {
          errorSituation(value);
          refreshController.loadComplete();
        }
      }
    });
  }

  Future getRecommandCompanyList(String isCorp) async {
    await getRecommandCompanys(isCorp).then((value) async {
      if (value.isError == false) {
        List<Company> companyList = List.from(value.data)
            .map((company) => Company.fromJson(company))
            .toList();

        List<String> images =
            companyList.map((company) => company.images[0].image).toList();

        await _updatePalettes(images);
        recommendCompList(companyList);
      } else {
        errorSituation(value);
      }
    });
  }

  Future _updatePalettes(List<String> images) async {
    for (String image in images) {
      try {
        final PaletteGenerator generator =
            await PaletteGenerator.fromImageProvider(
          NetworkImage(image),
          size: const Size(200, 120),
        );
        colors.add(generator.lightMutedColor ??
            generator.lightVibrantColor ??
            PaletteColor(mainWhite, 2));
      } catch (e) {
        colors.add(PaletteColor(mainblue, 2));
      }
    }
  }
}
