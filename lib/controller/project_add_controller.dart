import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:http/http.dart' as http;

enum SelectDateType { start, end }

class ProjectAddController extends GetxController {
  static ProjectAddController get to => Get.find();

  final TextEditingController projectnamecontroller = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  RxList<SelectedTagWidget> selectedpersontaglist = <SelectedTagWidget>[].obs;

  RxBool onTitleButton = false.obs;
  RxBool onRegisterButton = false.obs;
  RxBool isIntroTextEmpty = true.obs;
  RxBool isPublic = false.obs;

  List<Company> searchCompanyList = <Company>[].obs;
  List<Person> looplist = <Person>[].obs;
  RxList<CheckBoxPersonWidget> looppersonlist = <CheckBoxPersonWidget>[].obs;
  // RxBool isLooppersonLoading = true.obs;
  Rx<ScreenState> looppersonscreenstate = ScreenState.normal.obs;
  Rx<ScreenState> companySearchState = ScreenState.normal.obs;
  Rx<Company> selectCompany = Company.defaultCompany().obs;

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
      onTitleButton(
          CheckValidate.validateSpecificWords(projectnamecontroller.text));
    });

    companyController.addListener(() {
      onRegisterButton(
          CheckValidate.validateSpecificWords(companyController.text));
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    projectnamecontroller.dispose();
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
