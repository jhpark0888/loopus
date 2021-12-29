import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/screen/report_screen.dart';
import 'package:loopus/widget/alertdialog2_widget.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/message_answer_widget.dart';
import 'package:loopus/widget/message_question_widget.dart';

class QuestionScreen extends StatelessWidget {
  final TextEditingController _textController = new TextEditingController();
  QuestionController questionController = Get.find();
  late Map data;

  void _handleSubmitted(String text) async {
    print(text);
    data =
        await answermake(text, questionController.questionModel2.questions.id);
    questionController.messageanswerlist.add(MessageAnswerWidget(
        content: data["content"], image: "image", name: data["real_name"]));
    questionController.answerfocus.unfocus();
    _textController.clear();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.black),
      child: Container(
        color: mainWhite,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  focusNode: questionController.answerfocus,
                  style: TextStyle(decoration: TextDecoration.none),
                  cursorColor: Color(0xFF424242),
                  controller: _textController,
                  onChanged: (text) {},
                  onSubmitted: _handleSubmitted,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      hintText: " 답변 남기기...",
                      hintStyle: TextStyle(fontSize: 14),
                      focusColor: mainblue,
                      fillColor: mainlightgrey,
                      filled: true),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 30,
                height: 20,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      _handleSubmitted(_textController.text);
                    },
                    child: Text(
                      "게시",
                      style: TextStyle(
                        color: mainblue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/Close.svg',
          ),
          onPressed: () {
            questionController.contentcontroller.clear();
            Get.back();
          },
        ),
        title: "${questionController.questionModel2.questions.realname}님의 질문",
        actions: [
          Obx(
            () => IconButton(
                onPressed: () {
                  if (questionController.check_alarm.value) {
                    questionController.check_alarm.value = false;
                    Get.dialog(
                      Dialog(
                        child: Container(
                          height: 80,
                          child: Center(
                            child: Text('알람이 취소되었습니다.'),
                          ),
                        ),
                      ),
                    );
                  } else {
                    questionController.check_alarm.value = true;
                    Get.dialog(
                      Dialog(
                        child: Container(
                          height: 80,
                          child: Center(
                            child: Text('답변이 달리면 알람을 보내드려요.'),
                          ),
                        ),
                      ),
                    );
                  }
                },
                icon: questionController.check_alarm.value == false
                    ? SvgPicture.asset(
                        'assets/icons/Bell_Inactive.svg',
                      )
                    : SvgPicture.asset(
                        'assets/icons/Bell_Active.svg',
                      )),
          ),
          IconButton(
              onPressed: () {
                Get.dialog(Alertdialog2Widget(
                  color_1: mainblack,
                  color_2: Colors.red,
                  text_1: "메세지 보내기",
                  text_2: "신고하기",
                  route_2: () {
                    print("SADasdsadasdsad");
                    Get.back();
                    Get.to(() => ReportScreen());
                  },
                ));
              },
              icon: SvgPicture.asset(
                'assets/icons/More.svg',
              ))
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          questionController.answerfocus.unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  child: ListView(
                    children: [
                      Column(children: [
                        MessageQuestionWidget(
                          content: questionController
                              .questionModel2.questions.content,
                          image: questionController
                                  .questionModel2.questions.profileimage ??
                              "",
                          name: questionController
                              .questionModel2.questions.realname,
                        ),
                        Obx(() => Column(
                              children: questionController.messageanswerlist,
                            )),
                      ]),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Divider(
                      color: mainlightgrey,
                      thickness: 17,
                    ),
                    _buildTextComposer(),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
