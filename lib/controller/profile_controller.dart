import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/home_posting_widget.dart';
import 'package:loopus/widget/project_widget.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  List<String> dropdown_qanda = ["내가 답변한 질문", "내가 한 질문"];
  var selectqanda = 0.obs;

  RxList<ProjectWidget> projectlist = <ProjectWidget>[].obs;
  Rx<User> user = User(
          user: 0,
          type: 0,
          realName: '',
          profileTag: [],
          department: '',
          isuser: -1)
      .obs;
  Rx<File> profileimage = File('').obs;

  @override
  void onInit() async {
    super.onInit();
  }
}
