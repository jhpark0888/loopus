import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';

class LocalDataController extends GetxController {
  static LocalDataController get to => Get.find();

  final firstProject = GetStorage();

  bool get isAddFirstProject => firstProject.read('firstProject') ?? true;

  void firstProjectAdd() {
    firstProject.write('firstProject', false);
    print('first project : ${firstProject.read('firstProject')}');
  }
}
