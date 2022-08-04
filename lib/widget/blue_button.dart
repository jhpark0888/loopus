import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/hover_controller.dart';

import '../constant.dart';

class BlueTextButton extends StatelessWidget {
  BlueTextButton(
      {Key? key,
      required this.onTap,
      required this.text,
      required this.hoverTag,
      this.width,
      this.height})
      : super(key: key);

  Function() onTap;
  String text;
  double? width;
  double? height;
  String hoverTag;
  late final HoverController _hoverController = Get.put(
    HoverController(),
    tag: hoverTag,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _hoverController.isHover(true),
      onTapCancel: () => _hoverController.isHover(false),
      onTapUp: (details) => _hoverController.isHover(false),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: mainblue,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Obx(
          () => Text(
            text,
            style: ktempFont.copyWith(
              color: _hoverController.isHover.value
                  ? mainWhite.withOpacity(0.6)
                  : mainWhite,
            ),
          ),
        ),
      ),
    );
  }
}
