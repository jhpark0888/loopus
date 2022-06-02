import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/editorcontroller.dart';

class PostingAddController extends GetxController {
  static PostingAddController get to => Get.find();
  PostingAddController({required this.route});

  TextEditingController textcontroller = TextEditingController();
  RxBool isPostingUploading = false.obs;
  RxList<File> images = <File>[].obs;

  RxBool isPostingTitleEmpty = false.obs;
  RxBool isPostingContentEmpty = true.obs;
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
