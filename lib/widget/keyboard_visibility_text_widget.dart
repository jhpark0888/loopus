import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
class KeyboardVisibilityTextWidget extends StatelessWidget {
  KeyboardVisibilityTextWidget({Key? key, required this.textfield, required this.controller, required this.boolea})
      : super(key: key);
  Widget textfield;
  KeyboardVisibilityController controller;
  RxBool boolea;
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
        controller: controller,
        builder: (cont, bool isKeyboardVisible) {
          return textfield;
        },
      );
    
  }
}
