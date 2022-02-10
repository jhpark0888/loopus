import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/hover_controller.dart';

import '../constant.dart';

class CustomExpandedButton extends StatelessWidget {
  CustomExpandedButton({
    required this.onTap,
    required this.isBlue,
    required this.title,
    required this.buttonTag,
    required this.isBig,
  });

  VoidCallback onTap;
  bool? isBlue;
  bool? isBig;
  String? title;
  String? buttonTag;
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: buttonTag);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _hoverController.isHover(true),
      onTapCancel: () => _hoverController.isHover(false),
      onTapUp: (details) => _hoverController.isHover(false),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isBig == true ? 12 : 8,
        ),
        decoration: BoxDecoration(
          color: isBlue! ? mainblue : const Color(0xffe7e7e7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Obx(
          () => Text(
            title!,
            textAlign: TextAlign.center,
            style: kButtonStyle.copyWith(
              color: _hoverController.isHover.value
                  ? isBlue!
                      ? mainWhite.withOpacity(0.6)
                      : mainblack.withOpacity(0.5)
                  : isBlue!
                      ? mainWhite
                      : mainblack,
            ),
          ),
        ),
      ),
    );
  }
}
