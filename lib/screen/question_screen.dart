import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/message_answer_widget.dart';
import 'package:loopus/widget/message_question_widget.dart';

class QuestionScreen extends StatelessWidget {
  // const QuestionScreen({Key? key}) : super(key: key);
  final TextEditingController _textController = new TextEditingController();

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
          "손승태님의 질문",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              MessageQuestionWidget(),
              MessageAnswerWidget(),
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
