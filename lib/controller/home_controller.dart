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
  Rx<QuestionModel> questionResult = QuestionModel(questionitems: []).obs;
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
    questionResult(QuestionModel(questionitems: []));

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
    if (selectgroup == "모든 질문") {
      QuestionModel questionModel = await questionlist(pageNumber, "any");
      QuestionModel questionModel2 = await questionlist(pageNumber + 1, "any");

      if (questionModel.questionitems[0].id ==
          questionModel2.questionitems[0].id) {
        enablepullup.value = false;
      }
      print(questionModel.questionitems);
      // if (pageNumber == 1) {
      //   questionResult.update((val) {
      //     val!.questionitems.addAll(questionModel.questionitems);
      //   });
      // }
      questionResult.update((val) {
        val!.questionitems.addAll(questionModel.questionitems);
      });
      print(questionResult.value.questionitems.length);
      print(questionResult.value.questionitems);
    } else {
      QuestionModel questionModel = await questionlist(pageNumber, "my");
      QuestionModel questionModel2 = await questionlist(pageNumber + 1, "my");

      if (questionModel.questionitems[0].id ==
          questionModel2.questionitems[0].id) {
        enablepullup.value = false;
      }
      print(questionModel.questionitems);
      // if (pageNumber == 1) {
      //   questionResult.update((val) {
      //     val!.questionitems.addAll(questionModel.questionitems);
      //   });
      // }
      questionResult.update((val) {
        val!.questionitems.addAll(questionModel.questionitems);
      });
      print(questionResult.value.questionitems.length);
      print(questionResult.value.questionitems);
    }
  }
}
