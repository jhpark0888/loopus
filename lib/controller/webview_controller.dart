import 'package:get/state_manager.dart';

class WebController extends GetxController {
  RxInt progressPercent = 0.obs;
  RxBool isWrongUrl = false.obs;
}
