import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/search_tag_detail_screen.dart';

class Tagwidget extends StatelessWidget {
  Tagwidget({
    Key? key,
    required this.content,
    required this.fontSize,
  }) : super(key: key);

  String content;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SearchTagDetailScreen(
              title: content,
              count: 0,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xffefefef), borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Text(
          "${content}",
          style: TextStyle(
            fontSize: fontSize,
            color: Color(0xff999999),
          ),
        ),
      ),
    );
  }
}
