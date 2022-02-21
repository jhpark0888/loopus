import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:http/http.dart' as http;

class TagController extends GetxController {
  TagController({required this.tagtype});
  static TagController get to => Get.find();
  ScrollController _tagScrollController = ScrollController();
  RxBool isTagChanging = false.obs;
  Rx<ScreenState> tagsearchstate = ScreenState.loading.obs;
  // RxBool isTagSearchLoading = false.obs;
  RxString _searchword = "".obs;
  // late Timer _debounce;

  Tagtype tagtype;
  final maxExtent = Get.height * 0.25;
  RxDouble currentExtent = 0.0.obs;

  // _onSearchChanged() {
  //   if (_debounce.isActive) _debounce.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 300), () {
  //     //원하는 함수
  //     gettagsearch(tagtype);
  //   });
  // }

  void onInit() {
    super.onInit();

    debounce(_searchword, (_) {
      gettagsearch(tagtype);
    }, time: Duration(milliseconds: 300));

    tagsearch.addListener(() {
      _searchword(tagsearch.text);
    });
    _tagScrollController.addListener(() {
      currentExtent.value = maxExtent - _tagScrollController.offset;
      if (currentExtent.value < 0) currentExtent.value = 0.0;
      if (currentExtent.value > maxExtent) currentExtent.value = maxExtent;
    });
  }

  TextEditingController tagsearch = TextEditingController();
  FocusNode tagsearchfocusNode = FocusNode();

  RxList<SelectedTagWidget> selectedtaglist = <SelectedTagWidget>[].obs;
  RxList<SearchTagWidget> searchtaglist = <SearchTagWidget>[].obs;
  RxList<SearchTagWidget> searchpagetag = <SearchTagWidget>[].obs;
  RxList<SelectedTagWidget> selectedpersontaglist = <SelectedTagWidget>[].obs;
}
