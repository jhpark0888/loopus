import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
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
import 'package:loopus/widget/selected_persontag_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class ProjectModifyScreen extends StatelessWidget {
  ProjectModifyScreen({Key? key, required this.project}) : super(key: key);

  ProjectAddController projectaddcontroller = Get.put(ProjectAddController());
  TagController tagController = Get.put(TagController());

  Rx<Project> project;
  Project? exproject;

  @override
  Widget build(BuildContext context) {
    datainput();
    return Scaffold(
        appBar: AppBarWidget(
          title: '활동 편집',
          leading: IconButton(
            onPressed: () {
              Get.back(result: project.value);
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
                  exproject = await Get.to(() => ProjectAddTitleScreen(
                        screenType: Screentype.update,
                        project: project.value,
                      ));
                  project(exproject);
                },
                project: project.value,
                title: '활동명',
                subtitle: project.value.projectName,
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  exproject = await Get.to(() => ProjectAddPeriodScreen(
                        screenType: Screentype.update,
                        project: project.value,
                      ));
                  project(exproject);
                },
                project: project.value,
                title: '활동 기간',
                subtitle:
                    '${DateFormat("yyyy.MM").format(project.value.startDate!)} ~ ${project.value.endDate != null ? DateFormat("yyyy.MM").format(project.value.endDate!) : ''}',
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  exproject = await Get.to(() => ProjectAddIntroScreen(
                        screenType: Screentype.update,
                        project: project.value,
                      ));
                  project(exproject);
                },
                project: project.value,
                title: '활동 정보',
                subtitle: project.value.introduction!,
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: true,
                onTap: () async {
                  exproject = await Get.to(() => ProjectAddTagScreen(
                        screenType: Screentype.update,
                        project: project.value,
                      ));
                  project(exproject);
                },
                project: project.value,
                title: '활동 태그',
                subtitle: project.value.projectTag.isEmpty
                    ? ''
                    : '${project.value.projectTag[0].tag}, ${project.value.projectTag[1].tag}, ${project.value.projectTag[2].tag}',
              ),
            ),
            Obx(
              () => updateProjectTile(
                isSubtitleExist: project.value.looper!.isEmpty ? false : true,
                onTap: () async {
                  exproject = await Get.to(() => ProjectAddPersonScreen(
                        screenType: Screentype.update,
                        project: project.value,
                      ));
                  project(exproject);
                },
                project: project.value,
                title: '함께 활동한 사람',
                subtitle: project.value.looper!.isEmpty
                    ? '함께 활동한 사람이 없어요'
                    : '함께 활동한 사람이 없어요',
              ),
            ),
            updateProjectTile(
              isSubtitleExist: false,
              onTap: () async {
                exproject = await Get.to(() => ProjectAddThumbnailScreen(
                      screenType: Screentype.update,
                      project: project.value,
                    ));
                project(exproject);
              },
              project: project.value,
              title: '대표 사진 변경',
              subtitle: '',
            ),
          ],
        ));
  }

  void datainput() {
    projectaddcontroller.projectnamecontroller.text = project.value.projectName;

    projectaddcontroller.introcontroller.text =
        project.value.introduction ?? '';

    projectaddcontroller.startyearcontroller.text =
        project.value.startDate!.year.toString();
    projectaddcontroller.startmonthcontroller.text =
        DateFormat("MM").format(project.value.startDate!);
    projectaddcontroller.startdaycontroller.text =
        DateFormat("dd").format(project.value.startDate!);

    if (project.value.endDate == null) {
      projectaddcontroller.isvaildstartdate(true);
      projectaddcontroller.isongoing(true);
    } else {
      projectaddcontroller.endyearcontroller.text =
          project.value.startDate!.year.toString();
      projectaddcontroller.endmonthcontroller.text =
          DateFormat("MM").format(project.value.endDate!);
      projectaddcontroller.enddaycontroller.text =
          DateFormat("dd").format(project.value.endDate!);
      projectaddcontroller.isvaildstartdate(true);
      projectaddcontroller.isvaildenddate(true);
    }
    tagController.selectedtaglist.clear();
    for (var tag in project.value.projectTag) {
      tagController.selectedtaglist.add(SelectedTagWidget(
        id: tag.tagId,
        text: tag.tag,
      ));
    }
    if (project.value.looper != null) {
      tagController.selectedpersontaglist.clear();
      for (var tag in project.value.looper!) {
        tagController.selectedpersontaglist.add(SelectedPersonTagWidget(
          id: tag.tagId,
          text: tag.tag,
        ));
      }
    }

    projectaddcontroller.projecturlthumbnail = project.value.thumbnail;
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
