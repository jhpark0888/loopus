import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum SelectDateType { start, end }

class ProjectAddController extends GetxController {
  static ProjectAddController get to => Get.find();

  final TextEditingController projectnamecontroller = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  RxList<SelectedTagWidget> selectedpersontaglist = <SelectedTagWidget>[].obs;
  RefreshController compRefreshController = RefreshController();

  RxBool onTitleButton = false.obs;
  RxBool onRegisterButton = false.obs;
  RxBool isIntroTextEmpty = true.obs;
  RxBool isPublic = false.obs;

  RxList<Company> searchCompanyList = <Company>[].obs;
  List<Person> looplist = <Person>[].obs;
  RxList<CheckBoxPersonWidget> looppersonlist = <CheckBoxPersonWidget>[].obs;
  // RxBool isLooppersonLoading = true.obs;
  Rx<ScreenState> looppersonscreenstate = ScreenState.normal.obs;
  Rx<ScreenState> companySearchState = ScreenState.normal.obs;
  Rx<Company> selectCompany = Company.defaultCompany().obs;
  int companyPageNum = 0;

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

  void careerCompSearch() async {
    await search(SearchType.company, companyController.text, companyPageNum)
        .then((value) {
      if (value.isError == false) {
        List<Company> tempList = List.from(value.data)
            .map((company) => Company.fromJson(company))
            .toList();

        searchCompanyList.addAll(tempList);
        companyPageNum += 1;
        compRefreshController.loadComplete();
        companySearchState(ScreenState.success);
      } else {
        if (value.errorData!["statusCode"] == 204) {
          compRefreshController.loadNoData();
          companySearchState(ScreenState.success);
        } else {
          errorSituation(value, screenState: companySearchState);

          compRefreshController.loadComplete();
        }
      }
    });
  }

  void onLoading() {
    careerCompSearch();
  }

  void compSearchInit() {
    compRefreshController.loadComplete();
    companyController.text = "";
    onRegisterButton(false);
    searchCompanyList.clear();
    companySearchState(ScreenState.normal);
    companyPageNum = 1;
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
