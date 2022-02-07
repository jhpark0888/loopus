import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/question_add_controller.dart';
import 'package:loopus/controller/question_detail_controller.dart';
import 'package:loopus/screen/question_add_tag_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class QuestionAddContentScreen extends StatelessWidget {
  // ProjectAddNameScreen({Key? key}) : super(key: key);
  QuestionAddController questionaddController =
      Get.put(QuestionAddController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
              onPressed: () {
                if (questionaddController.ignore_check_add_q.value == false) {
                  Get.to(() => QuestionAddTagScreen());
                }
              },
              child: Obx(
                () => Text(
                  '다음',
                  style: questionaddController.ignore_check_add_q.value == false
                      ? kSubTitle2Style.copyWith(color: mainblue)
                      : kSubTitle2Style.copyWith(
                          color: mainblack.withOpacity(0.38)),
                ),
              )),
        ],
        title: '질문 내용',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Expanded(
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      if (value == "") {
                        print(value);
                        questionaddController.ignore_check_add_q.value = true;
                        print(questionaddController.ignore_check_add_q.value);
                      } else {
                        if (questionaddController.ignore_check_add_q.value ==
                            true) {
                          questionaddController.ignore_check_add_q.value =
                              false;
                        }
                      }
                    },
                    cursorColor: Colors.black,
                    controller: questionaddController.contentcontroller,
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
      ),
    );
  }
}
