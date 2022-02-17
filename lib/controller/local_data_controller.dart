import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/profile_controller.dart';

class LocalDataController extends GetxController {
  static LocalDataController get to => Get.find();
  static final ProfileController _profileController = Get.find();

  final firstProject = GetStorage();
  final changeMyTag = GetStorage();

  bool get isAddFirstProject =>
      firstProject.read('firstProject' +
          _profileController.myUserInfo.value.userid.toString()) ??
      true;

  void firstProjectAdd() => firstProject.write(
      'firstProject' + _profileController.myUserInfo.value.userid.toString(),
      false);

  bool get isTagChanged =>
      changeMyTag.read('changeMyTag' +
          _profileController.myUserInfo.value.userid.toString()) ??
      false;

  void tagChange(bool isChanged) => changeMyTag.write(
      'changeMyTag' + _profileController.myUserInfo.value.userid.toString(),
      isChanged);
}
