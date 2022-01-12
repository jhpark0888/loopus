// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class ProjectAddIntroScreen extends StatelessWidget {
  ProjectAddIntroScreen({
    Key? key,
    required this.screenType,
  }) : super(key: key);

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
                    Get.to(() => ProjectAddPeriodScreen(
                          screenType: Screentype.add,
                        ));
                  },
                  child: Text(
                    '다음',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: mainblue,
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
                                ProjectUpdateType.introduction);
                            await getproject(
                                    ProjectDetailController.to.project.value.id)
                                .then((value) {
                              ProjectDetailController.to.project(value);
                              ProjectDetailController
                                  .to.isProjectLoading.value = false;
                            });
                            Get.back();
                          },
                          child: Text(
                            '저장',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: mainblue,
                            ),
                          ),
                        ),
                )
        ],
        title: '활동 정보',
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          32,
          24,
          32,
          40,
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  '어떤 활동인지 간략하게 소개해주세요!',
                  style: kSubTitle1Style,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  '지금 적지 않아도 나중에 추가할 수 있어요',
                  style: kBody2Style,
                ),
              ),
              TextField(
                maxLines: 2,
                controller: projectaddcontroller.introcontroller,
                cursorWidth: 1.5,
                cursorRadius: Radius.circular(2),
                cursorColor: mainblack,
                style: TextStyle(
                  color: mainblack,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                decoration: InputDecoration(
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
                    hintText: 'OO를 주제로 진행한 프로젝트이며, OO 역할을 맡았습니다.'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
