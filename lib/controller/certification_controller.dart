import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/utils/check_form_validate.dart';

class CertificationController extends GetxController {
  late TextEditingController idcontroller = TextEditingController();
  late TextEditingController passwordcontroller = TextEditingController();
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  RxBool nextButtonOn = false.obs;

  @override
  void onInit() {
    idcontroller.addListener(() {
      nextbuttonCheck();
    });
    passwordcontroller.addListener(() {
      nextbuttonCheck();
    });

    super.onInit();
  }

  void nextbuttonCheck() {
    if (idcontroller.text.trim().isNotEmpty &&
        passwordcontroller.text.trim().isNotEmpty) {
      nextButtonOn(true);
    } else {
      nextButtonOn(false);
    }
  }
}
