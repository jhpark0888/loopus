import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/widget/home_posting_widget.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  List<String> dropdown_qanda = ["내가 답변한 질문", "내가 한 질문"];
  var selectqanda = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }
}
