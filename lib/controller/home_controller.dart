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

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static HomeController get to => Get.find();
  List<HomePostingWidget> posting = [];
  List<RecommendPostingWidget> recommend_posting = [];
  RxBool bookmark = false.obs;
  RxBool isempty = false.obs;
  RxBool isPostingEmpty = true.obs;
  RxBool isAllQuestionEmpty = true.obs;
  RxBool isMyQuestionEmpty = true.obs;
  RxBool isLoopEmpty = true.obs;

  RxBool enablePostingPullup = true.obs;
  RxBool enableQuestionPullup = true.obs;
  RxBool enableLoopPullup = true.obs;
  var selectgroup = "모든 질문".obs;
  Rx<QuestionModel> questionResult = QuestionModel(questionitems: []).obs;
  Rx<PostingModel> postingResult = PostingModel(postingitems: <Post>[].obs).obs;
  Rx<PostingModel> loopResult = PostingModel(postingitems: <Post>[].obs).obs;
  RefreshController postingRefreshController =
      new RefreshController(initialRefresh: false);
  RefreshController questionRefreshController =
      new RefreshController(initialRefresh: false);
  RefreshController loopRefreshController =
      new RefreshController(initialRefresh: false);

  late TabController hometabcontroller;

  int pageNumber = 1;

  @override
  void onInit() {
    hometabcontroller = TabController(length: 3, vsync: this);

    // for (int i = 0; i < 4; i++) {
    //   recommend_posting.add(RecommendPostingWidget());
    // }
    onPostingRefresh();
    onQuestionRefresh();
    onLoopRefresh();
    super.onInit();
  }

  void onPostingRefresh() async {
    enablePostingPullup.value = true;
    postingResult(PostingModel(postingitems: <Post>[].obs));

    pageNumber = 1;
    await postloadItem().then((value) => isPostingEmpty.value = false);
    postingRefreshController.refreshCompleted();
  }

  void onPostingLoading() async {
    pageNumber += 1;
    //페이지 처리
    await postloadItem();
    postingRefreshController.loadComplete();
  }

  Future<void> onQuestionRefresh() async {
    enableQuestionPullup.value = true;
    questionResult(QuestionModel(questionitems: []));

    pageNumber = 1;
    await questionLoadItem().then((value) {
      isAllQuestionEmpty.value = false;
      isMyQuestionEmpty.value = false;
    });
    questionRefreshController.refreshCompleted();
  }

  void onQuestionLoading() async {
    pageNumber += 1;
    //페이지 처리
    await questionLoadItem();
    questionRefreshController.loadComplete();
  }

  void onLoopRefresh() async {
    enableLoopPullup.value = true;
    loopResult(PostingModel(postingitems: <Post>[].obs));

    pageNumber = 1;
    await looploadItem().then((value) => isLoopEmpty.value = false);
    loopRefreshController.refreshCompleted();
  }

  void onLoopLoading() async {
    pageNumber += 1;
    //페이지 처리
    await looploadItem();
    loopRefreshController.loadComplete();
  }

  Future<void> questionLoadItem() async {
    if (selectgroup == "모든 질문") {
      QuestionModel questionModel = await questionlist(pageNumber, "any");
      QuestionModel questionModel2 = await questionlist(pageNumber + 1, "any");

      if (questionModel.questionitems[0].id ==
          questionModel2.questionitems[0].id) {
        enableQuestionPullup.value = false;
      }
      print("questionitems : ${questionModel.questionitems}");

      questionResult.update((val) {
        val!.questionitems.addAll(questionModel.questionitems);
      });
    } else {
      QuestionModel questionModel = await questionlist(pageNumber, "my");
      QuestionModel questionModel2 = await questionlist(pageNumber + 1, "my");

      if (questionModel.questionitems[0].id ==
          questionModel2.questionitems[0].id) {
        enableQuestionPullup.value = false;
      }
      print("questionitems : ${questionModel.questionitems}");

      questionResult.update((val) {
        val!.questionitems.addAll(questionModel.questionitems);
      });
    }
  }

  Future<void> postloadItem() async {
    PostingModel postingModel = await mainpost(pageNumber);
    PostingModel postingModel2 = await mainpost(pageNumber + 1);

    if (postingModel.postingitems[0].id == postingModel2.postingitems[0].id) {
      enablePostingPullup.value = false;
    }
    print("postingitems : ${postingModel.postingitems}");

    postingResult.update((val) {
      val!.postingitems.addAll(postingModel.postingitems);
    });
  }

  Future<void> looploadItem() async {
    PostingModel loopModel = await looppost(pageNumber);
    PostingModel loopModel2 = await looppost(pageNumber + 1);
    if (loopModel.postingitems.isEmpty) {
      isempty.value = true;
    } else {
      if (loopModel.postingitems[0].id == loopModel2.postingitems[0].id) {
        enableLoopPullup.value = false;
      }
    }

    loopResult.update((val) {
      val!.postingitems.addAll(loopModel.postingitems);
    });
  }
}
