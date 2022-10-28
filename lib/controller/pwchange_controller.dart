import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/utils/certificate_timer.dart';

class PwChangeController extends GetxController {
  static PwChangeController get to => Get.find();
  Rx<Emailcertification> pwcertification = Emailcertification.normal.obs;

  TextEditingController originpwcontroller = TextEditingController();
  TextEditingController newpwcontroller = TextEditingController();
  TextEditingController newpwcheckcontroller = TextEditingController();
  TextEditingController certfyNumController = TextEditingController();

  RxBool pwChangeButtonOn = false.obs;
  RxBool isCertftNumCheck = false.obs;

  late CertificateTimer timer;

  @override
  void onInit() {
    timer = CertificateTimer(emailcertification: pwcertification);

    newpwcontroller.addListener(() {
      pwChangeButtonCheck();
    });
    newpwcheckcontroller.addListener(() {
      pwChangeButtonCheck();
    });

    certfyNumController.addListener(() {
      if (certfyNumController.text.length == 6 && timer.sec.value != 0) {
        isCertftNumCheck(true);
      } else {
        isCertftNumCheck(false);
      }
    });
    super.onInit();
  }

  void pwChangeButtonCheck() {
    if (newpwcontroller.text.trim().length >= 6 &&
        newpwcheckcontroller.text.trim().length >= 6) {
      pwChangeButtonOn(true);
    } else {
      pwChangeButtonOn(false);
    }
  }
}
