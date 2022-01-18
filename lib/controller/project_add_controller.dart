import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/searchedtag_widget.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:http/http.dart' as http;

class ProjectAddController extends GetxController {
  static ProjectAddController get to => Get.find();

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

  Rx<GlobalKey<FormState>> formKeystart = GlobalKey<FormState>().obs;
  RxBool isvaildstartdate = false.obs;

  Rx<GlobalKey<FormState>> formKeyend = GlobalKey<FormState>().obs;
  RxBool isvaildenddate = false.obs;

  RxBool isongoing = false.obs;
  RxBool ontitlebutton = false.obs;

  List<User> looplist = <User>[].obs;
  RxList<CheckBoxPersonWidget> looppersonlist = <CheckBoxPersonWidget>[].obs;
  RxBool isLooppersonLoading = true.obs;

  RxBool isProjectUploading = false.obs;

  Rx<File?> projectthumbnail = File('').obs;
  String? projecturlthumbnail;

  @override
  void onInit() {
    super.onInit();
    periodaddListener(startyearcontroller, startmonthFocusNode, 4);
    periodaddListener(startmonthcontroller, startdayFocusNode, 2);
    periodaddListener(startdaycontroller, endyearFocusNode, 2);
    periodaddListener(endyearcontroller, endmonthFocusNode, 4);
    periodaddListener(endmonthcontroller, enddayFocusNode, 2);
    periodaddListener(enddaycontroller, null, 2);

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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    projectnamecontroller.dispose();
    introcontroller.dispose();
    startyearcontroller.dispose();
    startmonthcontroller.dispose();
    startdaycontroller.dispose();
    endyearcontroller.dispose();
    endmonthcontroller.dispose();
    enddaycontroller.dispose();
  }

  periodaddListener(TextEditingController controller, FocusNode? nextfocusnode,
      int textlength) {
    controller.addListener(() {
      if (controller.text.length == textlength && nextfocusnode != null) {
        nextfocusnode.requestFocus();
      }
    });
  }

  String? validateDate(String value, int maxlenght) {
    if (value.isEmpty) {
      return '';
    } else {
      Pattern pattern = r'[\-\_\/\\\[\]\(\)\|\{\}*$@$!%*#?~^<>,.&+=]';
      RegExp regExp = new RegExp(pattern.toString());
      if (regExp.hasMatch(value) || value.length != maxlenght) {
        return '';
      } else {
        // formKey.currentState!.validate()
        //     ? ondatebutton(true)
        //     : ondatebutton(false);
        return null;
      }
    }
  }
}
