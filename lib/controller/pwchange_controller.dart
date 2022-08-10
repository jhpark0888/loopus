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

  RxBool pwChangeButtonOn = false.obs;

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
    super.onInit();
  }

  void pwChangeButtonCheck() {
    if (newpwcontroller.text.trim().length >= 6 &&
        newpwcontroller.text.trim() == newpwcheckcontroller.text.trim()) {
      pwChangeButtonOn(true);
    } else {
      pwChangeButtonOn(false);
    }
  }
}
