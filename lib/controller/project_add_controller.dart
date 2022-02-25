import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:http/http.dart' as http;

enum SelectDateType { start, end }

class ProjectAddController extends GetxController {
  static ProjectAddController get to => Get.find();

  final TextEditingController projectnamecontroller = TextEditingController();
  final TextEditingController introcontroller = TextEditingController();

  RxList<SelectedTagWidget> selectedpersontaglist = <SelectedTagWidget>[].obs;

  RxBool ontitlebutton = false.obs;
  RxBool isIntroTextEmpty = true.obs;

  List<User> looplist = <User>[].obs;
  RxList<CheckBoxPersonWidget> looppersonlist = <CheckBoxPersonWidget>[].obs;
  // RxBool isLooppersonLoading = true.obs;
  Rx<ScreenState> looppersonscreenstate = ScreenState.loading.obs;

  RxBool isProjectUploading = false.obs;

  Rx<File?> projectthumbnail = File('').obs;
  String? projecturlthumbnail;

  //새로운 datepicker
  RxBool isEndedProject = true.obs;
  RxBool isDateValidated = false.obs;
  RxBool startDateIsBiggerThanEndDate = false.obs;
  RxBool isDateChange = false.obs;
  RxString selectedStartDateTime = ''.obs;
  RxString selectedEndDateTime = ''.obs;

  @override
  void onInit() {
    super.onInit();

    projectnamecontroller.addListener(() {
      if (projectnamecontroller.text.trim().isEmpty) {
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
    introcontroller.addListener(() {
      if (introcontroller.text.trim().isNotEmpty) {
        isIntroTextEmpty(false);
      } else {
        isIntroTextEmpty(true);
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
  }

  //새로운 datepicker
  void changeEndState() {
    isEndedProject.value = !isEndedProject.value;

    if (isEndedProject.value == false) {
      startDateIsBiggerThanEndDate.value = false;

      validateDate();
    } else {
      validateDate();
    }
  }

  void validateDate() {
    if (isEndedProject.value == true) {
      if (selectedStartDateTime.value != '' &&
          selectedEndDateTime.value != '') {
        if (DateTime.parse(selectedEndDateTime.value)
                .difference(DateTime.parse(selectedStartDateTime.value))
                .inDays >=
            0) {
          startDateIsBiggerThanEndDate.value = false;
          isDateValidated.value = true;
        } else {
          isDateValidated.value = false;
          startDateIsBiggerThanEndDate.value = true;
        }
      } else {
        isDateValidated.value = false;
      }
    } else {
      if (selectedStartDateTime.value != '') {
        isDateValidated.value = true;
      } else {
        isDateValidated.value = false;
      }
    }
  }
}
