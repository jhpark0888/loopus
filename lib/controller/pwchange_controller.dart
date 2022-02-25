import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PwChangeController extends GetxController {
  static PwChangeController get to => Get.find();
  RxBool isPwFindCheck = false.obs;

  TextEditingController originpwcontroller = TextEditingController();
  TextEditingController newpwcontroller = TextEditingController();
  TextEditingController newpwcheckcontroller = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }
}
