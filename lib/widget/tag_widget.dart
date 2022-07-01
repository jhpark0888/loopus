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
  }) : super(key: key);

  Tag tag;
  bool isonTap;

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: maingray, width: 0.3)),
        child: Text(
          tag.tag,
          style: kmain,
        ),
      ),
    );
  }
}
