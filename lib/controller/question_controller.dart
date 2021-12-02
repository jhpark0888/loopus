import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/widget/message_answer_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class QuestionController extends GetxController {
  static QuestionController get to => Get.find();
  TextEditingController contentcontroller = TextEditingController();
  RxList<SelectedTagWidget> selectedtaglist = <SelectedTagWidget>[].obs;
  TextEditingController tagsearch = TextEditingController();
  RxList<MessageAnswerWidget> messageanswerlist = <MessageAnswerWidget>[].obs;
  QuestionModel2 questionModel2 = QuestionModel2(Question(
      id: 0,
      user: 0,
      questioner: "",
      content: "",
      answers: [],
      adopt: null,
      date: null,
      questionTag: [],
      realname: "",
      profileimage: null));

  var personselected = false.obs;

  Future<void> addanswer() async {
    questionModel2.questions.answers.forEach((element) {
      messageanswerlist.add(MessageAnswerWidget(
        content: element.content,
        image: element.profileimage ?? "",
        name: element.realname ?? "",
      ));
    });
  }

  Future<void> loadItem(int questionid) async {
    QuestionModel2 result = await specificquestion(questionid);
    print("hihi");
    questionModel2.questions = result.questions;
  }
}
