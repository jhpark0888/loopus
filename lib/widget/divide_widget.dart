import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class DivideWidget extends StatelessWidget {
  DivideWidget({Key? key, this.height}) : super(key: key);

  double? height;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 16,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
      color: AppColors.dividegray,
    );
  }
}

class NewDivider extends StatelessWidget {
  const NewDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 8,
      color: Color(0xFFDDDDDD),
    );
  }
}
