import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/share_intent_controller.dart';
import 'package:loopus/model/project_model.dart';

class SelectProjectController extends GetxController {
  // SelectProjectController(this.projectid);
  static SelectProjectController get to => Get.find();
  RxBool isSelectProjectLoading = false.obs;

  RxList<Project> selectprojectlist = <Project>[].obs;

  void loadProjectList() async {
    // isSelectProjectLoading(true);
    // selectprojectlist(HomeController.to.);

    String? userId = HomeController.to.myId;
    getProjectlist(int.parse(userId!)).then((value) {
      List<Project> projectlist = List.from(value.data)
          .map((project) => Project.fromJson(project))
          .toList();
      selectprojectlist(projectlist);
      isSelectProjectLoading.value = false;
    });
  }

  @override
  void onInit() {
    loadProjectList();
    super.onInit();
  }

  @override
  void onClose() {
    if (Get.isRegistered<ShareIntentController>()) {
      Get.delete<ShareIntentController>();
    }
    // TODO: implement onClose
    super.onClose();
  }
}
