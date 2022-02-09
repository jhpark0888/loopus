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
        bottomBorder: false,
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
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 40),
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
                      questionaddController.ignore_check_add_q.value = false;
                    }
                  }
                },
                inputFormatters: [
                  // TextInputFormatter
                ],
                autocorrect: false,
                controller: questionaddController.contentcontroller,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                cursorColor: mainblue,
                cursorWidth: 1.3,
                cursorRadius: const Radius.circular(500),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '질문 내용을 작성해주세요',
                ),
                style: TextStyle(
                  fontSize: 16.0,
                  color: mainblack,
                  height: 1.6,
                ),
                toolbarOptions: const ToolbarOptions(
                  cut: true,
                  copy: true,
                  paste: true,
                  selectAll: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
