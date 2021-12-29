import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant.dart';

class BlueTextButton extends StatelessWidget {
  BlueTextButton(
      {Key? key,
      required this.onTap,
      required this.text,
      this.width,
      this.height})
      : super(key: key);

  Function() onTap;
  String text;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: mainblue,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(
          text,
          style: kButtonStyle.copyWith(
            color: mainWhite,
          ),
        ),
      ),
    );
  }
}
