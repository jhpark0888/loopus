// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class ProjectAddNameScreen extends StatelessWidget {
  ProjectAddNameScreen({Key? key}) : super(key: key);

  ProjectMakeController projectmakecontroller =
      Get.put(ProjectMakeController());
  TagController tagController = Get.put(TagController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => ProjectAddIntroScreen());
            },
            child: Text(
              '다음',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mainblue,
              ),
            ),
          ),
        ],
        title: '활동명',
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          32,
          24,
          32,
          40,
        ),
        child: Column(
          children: [
            Text(
              '활동명이 무엇인가요?',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '어떤 활동인지 잘 드러나는 이름을 입력해주세요',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            TextField(
              minLines: 1,
              maxLines: 2,
              maxLength: 32,
              autocorrect: false,
              cursorWidth: 1.5,
              cursorRadius: Radius.circular(2),
              style: TextStyle(
                color: mainblack,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
              cursorColor: mainblack,
              controller: projectmakecontroller.projectnamecontroller,
              decoration: InputDecoration(
                hintText: 'OO 스터디, OO 공모전, OO 프로젝트...',
                hintStyle: TextStyle(
                  color: mainblack.withOpacity(0.38),
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: BorderSide(color: mainblack, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: BorderSide(color: mainblack, width: 1),
                ),
                errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: BorderSide(color: mainpink, width: 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
