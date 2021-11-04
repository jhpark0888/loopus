import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/widget/home_posting_widget.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  List<HomePostingWidget> group = [];

  @override
  void onInit() {
    for (int i = 0; i < 4; i++) {
      group.add(HomePostingWidget());
    }
    super.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
