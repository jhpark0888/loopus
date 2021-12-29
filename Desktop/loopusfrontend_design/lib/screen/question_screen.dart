import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/message_answer_widget.dart';
import 'package:loopus/widget/message_question_widget.dart';

class QuestionScreen extends StatelessWidget {
  // const QuestionScreen({Key? key}) : super(key: key);
  final TextEditingController _textController = new TextEditingController();
  QuestionController questionController = Get.find();
  late Map data;

  void _handleSubmitted(String text) async {
    print(text);
    data = await answermake(text, 2);
    questionController.messageanswerlist.add(MessageAnswerWidget(
        content: data["content"], image: "image", name: data["answerer"]));
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
                      hintText: " 답변 작성하기...",
                      focusColor: mainblue,
                      fillColor: mainlightgrey,
                      filled: true),
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
        title: "${questionController.questionModel2.questions.realname}님의 질문",
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                child: ListView(
                  children: [
                    Column(children: [
                      MessageQuestionWidget(
                        content:
                            questionController.questionModel2.questions.content,
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
    );
  }
}
