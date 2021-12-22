import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LogInController extends GetxController {
  late TextEditingController idcontroller;
  late TextEditingController passwordcontroller;
  static final FlutterSecureStorage storage = new FlutterSecureStorage();

  @override
  void onInit() {
    idcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    super.onInit();
  }
}
