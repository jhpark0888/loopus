import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityMakeController extends GetxController {
  static ActivityMakeController get to => Get.find();

  TextEditingController namecontroller = TextEditingController();
  TextEditingController introcontroller = TextEditingController();
}
