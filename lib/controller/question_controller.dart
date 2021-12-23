import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/model/question_specific_model.dart';
import 'package:loopus/widget/message_answer_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class QuestionController extends GetxController {
  static QuestionController get to => Get.find();
  TextEditingController contentcontroller = TextEditingController();
  RxList<SelectedTagWidget> selectedtaglist = <SelectedTagWidget>[].obs;
  TextEditingController tagsearch = TextEditingController();
  RxList<MessageAnswerWidget> messageanswerlist = <MessageAnswerWidget>[].obs;
  FocusNode answerfocus = FocusNode();
  RxBool ignore_check_add_q = true.obs;
  RxBool check_alarm = false.obs;
  RxBool isDropdown = false.obs;

  @override
  void onInit() {
    // ignore_check_add_q.value = false;
    super.onInit();
  }

  QuestionModel2 questionModel2 = QuestionModel2(QuestionItem(
      adopt: null,
      answer: [],
      content: '',
      date: null,
      department: '',
      id: 0,
      is_user: -1,
      profileimage: '',
      questionTag: [],
      realname: '',
      user: 0));

  var personselected = false.obs;

  Future<void> addanswer() async {
    messageanswerlist.clear();
    questionModel2.questions.answer.forEach((element2) {
      messageanswerlist.add(MessageAnswerWidget(
        content: element2.content,
        image: element2.profileimage ?? "",
        name: element2.realname ?? "",
      ));
    });
  }

  Future<void> loadItem(int questionid) async {
    QuestionModel2 result = await specificquestion(questionid);
    print("hihi");
    print(result);
    questionModel2 = result;
  }
}
