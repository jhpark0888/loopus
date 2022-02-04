import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        SearchController.to.searchtagprojectlist.clear();
        SearchController.to.searchtagquestionlist.clear();
        SearchController.to.isSearchLoading(true);
        SearchController.to
            .search(SearchType.tag_project, tag.tagId.toString(), 1);
        SearchController.to
            .search(SearchType.tag_question, tag.tagId.toString(), 1)
            .then((value) {
          SearchController.to.isSearchLoading(false);
        });
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
            fontSize: fontSize,
            color: const Color(0xff999999),
          ),
        ),
      ),
    );
  }
}
