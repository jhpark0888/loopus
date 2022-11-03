// ignore_for_file: prefer_const_constructors
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/posting_update_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/no_ul_textfield_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/swiper_widget.dart';

import '../controller/modal_controller.dart';

class PostUpdateScreen extends StatelessWidget {
  PostUpdateScreen({Key? key, required this.post}) : super(key: key);
  late PostingUpdateController postingUpdateController =
      Get.put(PostingUpdateController(post: post));
  TagController tagController = Get.put(TagController(tagtype: Tagtype.Posting),
      tag: Tagtype.Posting.toString());
  KeyController keyController = Get.put(KeyController(isTextField: false.obs));

  PageController pageController = PageController();

  Post post;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        postingUpdateController.isTagClick.value = false;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          title: '포스트 수정',
          actions: [updateButton()],
        ),
        body: Obx(
          () => ScrollNoneffectWidget(
            child: SingleChildScrollView(
              controller: postingUpdateController.scrollController,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom:
                        // postingAddController.isTagClick.value ? 0 : 34,
                        34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (postingUpdateController.post.images.isNotEmpty ||
                        postingUpdateController.post.links.isNotEmpty)
                      Column(
                        children: [
                          SwiperWidget(
                            items:
                                postingUpdateController.post.images.isNotEmpty
                                    ? postingUpdateController.post.images
                                    : postingUpdateController.post.links,
                            swiperType:
                                postingUpdateController.post.images.isNotEmpty
                                    ? SwiperType.image
                                    : SwiperType.link,
                            aspectRatio:
                                postingUpdateController.post.images.isNotEmpty
                                    ? getAspectRatioinUrl(
                                        postingUpdateController.post.images[0])
                                    : null,
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Divider(thickness: 0.5),
                            LayoutBuilder(builder: (context, constraints) {
                              return NoUlTextField(
                                controller:
                                    postingUpdateController.textcontroller,
                                obscureText: false,
                                hintText: '내용을 입력해주세요',
                              );
                            }),
                            Divider(key: keyController.viewKey, thickness: 0.5),
                            SizedBox(height: 14),
                            Text('태그', style: kmain),
                            SizedBox(height: 14),
                            Obx(() => tagController.selectedtaglist.isEmpty
                                ? Text('입력시 기업이 컨택할 가능성이 높아져요',
                                    style: kmain.copyWith(
                                        color: maingray.withOpacity(0.5)))
                                : Container(
                                    width: Get.width,
                                    child: Wrap(
                                        spacing: 7,
                                        runSpacing: 7,
                                        direction: Axis.horizontal,
                                        children:
                                            tagController.selectedtaglist))),
                            SizedBox(height: 28),
                            CustomTextField(
                              textController: tagController.tagsearchContoller,
                              autofocus: false,
                              hintText: '태그를 입력해주세요',
                              validator: (_) {},
                              obscureText: false,
                              maxLines: 2,
                              counterText: '',
                              maxLength: null,
                              textInputAction: TextInputAction.done,
                              ontap: () async {
                                // await Future.delayed(Duration(milliseconds: 300));
                                // postingAddController.scrollController.animateTo(
                                //       postingAddController.lines.value < 7
                                //           ? tagController.offsetDy.value  - 80
                                //           : tagController.offsetDy.value +
                                //               ((postingAddController.lines.value - 7) *
                                //                   tagController.textfieldOffset.value) -
                                //               80,
                                //       duration: const Duration(milliseconds: 300),
                                //       curve: Curves.easeOut);
                                await Future.delayed(
                                    Duration(milliseconds: 300));
                                Scrollable.ensureVisible(
                                    keyController.viewKey.currentContext!,
                                    curve: Curves.easeOut,
                                    duration:
                                        const Duration(milliseconds: 300));
                                postingUpdateController.isTagClick(true);
                                // }
                                // );
                              },
                              onfieldSubmitted: (string) {
                                TagController controller =
                                    Get.find<TagController>(
                                        tag: Tagtype.Posting.toString());
                                print(controller.searchtaglist
                                    .where((element) => element.tag == string));
                                // if (controller.selectedtaglist.length < 3) {
                                if (controller.searchtaglist
                                    .where((element) => element.tag == string)
                                    .isNotEmpty) {
                                  controller.selectedtaglist
                                      .add(
                                          SelectedTagWidget(
                                              id: controller.searchtaglist
                                                  .where((element) =>
                                                      element.tag == string)
                                                  .first
                                                  .id,
                                              text: string,
                                              selecttagtype:
                                                  SelectTagtype.interesting,
                                              tagtype: Tagtype.Posting));
                                  controller.tagsearchContoller.clear();
                                  controller.searchtaglist.removeWhere(
                                      (element) =>
                                          element.id ==
                                          controller.searchtaglist
                                              .where((element) =>
                                                  element.tag == string)
                                              .first
                                              .id);
                                } else {
                                  controller.selectedtaglist.add(
                                      SelectedTagWidget(
                                          id: 0,
                                          text: string,
                                          selecttagtype:
                                              SelectTagtype.interesting,
                                          tagtype: Tagtype.Posting));
                                  controller.tagsearchContoller.clear();
                                }

                                // }
                                //  else {
                                //   showCustomDialog('최대 3개까지 선택할 수 있어요', 1000);
                                // }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Obx(() => SizedBox(
                                // height: postingAddController.isTagClick.value
                                //       ? postingAddController.lines.value < 7
                                //           ? tagController.offsetDy.value + 80
                                //           : tagController.offsetDy.value +
                                //               ((postingAddController.lines.value - 7) *
                                //                   tagController.textfieldOffset.value) +
                                //               100
                                //       : 0,
                                child: Column(
                                    children:
                                        tagController.searchtaglist.value))),
                            // const SizedBox(height: 100),
                            // updateButton()
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget updateButton() {
    return GestureDetector(
      onTap: () async {
        loading();
        await updateposting(post.id, PostingUpdateType.contents).then((value) {
          Get.back();
          if (value.isError == false) {
            postingUpdateController.post
                .content(postingUpdateController.textcontroller.text);
            postingUpdateController.post.tags.assignAll(tagController
                .selectedtaglist
                .map((tagwidget) =>
                    Tag(tagId: tagwidget.id!, tag: tagwidget.text, count: 0))
                .toList());

            Get.back();
            dialogBack(modalIOS: true);
            showCustomDialog('포스팅 수정이 완료됐어요', 1000);
          } else {
            errorSituation(value);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 14, 0),
        child: Text(
          '적용',
          textAlign: ui.TextAlign.center,
          style: kNavigationTitle.copyWith(
              color: checkContent() ? mainblue : maingray.withOpacity(0.5)),
        ),
      ),
      // Container(
      //   padding: const EdgeInsets.fromLTRB(146.5, 13, 146.5, 13),
      //   decoration: BoxDecoration(
      //       color: checkContent() ? mainblue : maingray.withOpacity(0.5),
      //       borderRadius: BorderRadius.circular(8)),
      //   child: Text(
      //     '적용하기',
      //     textAlign: ui.TextAlign.center,
      //     style: kNavigationTitle.copyWith(color: mainwhite),
      //   ),
      // ),
    );
  }

  bool checkContent() {
    if (!postingUpdateController.isPostingTitleEmpty.value) {
      return true;
    } else {
      return false;
    }
  }
}
