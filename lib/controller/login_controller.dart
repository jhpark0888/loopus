import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LogInController extends GetxController {
  RxBool isLoading = false.obs;
  late TextEditingController idcontroller;
  late TextEditingController passwordcontroller;
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void onInit() {
    idcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    super.onInit();
  }
}
