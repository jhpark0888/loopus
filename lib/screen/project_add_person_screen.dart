// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';

class ProjectAddPersonScreen extends StatelessWidget {
  ProjectAddPersonScreen({Key? key}) : super(key: key);

  ProjectMakeController projectmakecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Get.to(() => ActivityAddPeriodScreen());
            },
            child: Text(
              '완료',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        title: const Text(
          '활동 추가',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Text(
                '이 활동을 함께 진행한 학생이 있나요?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                '루프 중인 학생만 추가할 수 있어요',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '선택한 사람',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: projectmakecontroller.selectedpersonlist,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '루프 중인 사람',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '0명',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Obx(
                    () => Theme(
                      data: ThemeData(
                        unselectedWidgetColor: Colors.black,
                      ),
                      child: CheckboxListTile(
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        value: projectmakecontroller.personselected.value,
                        onChanged: (bool? value) {
                          projectmakecontroller.personselected.value =
                              value ?? false;
                        },
                        // shape: ShapeBorder(),
                        secondary: ClipOval(
                            child: CachedNetworkImage(
                          height: 56,
                          width: 56,
                          imageUrl: "https://i.stack.imgur.com/l60Hf.png",
                          placeholder: (context, url) => const CircleAvatar(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          fit: BoxFit.fill,
                        )),
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          '손승태',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '산업경영공학과',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
