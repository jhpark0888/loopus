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
        height: isBig == true ? 42 : 36,
        padding: EdgeInsets.symmetric(
          vertical: isBig == true ? 9 : 6,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          // ignore: prefer_if_null_operators
          color: boxColor != null
              ? boxColor
              : isBlue
                  ? AppColors.mainblue
                  : AppColors.maingray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Obx(
          () => Text(
            title!,
            textAlign: TextAlign.center,
            style: MyTextTheme.main(context).copyWith(
              // ignore: prefer_if_null_operators
              color: textColor != null
                  ? _hoverController.isHover.value
                      ? textColor!.withOpacity(0.6)
                      : textColor
                  : _hoverController.isHover.value
                      ? AppColors.mainWhite.withOpacity(0.6)
                      : AppColors.mainWhite,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomExpandedBoldButton extends StatelessWidget {
  CustomExpandedBoldButton({
    required this.onTap,
    required this.isBlue,
    required this.title,
    this.boxColor,
  });

  VoidCallback onTap;
  bool isBlue;

  String? title;
  Color? boxColor;
  final HoverController _hoverController = HoverController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _hoverController.isHover(true),
      onTapCancel: () => _hoverController.isHover(false),
      onTapUp: (details) => _hoverController.isHover(false),
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          // ignore: prefer_if_null_operators
          color: boxColor != null
              ? boxColor
              : isBlue
                  ? AppColors.mainblue
                  : AppColors.cardGray,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Obx(
            () => Text(
              title!,
              textAlign: TextAlign.center,
              style: MyTextTheme.main(context).copyWith(
                // ignore: prefer_if_null_operators
                color: isBlue
                    ? _hoverController.isHover.value
                        ? AppColors.mainWhite.withOpacity(0.6)
                        : AppColors.mainWhite
                    : _hoverController.isHover.value
                        ? AppColors.mainblack.withOpacity(0.6)
                        : AppColors.mainblack,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
