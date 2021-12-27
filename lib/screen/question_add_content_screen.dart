// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/screen/question_add_tag_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class QuestionAddContentScreen extends StatelessWidget {
  // ProjectAddNameScreen({Key? key}) : super(key: key);
  QuestionController questionController = Get.put(QuestionController());
  ProjectAddController projectmakecontroller = Get.put(ProjectAddController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          Obx(
            () => IgnorePointer(
              ignoring: questionController.ignore_check_add_q.value,
              child: TextButton(
                onPressed: () {
                  Get.to(() => QuestionAddTagScreen());
                },
                child: questionController.ignore_check_add_q.value == true
                    ? Text(
                        '다음',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      )
                    : Text(
                        '다음',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ),
        ],
        title: '질문 내용',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    if (value == "") {
                      print(value);
                      questionController.ignore_check_add_q.value = true;
                      print(questionController.ignore_check_add_q.value);
                    } else {
                      if (questionController.ignore_check_add_q.value == true) {
                        questionController.ignore_check_add_q.value = false;
                      }
                    }
                  },
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
