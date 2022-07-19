import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/univ_model.dart';
import 'package:loopus/utils/error_control.dart';

enum UserType {
  student,
  company,
  professer,
}

class SignupController extends GetxController {
  static SignupController get to => Get.find();
  TextEditingController campusnamecontroller = TextEditingController();
  TextEditingController classnumcontroller = TextEditingController();
  TextEditingController departmentcontroller = TextEditingController();
  TextEditingController emailidcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController passwordcheckcontroller = TextEditingController();

  Rx<Emailcertification> signupcertification = Emailcertification.fail.obs;
  // RxBool isdeptSearchLoading = false.obs;
  Rx<ScreenState> univscreenstate = ScreenState.normal.obs;
  Rx<ScreenState> deptscreenstate = ScreenState.normal.obs;
  Rx<ScreenState> tagscreenstate = ScreenState.success.obs;

  Rx<UserType> selectedType = UserType.student.obs;

  Rx<Dept> selectDept = Dept.defalut().obs;
  Rx<Univ> selectUniv = Univ.defalut().obs;

  RxList<Univ> searchUnivList = <Univ>[].obs;
  RxList<Dept> searchDeptList = <Dept>[].obs;
  Timer? timer;
  RxInt sec = 180.obs;

  static final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    campusnamecontroller.clear();
    classnumcontroller.clear();
    departmentcontroller.clear();
    emailidcontroller.clear();
    namecontroller.clear();
    passwordcontroller.clear();
    passwordcheckcontroller.clear();
    super.onClose();
  }

  void searchUnivLoad(String text) async {
    univscreenstate(ScreenState.loading);
    await searchUniv(text).then((value) {
      if (value.isError == false) {
        searchUnivList(
            List.from(value.data).map((univ) => Univ.fromJson(univ)).toList());
        univscreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: univscreenstate);
      }
    });
  }

  void searchDeptLoad(String text) async {
    deptscreenstate(ScreenState.loading);
    await searchDept(selectUniv.value.id, text).then((value) {
      if (value.isError == false) {
        searchDeptList(
            List.from(value.data).map((dept) => Dept.fromJson(dept)).toList());
        deptscreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: deptscreenstate);
      }
    });
  }

  void deptInit() {
    selectDept(Dept.defalut());
    searchDeptList.clear();
    departmentcontroller.clear();
  }
}
