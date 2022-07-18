// ignore_for_file: prefer_const_constructors
import 'dart:ui' as ui;
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
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/layout_builder.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/posting_add_link_screen.dart';
import 'package:loopus/screen/upload_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/no_ul_textfield_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/swiper_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

import '../controller/modal_controller.dart';

class PostingAddNameScreen1 extends StatelessWidget {
  PostingAddNameScreen1(
      {Key? key, this.postid, required this.project_id, required this.route})
      : super(key: key);
  late PostingAddController postingAddController =
      Get.put(PostingAddController(route: route));
  TagController tagController = Get.put(TagController(tagtype: Tagtype.Posting),
      tag: Tagtype.Posting.toString());
  KeyController keyController = Get.put(KeyController(isTextField: false.obs));
  int project_id;
  int? postid;
  PostaddRoute route;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        postingAddController.isTagClick.value = false;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          title: '포스트 작성',
        ),
        body: Obx(
          () => ScrollNoneffectWidget(
            child: SingleChildScrollView(
              controller: postingAddController.scrollController,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom:
                        // postingAddController.isTagClick.value ? 0 : 34,
                        34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Divider(
                      key: Get.put(
                              KeyController(
                                  tag: Tagtype.Posting, isTextField: false.obs),
                              tag: 'second')
                          .viewKey,
                      thickness: 0,
                      color: mainWhite,
                    ),
                    postingAddController.isAddLink.value == false
                        ? postingAddController.isAddImage.value == true
                            ? postingAddController.images.length == 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        color: mainblack,
                                        height: Get.width,
                                        child: Image.file(
                                            postingAddController.images.first,
                                            fit: BoxFit.contain),
                                      ),
                                      // const SizedBox(height: 14),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 14, 20, 14),
                                        child: GestureDetector(
                                            onTap: () {
                                              Get.to(() => UploadScreen());
                                            },
                                            child: Text('사진 수정하기',
                                                style: k16Normal.copyWith(
                                                    color: mainblue),
                                                textAlign: ui.TextAlign.right)),
                                      )
                                    ],
                                  )
                                : Stack(children: [
                                    SwiperWidget(
                                      items: postingAddController.images,
                                      swiperType: SwiperType.file,
                                    ),
                                    Positioned(
                                        child: GestureDetector(
                                            onTap: () {
                                              Get.to(() => UploadScreen(),
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease);
                                            },
                                            child: Text('사진 수정하기',
                                                style: k16Normal.copyWith(
                                                    color: mainblue))),
                                        right: 20,
                                        bottom: 5)
                                  ])
                            : Column(children: [
                                SizedBox(height: 23),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    addButton(
                                        title: '이미지',
                                        titleEng: 'image',
                                        ontap: () {
                                          Get.to(() => UploadScreen());
                                        }),
                                    addButton(
                                        title: '링크',
                                        titleEng: 'link',
                                        ontap: () {
                                          Get.to(() => PostingAddLinkScreen());
                                        })
                                  ],
                                ),
                                SizedBox(height: 24),
                              ])
                        : postingAddController.scrapList.length >= 2
                            ? SwiperWidget(
                                items: postingAddController.scrapList
                                    .map((linkwidget) => linkwidget.url)
                                    .toList(),
                                swiperType: SwiperType.link,
                              )
                            : postingAddController.scrapList.first,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Divider(thickness: 0.5),
                            LayoutBuilder(builder: (context, constraints) {
                              return NoUlTextField(
                                controller: postingAddController.textcontroller,
                                obscureText: false,
                                onChanged: (string) {
                                  TextSpan span = TextSpan(
                                      text: postingAddController
                                          .textcontroller.text,
                                      style: kSubTitle3Style);
                                  TextPainter tp = TextPainter(
                                      text: span,
                                      textDirection: ui.TextDirection.ltr);
                                  tp.layout(maxWidth: Get.width - 40);
                                  int numLines = tp.computeLineMetrics().length;
                                  postingAddController.lines.value = numLines;
                                  if (postingAddController.lines.value == 7) {
                                    postingAddController
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
                                postingAddController.isTagClick(true);
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
                            const SizedBox(height: 100),
                            uploadButton()
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

  Widget addButton(
      {required String title,
      required String titleEng,
      required Function()? ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.fromLTRB(18.25, 14.5, 18.25, 14.5),
        decoration: BoxDecoration(
            color: mainblue, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/Add_$titleEng.svg'),
            SizedBox(width: 7),
            Text(
              '$title 첨부하기',
              style: kSubTitle3Style.copyWith(color: mainWhite),
            )
          ],
        ),
      ),
    );
  }

  Widget uploadButton() {
    return GestureDetector(
      onTap: () async {
        loading();
        await addposting(project_id).then((value) {
          Get.back();
          if (value.isError == false) {
            Post post = Post.fromJson(value.data);

            if (Get.isRegistered<ProfileController>()) {
              Project? career =
                  ProfileController.to.myProjectList.firstWhereOrNull(
                (career) => career.id == project_id,
              );

              if (career != null) {
                career.posts.insert(0, post);
              }

              getbacks(2);
              dialogBack();
              showCustomDialog('포스팅을 업로드했어요', 1000);
            } else {
              errorSituation(value);
            }
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(146.5, 13, 146.5, 13),
        decoration: BoxDecoration(
            color: checkContent() ? mainblue : maingray.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          '업로드',
          textAlign: ui.TextAlign.center,
          style: k16Normal.copyWith(color: mainWhite),
        ),
      ),
    );
  }

  bool checkContent() {
    if (postingAddController.isAddImage.value ||
        postingAddController.isAddLink.value ||
        !postingAddController.isPostingTitleEmpty.value) {
      return true;
    } else {
      return false;
    }
  }
}
