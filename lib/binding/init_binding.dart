import 'package:get/get.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(NotificationController());
    Get.create(() => ProjectDetailController());
  }
}
