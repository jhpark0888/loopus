import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant.dart';

class BlueTextButton extends StatelessWidget {
  BlueTextButton(
      {Key? key,
      required this.onpressed,
      required this.text,
      this.width,
      this.height})
      : super(key: key);

  Function() onpressed;
  String text;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      onPressed: onpressed,
      child: Container(
        decoration: BoxDecoration(
          color: mainblue,
          borderRadius: BorderRadius.circular(4),
        ),
        margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
        width: width ?? 72,
        height: height ?? 36,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: mainWhite, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
