import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/widget/posting_widget.dart';

class HoverController extends GetxController with GetTickerProviderStateMixin {
  static HoverController get to => Get.find();
  RxDouble scale = 1.0.obs;
  RxBool isHover = false.obs;

  void isHoverState() {
    scale.value = 0.95;
  }

  void isNonHoverState() {
    scale.value = 1.0;
  }
}
