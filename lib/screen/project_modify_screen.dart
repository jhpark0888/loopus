import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';
import 'package:loopus/screen/project_add_thumbnail_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/screen/project_add_tag_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:loopus/widget/checkboxperson_widget.dart';
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class ProjectModifyScreen extends StatelessWidget {
  ProjectModifyScreen({Key? key, required this.projectid}) : super(key: key);

  ProjectAddController projectaddcontroller = Get.put(ProjectAddController());
  // ProjectDetailController projectDetailController = Get.find();
  TagController tagController = Get.put(TagController(tagtype: Tagtype.project),
      tag: Tagtype.project.toString());
  //
  int projectid;
  late ProjectDetailController controller = Get.find(tag: projectid.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          title: '활동 편집',
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/icons/Arrow.svg'),
          ),
        ),
        body: ListView(
          children: [
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  projectnameinput();
                  Get.to(() => ProjectAddTitleScreen(
                        projectid: projectid,
                        screenType: Screentype.update,
                      ));
                },
                title: '활동명',
                subtitle: controller.project.value.projectName,
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  projectdateinput();
                  Get.to(() => ProjectAddPeriodScreen(
                        projectid: projectid,
                        screenType: Screentype.update,
                      ));
                },
                title: '활동 기간',
                subtitle:
                    '${DateFormat("yy.MM.dd").format(controller.project.value.startDate!)} ~ ${controller.project.value.endDate != null ? DateFormat("yy.MM.dd").format(controller.project.value.endDate!) : '진행중'}',
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  projectintroinput();
                  Get.to(() => ProjectAddIntroScreen(
                        projectid: projectid,
                        screenType: Screentype.update,
                      ));
                },
                title: '활동 소개',
                subtitle: (controller.project.value.introduction! != '')
                    ? controller.project.value.introduction!
                    : '아직 활동 소개를 작성하지 않았어요',
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  projecttaginput();
                  Get.to(() => ProjectAddTagScreen(
                        projectid: projectid,
                        screenType: Screentype.update,
                      ));
                },
                title: '활동 태그',
                subtitle: controller.project.value.projectTag.isEmpty
                    ? ''
                    : '${controller.project.value.projectTag[0].tag}, ${controller.project.value.projectTag[1].tag}, ${controller.project.value.projectTag[2].tag}',
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  projectlooperinput();
                  projectaddcontroller.isLooppersonLoading(true);
                  getfollowlist(ProfileController.to.myUserInfo.value.userid,
                          followlist.follower)
                      .then((value) {
                    projectaddcontroller.looplist = value;
                    projectaddcontroller.looppersonlist(projectaddcontroller
                        .looplist
                        .map((user) => CheckBoxPersonWidget(user: user))
                        .toList());
                    projectaddcontroller.isLooppersonLoading(false);
                  });
                  Get.to(() => ProjectAddPersonScreen(
                        projectid: projectid,
                        screenType: Screentype.update,
                      ));
                },
                title: '함께 활동한 사람',
                subtitle: controller.project.value.looper.isEmpty
                    ? '함께 활동한 사람이 없어요'
                    : controller.project.value.looper
                        .map((user) => user.realName)
                        .toList()
                        .join(', '),
              ),
            ),
            updateProjectTile(
              isSubtitleExist: false,
              onTap: () async {
                projectthumbnailinput();
                Get.to(() => ProjectAddThumbnailScreen(
                      projectid: projectid,
                      screenType: Screentype.update,
                    ));
              },
              title: '대표 사진 변경',
              subtitle: '',
            ),
          ],
        ));
  }

  void projectnameinput() {
    projectaddcontroller.projectnamecontroller.text =
        controller.project.value.projectName;
  }

  void projectintroinput() {
    projectaddcontroller.introcontroller.text =
        controller.project.value.introduction ?? '';
  }

  void projectdateinput() {
    projectaddcontroller.selectedStartDateTime.value =
        controller.project.value.startDate!.toString();

    if (controller.project.value.endDate != null) {
      projectaddcontroller.selectedEndDateTime.value =
          controller.project.value.endDate!.toString();
      projectaddcontroller.isEndedProject.value = true;
    } else {
      projectaddcontroller.isEndedProject.value = false;
    }
  }

  void projecttaginput() {
    tagController.selectedtaglist.clear();
    for (var tag in controller.project.value.projectTag) {
      tagController.selectedtaglist.add(SelectedTagWidget(
        id: tag.tagId,
        text: tag.tag,
        selecttagtype: SelectTagtype.interesting,
        tagtype: Tagtype.project,
      ));
    }
  }

  void projectlooperinput() {
    if (controller.project.value.looper != null) {
      projectaddcontroller.selectedpersontaglist.clear();
      for (var user in controller.project.value.looper) {
        projectaddcontroller.selectedpersontaglist.add(SelectedTagWidget(
          id: user.userid,
          text: user.realName,
          selecttagtype: SelectTagtype.person,
          tagtype: Tagtype.project,
        ));
      }
    }
  }

  void projectthumbnailinput() {
    projectaddcontroller.projecturlthumbnail =
        controller.project.value.thumbnail;
    projectaddcontroller.projectthumbnail.value = File("");
  }
}

Widget updateProjectTile({
  required VoidCallback onTap,
  required String title,
  required String subtitle,
  required bool isSubtitleExist,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: (isSubtitleExist) ? 16 : 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kSubTitle2Style,
                ),
                if (isSubtitleExist)
                  SizedBox(
                    height: 12,
                  ),
                if (isSubtitleExist)
                  Text(
                    subtitle,
                    style: kSubTitle3Style,
                    overflow: TextOverflow.ellipsis,
                  )
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: mainblack,
            size: 28,
          ),
        ],
      ),
    ),
  );
}
