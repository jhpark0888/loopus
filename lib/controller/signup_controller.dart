import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/univ_model.dart';
import 'package:loopus/utils/certificate_timer.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/error_control.dart';

class SignupController extends GetxController {
  static SignupController get to => Get.find();
  SignupController({this.isReCertification = false, this.reCertPw});

  //학생
  TextEditingController univcontroller = TextEditingController();
  TextEditingController admissioncontroller = TextEditingController();
  TextEditingController departmentcontroller = TextEditingController();
  TextEditingController emailidcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController passwordcheckcontroller = TextEditingController();
  TextEditingController certfyNumController = TextEditingController();

  Rx<Emailcertification> signupcertification = Emailcertification.normal.obs;
  Rx<ScreenState> searchscreenstate = ScreenState.normal.obs;
  // Rx<ScreenState> tagscreenstate = ScreenState.success.obs;

  String? reCertPw;

  Rx<UserType> selectedType = UserType.student.obs;

  Rx<Dept> selectDept = Dept.defalut().obs;
  Rx<Univ> selectUniv = Univ.defalut().obs;

  RxList<Univ> searchUnivList = <Univ>[].obs;
  RxList<Dept> searchDeptList = <Dept>[].obs;

  RxBool isUserInfoCheck = false.obs;
  RxBool isEmailPassWordCheck = true.obs;
  RxBool isCertftNumCheck = false.obs;
  final bool isReCertification;

  late CertificateTimer timer;

  //기업
  TextEditingController compNameController = TextEditingController();
  TextEditingController compEmailController = TextEditingController();

  RxBool isCompInfoCheck = false.obs;

  @override
  void onInit() {
    timer = CertificateTimer(emailcertification: signupcertification);

    namecontroller.addListener(() {
      _userInfoFillCheck();
    });
    univcontroller.addListener(() {
      _userInfoFillCheck();
    });
    departmentcontroller.addListener(() {
      _userInfoFillCheck();
    });
    admissioncontroller.addListener(() {
      _userInfoFillCheck();
    });
    emailidcontroller.addListener(() {
      if (isReCertification == false) {
        _emailpasswordCheck();
      } else {
        _emailCheck();
      }
    });
    passwordcontroller.addListener(() {
      _emailpasswordCheck();
    });
    passwordcheckcontroller.addListener(() {
      _emailpasswordCheck();
    });

    certfyNumController.addListener(() {
      if (certfyNumController.text.length == 6 && timer.sec.value != 0) {
        isCertftNumCheck(true);
      } else {
        isCertftNumCheck(false);
      }
    });

    ever(timer.sec, (_) {
      if (timer.sec.value == 0) {
        isCertftNumCheck(false);
      }
    });

    //기업 addListener
    compNameController.addListener(() {
      _compInfoFillCheck();
    });

    compEmailController.addListener(() {
      _compInfoFillCheck();
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
    timer.timerClose();
    super.onClose();
  }

  String getEmail() {
    return emailidcontroller.text + "@" + selectUniv.value.email;
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

  void _userInfoFillCheck() {
    if (namecontroller.text.isNotEmpty &&
        univcontroller.text.isNotEmpty &&
        departmentcontroller.text.isNotEmpty &&
        admissioncontroller.text.isNotEmpty) {
      isUserInfoCheck(true);
    } else {
      isUserInfoCheck(false);
    }
  }

  void _emailpasswordCheck() {
    String pwText = passwordcontroller.text;
    String pwCheckText = passwordcheckcontroller.text;
    if (pwText.trim().length >= 6 &&
        pwCheckText.trim().length >= 6 &&
        emailidcontroller.text.trim() != "") {
      isEmailPassWordCheck(true);
    } else {
      isEmailPassWordCheck(false);
    }
  }

  void _emailCheck() {
    if (emailidcontroller.text.trim() != "") {
      isEmailPassWordCheck(true);
    } else {
      isEmailPassWordCheck(false);
    }
  }

  void _compInfoFillCheck() {
    if (compNameController.text.trim() != "" &&
        CheckValidate.validateEmailBool(compEmailController.text)) {
      isCompInfoCheck(true);
    } else {
      isCompInfoCheck(false);
    }
  }
}
