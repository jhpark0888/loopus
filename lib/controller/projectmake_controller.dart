import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:http/http.dart' as http;

class ProjectMakeController extends GetxController {
  static ProjectMakeController get to => Get.find();

  void onInit() {
    super.onInit();
  }

  TextEditingController projectnamecontroller = TextEditingController();
  TextEditingController introcontroller = TextEditingController();
  TextEditingController startyearcontroller = TextEditingController();
  TextEditingController startmonthcontroller = TextEditingController();
  TextEditingController finishyearcontroller = TextEditingController();
  TextEditingController finishmonthcontroller = TextEditingController();

  RxList<SelectedPersonTagWidget> selectedpersontaglist =
      <SelectedPersonTagWidget>[].obs;

  RxBool isongoing = false.obs;
  // List<CheckBoxPersonWidget> looppersonlist = <CheckBoxPersonWidget>[].obs;

}
