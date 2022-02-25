import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/question_widget.dart';
import 'package:loopus/widget/recommend_posting_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static HomeController get to => Get.find();
  NotificationController notificationController =
      Get.put(NotificationController());
  List<PostingWidget> posting = [];
  // List<RecommendPostingWidget> recommend_posting = [];
  RxBool bookmark = false.obs;
  RxBool isLoopEmpty = false.obs;
  RxBool isPostingEmpty = false.obs;
  RxBool isAllQuestionEmpty = false.obs;
  RxBool isMyQuestionEmpty = false.obs;
  RxBool isRecommandFull = false.obs;

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
  Rx<PostingModel> recommandpostingResult =
      PostingModel(postingitems: <Post>[].obs).obs;
  Rx<PostingModel> latestpostingResult =
      PostingModel(postingitems: <Post>[].obs).obs;
  Rx<PostingModel> loopResult = PostingModel(postingitems: <Post>[].obs).obs;
  RefreshController postingRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController questionRefreshController =
      RefreshController(initialRefresh: false);
  RefreshController loopRefreshController =
      RefreshController(initialRefresh: false);

  int recommandpagenum = 1;

  Rx<ScreenState> populartagstate = ScreenState.loading.obs;
  RxList<Tag> populartaglist = <Tag>[].obs;

  late TabController hometabcontroller;

  // int pageNumber = 1;

  @override
  void onInit() {
    hometabcontroller = TabController(length: 3, vsync: this);

    // for (int i = 0; i < 4; i++) {
    //   recommend_posting.add(RecommendPostingWidget());
    // }
    getpopulartag();
    onPostingRefresh();
    onQuestionRefresh();
    onLoopRefresh();
    super.onInit();
  }

  void onPostingRefresh() async {
    recommandpagenum = 1;
    isRecommandFull(false);
    enablePostingPullup.value = true;
    recommandpostingResult(PostingModel(postingitems: <Post>[].obs));
    latestpostingResult(PostingModel(postingitems: <Post>[].obs));

    await postloadItem().then((value) => isPostingLoading.value = false);
    postingRefreshController.refreshCompleted();
  }

  void onPostingLoading() async {
    //페이지 처리
    await postloadItem();
    postingRefreshController.loadComplete();
  }

  Future<void> onQuestionRefresh() async {
    enableQuestionPullup.value = true;
    questionResult(QuestionModel(questionitems: <QuestionItem>[].obs));

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
    //페이지 처리
    await questionLoadItem();
    questionRefreshController.loadComplete();
  }

  void onLoopRefresh() async {
    enableLoopPullup.value = true;
    loopResult(PostingModel(postingitems: <Post>[].obs));

    await looploadItem().then((value) => isLoopLoading.value = false);
    loopRefreshController.refreshCompleted();
  }

  void onLoopLoading() async {
    //페이지 처리
    await looploadItem();
    loopRefreshController.loadComplete();
  }

  Future<void> questionLoadItem() async {
    ConnectivityResult result = await initConnectivity();
    if (result == ConnectivityResult.none) {
      ModalController.to.showdisconnectdialog();
    } else {
      if (selectgroup.value == "모든 질문") {
        QuestionModel? questionModel = await getquestionlist(
            questionResult.value.questionitems.isEmpty
                ? 0
                : questionResult.value.questionitems.last.id,
            "any");

        if (questionModel != null) {
          if (questionModel.questionitems.isEmpty &&
              questionResult.value.questionitems.isEmpty) {
            isAllQuestionEmpty.value = true;
          } else if (questionModel.questionitems.isEmpty &&
              questionResult.value.questionitems.isNotEmpty) {
            enableQuestionPullup.value = false;
          }

          questionResult.value.questionitems
              .addAll(questionModel.questionitems);
        }
      } else {
        QuestionModel? questionModel = await getquestionlist(
            questionResult.value.questionitems.isEmpty
                ? 0
                : questionResult.value.questionitems.last.id,
            "my");

        if (questionModel != null) {
          if (questionModel.questionitems.isEmpty &&
              questionResult.value.questionitems.isEmpty) {
            isMyQuestionEmpty.value = true;
          } else if (questionModel.questionitems.isEmpty &&
              questionResult.value.questionitems.isNotEmpty) {
            enableQuestionPullup.value = false;
          }

          questionResult.value.questionitems
              .addAll(questionModel.questionitems);
        }
      }
    }
  }

  Future<void> postloadItem() async {
    PostingModel? postingModel;
    ConnectivityResult result = await initConnectivity();
    if (result == ConnectivityResult.none) {
      ModalController.to.showdisconnectdialog();
    } else {
      if (isRecommandFull.value == false) {
        postingModel = await recommandpost(recommandpagenum);
      } else {
        postingModel = await latestpost(
            latestpostingResult.value.postingitems.isEmpty
                ? 0
                : latestpostingResult.value.postingitems.last.id);
      }

      if (postingModel != null) {
        if (postingModel.postingitems.isEmpty &&
            recommandpostingResult.value.postingitems.isEmpty &&
            isRecommandFull.value == false) {
          print("1");
          getpopulartag();
          isPostingEmpty.value = true;
          isRecommandFull(true);
          postloadItem();
        } else if (postingModel.postingitems.isNotEmpty &&
            recommandpostingResult.value.postingitems.isEmpty &&
            isPostingEmpty.value == true &&
            isRecommandFull.value == false) {
          print("2");

          isPostingEmpty.value = false;
        } else if (postingModel.postingitems.isEmpty &&
            recommandpostingResult.value.postingitems.isNotEmpty &&
            latestpostingResult.value.postingitems.isEmpty) {
          print("3");

          isRecommandFull(true);
        } else if (postingModel.postingitems.isEmpty &&
            isRecommandFull.value == true) {
          print("4");
          enablePostingPullup.value = false;
        }
        if (isRecommandFull.value == false) {
          for (var originpost in recommandpostingResult.value.postingitems) {
            postingModel.postingitems
                .removeWhere((post) => post.id == originpost.id);
          }

          recommandpostingResult.value.postingitems
              .addAll(postingModel.postingitems);
        } else {
          latestpostingResult.value.postingitems
              .addAll(postingModel.postingitems);
        }
      }
    }
  }

  Future<void> looploadItem() async {
    ConnectivityResult result = await initConnectivity();
    if (result == ConnectivityResult.none) {
      ModalController.to.showdisconnectdialog();
    } else {
      PostingModel? loopModel = await looppost(
          loopResult.value.postingitems.isEmpty
              ? 0
              : loopResult.value.postingitems.last.id);

      if (loopModel != null) {
        if (loopModel.postingitems.isEmpty &&
            loopResult.value.postingitems.isEmpty) {
          isLoopEmpty.value = true;
        } else if (loopModel.postingitems.isEmpty &&
            loopResult.value.postingitems.isNotEmpty) {
          enableLoopPullup.value = false;
        }

        loopResult.value.postingitems.addAll(loopModel.postingitems);
      }
    }
  }

  void tapBookmark(int postid) async {
    if (recommandpostingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      recommandpostingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isMarked(1);
    }
    if (latestpostingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      latestpostingResult.value.postingitems
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
    if (SearchController.to.searchpostinglist
        .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
        .isNotEmpty) {
      SearchController.to.searchpostinglist
          .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
          .first
          .post
          .isMarked(1);
    }

    await bookmarkpost(postid);
    ModalController.to.showCustomDialog('북마크 탭에 저장했어요', 1000);
  }

  void tapunBookmark(int postid) async {
    if (recommandpostingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      recommandpostingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isMarked(0);
    }
    if (latestpostingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      latestpostingResult.value.postingitems
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
    if (SearchController.to.searchpostinglist
        .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
        .isNotEmpty) {
      SearchController.to.searchpostinglist
          .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
          .first
          .post
          .isMarked(0);
    }

    await bookmarkpost(postid);
    ModalController.to.showCustomDialog("북마크 탭에서 삭제했어요.", 1000);
  }

  void tapLike(int postid, int likecount) {
    if (recommandpostingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      recommandpostingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isLiked(1);
      recommandpostingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .likeCount(likecount);
    }
    if (latestpostingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      latestpostingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isLiked(1);
      latestpostingResult.value.postingitems
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
    if (SearchController.to.searchpostinglist
        .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
        .isNotEmpty) {
      SearchController.to.searchpostinglist
          .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
          .first
          .post
          .isLiked(1);
      SearchController.to.searchpostinglist
          .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
          .first
          .post
          .likeCount(likecount);
    }
  }

  void tapunLike(int postid, int likecount) {
    if (recommandpostingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      recommandpostingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isLiked(0);
      recommandpostingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .likeCount(likecount);
    }
    if (latestpostingResult.value.postingitems
        .where((post) => post.id == postid)
        .isNotEmpty) {
      latestpostingResult.value.postingitems
          .where((post) => post.id == postid)
          .first
          .isLiked(0);
      latestpostingResult.value.postingitems
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
    if (SearchController.to.searchpostinglist
        .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
        .isNotEmpty) {
      SearchController.to.searchpostinglist
          .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
          .first
          .post
          .isLiked(0);
      SearchController.to.searchpostinglist
          .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
          .first
          .post
          .likeCount(likecount);
    }
  }
}
