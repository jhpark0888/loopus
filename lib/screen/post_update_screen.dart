// ignore_for_file: prefer_const_constructors
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/posting_update_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/layout_builder.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/posting_add_link_screen.dart';
import 'package:loopus/screen/upload_screen.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/no_ul_textfield_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/swiper_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

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
                      SwiperWidget(
                        items: postingUpdateController.post.images.isNotEmpty
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

                    // Column(
                    //   children: [
                    //     Container(
                    //         color: mainblack,
                    //         constraints: BoxConstraints(
                    //             maxWidth: 600,
                    //             maxHeight: postingUpdateController
                    //                     .post.images.isNotEmpty
                    //                 ? Get.width
                    //                 : 300),
                    //         child: PageView.builder(
                    //           controller: pageController,
                    //           itemBuilder: (BuildContext context, int index) {
                    //             if (postingUpdateController
                    //                 .post.images.isNotEmpty) {
                    //               return CachedNetworkImage(
                    //                   imageUrl: postingUpdateController
                    //                       .post.images[index],
                    //                   fit: BoxFit.contain);
                    //               // Image.network(item.images[index],
                    //               //     fit: BoxFit.fill);
                    //             } else {
                    //               return KeepAlivePage(
                    //                 child: LinkWidget(
                    //                     url: postingUpdateController
                    //                         .post.links[index],
                    //                     widgetType: 'post'),
                    //               );
                    //             }
                    //           },
                    //           itemCount: postingUpdateController
                    //                   .post.images.isNotEmpty
                    //               ? postingUpdateController.post.images.length
                    //               : postingUpdateController.post.links.length,
                    //         )),
                    //     const SizedBox(
                    //       height: 14,
                    //     ),
                    //     if (postingUpdateController.post.images.length > 1 ||
                    //         postingUpdateController.post.links.length > 1)
                    //       Column(
                    //         children: [
                    //           PageIndicator(
                    //             size: 7,
                    //             activeSize: 7,
                    //             space: 7,
                    //             color: maingray,
                    //             activeColor: mainblue,
                    //             count: postingUpdateController
                    //                     .post.images.isNotEmpty
                    //                 ? postingUpdateController
                    //                     .post.images.length
                    //                 : postingUpdateController
                    //                     .post.links.length,
                    //             controller: pageController,
                    //             layout: PageIndicatorLayout.SLIDE,
                    //           ),
                    //         ],
                    //       ),
                    //     const SizedBox(
                    //       height: 14,
                    //     ),
                    //   ],
                    // ),
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
                                onChanged: (string) {
                                  TextSpan span = TextSpan(
                                      text: postingUpdateController
                                          .textcontroller.text,
                                      style: kSubTitle3Style);
                                  TextPainter tp = TextPainter(
                                      text: span,
                                      textDirection: ui.TextDirection.ltr);
                                  tp.layout(maxWidth: Get.width - 40);
                                  int numLines = tp.computeLineMetrics().length;
                                  postingUpdateController.lines.value =
                                      numLines;
                                  if (postingUpdateController.lines.value ==
                                      7) {
                                    postingUpdateController
                                        .keyControllerAtive.value = true;
                                  }
                                },
                                hintText: '내용을 입력해주세요',
                              );
                            }),
                            // Obx(() => Divider(
                            //     key: Get.put(
                            //               KeyController(
                            //                   tag: Tagtype.Posting, isTextField: true.obs),
                            //               tag: postingAddController.keyControllerAtive.value
                            //                   .toString())
                            //           .viewKey,
                            //     thickness: 0.5)),
                            Divider(key: keyController.viewKey, thickness: 0.5),
                            SizedBox(height: 14),
                            Text('태그', style: kSubTitle3Style),
                            SizedBox(height: 14),
                            Obx(() => tagController.selectedtaglist.isEmpty
                                ? Text('입력시 기업이 컨택할 가능성이 높아져요',
                                    style: kSubTitle3Style.copyWith(
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
                                    children: tagController.searchtaglist))),
                            const SizedBox(height: 100),
                            updateButton()
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
      child: Container(
        padding: const EdgeInsets.fromLTRB(146.5, 13, 146.5, 13),
        decoration: BoxDecoration(
            color: checkContent() ? mainblue : maingray.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          '적용하기',
          textAlign: ui.TextAlign.center,
          style: k16Normal.copyWith(color: mainWhite),
        ),
      ),
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
