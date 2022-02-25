import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/widget/project_widget.dart';

class SelectProjectController extends GetxController {
  // SelectProjectController(this.projectid);
  static SelectProjectController get to => Get.find();
  RxBool isSelectProjectLoading = false.obs;

  List<Project> projectlist = <Project>[].obs;

  RxList<Project> selectprojectlist = <Project>[].obs;

  void loadProjectList() async {
    // isSelectProjectLoading(true);
    selectprojectlist(ProfileController.to.myProjectList);

    // String? userId = await const FlutterSecureStorage().read(key: "id");
    // getProjectlist(userId).then((value) {
    //   projectlist = value;
    //   selectprojectlist(projectlist
    //       .map((project) => ProjectWidget(
    //             project: project.obs,
    //             type: ProjectWidgetType.addposting,
    //           ))
    //       .toList());
    //   isSelectProjectLoading.value = false;
    // });
  }

  @override
  void onInit() {
    loadProjectList();
    super.onInit();
  }
}
