import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/tag_detail_screen.dart';
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
  int id;
  String tag;
  int? count;
  int isSearch;

  @override
  Widget build(BuildContext context) {
    return id != -1
        ? 0 == isSearch
            ? GestureDetector(
                onTap: _selectTag,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/Tag.svg',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tag,
                              style: kButtonStyle,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            (count != null)
                                ? Text(
                                    '관심도 ${count.toString()}',
                                    style: kBody1Style,
                                  )
                                : Text(
                                    '관심도 표시 불가',
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : GestureDetector(
                onTap: () async {
                  SearchController.to.searchtagprojectlist.clear();
                  SearchController.to.searchtagquestionlist.clear();
                  await SearchController.to.search(SearchType.tagProject, id,
                      SearchController.to.tagpagenumber);
                  await SearchController.to.search(SearchType.tagQuestion, id,
                      SearchController.to.pagenumber);
                  Get.to(() => TagDetailScreen(
                        title: tag,
                        count: count,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/Tag.svg',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tag,
                              style: kButtonStyle,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            (count != null)
                                ? Text(
                                    '관심도 ${count}',
                                    style: kBody1Style,
                                  )
                                : Text(
                                    '관심도 표시 불가',
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
        : Container(
            child: Center(
              child: Text(
                tag,
                style: kSubTitle2Style,
              ),
            ),
          );
  }

  void _selectTag() async {
    if (tagController.selectedtaglist.length < 3) {
      if (id == 0) {
        SearchTag? searchTag = await postmaketag();
        if (searchTag != null) {
          tagController.selectedtaglist
              .add(SelectedTagWidget(id: searchTag.id, text: searchTag.tag));
          tagController.tagsearch.clear();
          gettagsearch();
        }
      } else {
        tagController.selectedtaglist.add(SelectedTagWidget(
          id: id,
          text: tag,
        ));
        tagController.tagsearch.clear();
        gettagsearch();
      }
    } else {
      ModalController.to.showCustomDialog('최대 3개까지 선택할 수 있어요', 1000);
    }
  }
}
