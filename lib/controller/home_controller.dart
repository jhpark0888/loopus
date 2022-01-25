import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/question_widget.dart';
import 'package:loopus/widget/recommend_posting_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static HomeController get to => Get.find();
  List<PostingWidget> posting = [];
  // List<RecommendPostingWidget> recommend_posting = [];
  RxBool bookmark = false.obs;
  RxBool isLoopEmpty = false.obs;
  RxBool isPostingEmpty = false.obs;
  RxBool isAllQuestionEmpty = false.obs;
  RxBool isMyQuestionEmpty = false.obs;

  RxBool isPostingLoading = true.obs;
  RxBool isAllQuestionLoading = true.obs;
  RxBool isMyQuestionLoading = true.obs;
  RxBool isLoopLoading = true.obs;

  RxBool enablePostingPullup = true.obs;
  RxBool enableQuestionPullup = true.obs;
  RxBool enableLoopPullup = true.obs;
  RxString selectgroup = '모든 질문'.obs;

  Rx<QuestionModel> questionResult =
      QuestionModel(questionitems: <QuestionItem>[].obs).obs;
  Rx<PostingModel> postingResult = PostingModel(postingitems: <Post>[].obs).obs;
  Rx<PostingModel> loopResult = PostingModel(postingitems: <Post>[].obs).obs;
  RefreshController postingRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController questionRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController loopRefreshController =
      RefreshController(initialRefresh: false);

  late TabController hometabcontroller;

  // int pageNumber = 1;

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

    // pageNumber = 1;
    await postloadItem().then((value) => isPostingLoading.value = false);
    postingRefreshController.refreshCompleted();
  }

  void onPostingLoading() async {
    // pageNumber += 1;
    //페이지 처리
    await postloadItem();
    postingRefreshController.loadComplete();
  }

  Future<void> onQuestionRefresh() async {
    enableQuestionPullup.value = true;
    questionResult(QuestionModel(questionitems: <QuestionItem>[].obs));

    // pageNumber = 1;
    await questionLoadItem().then((value) {
      if (selectgroup.value == '모든 질문') {
        isAllQuestionLoading.value = false;
      } else {
        isMyQuestionLoading.value = false;
      }
    });
    questionRefreshController.refreshCompleted();
  }

  void onQuestionLoading() async {
    // pageNumber += 1;
    //페이지 처리
    await questionLoadItem();
    questionRefreshController.loadComplete();
  }

  void onLoopRefresh() async {
    enableLoopPullup.value = true;
    loopResult(PostingModel(postingitems: <Post>[].obs));

    // pageNumber = 1;
    await looploadItem().then((value) => isLoopLoading.value = false);
    loopRefreshController.refreshCompleted();
  }

  void onLoopLoading() async {
    // pageNumber += 1;
    //페이지 처리
    await looploadItem();
    loopRefreshController.loadComplete();
  }

  Future<void> questionLoadItem() async {
    if (selectgroup.value == "모든 질문") {
      QuestionModel questionModel = await getquestionlist(
          questionResult.value.questionitems.isEmpty
              ? 0
              : questionResult.value.questionitems.last.id,
          "any");

      if (questionModel.questionitems.isEmpty &&
          questionResult.value.questionitems.isEmpty) {
        isAllQuestionEmpty.value = true;
      } else if (questionModel.questionitems.isEmpty &&
          questionResult.value.questionitems.isNotEmpty) {
        enableQuestionPullup.value = false;
      }

      questionResult.value.questionitems.addAll(questionModel.questionitems);
    } else {
      QuestionModel questionModel = await getquestionlist(
          questionResult.value.questionitems.isEmpty
              ? 0
              : questionResult.value.questionitems.last.id,
          "my");

      if (questionModel.questionitems.isEmpty &&
          questionResult.value.questionitems.isEmpty) {
        isMyQuestionEmpty.value = true;
      } else if (questionModel.questionitems.isEmpty &&
          questionResult.value.questionitems.isNotEmpty) {
        enableQuestionPullup.value = false;
      }

      questionResult.value.questionitems.addAll(questionModel.questionitems);
    }
  }

  Future<void> postloadItem() async {
    PostingModel postingModel = await mainpost(
        postingResult.value.postingitems.isEmpty
            ? 0
            : postingResult.value.postingitems.last.id);

    if (postingModel.postingitems.isEmpty &&
        postingResult.value.postingitems.isEmpty) {
      isPostingEmpty.value = true;
    } else if (postingModel.postingitems.isEmpty &&
        postingResult.value.postingitems.isNotEmpty) {
      enablePostingPullup.value = false;
    }
    postingResult.value.postingitems.addAll(postingModel.postingitems);
    // print(postingModel.postingitems[2].thumbnail);
  }

  Future<void> looploadItem() async {
    PostingModel loopModel = await looppost(
        loopResult.value.postingitems.isEmpty
            ? 0
            : loopResult.value.postingitems.last.id);

    if (loopModel.postingitems.isEmpty &&
        loopResult.value.postingitems.isEmpty) {
      isLoopEmpty.value = true;
    } else if (loopModel.postingitems.isEmpty &&
        loopResult.value.postingitems.isNotEmpty) {
      enableLoopPullup.value = false;
    }

    loopResult.value.postingitems.addAll(loopModel.postingitems);
  }

  void tapBookmark(int postid) async {
    if (postingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      postingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isMarked(1);
    }
    if (loopResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      loopResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isMarked(1);
    }

    await bookmarkpost(postid);
  }

  void tapunBookmark(int postid) async {
    if (postingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      postingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isMarked(0);
    }
    if (loopResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      loopResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isMarked(0);
    }

    await bookmarkpost(postid);
  }

  void tapLike(int postid, int likecount) {
    if (postingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      postingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isLiked(1);
      postingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .likeCount(likecount);
    }
    if (loopResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      loopResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isLiked(1);
      loopResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .likeCount(likecount);
    }

    likepost(postid);
  }

  void tapunLike(int postid, int likecount) {
    if (postingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      postingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isLiked(0);
      postingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .likeCount(likecount);
    }
    if (loopResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      loopResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isLiked(0);
      loopResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .likeCount(likecount);
    }
    likepost(postid);
  }
}
