import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/question_widget.dart';
import 'package:loopus/widget/search_posting_widget.dart';
import 'package:loopus/widget/search_profile_widget.dart';
import 'package:loopus/widget/search_question_widget.dart';
import 'package:loopus/widget/search_tag_project_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';

class TagDetailController extends GetxController
    with GetTickerProviderStateMixin {
  TagDetailController(this.tagid);
  static TagDetailController get to => Get.find();

  RxList<SearchTagProjectWidget> searchtagprojectlist =
      <SearchTagProjectWidget>[].obs;
  RxList<QuestionWidget> searchtagquestionlist = <QuestionWidget>[].obs;

  // RxBool istag = false.obs;

  late TabController tabController;
  late TabController tagtabController;

  int tagid;

  RxBool istagSearchLoading = false.obs;

  @override
  void onInit() {
    tagtabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );

    istagSearchLoading(true);
    search(SearchType.tag_project, tagid.toString(), 1);
    search(SearchType.tag_question, tagid.toString(), 1).then((value) {
      istagSearchLoading(false);
    });
    super.onInit();
  }
}
