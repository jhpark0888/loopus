import 'package:get/get.dart';

class HoverController {
  RxDouble scale = 1.0.obs;
  RxBool isHover = false.obs;
  RxDouble followOpacity = 1.0.obs;
  RxDouble myTagOpacity = 1.0.obs;
  RxDouble opacity = 0.0.obs;

  void isHoverState() {
    scale.value = 0.97;
  }

  void isNonHoverState() {
    scale.value = 1.0;
  }

  void hoverButton() {
    followOpacity(0.5);
  }

  void isOpacityState() {
    opacity.value = 0.7;
  }

  void isNonOpacityState() {
    opacity.value = 1.0;
  }
}
