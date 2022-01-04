// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/get_image_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_widget.dart';

class ProjectAddThumbnailScreen extends StatelessWidget {
  ProjectAddThumbnailScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  ProjectAddController projectAddController = Get.put(ProjectAddController());
  TagController tagController = Get.put(TagController());
  var image = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Get.to(() => ProjectAddIntroScreen());
              }
            },
            child: Text(
              '저장',
              style: kSubTitle2Style.copyWith(color: mainblue),
            ),
          ),
        ],
        title: '대표 사진',
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
              '대표 사진을 설정해주세요',
              style: kSubTitle1Style,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '나중에 수정할 수 있어요',
              style: kBody2Style,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                image = await getcropImage(imagetype.thumnail);
                if (image != null) {
                  projectAddController.projectimage(image);
                }
              },
              child: Container(
                width: 141,
                height: 32,
                decoration: BoxDecoration(
                  color: mainblue,
                  borderRadius: BorderRadius.circular(4),
                ),
                // color: Colors.grey[400],

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Center(
                    child: Text('대표 사진 변경하기',
                        style: kButtonStyle.copyWith(color: mainWhite)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '내 프로필에 이렇게 보여요',
                style: kSubTitle2Style,
              ),
            ),
            SizedBox(height: 16),
            Obx(
              () => ProjectWidget(
                project: Project(
                  id: 0,
                  projectName: projectAddController.projectnamecontroller.text,
                  projectTag: tagController.selectedtaglist
                      .map((tag) => Tag(tagId: tag.id ?? 0, tag: tag.text))
                      .toList(),
                  startDate:
                      '${projectAddController.startyearcontroller.text}-${projectAddController.startmonthcontroller.text}-${projectAddController.startdaycontroller.text}',
                  endDate: projectAddController.isongoing.value
                      ? null
                      : '${projectAddController.endyearcontroller.text}-${projectAddController.endmonthcontroller.text}-${projectAddController.enddaycontroller.text}',
                  like_count: 0,
                ),
                // image: projectAddController.projectimage
              ),
            ),
          ],
        ),
      ),
    );
  }
}
