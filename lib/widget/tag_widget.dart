import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/tag_detail_screen.dart';

class Tagwidget extends StatelessWidget {
  Tagwidget({
    Key? key,
    required this.tag,
    required this.fontSize,
  }) : super(key: key);

  Tag tag;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TagDetailScreen(
              tag: tag,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffefefef),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Text(
          tag.tag,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: fontSize,
            color: const Color(0xff999999),
          ),
        ),
      ),
    );
  }
}
