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
  ProjectModifyScreen({
    Key? key,
  }) : super(key: key);

  ProjectAddController projectaddcontroller = Get.put(ProjectAddController());
  ProjectDetailController projectDetailController = Get.find();
  TagController tagController = Get.put(TagController());

  // Rx<Project> project;
  Project? exproject;

  @override
  Widget build(BuildContext context) {
    projectnameinput();
    projectdateinput();
    projectintroinput();
    projecttaginput();
    projectlooperinput();
    projectthumbnailinput();
    return Scaffold(
        appBar: AppBarWidget(
          title: '활동 편집',
          leading: IconButton(
            onPressed: () {
              Get.back(result: projectDetailController.project.value);
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
                        screenType: Screentype.update,
                      ));
                },
                project: projectDetailController.project.value,
                title: '활동명',
                subtitle: projectDetailController.project.value.projectName,
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  projectdateinput();
                  Get.to(() => ProjectAddPeriodScreen(
                        screenType: Screentype.update,
                      ));
                },
                project: projectDetailController.project.value,
                title: '활동 기간',
                subtitle:
                    '${DateFormat("yyyy.MM").format(projectDetailController.project.value.startDate!)} ~ ${projectDetailController.project.value.endDate != null ? DateFormat("yyyy.MM").format(projectDetailController.project.value.endDate!) : ''}',
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  projectintroinput();
                  Get.to(() => ProjectAddIntroScreen(
                        screenType: Screentype.update,
                      ));
                },
                project: projectDetailController.project.value,
                title: '활동 정보',
                subtitle: projectDetailController.project.value.introduction!,
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  projecttaginput();
                  Get.to(() => ProjectAddTagScreen(
                        screenType: Screentype.update,
                      ));
                },
                project: projectDetailController.project.value,
                title: '활동 태그',
                subtitle: projectDetailController
                        .project.value.projectTag.isEmpty
                    ? ''
                    : '${projectDetailController.project.value.projectTag[0].tag}, ${projectDetailController.project.value.projectTag[1].tag}, ${projectDetailController.project.value.projectTag[2].tag}',
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  projectlooperinput();
                  projectaddcontroller.islooppersonloading(true);
                  getlooplist(ProfileController.to.myUserInfo.value.user)
                      .then((value) {
                    projectaddcontroller.looplist = value;
                    projectaddcontroller.looppersonlist(projectaddcontroller
                        .looplist
                        .map((user) => CheckBoxPersonWidget(user: user))
                        .toList());
                    projectaddcontroller.islooppersonloading(false);
                  });
                  Get.to(() => ProjectAddPersonScreen(
                        screenType: Screentype.update,
                      ));
                },
                project: projectDetailController.project.value,
                title: '함께 활동한 사람',
                subtitle: projectDetailController.project.value.looper.isEmpty
                    ? '함께 활동한 사람이 없어요'
                    : projectDetailController.project.value.looper
                        .map((user) => user.realName)
                        .toString(),
              ),
            ),
            updateProjectTile(
              isSubtitleExist: false,
              onTap: () async {
                projectthumbnailinput();
                Get.to(() => ProjectAddThumbnailScreen(
                      screenType: Screentype.update,
                    ));
              },
              project: projectDetailController.project.value,
              title: '대표 사진 변경',
              subtitle: '',
            ),
          ],
        ));
  }

  void projectnameinput() {
    projectaddcontroller.projectnamecontroller.text =
        projectDetailController.project.value.projectName;
  }

  void projectintroinput() {
    projectaddcontroller.introcontroller.text =
        projectDetailController.project.value.introduction ?? '';
  }

  void projectdateinput() {
    projectaddcontroller.startyearcontroller.text = DateFormat("yyyy")
        .format(projectDetailController.project.value.startDate!);
    projectaddcontroller.startmonthcontroller.text = DateFormat("MM")
        .format(projectDetailController.project.value.startDate!);
    projectaddcontroller.startdaycontroller.text = DateFormat("dd")
        .format(projectDetailController.project.value.startDate!);

    if (projectDetailController.project.value.endDate == null) {
      projectaddcontroller.isvaildstartdate(true);
      projectaddcontroller.isongoing(true);
    } else {
      projectaddcontroller.endyearcontroller.text = DateFormat("yyyy")
          .format(projectDetailController.project.value.endDate!);
      projectaddcontroller.endmonthcontroller.text = DateFormat("MM")
          .format(projectDetailController.project.value.endDate!);
      projectaddcontroller.enddaycontroller.text = DateFormat("dd")
          .format(projectDetailController.project.value.endDate!);
      projectaddcontroller.isvaildstartdate(true);
      projectaddcontroller.isvaildenddate(true);
    }
  }

  void projecttaginput() {
    tagController.selectedtaglist.clear();
    for (var tag in projectDetailController.project.value.projectTag) {
      tagController.selectedtaglist.add(SelectedTagWidget(
        id: tag.tagId,
        text: tag.tag,
      ));
    }
  }

  void projectlooperinput() {
    if (projectDetailController.project.value.looper != null) {
      projectaddcontroller.selectedpersontaglist.clear();
      for (var user in projectDetailController.project.value.looper) {
        projectaddcontroller.selectedpersontaglist.add(SelectedPersonTagWidget(
          id: user.user,
          text: user.realName,
        ));
      }
    }
  }

  void projectthumbnailinput() {
    projectaddcontroller.projecturlthumbnail =
        projectDetailController.project.value.thumbnail;
  }
}

Widget updateProjectTile({
  required VoidCallback onTap,
  required Project project,
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
