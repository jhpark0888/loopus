import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/hover_controller.dart';

import '../constant.dart';

class CustomExpandedButton extends StatelessWidget {
  CustomExpandedButton(
      {required this.onTap,
      required this.isBlue,
      required this.title,
      required this.isBig,
      this.boxColor,
      this.textColor});

  VoidCallback onTap;
  bool isBlue;
  bool isBig;
  String? title;
  Color? boxColor;
  Color? textColor;
  final HoverController _hoverController = HoverController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _hoverController.isHover(true),
      onTapCancel: () => _hoverController.isHover(false),
      onTapUp: (details) => _hoverController.isHover(false),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isBig == true ? 13 : 8,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          // ignore: prefer_if_null_operators
          color: boxColor != null
              ? boxColor
              : isBlue
                  ? mainblue
                  : maingray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Obx(
          () => Text(
            title!,
            textAlign: TextAlign.center,
            style: kmain.copyWith(
              // ignore: prefer_if_null_operators
              color: textColor != null
                  ? _hoverController.isHover.value
                      ? textColor!.withOpacity(0.6)
                      : textColor
                  : _hoverController.isHover.value
                      ? mainWhite.withOpacity(0.6)
                      : mainWhite,
            ),
          ),
        ),
      ),
    );
  }
}
