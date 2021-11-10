// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';

class ProjectAddNameScreen extends StatelessWidget {
  ProjectAddNameScreen({Key? key}) : super(key: key);

  ProjectMakeController projectmakecontroller =
      Get.put(ProjectMakeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => ProjectAddIntroScreen());
            },
            child: Text(
              '다음',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  '활동명이 무엇인가요?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  '어떤 활동인지 잘 드러나는 이름을 입력해주세요',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                cursorColor: Colors.black,
                controller: projectmakecontroller.namecontroller,
                decoration: InputDecoration(
                  hintText: 'OO 스터디, OO 공모전, OO 프로젝트...',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
