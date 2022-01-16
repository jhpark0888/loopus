import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/model/question_specific_model.dart';
import 'package:loopus/widget/message_answer_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class QuestionController extends GetxController {
  static QuestionController get to => Get.find();
  TextEditingController contentcontroller = TextEditingController();
  RxList<SelectedTagWidget> selectedtaglist = <SelectedTagWidget>[].obs;
  TextEditingController answertextController = TextEditingController();
  RxBool isemptytext = true.obs;
  TextEditingController tagsearch = TextEditingController();
  RxList<MessageAnswerWidget> messageanswerlist = <MessageAnswerWidget>[].obs;
  FocusNode answerfocus = FocusNode();
  RxBool ignore_check_add_q = true.obs;
  RxBool check_alarm = false.obs;
  RxBool isDropdown = false.obs;
  // RxDouble textFormHeight = 36.0.obs;
  // Rx<GlobalKey> textFieldBoxKey = GlobalKey().obs;
  // Rx<Size> textBoxSize = Size(Get.width, 36).obs;

  // @override
  // void onInit() {
  //   answertextController.addListener(() {
  //     textBoxSize.value = getSize(textFieldBoxKey.value);
  //   });
  //   super.onInit();
  // }

  // getSize(GlobalKey key) {
  //   if (key.currentContext != null) {
  //     RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
  //     Size size = renderBox.size;
  //     return size;
  //   }
  //   return Size(Get.width, 36);
  // }

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
        user: element2.user,
      ));
    });
  }

  Future<void> loadItem(int questionid) async {
    QuestionModel2 result = await specificquestion(questionid);
    questionModel2 = result;
  }
}
