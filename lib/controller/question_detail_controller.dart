import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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

  TextEditingController answertextController = TextEditingController();

  ScrollController scrollController = ScrollController();

  KeyboardVisibilityController keyboardController =
      KeyboardVisibilityController();

  RxBool isSendButtonon = false.obs;
  RxList<QuestionAnswerWidget> answerlist = <QuestionAnswerWidget>[].obs;
  FocusNode answerfocus = FocusNode();
  RxBool check_alarm = false.obs;
  RxBool isDropdown = false.obs;
  Rx<QuestionItem> question = QuestionItem(
    id: 0,
    user: 0,
    isuser: 0,
    content: '',
    answercount: 0,
    answer: [],
    adopt: false,
    date: DateTime.now(),
    department: '',
    questionTag: [],
    realname: '',
    profileimage: '',
  ).obs;

  int questionid;

  RxDouble textFormHeight = 0.0.obs;
  Rx<GlobalKey> textFieldBoxKey = GlobalKey().obs;
  Rx<Size> textBoxSize = Size(Get.width, 0).obs;

  @override
  void onInit() {
    loadItem(questionid);

    answertextController.addListener(() {
      textBoxSize.value = getSize(textFieldBoxKey.value);

      if (answertextController.text.replaceAll(" ", "") == "") {
        isSendButtonon(false);
      } else {
        isSendButtonon(true);
      }
    });

    keyboardController.onChange.listen((isVisible) {
      if (isVisible) {
        if (scrollController.hasClients) {
          print("키보드 on ${scrollController.offset}");
          scrollController.animateTo(scrollController.offset,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      } else {
        if (scrollController.hasClients) {
          print("키보드 off ${scrollController.offset}");

          scrollController.animateTo(scrollController.offset,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      }
    });
    super.onInit();
  }

  getSize(GlobalKey key) {
    if (key.currentContext != null) {
      RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
    return Size(Get.width, 36);
  }

  var personselected = false.obs;

  Future<void> addanswer() async {
    answerlist.clear();
    question.value.answer.forEach((answer) {
      answerlist.add(QuestionAnswerWidget(
        answer: answer,
      ));
    });
  }

  Future<void> loadItem(int questionid) async {
    isQuestionLoading(true);
    await getquestion(questionid).then((value) {
      question(value);
      addanswer();
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
      isQuestionLoading(false);
    });
  }
}
