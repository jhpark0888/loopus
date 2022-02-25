import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/editorcontroller.dart';

class PostingAddController extends GetxController {
  static PostingAddController get to => Get.find();
  PostingAddController({required this.route});

  EditorController editorController = Get.put(EditorController());
  TextEditingController titlecontroller = TextEditingController();
  RxBool isPostingUploading = false.obs;
  List<File> images = [];

  Rx<File> thumbnail = File("").obs;
  RxString postingurlthumbnail = "".obs;

  RxBool isPostingTitleEmpty = false.obs;
  RxBool isPostingContentEmpty = true.obs;
  PostaddRoute route;

  void onInit() {
    titlecontroller.addListener(() {
      if (titlecontroller.text.trim().isEmpty) {
        isPostingTitleEmpty.value = true;
      } else {
        isPostingTitleEmpty.value = false;
      }
    });

    super.onInit();
  }
}
