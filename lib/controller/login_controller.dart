import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/utils/check_form_validate.dart';

class LogInController extends GetxController {
  RxBool isLogout = false.obs;

  late TextEditingController idcontroller;
  late TextEditingController passwordcontroller;
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  RxBool loginButtonOn = false.obs;

  RxBool pwFindButtonOn = false.obs;

  // Rx<UserType> loginType = UserType.student.obs;

  @override
  void onInit() {
    idcontroller = TextEditingController();
    passwordcontroller = TextEditingController();

    idcontroller.addListener(() {
      loginbuttonCheck();
      pwFindButtonCheck();
    });
    passwordcontroller.addListener(() {
      loginbuttonCheck();
    });

    super.onInit();
  }

  void loginbuttonCheck() {
    if (idcontroller.text.trim().isNotEmpty &&
        passwordcontroller.text.trim().isNotEmpty) {
      loginButtonOn(true);
    } else {
      loginButtonOn(false);
    }
  }

  void pwFindButtonCheck() {
    if (CheckValidate.validateEmailBool(idcontroller.text)) {
      pwFindButtonOn(true);
    } else {
      pwFindButtonOn(false);
    }
  }
}
