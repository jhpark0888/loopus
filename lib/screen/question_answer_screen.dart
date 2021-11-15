import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/screen/question_add_content_screen.dart';

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
        backgroundColor: mainblack,
        onPressed: () {
          Get.to(() => QuestionAddContnetnScreen());
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
