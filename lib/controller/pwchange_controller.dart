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

  late CertificateTimer timer;

  @override
  void onInit() {
    timer = CertificateTimer(emailcertification: pwcertification);
    super.onInit();
  }
}
