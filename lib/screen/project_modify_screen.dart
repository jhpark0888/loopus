// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/inquiry_screen.dart';
import 'package:loopus/screen/privacypolicy_screen.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/screen/project_add_tag_screen.dart';
import 'package:loopus/screen/termsofservice_screen.dart';
import 'package:loopus/screen/userinfo_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class ProjectModifyScreen extends StatelessWidget {
  ProjectModifyScreen({Key? key, required this.project}) : super(key: key);

  ProjectAddController projectaddcontroller = Get.put(ProjectAddController());
  TagController tagController = Get.put(TagController());

  Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          actions: [
            TextButton(
              onPressed: () {
                // Get.to(() => ActivityAddPeriodScreen());
                Get.back();
              },
              child: Text(
                '완료',
                style: kSubTitle2Style.copyWith(color: mainblue),
              ),
            ),
          ],
          title: '활동 편집',
        ),
        body: ListView(
          children: [
            ListTile(
              onTap: () {
                Get.to(() => ProjectAddTitleScreen(
                      screenType: Screentype.update,
                    ));
              },
              title: Text('활동명', style: kSubTitle2Style),
              subtitle: Text(project.projectName, style: kSubTitle4Style),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => ProjectAddPeriodScreen());
              },
              title: Text('활동 기간', style: kSubTitle2Style),
              subtitle: Text(
                  '${project.startDate!.substring(0, 4)}.${project.startDate!.substring(5, 7)} ~ ${project.endDate != null ? project.endDate!.substring(0, 4) : ''}.${project.endDate != null ? project.endDate!.substring(5, 7) : ''}',
                  style: kSubTitle4Style),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => ProjectAddIntroScreen());
              },
              title: Text('활동 정보', style: kSubTitle2Style),
              subtitle: Text(project.introduction!, style: kSubTitle4Style),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => ProjectAddTagScreen());
              },
              title: Text('활동 태그', style: kSubTitle2Style),
              subtitle: Text(
                  project.projectTag.isEmpty
                      ? ''
                      : '${project.projectTag[0].tag}, ${project.projectTag[1].tag}, 태그 하나 추가 해야함',
                  style: kSubTitle4Style),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => ProjectAddPersonScreen());
              },
              title: Text('함께 활동한 사람', style: kSubTitle2Style),
              subtitle: Text(project.looper!.isEmpty ? '' : '',
                  style: kSubTitle4Style),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
          ],
        ));
  }
}
