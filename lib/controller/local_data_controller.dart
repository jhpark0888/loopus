import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

class LocalDataController extends GetxController {
  static LocalDataController get to => Get.find();

  final firstProject = GetStorage();

  //todo : key값에 userid 값 넣어서 개인화 시켜야함
  bool get isAddFirstProject => firstProject.read('firstProject') ?? true;

  void firstProjectAdd() => firstProject.write('firstProject', false);
}
