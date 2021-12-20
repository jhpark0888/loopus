// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class ProjectAddIntroScreen extends StatelessWidget {
  ProjectAddIntroScreen({Key? key}) : super(key: key);

  ProjectMakeController projectmakecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => ProjectAddPeriodScreen());
            },
            child: Text(
              '다음',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        title: '활동 추가',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  '어떤 활동인지 간략하게 소개해주세요!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  '지금 적지 않아도 나중에 추가할 수 있어요',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                cursorColor: Colors.black,
                maxLines: 2,
                controller: projectmakecontroller.introcontroller,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
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
