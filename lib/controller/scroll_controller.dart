import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/home_controller.dart';

class CustomScrollController extends GetxController {
  static CustomScrollController get to => Get.put(CustomScrollController());
  final Rx<ScrollController> customScrollController = ScrollController().obs;

  RxBool _showBackToTopButton = false.obs;

  @override
  void onInit() {
    customScrollController.value = ScrollController()
      ..addListener(() {
        if (customScrollController.value.offset >= Get.height) {
          _showBackToTopButton.value = true; // show the back-to-top button
        } else {
          _showBackToTopButton.value = false; // hide the back-to-top button
        }
      });
    super.onInit();
  }

  @override
  void onClose() {
    customScrollController.close();
    super.onClose();
  }

  void scrollToTop() {
    print(customScrollController.value.offset);
    customScrollController.value.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
