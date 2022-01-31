import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

enum UserType {
  student,
  company,
  professer,
}

class SignupController extends GetxController {
  TextEditingController campusnamecontroller = TextEditingController();
  TextEditingController classnumcontroller = TextEditingController();
  TextEditingController departmentcontroller = TextEditingController();
  TextEditingController emailidcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController passwordcheckcontroller = TextEditingController();
  RxBool emailcheck = false.obs;
  Rx<UserType> selectedType = UserType.student.obs;

  static final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void onInit() {
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
