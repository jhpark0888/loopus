import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class WebController extends GetxController {
  RxInt progressPercent = 0.obs;
  RxBool canGoBack = false.obs;
}
