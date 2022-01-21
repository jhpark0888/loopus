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

class ProjectAddTagScreen extends StatelessWidget {
  ProjectAddTagScreen({
    Key? key,
    this.projectid,
    required this.screenType,
  }) : super(key: key);
  final ProjectAddController projectaddcontroller = Get.find();
  final TagController tagController = Get.find();
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
                      getlooplist(ProfileController.to.myUserInfo.value.userid)
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
                  children: const [
                    Text(
                      '활동을 대표하는 키워드가 무엇인가요?',
                      style: kSubTitle1Style,
                    ),
                    SizedBox(
                      height: 16,
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '선택한 태그',
                    style: kSubTitle2Style,
                  ),
                  Obx(
                    () => Text(
                      '${tagController.selectedtaglist.length} / 3',
                      style: kSubTitle2Style,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
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
                      child: Obx(() =>
                          Row(children: tagController.selectedtaglist.value)),
                    );
                  }),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: tagController.tagsearch,
                style: kBody2Style,
                cursorColor: Colors.grey,
                cursorWidth: 1.2,
                cursorRadius: Radius.circular(5.0),

                // focusNode: searchController.detailsearchFocusnode,
                textAlign: TextAlign.start,
                // selectionHeightStyle: BoxHeightStyle.tight,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mainlightgrey,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  // focusColor: Colors.black,
                  // border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.only(right: 16),
                  hintStyle: kBody2Style.copyWith(
                      color: mainblack.withOpacity(0.38), height: 1.5),
                  isDense: true,
                  hintText: "예) 봉사, 기계공학과, 서포터즈",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                    child: SvgPicture.asset(
                      "assets/icons/Search_Inactive.svg",
                      width: 16,
                      height: 16,
                      color: mainblack.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Obx(
              () => Expanded(
                child: ListView(
                  children: tagController.searchtaglist,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
