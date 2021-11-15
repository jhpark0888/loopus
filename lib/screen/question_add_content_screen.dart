// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';
import 'package:loopus/screen/project_add_tag_screen.dart';

class QuestionAddContnetnScreen extends StatelessWidget {
  // ProjectAddNameScreen({Key? key}) : super(key: key);
  QuestionController questionController = Get.put(QuestionController());
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
              Get.to(() => ProjectAddTagScreen(
                    content1: '질문 태그를 선택해주세요!',
                    content2: '해당 태그에 관심있는 학생에게 질문을 보여드려요.',
                    textbtn: '올리기',
                    title: '질문 태그',
                  ));
            },
            child: Text(
              '다음',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        title: const Text(
          '질문 내용',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                TextField(
                  cursorColor: Colors.black,
                  controller: questionController.contentcontroller,
                  maxLines: 20,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '어떤 질문을 남기시겠어요?',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
