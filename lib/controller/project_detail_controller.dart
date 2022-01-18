import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/widget/project_posting_widget.dart';

class ProjectDetailController extends GetxController {
  static ProjectDetailController get to => Get.find();
  RxBool isProjectLoading = false.obs;
  Rx<Project> project = Project(
      id: 0,
      userid: 0,
      projectName: '',
      post: [],
      projectTag: [],
      looper: []).obs;

  RxList<ProjectPostingWidget> postinglist = <ProjectPostingWidget>[].obs;

  @override
  void onInit() {
    super.onInit();
  }
}
