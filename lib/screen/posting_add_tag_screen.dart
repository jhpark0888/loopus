// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/tagsearchwidget.dart';

import '../controller/modal_controller.dart';

class PostingAddTagScreen extends StatelessWidget {
  PostingAddTagScreen({
    Key? key,
    required this.projectId,
    required this.screenType,
  }) : super(key: key);
  final PostingAddController postingAddController = Get.find();
  final TagController tagController = Get.find(tag: Tagtype.Posting.toString());
  final Screentype screenType;
  int projectId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          screenType == Screentype.add
              ? TextButton(
                  onPressed: () async {
                    await addposting(
                      projectId,
                    ).then((value) => null);

                    // if (tagController.selectedtaglist.length == 3) {
                    //   await addposting(
                    //     projectId,
                    //   ).then((value) => null);
                    // } else {
                    //
                    //       .showCustomDialog('3개의 태그를 선택해주세요', 1000);
                    // }
                  },
                  child: Text(
                    '다음',
                    style: kSubTitle2Style.copyWith(
                      color: mainblue,
                    ),
                  ),
                )
              : Obx(
                  () => TextButton(
                    onPressed: () async {
                      if (tagController.selectedtaglist.length == 3) {}
                    },
                    child: Obx(
                      () => Text(
                        '게시',
                        style: kSubTitle2Style.copyWith(
                          color: tagController.selectedtaglist.length == 3
                              ? mainblue
                              : mainblack.withOpacity(0.38),
                        ),
                      ),
                    ),
                  ),
                )
        ],
        title: "포스팅 태그",
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      32,
                      24,
                      32,
                      12,
                    ),
                    child: Column(
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '포스팅을 대표하는 ',
                                style: kSubTitle1Style,
                              ),
                              TextSpan(
                                text: '키워드',
                                style: kSubTitle1Style.copyWith(
                                  color: mainblue,
                                ),
                              ),
                              TextSpan(
                                text: '가 무엇인가요?',
                                style: kSubTitle1Style,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          '나중에 추가할 수 있어요',
                          style: kBody1Style,
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TagSearchWidget(
              tagtype: Tagtype.Posting,
            )),
      ),
    );
  }
}
