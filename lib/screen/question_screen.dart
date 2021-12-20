import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/widget/message_answer_widget.dart';
import 'package:loopus/widget/message_question_widget.dart';

class QuestionScreen extends StatelessWidget {
  // const QuestionScreen({Key? key}) : super(key: key);
  final TextEditingController _textController = new TextEditingController();
  QuestionController questionController = Get.find();

  void _handleSubmitted(String text) async {
    print(text);
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.black),
      child: Container(
        color: mainWhite,
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                style: TextStyle(decoration: TextDecoration.none),
                cursorColor: Color(0xFF424242),
                controller: _textController,
                onChanged: (text) {},
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "  답변 작성하기...",
                    focusColor: mainWhite,
                    fillColor: mainWhite),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              child: InkWell(
                  onTap: () => _handleSubmitted(_textController.text),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                      decoration: BoxDecoration(
                          color: mainlightgrey,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "작성",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800]),
                      ))),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "${questionController.questionModel2.questions.realname}님의 질문",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
              children: List.generate(
                  questionController.questionModel2.questions.answers.length +
                      1, (index) {
            return index == 0
                ? MessageQuestionWidget(
                    content:
                        questionController.questionModel2.questions.content,
                    image: questionController
                            .questionModel2.questions.profileimage ??
                        "",
                    name: questionController.questionModel2.questions.realname,
                  )
                : questionController.questionModel2.questions.answers[index - 1]
                            .realname ==
                        questionController.questionModel2.questions.realname
                    ? MessageQuestionWidget(
                        content: questionController.questionModel2.questions
                            .answers[index - 1].content,
                        image: questionController.questionModel2.questions
                                .answers[index - 1].profileimage ??
                            "",
                        name: questionController.questionModel2.questions
                                .answers[index - 1].realname ??
                            "",
                      )
                    : MessageAnswerWidget(
                        content: questionController.questionModel2.questions
                            .answers[index - 1].content,
                        image: questionController.questionModel2.questions
                                .answers[index - 1].profileimage ??
                            "",
                        name: questionController.questionModel2.questions
                                .answers[index - 1].realname ??
                            "",
                      );
          })
              // MessageQuestionWidget(content: '', image: '', name: questionController.questionModel2.questions.realname,),
              // MessageAnswerWidget(),

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
