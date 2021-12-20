import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  late TextEditingController campusnamecontroller;
  late TextEditingController classnumcontroller;
  late TextEditingController departmentcontroller;
  late TextEditingController emailidcontroller;
  late TextEditingController namecontroller;
  late TextEditingController passwordcontroller;
  late TextEditingController passwordcheckcontroller;
  bool emailcheck = false;

  static final FlutterSecureStorage storage = new FlutterSecureStorage();

  @override
  void onInit() {
    campusnamecontroller = TextEditingController();
    classnumcontroller = TextEditingController();
    departmentcontroller = TextEditingController();
    emailidcontroller = TextEditingController();
    namecontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    passwordcheckcontroller = TextEditingController();
    super.onInit();
  }
}
