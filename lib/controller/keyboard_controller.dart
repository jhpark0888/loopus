import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:loopus/firebase_options.dart';

class KeyBoardController extends GetxController {
  RxBool keyboardStatus = false.obs;

  var keyboardVisibilityController;

  RxInt padding = 0.obs;

  @override
  void onInit() {
    keyboardVisibilityController = KeyboardVisibilityController();
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      print(DefaultFirebaseOptions.currentPlatform);
      padding.value = visible == true ? 0 : 43;
    });
    super.onInit();
  }
}
