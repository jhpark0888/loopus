import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class PwChangeController extends GetxController {
  static PwChangeController get to => Get.find();
  Rx<Emailcertification> pwcertification = Emailcertification.fail.obs;

  TextEditingController originpwcontroller = TextEditingController();
  TextEditingController newpwcontroller = TextEditingController();
  TextEditingController newpwcheckcontroller = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }
}
