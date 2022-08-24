import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';

class ShareIntentController extends GetxController {
  // SelectProjectController(this.projectid);
  static ShareIntentController get to => Get.find();

  String shareText = "";
}
