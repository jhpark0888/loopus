import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
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
      required this.isSearch,
      this.tagtype})
      : super(key: key);

  int id;
  String tag;
  int? count;
  int isSearch;
  Tagtype? tagtype;

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
                  Get.to(() => TagDetailScreen(
                        tag: Tag(tagId: id, tag: tag, count: count ?? 0),
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
    TagController controller = Get.find<TagController>(tag: tagtype.toString());
    if (controller.selectedtaglist.length < 3) {
      if (id == 0) {
        // SearchTag? searchTag = await postmaketag(tagtype!);
        SearchTag searchTag = SearchTag(
            id: id, tag: controller.tagsearch.text.replaceAll(" ", ""));
        controller.selectedtaglist.add(SelectedTagWidget(
          id: searchTag.id,
          text: searchTag.tag,
          selecttagtype: SelectTagtype.interesting,
          tagtype: tagtype!,
        ));
        controller.tagsearch.clear();
        gettagsearch(tagtype!);
      } else {
        controller.selectedtaglist.add(SelectedTagWidget(
            id: id,
            text: tag,
            selecttagtype: SelectTagtype.interesting,
            tagtype: tagtype!));
        controller.tagsearch.clear();
        gettagsearch(tagtype!);
      }
    } else {
      ModalController.to.showCustomDialog('최대 3개까지 선택할 수 있어요', 1000);
    }
  }
}
