import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';

enum UserType {
  student,
  company,
  professer,
}

class SignupController extends GetxController {
  static SignupController get to => Get.find();
  TextEditingController campusnamecontroller = TextEditingController();
  TextEditingController classnumcontroller = TextEditingController();
  TextEditingController departmentcontroller = TextEditingController();
  TextEditingController emailidcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController passwordcheckcontroller = TextEditingController();

  Rx<Emailcertification> signupcertification = Emailcertification.fail.obs;
  // RxBool isdeptSearchLoading = false.obs;
  Rx<ScreenState> deptscreenstate = ScreenState.loading.obs;
  Rx<ScreenState> tagscreenstate = ScreenState.success.obs;
  RxString selectdept = "".obs;

  Rx<UserType> selectedType = UserType.student.obs;

  RxList deptlist = [].obs;
  RxList searchdeptlist = [].obs;
  Timer? timer;
  RxInt sec = 180.obs;

  static final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void onInit() {
    departmentcontroller.addListener(() {
      searchdeptlist.clear();
      deptscreenstate(ScreenState.loading);
      for (String dept in deptlist) {
        if (dept.contains(departmentcontroller.text)) {
          searchdeptlist.add(dept.toString());
        }
      }
      deptscreenstate(ScreenState.success);
    });
    super.onInit();
  }

  @override
  void onClose() {
    campusnamecontroller.clear();
    classnumcontroller.clear();
    departmentcontroller.clear();
    emailidcontroller.clear();
    namecontroller.clear();
    passwordcontroller.clear();
    passwordcheckcontroller.clear();
    super.onClose();
  }
}
