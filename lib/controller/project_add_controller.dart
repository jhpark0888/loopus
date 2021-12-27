import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:http/http.dart' as http;

class ProjectAddController extends GetxController {
  static ProjectAddController get to => Get.find();

  void onInit() {
    super.onInit();
    periodNextFocus(startyearcontroller, startmonthFocusNode, 4);
    periodNextFocus(startmonthcontroller, startdayFocusNode, 2);
    periodNextFocus(startdaycontroller, endyearFocusNode, 2);
    periodNextFocus(endyearcontroller, endmonthFocusNode, 4);
    periodNextFocus(endmonthcontroller, enddayFocusNode, 2);

    projectnamecontroller.addListener(() {
      if (projectnamecontroller.text.isEmpty) {
        ontitlebutton(false);
      } else {
        Pattern pattern = r'[\-\_\/\\\[\]\(\)\|\{\}*$@$!%*#?~^<>,.&+=]';
        RegExp regExp = new RegExp(pattern.toString());
        if (regExp.hasMatch(projectnamecontroller.text)) {
          ontitlebutton(false);
        } else {
          ontitlebutton(true);
        }
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
  RxBool ontitlebutton = false.obs;
  RxBool ondatebutton = false.obs;
  List<CheckBoxPersonWidget> looppersonlist = <CheckBoxPersonWidget>[].obs;
}

periodNextFocus(
    TextEditingController controller, FocusNode nextfocusnode, int textlength) {
  controller.addListener(() {
    if (controller.text.length == textlength) {
      nextfocusnode.requestFocus();
    }
  });
}
