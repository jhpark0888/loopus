import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/profile_controller.dart';

class LocalDataController extends GetxController {
  static LocalDataController get to => Get.find();
  //  final ProfileController _profileController = Get.find();

  final firstProject = GetStorage();
  final changeMyTag = GetStorage();
  final promotionNotification = GetStorage();

  bool get isAddFirstProject => firstProject.read('firstProject') ?? true;

  void firstProjectAdd() => firstProject.write('firstProject', false);

  bool get isTagChanged => changeMyTag.read('changeMyTag') ?? false;

  void tagChange(bool isChanged) => changeMyTag.write('changeMyTag', isChanged);

  bool get isUserAgreeProNoti =>
      promotionNotification.read('promotionNotification') ?? false;

  void agreeProNoti(bool isSelected) =>
      promotionNotification.write('promotionNotification', isSelected);
}
