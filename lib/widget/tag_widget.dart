import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';

class Tagwidget extends StatelessWidget {
  // Tagwidget({Key? key, required String content}) : super(key: key);
  String content;
  Tagwidget({required this.content});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
          color: mainWhite, borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 24,
      child: Text("${content}"),
    );
  }
}
