import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loopus/controller/profile_controller.dart';

class LocalDataController extends GetxController {
  static LocalDataController get to => Get.find();
  static final ProfileController _profileController = Get.find();
  final firstProject = GetStorage();

  //todo : key값에 userid 값 넣어서 개인화 시켜야함
  bool get isAddFirstProject =>
      firstProject.read('firstProject' +
          _profileController.myUserInfo.value.userid.toString()) ??
      true;

  void firstProjectAdd() => firstProject.write(
      'firstProject' + _profileController.myUserInfo.value.userid.toString(),
      false);
}
