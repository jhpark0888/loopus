import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/widget/home_posting_widget.dart';
import 'package:loopus/widget/question_posting_widget.dart';
import 'package:loopus/widget/recommend_posting_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin {
  static HomeController get to => Get.find();
  List<HomePostingWidget> posting = [];
  List<RecommendPostingWidget> recommend_posting = [];
  RxBool bookmark = false.obs;
  RxBool isempty = false.obs;
  RxBool enablepullup1 = true.obs;
  RxBool enablepullup2 = true.obs;
  RxBool enablepullup3 = true.obs;
  var selectgroup = "모든 질문".obs;
  Rx<QuestionModel> questionResult = QuestionModel(questionitems: []).obs;
  Rx<PostingModel> postingResult = PostingModel(postingitems: []).obs;
  Rx<PostingModel> loopResult = PostingModel(postingitems: []).obs;
  RefreshController refreshController1 =
      new RefreshController(initialRefresh: false);
  RefreshController refreshController2 =
      new RefreshController(initialRefresh: false);
  RefreshController refreshController3 =
      new RefreshController(initialRefresh: false);

  late TabController hometabcontroller;

  int pageNumber = 1;

  @override
  void onInit() {
    for (int i = 0; i < 4; i++) {
      // qustion_posting.add(QuestionPostingWidget());
      recommend_posting.add(RecommendPostingWidget());
    }
    onRefresh1();
    onRefresh2();
    onRefresh3();
    hometabcontroller = TabController(length: 3, vsync: this);
    super.onInit();
  }

  void onRefresh1() async {
    enablepullup1.value = true;
    postingResult(PostingModel(postingitems: []));

    pageNumber = 1;
    postloadItem();
    await Future.delayed(Duration(microseconds: 500));
    refreshController1.refreshCompleted();
  }

  void onLoading1() async {
    pageNumber += 1;
    await Future.delayed(Duration(microseconds: 500));
    //페이지 처리
    postloadItem();
    refreshController1.loadComplete();
  }

  void onRefresh2() async {
    enablepullup2.value = true;
    questionResult(QuestionModel(questionitems: []));

    pageNumber = 1;
    loadItem();
    await Future.delayed(Duration(microseconds: 500));
    refreshController2.refreshCompleted();
  }

  void onLoading2() async {
    pageNumber += 1;
    await Future.delayed(Duration(microseconds: 500));
    //페이지 처리
    loadItem();
    refreshController2.loadComplete();
  }

  void onRefresh3() async {
    enablepullup3.value = true;
    loopResult(PostingModel(postingitems: []));

    pageNumber = 1;
    looploadItem();
    await Future.delayed(Duration(microseconds: 500));
    refreshController3.refreshCompleted();
  }

  void onLoading3() async {
    pageNumber += 1;
    await Future.delayed(Duration(microseconds: 500));
    //페이지 처리
    looploadItem();
    refreshController3.loadComplete();
  }

  void loadItem() async {
    if (selectgroup == "모든 질문") {
      QuestionModel questionModel = await questionlist(pageNumber, "any");
      QuestionModel questionModel2 = await questionlist(pageNumber + 1, "any");

      if (questionModel.questionitems[0].id ==
          questionModel2.questionitems[0].id) {
        enablepullup2.value = false;
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
        enablepullup2.value = false;
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

  void postloadItem() async {
    PostingModel postingModel = await mainpost(pageNumber);
    PostingModel postingModel2 = await mainpost(pageNumber + 1);

    if (postingModel.postingitems[0].id == postingModel2.postingitems[0].id) {
      enablepullup1.value = false;
    }
    print(postingModel.postingitems);
    // if (pageNumber == 1) {
    //   questionResult.update((val) {
    //     val!.questionitems.addAll(questionModel.questionitems);
    //   });
    // }
    postingResult.update((val) {
      val!.postingitems.addAll(postingModel.postingitems);
    });
  }

  void looploadItem() async {
    PostingModel loopModel = await looppost(pageNumber);
    PostingModel loopModel2 = await looppost(pageNumber + 1);
    if (loopModel.postingitems.isEmpty) {
      isempty.value = true;
    } else {
      if (loopModel.postingitems[0].id == loopModel2.postingitems[0].id) {
        enablepullup3.value = false;
      }
    }

    print(loopModel.postingitems);
    // if (pageNumber == 1) {
    //   questionResult.update((val) {
    //     val!.questionitems.addAll(questionModel.questionitems);
    //   });
    // }
    loopResult.update((val) {
      val!.postingitems.addAll(loopModel.postingitems);
    });
  }
}
