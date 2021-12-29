import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class HeaderController extends GetxController {
  ScrollController mainScrollController = ScrollController();
  ScrollController subScrollController = ScrollController();

  RxDouble removableWidgetSize = 200.0.obs;
  RxBool isStickyOnTop = false.obs;

  @override
  void onInit() {
    mainScrollController.addListener(() {
      if (mainScrollController.offset >= removableWidgetSize.value &&
          !isStickyOnTop.value) {
        isStickyOnTop.value = true;
      } else if (mainScrollController.offset < removableWidgetSize.value &&
          isStickyOnTop.value) {
        isStickyOnTop.value = false;
      }
    });
    super.onInit();
  }
}
