import 'package:flutter/material.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';

class QuestionAnswerScreen extends StatelessWidget {
  // const QuestionAnswerScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: HomeController.to.qustion_posting,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainFontDark,
        onPressed: () {},
        child: Icon(Icons.edit),
      ),
    );
  }
}
