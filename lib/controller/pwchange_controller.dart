import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/widget/message_widget.dart';

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
