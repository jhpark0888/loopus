import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
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
          like_count: 0.obs,
          is_user: 0,
          user: User(
              userid: 0,
              realName: "",
              type: 0,
              department: "",
              loopcount: 0.obs,
              totalposting: 0,
              isuser: 0,
              profileTag: [],
              looped: FollowState.normal.obs))
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

  void loadProject() {
    isProjectLoading(true);
    getproject(projectid).then((value) {
      project(value);
      postinglist(List.from(project.value.post
          .map((post) => ProjectPostingWidget(
                item: post,
                isuser: project.value.is_user,
                realname: project.value.user!.realName,
                department: project.value.user!.department,
                profileimage: project.value.user!.profileImage ?? '',
              ))
          .toList()
          .reversed));
      isProjectLoading.value = false;
    });
  }

  @override
  void onInit() {
    super.onInit();
  }
}
