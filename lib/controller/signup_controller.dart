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
  RxBool isPassWordCheck = false.obs;

  Timer? displaytimer;
  RxInt sec = 180.obs;

  static final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void onInit() {
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
    passwordcontroller.addListener(() {
      passwordCheck();
    });
    passwordcheckcontroller.addListener(() {
      passwordCheck();
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

  void passwordCheck() {
    String pwText = passwordcontroller.text;
    String pwCheckText = passwordcheckcontroller.text;
    if (pwText.trim().length > 6 && pwText == pwCheckText) {
      isPassWordCheck(true);
    } else {
      isPassWordCheck(false);
    }
  }

  void timerOn() async {
    displaytimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sec.value != 0) {
        sec.value -= 1;
      } else {
        timerClose();
      }
    });
    // validChecktimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
    //   if (sec.value != 0) {
    //     await emailvalidRequest().then((value) {
    //       if (value.isError == false) {
    //         print("성공");
    //         timerClose(dialogOn: false);
    //         _signupController.signupcertification(Emailcertification.success);
    //         Get.to(() => SignupPwScreen());
    //       } else {}
    //     });
    //   }
    // });
  }

  void timerClose({bool dialogOn = true}) {
    if (displaytimer != null) {
      if (displaytimer!.isActive) {
        displaytimer!.cancel();
      }
    }
    // if (validChecktimer != null) {
    //   if (validChecktimer!.isActive) {
    //     validChecktimer!.cancel();
    //   }
    // }
    if (dialogOn) {
      signupcertification(Emailcertification.fail);
      Get.closeCurrentSnackbar();
      showCustomDialog("인증이 취소되었습니다", 1000);
    }
  }
}
