import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/widget/scrap_widget.dart';

class PostingAddController extends GetxController {
  static PostingAddController get to => Get.find();
  PostingAddController({required this.route});
  ScrollController scrollController = ScrollController();
  TextEditingController textcontroller = TextEditingController();
  TextEditingController tagcontroller = TextEditingController();
  TextEditingController linkcontroller = TextEditingController();
  RxBool isPostingUploading = false.obs;
  RxList<File> images = <File>[].obs;
  RxList<ScrapWidget> scrapList = <ScrapWidget>[].obs;
  RxInt lines = 0.obs;
  RxBool isPostingTitleEmpty = false.obs;
  RxBool isPostingContentEmpty = true.obs;
  RxBool isTagClick = false.obs;
  RxBool keyControllerAtive = false.obs;
  PostaddRoute route;

  void onInit() {
    textcontroller.addListener(() {
      if (textcontroller.text.trim().isEmpty) {
        isPostingTitleEmpty.value = true;
      } else {
        isPostingTitleEmpty.value = false;
      }
    });

    super.onInit();
  }
}
