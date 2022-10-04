import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/univ_model.dart';
import 'package:loopus/utils/certificate_timer.dart';
import 'package:loopus/utils/error_control.dart';

enum UserType {
  student,
  company,
  school,
}

class SignupController extends GetxController {
  static SignupController get to => Get.find();
  SignupController({this.isReCertification = false});

  TextEditingController univcontroller = TextEditingController();
  TextEditingController admissioncontroller = TextEditingController();
  TextEditingController departmentcontroller = TextEditingController();
  TextEditingController emailidcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController passwordcheckcontroller = TextEditingController();

  Rx<Emailcertification> signupcertification = Emailcertification.normal.obs;
  Rx<ScreenState> searchscreenstate = ScreenState.normal.obs;
  // Rx<ScreenState> tagscreenstate = ScreenState.success.obs;

  Rx<UserType> selectedType = UserType.student.obs;

  Rx<Dept> selectDept = Dept.defalut().obs;
  Rx<Univ> selectUniv = Univ.defalut().obs;

  RxList<Univ> searchUnivList = <Univ>[].obs;
  RxList<Dept> searchDeptList = <Dept>[].obs;

  RxBool isUserInfoFill = false.obs;
  RxBool isEmailPassWordCheck = true.obs;
  final bool isReCertification;

  late CertificateTimer timer;

  static final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void onInit() {
    timer = CertificateTimer(emailcertification: signupcertification);

    namecontroller.addListener(() {
      userInfoFillCheck();
    });
    univcontroller.addListener(() {
      userInfoFillCheck();
    });
    departmentcontroller.addListener(() {
      userInfoFillCheck();
    });
    admissioncontroller.addListener(() {
      userInfoFillCheck();
    });
    emailidcontroller.addListener(() {
      if (isReCertification == false) {
        emailpasswordCheck();
      } else {
        emailCheck();
      }
    });
    passwordcontroller.addListener(() {
      emailpasswordCheck();
    });
    passwordcheckcontroller.addListener(() {
      emailpasswordCheck();
    });

    super.onInit();
  }

  @override
  void onClose() {
    univcontroller.clear();
    admissioncontroller.clear();
    departmentcontroller.clear();
    emailidcontroller.clear();
    namecontroller.clear();
    passwordcontroller.clear();
    passwordcheckcontroller.clear();
    super.onClose();
  }

  void searchUnivLoad(String text) async {
    searchscreenstate(ScreenState.loading);
    await searchUniv(text).then((value) {
      if (value.isError == false) {
        searchUnivList(
            List.from(value.data).map((univ) => Univ.fromJson(univ)).toList());
        searchscreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: searchscreenstate);
      }
    });
  }

  void searchDeptLoad(String text) async {
    searchscreenstate(ScreenState.loading);
    await searchDept(selectUniv.value.id, text).then((value) {
      if (value.isError == false) {
        searchDeptList(
            List.from(value.data).map((dept) => Dept.fromJson(dept)).toList());
        searchscreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: searchscreenstate);
      }
    });
  }

  void deptInit() {
    selectDept(Dept.defalut());
    searchDeptList.clear();
    departmentcontroller.clear();
  }

  void userInfoFillCheck() {
    if (namecontroller.text.isNotEmpty &&
        univcontroller.text.isNotEmpty &&
        departmentcontroller.text.isNotEmpty &&
        admissioncontroller.text.isNotEmpty) {
      isUserInfoFill(true);
    } else {
      isUserInfoFill(false);
    }
  }

  void emailpasswordCheck() {
    String pwText = passwordcontroller.text;
    String pwCheckText = passwordcheckcontroller.text;
    if (pwText.trim().length > 6 &&
        pwText == pwCheckText &&
        emailidcontroller.text.trim() != "") {
      isEmailPassWordCheck(true);
    } else {
      isEmailPassWordCheck(false);
    }
  }

  void emailCheck() {
    if (emailidcontroller.text.trim() != "") {
      isEmailPassWordCheck(true);
    } else {
      isEmailPassWordCheck(false);
    }
  }
}
