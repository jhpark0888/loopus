// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_person_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/project_add_thumbnail_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';

class ProjectAddPersonScreen extends StatelessWidget {
  ProjectAddPersonScreen({Key? key, required this.screenType, this.project})
      : super(key: key);
  // ProjectAddPersonController projectaddpersoncontroller =
  //     Get.put(ProjectAddPersonController());
  ProjectAddController projectaddcontroller = Get.find();
  Screentype screenType;
  Project? project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () async {
              if (screenType == Screentype.add) {
                Get.to(() => ProjectAddThumbnailScreen(
                      screenType: Screentype.add,
                    ));
              } else {
                project = await updateproject(project!.id);
                Get.back(result: project);
              }
            },
            child: Obx(
              () => Text(
                screenType == Screentype.add
                    ? projectaddcontroller.selectedpersontaglist.isEmpty
                        ? '건너뛰기'
                        : '다음'
                    : '저장',
                style: kSubTitle2Style.copyWith(
                  color: projectaddcontroller.selectedpersontaglist.isEmpty
                      ? mainblack
                      : mainblue,
                ),
              ),
            ),
          ),
        ],
        title: '함께 활동한 사람',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Text(
                '이 활동을 함께 진행한 학생이 있나요?',
                style: kSubTitle1Style,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                '루프 중인 학생만 추가할 수 있어요',
                style: kBody2Style,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '선택한 사람',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Obx(
              () => Flexible(
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: projectaddcontroller.selectedpersontaglist,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '루프 중인 사람',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${projectaddcontroller.looppersonlist.length}명',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: projectaddcontroller.looppersonlist,
              ),
            )
          ],
        ),
      ),
    );
  }
}
