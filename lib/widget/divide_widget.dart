import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class DivideWidget extends StatelessWidget {
  DivideWidget({Key? key, this.height}) : super(key: key);

  double? height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 20,
      thickness: 0.5,
      indent: 20,
      endIndent: 20,
      color: dividegray,
    );
  }
}
