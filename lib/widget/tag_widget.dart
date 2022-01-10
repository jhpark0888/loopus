import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/search_tag_detail_screen.dart';

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
      onTap: () async {
        SearchController.to.searchtagprojectlist.clear();
        SearchController.to.searchtagquestionlist.clear();
        await SearchController.to.search(SearchType.tag_project, tag.tagId, 1);
        await SearchController.to.search(SearchType.tag_question, tag.tagId, 1);
        Get.to(() => SearchTagDetailScreen(
              title: tag.tag,
              count: 0,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffefefef),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Text(
          "${tag.tag}",
          style: TextStyle(
            fontSize: fontSize,
            color: Color(0xff999999),
          ),
        ),
      ),
    );
  }
}
