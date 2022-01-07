import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:http/http.dart' as http;

class TagController extends GetxController {
  static TagController get to => Get.find();

  void onInit() {
    super.onInit();
    tagsearch.addListener(() {
      gettagsearch();
    });
  }

  TextEditingController tagsearch = TextEditingController();

  RxList<SelectedTagWidget> selectedtaglist = <SelectedTagWidget>[].obs;
  RxList<SearchTagWidget> searchtaglist = <SearchTagWidget>[].obs;
  RxList<SearchTagWidget> searchpagetag = <SearchTagWidget>[].obs;
  RxList<SelectedPersonTagWidget> selectedpersontaglist =
      <SelectedPersonTagWidget>[].obs;
}
