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
    startyearcontroller.addListener(() {
      if (startyearcontroller.text.length == 4) {
        startmonthFocusNode.requestFocus();
      }
    });
    startmonthcontroller.addListener(() {
      if (startmonthcontroller.text.length == 2) {
        startdayFocusNode.requestFocus();
      }
    });
    startdaycontroller.addListener(() {
      if (startdaycontroller.text.length == 2) {
        endyearFocusNode.requestFocus();
      }
    });
    endyearcontroller.addListener(() {
      if (endyearcontroller.text.length == 4) {
        endmonthFocusNode.requestFocus();
      }
    });
    endmonthcontroller.addListener(() {
      if (endmonthcontroller.text.length == 2) {
        enddayFocusNode.requestFocus();
      }
    });
  }

  final startmonthFocusNode = FocusNode();
  final startdayFocusNode = FocusNode();
  final endyearFocusNode = FocusNode();
  final endmonthFocusNode = FocusNode();
  final enddayFocusNode = FocusNode();

  TextEditingController projectnamecontroller = TextEditingController();
  TextEditingController introcontroller = TextEditingController();
  TextEditingController startyearcontroller = TextEditingController();
  TextEditingController startmonthcontroller = TextEditingController();
  TextEditingController startdaycontroller = TextEditingController();
  TextEditingController endyearcontroller = TextEditingController();
  TextEditingController endmonthcontroller = TextEditingController();
  TextEditingController enddaycontroller = TextEditingController();

  RxList<SelectedPersonTagWidget> selectedpersontaglist =
      <SelectedPersonTagWidget>[].obs;

  RxBool isongoing = false.obs;
  List<CheckBoxPersonWidget> looppersonlist = <CheckBoxPersonWidget>[].obs;
}
