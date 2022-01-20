// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_person_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/project_add_thumbnail_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';

class ProjectAddPersonScreen extends StatelessWidget {
  ProjectAddPersonScreen({
    Key? key,
    this.projectid,
    required this.screenType,
  }) : super(key: key);
  // ProjectAddPersonController projectaddpersoncontroller =
  // Get.put(ProjectAddPersonController());
  ProjectAddController projectaddcontroller = Get.find();
  Screentype screenType;
  int? projectid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          screenType == Screentype.add
              ? TextButton(
                  onPressed: () async {
                    Get.to(() => ProjectAddThumbnailScreen(
                          screenType: Screentype.add,
                        ));
                  },
                  child: Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        projectaddcontroller.selectedpersontaglist.isEmpty
                            ? '건너뛰기'
                            : '다음',
                        style: kSubTitle2Style.copyWith(
                          color: mainblue,
                        ),
                      ),
                    ),
                  ),
                )
              : Obx(
                  () => Get.find<ProjectDetailController>(
                              tag: projectid.toString())
                          .isProjectUpdateLoading
                          .value
                      ? Image.asset(
                          'assets/icons/loading.gif',
                          scale: 9,
                        )
                      : TextButton(
                          onPressed: () async {
                            Get.find<ProjectDetailController>(
                                    tag: projectid.toString())
                                .isProjectUpdateLoading
                                .value = true;
                            await updateproject(
                                Get.find<ProjectDetailController>(
                                        tag: projectid.toString())
                                    .project
                                    .value
                                    .id,
                                ProjectUpdateType.looper);
                            await getproject(Get.find<ProjectDetailController>(
                                        tag: projectid.toString())
                                    .project
                                    .value
                                    .id)
                                .then((value) {
                              Get.find<ProjectDetailController>(
                                      tag: projectid.toString())
                                  .project(value);
                              Get.find<ProjectDetailController>(
                                      tag: projectid.toString())
                                  .isProjectUpdateLoading
                                  .value = false;
                            });
                            Get.back();
                          },
                          child: Obx(
                            () => Text(
                              '저장',
                              style: kSubTitle2Style.copyWith(
                                color: projectaddcontroller
                                        .selectedpersontaglist.isEmpty
                                    ? mainblack
                                    : mainblue,
                              ),
                            ),
                          ),
                        ),
                )
        ],
        title: '함께 활동한 사람',
      ),
      body: NestedScrollView(
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
                  children: const [
                    Text(
                      '활동을 같이 진행한 학생이 있나요?',
                      style: kSubTitle1Style,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      '루프 중인 학생만 추가할 수 있어요',
                      style: kBody1Style,
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
              child: Text(
                '선택한 학생',
                style: kSubTitle2Style,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 32,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: (index == 0) ? 16 : 0,
                          right: (index == 0) ? 16 : 0),
                      child: Obx(() => Row(
                          children:
                              projectaddcontroller.selectedpersontaglist)),
                    );
                  }),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '루프 중인 사람',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => Text(
                      '${projectaddcontroller.looppersonlist.value.length}명',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() => projectaddcontroller.isLooppersonLoading.value
                ? Column(
                    children: [
                      Image.asset(
                        'assets/icons/loading.gif',
                        scale: 6,
                      ),
                      Text(
                        '루프 리스트 받아오는 중...',
                        style: TextStyle(fontSize: 10, color: mainblue),
                      )
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 16, left: 16),
                    child: Column(
                      children: projectaddcontroller.looppersonlist,
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
