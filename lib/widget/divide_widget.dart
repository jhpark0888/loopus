import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class DivideWidget extends StatelessWidget {
  DivideWidget({Key? key, this.height}) : super(key: key);

  double? height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 20,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: dividegray,
    );
  }
}
