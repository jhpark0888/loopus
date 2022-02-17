// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/tagsearchwidget.dart';

import '../controller/modal_controller.dart';

class ProjectAddTagScreen extends StatelessWidget {
  ProjectAddTagScreen({
    Key? key,
    this.projectid,
    required this.screenType,
  }) : super(key: key);
  final ProjectAddController projectaddcontroller = Get.find();
  final TagController tagController = Get.find(tag: Tagtype.project.toString());
  final Screentype screenType;
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
                    if (tagController.selectedtaglist.length == 3) {
                      projectaddcontroller.isLooppersonLoading(true);
                      getfollowlist(
                              ProfileController.to.myUserInfo.value.userid,
                              followlist.following)
                          .then((value) {
                        projectaddcontroller.looplist = value;
                        projectaddcontroller.looppersonlist(projectaddcontroller
                            .looplist
                            .map((user) => CheckBoxPersonWidget(user: user))
                            .toList());
                        projectaddcontroller.isLooppersonLoading(false);
                      });
                      tagController.tagsearchfocusNode.unfocus();
                      Get.to(() => ProjectAddPersonScreen(
                            screenType: Screentype.add,
                          ));
                    } else {
                      ModalController.to
                          .showCustomDialog('3개의 태그를 선택해주세요', 1000);
                    }
                  },
                  child: Obx(
                    () => Text(
                      '다음',
                      style: kSubTitle2Style.copyWith(
                        color: tagController.selectedtaglist.length == 3
                            ? mainblue
                            : mainblack.withOpacity(0.38),
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
                            if (tagController.selectedtaglist.length == 3) {
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
                                  ProjectUpdateType.tag);
                              await getproject(
                                      Get.find<ProjectDetailController>(
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
                              ModalController.to
                                  .showCustomDialog('변경이 완료되었어요', 1000);
                            }
                          },
                          child: Obx(
                            () => Text(
                              '저장',
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
        title: "활동 태그",
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
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '활동을 대표하는 ',
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
                        '나중에 얼마든지 변경할 수 있어요',
                        style: kBody1Style,
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TagSearchWidget(
            tagtype: Tagtype.project,
          )),
    );
  }
}
