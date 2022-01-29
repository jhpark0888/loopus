import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/widget/question_answer_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class QuestionDetailController extends GetxController {
  QuestionDetailController({required this.questionid});
  static QuestionDetailController get to => Get.find();
  RxBool isQuestionDeleteLoading = false.obs;
  RxBool isQuestionLoading = false.obs;

  TextEditingController contentcontroller = TextEditingController();
  TextEditingController answertextController = TextEditingController();

  RxBool isemptytext = true.obs;
  RxList<QuestionAnswerWidget> messageanswerlist = <QuestionAnswerWidget>[].obs;
  FocusNode answerfocus = FocusNode();
  RxBool check_alarm = false.obs;
  RxBool isDropdown = false.obs;
  Rx<QuestionItem> question = QuestionItem(id: 0, user: 0, isuser: 0, content: '', answercount: 0, answer: [], adopt: false, date: DateTime.now(), department: '', questionTag: [], realname: '', profileimage: '',).obs;
  int questionid;
  // RxDouble textFormHeight = 36.0.obs;
  // Rx<GlobalKey> textFieldBoxKey = GlobalKey().obs;
  // Rx<Size> textBoxSize = Size(Get.width, 36).obs;

  @override
  void onInit() {
    loadItem(questionid);

    // answertextController.addListener(() {
    //   textBoxSize.value = getSize(textFieldBoxKey.value);
    // });
    super.onInit();
  }

  // getSize(GlobalKey key) {
  //   if (key.currentContext != null) {
  //     RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
  //     Size size = renderBox.size;
  //     return size;
  //   }
  //   return Size(Get.width, 36);
  // }

  var personselected = false.obs;

  Future<void> addanswer() async {
    messageanswerlist.clear();
    question.value.answer.forEach((answer) {
      messageanswerlist.add(QuestionAnswerWidget(
        answer: answer,
      ));
    });
  }

  Future<void> loadItem(int questionid) async {
    isQuestionLoading(true);
    await getquestion(questionid).then((value) {
      question(value);
      addanswer();
    isQuestionLoading(false);});
  }
}
