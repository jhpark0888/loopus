// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/app.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/question_add_controller.dart';
import 'package:loopus/controller/question_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/home_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/tagsearchwidget.dart';

class QuestionAddTagScreen extends StatelessWidget {
  QuestionAddController questionaddController = Get.find();
  TagController tagController = Get.put(
      TagController(tagtype: Tagtype.question),
      tag: Tagtype.question.toString());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(children: [
        Scaffold(
          appBar: AppBarWidget(
            actions: [
              Obx(
                () => TextButton(
                    onPressed: () async {
                      if (tagController.selectedtaglist.length == 3) {
                        tagController.tagsearchfocusNode.unfocus();
                        questionaddController.isQuestionUploading(true);
                        await postquestion(
                                questionaddController.contentcontroller.text)
                            .then((value) {
                          Get.back();
                          Get.back();
                          questionaddController.isQuestionUploading(false);
                        });

                        HomeController.to.onQuestionRefresh();
                      }
                    },
                    child: Text(
                      '올리기',
                      style: tagController.selectedtaglist.length == 3
                          ? kSubTitle2Style.copyWith(color: mainblue)
                          : kSubTitle2Style.copyWith(
                              color: mainblack.withOpacity(0.38)),
                    )),
              ),
            ],
            title: "질문 태그",
          ),
          body: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                '질문 태그를 선택해주세요!',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                '해당 태그에 관심있는 학생에게 질문을 보여드려요.',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ];
              },
              body: TagSearchWidget(
                tagtype: Tagtype.question,
              )),
        ),
        if (questionaddController.isQuestionUploading.value)
          Container(
            height: Get.height,
            width: Get.width,
            color: mainblack.withOpacity(0.3),
            child: Image.asset(
              'assets/icons/loading.gif',
              scale: 6,
            ),
          ),
      ]),
    );
  }
}
