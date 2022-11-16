import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/tag_detail_controller.dart';
import 'package:loopus/model/search_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/tag_detail_screen.dart';

class Tagwidget extends StatelessWidget {
  Tagwidget({
    Key? key,
    required this.tag,
    this.isonTap = true,
    this.isAddRecentSearch = false,
    this.isDark = false,
  }) : super(key: key);

  Tag tag;
  bool isonTap;
  bool isAddRecentSearch;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isonTap) {
          if (isAddRecentSearch) {
            addRecentSearch(SearchType.tag.index, tag.tagId.toString())
                .then((value) {
              if (value.isError == false && value.data != null) {
                RecentSearch tempRecentSearch =
                    RecentSearch.fromJson(value.data);
                SearchController.to.recentSearchList
                    .insert(0, tempRecentSearch);
              }
            });
          }
          Get.to(
              () => TagDetailScreen(
                    tag: tag,
                  ),
              preventDuplicates: false);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isDark ? AppColors.mainWhite : AppColors.maingray,
                width: 0.5)),
        child: Text(
          tag.tag,
          style: MyTextTheme.main(context)
              .copyWith(color: isDark ? AppColors.mainWhite : null),
        ),
      ),
    );
  }
}
