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
    required this.screenType,
  }) : super(key: key);
  // ProjectAddPersonController projectaddpersoncontroller =
  // Get.put(ProjectAddPersonController());
  ProjectAddController projectaddcontroller = Get.find();
  Screentype screenType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          screenType == Screentype.add
              ? TextButton(
                  onPressed: () async {
                    Get.to(() => ProjectAddThumbnailScreen(
                          screenType: Screentype.add,
                        ));
                  },
                  child: Obx(
                    () => Text(
                      projectaddcontroller.selectedpersontaglist.isEmpty
                          ? '건너뛰기'
                          : '다음',
                      style: kSubTitle2Style.copyWith(
                        color:
                            projectaddcontroller.selectedpersontaglist.isEmpty
                                ? mainblack
                                : mainblue,
                      ),
                    ),
                  ),
                )
              : Obx(
                  () => ProjectDetailController.to.isProjectLoading.value
                      ? Image.asset(
                          'assets/icons/loading.gif',
                          scale: 9,
                        )
                      : TextButton(
                          onPressed: () async {
                            ProjectDetailController.to.isProjectLoading.value =
                                true;
                            await updateproject(
                                ProjectDetailController.to.project.value.id,
                                ProjectUpdateType.looper);
                            await getproject(
                                    ProjectDetailController.to.project.value.id)
                                .then((value) {
                              ProjectDetailController.to.project(value);
                              ProjectDetailController
                                  .to.isProjectLoading.value = false;
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
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          '이 활동을 함께 진행한 학생이 있나요?',
                          style: kSubTitle1Style,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          '루프 중인 학생만 추가할 수 있어요',
                          style: kBody2Style,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ];
        },
        body: Padding(
          padding: const EdgeInsets.fromLTRB(
            15,
            20,
            15,
            10,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '선택한 사람',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Obx(
                () => Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    width: Get.width,
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: projectaddcontroller.selectedpersontaglist,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
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
                  : Column(
                      children: projectaddcontroller.looppersonlist,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
