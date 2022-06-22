import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class EmptyContentWidget extends StatelessWidget {
  EmptyContentWidget({Key? key, required this.text}) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      alignment: Alignment.center,
      child: Text(
        text,
        style: kBody1Style.copyWith(color: mainblack.withOpacity(0.6)),
      ),
    );
  }
}
