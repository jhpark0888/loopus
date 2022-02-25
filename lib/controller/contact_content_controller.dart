import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/utils/user_device_info.dart';

class ContactContentController extends GetxController {
  static ContactContentController get to => Get.find();
  final UserDeviceInfo userDeviceInfo = Get.put(UserDeviceInfo());

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController contentcontroller = TextEditingController();
  RxBool iscontactcontentloading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }
}
