import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/editorcontroller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

class PostingUpdateController extends GetxController {
  static PostingUpdateController get to => Get.find();
  PostingUpdateController({required this.post});
  ScrollController scrollController = ScrollController();
  RichTextController textcontroller = RichTextController(patternMatchMap: {
    CheckValidate.urlRegExp:
        MyTextTheme.main(Get.context!).copyWith(color: AppColors.mainblue),
  }, onMatch: (match) {});
  TextEditingController tagcontroller = TextEditingController();

  RxInt lines = 0.obs;
  RxBool isPostingTitleEmpty = true.obs;
  RxBool isPostingContentEmpty = true.obs;
  RxBool isTagClick = false.obs;

  Post post;

  @override
  void onInit() {
    textcontroller.addListener(() {
      if (textcontroller.text.trim().isEmpty) {
        isPostingTitleEmpty.value = true;
      } else {
        isPostingTitleEmpty.value = false;
      }
    });

    textcontroller.text = post.content.value;
    TagController tagselectController =
        Get.find<TagController>(tag: Tagtype.Posting.toString());
    for (var tag in post.tags) {
      tagselectController.selectedtaglist.add(SelectedTagWidget(
        text: tag.tag,
        selecttagtype: SelectTagtype.interesting,
        tagtype: Tagtype.Posting,
        id: tag.tagId,
      ));
    }
    super.onInit();
  }

  // @override
  // void onInit() {
  //   _loadPhotos();
  //   super.onInit();
  // }

}
