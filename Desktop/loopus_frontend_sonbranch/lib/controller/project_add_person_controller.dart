import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class ProjectAddPersonController extends GetxController {
  static ProjectAddPersonController get to => Get.find();
  ProjectMakeController projectMakeController = Get.find();

  void onInit() {
    // looppersonlist.add(
    //   CheckBoxPersonWidget(
    //     name: '박지환',
    //     department: '산업경영공학과',
    //     id: 1,
    //   ),
    // );
    // looppersonlist.add(
    //   CheckBoxPersonWidget(
    //     name: '손승태',
    //     department: '산업경영공학과',
    //     id: 2,
    //   ),
    // );
    super.onInit();
  }

  List<CheckBoxPersonWidget> looppersonlist = <CheckBoxPersonWidget>[].obs;
}
