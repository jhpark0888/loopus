import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/widget/home_posting_widget.dart';
import 'package:loopus/widget/question_posting_widget.dart';
import 'package:loopus/widget/recommend_posting_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  List<HomePostingWidget> posting = [];
  List<RecommendPostingWidget> recommend_posting = [];
  bool bookmark = false;
  RxBool enablepullup = true.obs;
  var selectgroup = "모든 질문".obs;
  Rx<QuestionModel> questionResult = QuestionModel(QuestionItem(
    myQuestions: [
      Question(
          id: 0,
          user: 0,
          questioner: "",
          content: "",
          answers: [],
          adopt: null,
          date: null,
          questionTag: [],
          realname: "",
          profileimage: null)
    ].obs,
    questions: [
      Question(
          id: 0,
          user: 0,
          questioner: "",
          content: "",
          answers: [],
          adopt: null,
          date: null,
          questionTag: [],
          realname: "",
          profileimage: null)
    ].obs,
  )).obs;
  RefreshController refreshController =
      new RefreshController(initialRefresh: true);
  int pageNumber = 1;

  @override
  void onInit() {
    for (int i = 0; i < 4; i++) {
      posting.add(HomePostingWidget());
      // qustion_posting.add(QuestionPostingWidget());
      recommend_posting.add(RecommendPostingWidget());
    }
    super.onInit();
  }

  void onRefresh() async {
    enablepullup.value = true;
    questionResult(QuestionModel(QuestionItem(
      myQuestions: [
        Question(
            id: 0,
            user: 0,
            questioner: "",
            content: "",
            answers: [],
            adopt: null,
            date: null,
            questionTag: [],
            realname: "",
            profileimage: null)
      ].obs,
      questions: [
        Question(
            id: 0,
            user: 0,
            questioner: "",
            content: "",
            answers: [],
            adopt: null,
            date: null,
            questionTag: [],
            realname: "",
            profileimage: null)
      ].obs,
    )));

    pageNumber = 1;
    loadItem();
    await Future.delayed(Duration(microseconds: 500));
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    pageNumber += 1;
    await Future.delayed(Duration(microseconds: 500));
    //페이지 처리
    loadItem();
    refreshController.loadComplete();
  }

  void loadItem() async {
    QuestionModel questionModel = await questionlist(pageNumber);
    QuestionModel questionModel2 = await questionlist(pageNumber + 1);
    if (pageNumber == 1) {
      questionResult.value.questionitems.myQuestions
          .addAll(questionModel.questionitems.myQuestions);
    }

    if (questionModel.questionitems.questions[0].id ==
        questionModel2.questionitems.questions[0].id) {
      enablepullup.value = false;
    }

    questionResult.value.questionitems.questions
        .addAll(questionModel.questionitems.questions);
    print(questionResult.value.questionitems.questions.length);
  }
}
