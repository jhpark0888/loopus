import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/project_api.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/widget/project_posting_widget.dart';

class ProjectDetailController extends GetxController {
  ProjectDetailController(this.projectid);
  static ProjectDetailController get to => Get.find();
  RxBool isProjectLoading = false.obs;
  RxBool isProjectDeleteLoading = false.obs;
  RxBool isProjectUpdateLoading = false.obs;

  Rx<Project> project = Project(
          id: 0,
          userid: 0,
          projectName: '',
          post: [],
          projectTag: [],
          looper: [],
          like_count: 0)
      .obs;
  int projectid;
  RxList<ProjectPostingWidget> postinglist = <ProjectPostingWidget>[].obs;

  RxInt likesum(RxInt likecount, List<int> list) {
    likecount(0);
    for (var like in list) {
      likecount.value += like;
    }
    return likecount;
  }

  @override
  void onInit() {
    isProjectLoading(true);
    getproject(projectid).then((value) {
      project(value);
      postinglist(List.from(project.value.post
          .map((post) => ProjectPostingWidget(
                item: post,
                isuser: project.value.is_user ?? 0,
                realname: project.value.realname ?? '',
                department: project.value.department ?? '',
                profileimage: project.value.profileimage ?? '',
              ))
          .toList()
          .reversed));
      isProjectLoading.value = false;
    });
    super.onInit();
  }
}
