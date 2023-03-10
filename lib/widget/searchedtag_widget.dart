import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/tag_detail_screen.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

import '../controller/hover_controller.dart';

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
  var numberFormat = NumberFormat('###,###,###,###');
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: id.toString());

  @override
  Widget build(BuildContext context) {
    return id != -1
        ? 0 == isSearch
            ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (details) => _hoverController.isHover(true),
                onTapCancel: () => _hoverController.isHover(false),
                onTapUp: (details) => _hoverController.isHover(false),
                onTap: _selectTag,
                // child: Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 24,
                //     vertical: 12,
                //   ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: [
                      // // Obx(
                      // //   () => SvgPicture.asset(
                      // //     'assets/icons/Tag.svg',
                      // //     width: 24,
                      // //     height: 24,
                      // //     color: _hoverController.isHover.value
                      // //         ? AppColors.mainblack.withOpacity(0.6)
                      // //         : AppColors.mainblack,
                      // //   ),
                      // // ),
                      // const SizedBox(
                      //   width: 20,
                      // ),
                      // Expanded(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Obx(
                      //         () => Text(
                      //           tag,
                      //           style: kButtonStyle.copyWith(
                      //             color: _hoverController.isHover.value
                      //                 ? AppColors.mainblack.withOpacity(0.6)
                      //                 : AppColors.mainblack,
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(
                      //         height: 4,
                      //       ),
                      //       (count != null)
                      //           ? Obx(
                      //               () => Text(
                      //                 '????????? ${numberFormat.format(count)}',
                      //                 style: kBody1Style.copyWith(
                      //                   color: _hoverController.isHover.value
                      //                       ? AppColors.mainblack.withOpacity(0.6)
                      //                       : AppColors.mainblack,
                      //                 ),
                      //               ),
                      //             )
                      //           : Obx(
                      //               () => Text(
                      //                 '????????? 0',
                      //                 style: kBody1Style.copyWith(
                      //                   color: _hoverController.isHover.value
                      //                       ? AppColors.mainblack.withOpacity(0.6)
                      //                       : AppColors.mainblack,
                      //                 ),
                      //               ),
                      //             ),
                      //   ],
                      // ),
                      // ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: AppColors.maingray.withOpacity(0.5),
                                width: 0.3)),
                        padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                        child: Text(tag, style: MyTextTheme.main(context)),
                      ),
                      const Spacer(),
                      (count != null)
                          ? Text('${numberFormat.format(count)}???',
                              style: MyTextTheme.main(context))
                          : Text('0 ???', style: MyTextTheme.main(context)),
                    ],
                  ),
                ),
                // ),
              )
            : GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (details) => _hoverController.isHover(true),
                onTapCancel: () => _hoverController.isHover(false),
                onTapUp: (details) => _hoverController.isHover(false),
                onTap: () async {
                  Get.to(() => TagDetailScreen(
                        tag: Tag(tagId: id, tag: tag, count: count ?? 0),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Obx(
                        () => SvgPicture.asset(
                          'assets/icons/Tag.svg',
                          width: 24,
                          height: 24,
                          color: _hoverController.isHover.value
                              ? AppColors.mainblack.withOpacity(0.6)
                              : AppColors.mainblack,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                tag,
                                style: MyTextTheme.tempfont(context).copyWith(
                                  color: _hoverController.isHover.value
                                      ? AppColors.mainblack.withOpacity(0.6)
                                      : AppColors.mainblack,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            (count != null)
                                ? Obx(
                                    () => Text(
                                      '????????? ${numberFormat.format(count)}',
                                      style: MyTextTheme.tempfont(context)
                                          .copyWith(
                                        color: _hoverController.isHover.value
                                            ? AppColors.mainblack
                                                .withOpacity(0.6)
                                            : AppColors.mainblack,
                                      ),
                                    ),
                                  )
                                : Obx(
                                    () => Text(
                                      '????????? 0',
                                      style: MyTextTheme.tempfont(context)
                                          .copyWith(
                                        color: _hoverController.isHover.value
                                            ? AppColors.mainblack
                                                .withOpacity(0.6)
                                            : AppColors.mainblack,
                                      ),
                                    ),
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
                style: MyTextTheme.main(context),
              ),
            ),
          );
  }

  void _selectTag() async {
    TagController controller = Get.find<TagController>(tag: tagtype.toString());
    // if (controller.selectedtaglist.length < 3) {
    if (id == 0) {
      // SearchTag? searchTag = await postmaketag(tagtype!);
      Tag searchTag = Tag(
          tagId: id,
          tag: controller.tagsearchContoller.text.replaceAll(" ", ""),
          count: 0);
      controller.selectedtaglist.add(SelectedTagWidget(
        id: searchTag.tagId,
        text: searchTag.tag,
        selecttagtype: SelectTagtype.interesting,
        tagtype: tagtype!,
      ));
      controller.tagsearchContoller.clear();
      // gettagsearch(tagtype!);
    } else {
      controller.selectedtaglist.add(SelectedTagWidget(
          id: id,
          text: tag,
          selecttagtype: SelectTagtype.interesting,
          tagtype: tagtype!));
      controller.tagsearchContoller.clear();
      controller.searchtaglist.removeWhere((element) => element.id == id);
      // gettagsearch(tagtype!);
    }
    // }
    //  else {
    //   showCustomDialog('?????? 3????????? ????????? ??? ?????????', 1000);
    // }
  }
}
