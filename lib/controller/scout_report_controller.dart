import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/rank_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:palette_generator/palette_generator.dart';

class ScoutReportController extends GetxController
    with GetTickerProviderStateMixin {
  Map<String, RxList<Company>> companyMap = {
    "0": <Company>[].obs,
    for (var key in fieldList.keys)
      if (key != "10") key: <Company>[].obs
  };

  RxBool isSearchLoading = false.obs;
  TextEditingController searchContactController = TextEditingController();
  RxMap<String, String> currentFieldMap = <String, String>{}.obs;
  late TabController tabController;

  RxInt currentField = 1.obs;
}
