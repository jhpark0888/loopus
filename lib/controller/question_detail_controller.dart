import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/question_answer_widget.dart';

class QuestionDetailController extends GetxController {
  QuestionDetailController({required this.questionid});
  static QuestionDetailController get to => Get.find();
  RxBool isQuestionDeleteLoading = false.obs;
  // RxBool isQuestionLoading = false.obs;
  Rx<ScreenState> questionscreenstate = ScreenState.loading.obs;

  TextEditingController answertextController = TextEditingController();

  ScrollController scrollController = ScrollController();

  KeyboardVisibilityController keyboardController =
      KeyboardVisibilityController();

  RxBool isSendButtonon = false.obs;
  RxList<QuestionAnswerWidget> answerlist = <QuestionAnswerWidget>[].obs;
  FocusNode answerfocus = FocusNode();
  RxBool checkAlert = false.obs;
  RxBool isDropdown = false.obs;
  Rx<QuestionItem> question = QuestionItem(
          id: 0,
          userid: 0,
          isuser: 0,
          content: '',
          answercount: 0,
          answer: [],
          adopt: false,
          date: DateTime.now(),
          questionTag: [],
          user: User(
              userid: 0,
              realName: "",
              type: 0,
              department: "",
              loopcount: 0.obs,
              totalposting: 0,
              isuser: 0,
              profileTag: [],
              looped: FollowState.normal.obs))
      .obs;

  int questionid;

  RxDouble textFormHeight = 0.0.obs;
  Rx<GlobalKey> textFieldBoxKey = GlobalKey().obs;
  Rx<Size> textBoxSize = Size(Get.width, 0).obs;

  @override
  void onInit() {
    loadquestion(questionid);

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
          scrollController.animateTo(scrollController.offset,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        }
      } else {
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.offset,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
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
    for (var answer in question.value.answer) {
      answerlist.add(QuestionAnswerWidget(
        answer: answer,
      ));
    }
  }

  Future<void> loadquestion(int questionid) async {
    questionscreenstate(ScreenState.loading);
    await getquestion(questionid);
  }
}

class QuestionScrollController extends GetxController {
  QuestionScrollController({required this.questionid});

  int questionid;
  late ScrollController questionscrollController =
      Get.find<QuestionDetailController>(tag: questionid.toString())
          .scrollController;

  @override
  void onReady() {
    // TODO: implement onReady
    if (questionscrollController.hasClients) {
      questionscrollController
          .jumpTo(questionscrollController.position.maxScrollExtent);
    }
    super.onReady();
  }
}
