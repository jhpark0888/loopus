import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/search_tag_detail_screen.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class SearchTagWidget extends StatelessWidget {
  SearchTagWidget(
      {Key? key,
      required this.id,
      required this.tag,
      this.count,
      required this.isSearch})
      : super(key: key);
  TagController tagController = Get.put(TagController());
  SearchController searchController = Get.find();
  int id;
  String tag;
  int? count;
  int isSearch;

  @override
  Widget build(BuildContext context) {
    return id != -1
        ? 0 == isSearch
            ? ListTile(
                onTap: () {
                  if (tagController.selectedtaglist.length < 3) {
                    if (id == 0) {
                      // projectMakeController.postmaketag();
                      tagController.selectedtaglist.add(SelectedTagWidget(
                          id: id, text: tagController.tagsearch.text));
                      tagController.tagsearch.clear();
                      tagController.gettagsearch();
                    } else {
                      tagController.selectedtaglist.add(SelectedTagWidget(
                        id: id,
                        text: tag,
                      ));
                      tagController.tagsearch.clear();
                      tagController.gettagsearch();
                    }
                  } else {
                    Get.dialog(Dialog(
                        child: Container(
                            height: Get.height * 0.15,
                            width: Get.width * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    "태그는 최대 3개까지 가능합니다",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ))));
                  }
                },
                dense: true,
                leading: SvgPicture.asset(
                  'assets/icons/Tag.svg',
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  tag,
                  style: kButtonStyle,
                ),
                subtitle: count != null
                    ? Text(
                        '관심도 $count',
                        style: kBody1Style,
                      )
                    : null,
              )
            : ListTile(
                onTap: () async {
                  searchController.searchtagprojectlist.clear();
                  searchController.searchtagquestionlist.clear();
                  await searchController.search(
                      3, id, searchController.pagenumber4);
                  await searchController.search(
                      4, id, searchController.pagenumber5);
                  Get.to(() => SearchTagDetailScreen(
                        title: tag,
                        count: count,
                      ));
                },
                dense: true,
                leading: SvgPicture.asset(
                  'assets/icons/Tag.svg',
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  tag,
                  style: kButtonStyle,
                ),
                subtitle: count != null
                    ? Text(
                        '관심도 $count',
                        style: kBody1Style,
                      )
                    : null,
              )
        : Container(
            height: 80,
            width: Get.width * 0.94,
            child: Center(
              child: Text(
                tag,
                style: kSubTitle2Style,
              ),
            ),
          );
  }
}
