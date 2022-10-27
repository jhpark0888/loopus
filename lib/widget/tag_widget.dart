import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/tag_detail_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/tag_detail_screen.dart';

class Tagwidget extends StatelessWidget {
  Tagwidget({
    Key? key,
    required this.tag,
    this.isonTap = true,
    this.isDark = false,
  }) : super(key: key);

  Tag tag;
  bool isonTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isonTap) {
          if (Get.isRegistered<TagDetailController>(
                  tag: tag.tagId.toString()) ==
              false) {
            Get.to(
                () => TagDetailScreen(
                      tag: tag,
                    ),
                preventDuplicates: false);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: isDark ? mainWhite : maingray, width: 0.5)),
        child: Text(
          tag.tag,
          style: kmain.copyWith(color: isDark ? mainWhite : null),
        ),
      ),
    );
  }
}
