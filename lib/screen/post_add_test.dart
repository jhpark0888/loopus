// ignore_for_file: prefer_const_constructors
import 'dart:ui' as ui;
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
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/layout_builder.dart';
import 'package:loopus/screen/posting_add_link_screen.dart';
import 'package:loopus/screen/posting_add_tag_screen.dart';
import 'package:loopus/screen/upload_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/no_ul_textfield_widget.dart';
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
          leading: GestureDetector(onTap: (){Get.back();},child: SvgPicture.asset('assets/icons/Back_icon.svg')),
        ),
        body: Obx(
          () => SingleChildScrollView(
            controller: postingAddController.scrollController,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                0,
                20,
                postingAddController.isTagClick.value ? 0 : 34,
              ),
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
                  SizedBox(height: 23),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      addButton(title: '이미지', titleEng: 'image', ontap: (){Get.to(() => UploadScreen());}),
                      addButton(title: '링크', titleEng: 'link', ontap: (){Get.to(() => PostingAddLinkScreen());})
                    ],
                  ),
                  SizedBox(height: 24),
                  Divider(thickness: 0.5),
                  LayoutBuilder(builder: (context, constraints) {
                    return NoUlTextField(
                      controller: postingAddController.textcontroller,
                      obscureText: false,
                      onChanged: (string) {
                        TextSpan span = TextSpan(
                            text: postingAddController.textcontroller.text,
                            style: kSubTitle3Style);
                        TextPainter tp =
                            TextPainter(text: span, textDirection: ui.TextDirection.ltr);
                        tp.layout(maxWidth: Get.width - 40);
                        int numLines = tp.computeLineMetrics().length;
                        postingAddController.lines.value =
                            numLines;
                        if (postingAddController.lines.value == 7) {
                          postingAddController.keyControllerAtive.value = true;
                        }
                      },
                      hintText: '내용을 입력해주세요',
                    );
                  }),
                  Obx(() => Divider(
                      key: Get.put(
                              KeyController(
                                  tag: Tagtype.Posting, isTextField: true.obs),
                              tag: postingAddController.keyControllerAtive.value
                                  .toString())
                          .viewKey,
                      thickness: 0.5)),
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
                              children: tagController.selectedtaglist))),
                  SizedBox(height: 28),
                  CustomTextField(
                    textController: tagController.tagsearch,
                    autofocus: false,
                    hintText: '태그를 입력해주세요',
                    validator: (_) {},
                    obscureText: false,
                    maxLines: 2,
                    counterText: '',
                    maxLength: null,
                    textInputAction: TextInputAction.done,
                    ontap: () async {
                      await Future.delayed(Duration(milliseconds: 300));
                      postingAddController.scrollController.animateTo(
                          postingAddController.lines.value < 7
                              ? tagController.offsetDy.value - 80
                              : tagController.offsetDy.value +
                                  ((postingAddController.lines.value - 7) *
                                      tagController.textfieldOffset.value) -
                                  80,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                      postingAddController.isTagClick(true);
                      // }
                      // );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(() => Container(
                      height: postingAddController.isTagClick.value
                          ? postingAddController.lines.value < 7
                              ? tagController.offsetDy.value + 100
                              : tagController.offsetDy.value +
                                  ((postingAddController.lines.value - 7) *
                                      tagController.textfieldOffset.value) +
                                  100
                          : 0,
                      child: Column(children: tagController.searchtaglist))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addButton({required String title, required String titleEng, required Function()? ontap}) {
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
}
