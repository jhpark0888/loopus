import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/getprofile_api.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/home_posting_widget.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  List<String> dropdown_qanda = ["내가 답변한 질문", "내가 한 질문"];
  var selectqanda = 0.obs;

  Rx<User> user = User(user: 0, type: 0, realName: '', classNum: '').obs;

  @override
  void onInit() {
    ProfileApi.to.getProfile();
    super.onInit();
  }
}
