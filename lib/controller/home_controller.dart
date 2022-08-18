import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static HomeController get to => Get.find();
  NotificationController notificationController =
      Get.put(NotificationController());

  Project? recommendCareer;
  RxList<Post> posts = <Post>[].obs;
  RxList<Contact> contact = <Contact>[].obs;
  RxList<User> growthUsers = <User>[].obs;
  RxList<String> newslist = <String>[].obs;
  RxList<User> joinSenior1 = <User>[].obs;
  RxList<User> joinSenior2 = <User>[].obs;

  late Rx<ScrollController> scrollController;

  RxList contents = [].obs;

  RxBool bookmark = false.obs;
  RxBool isPostingEmpty = false.obs;

  RxBool isPostingLoading = true.obs;

  RxBool enablePostingPullup = true.obs;

  RxBool isNewMsg = false.obs;
  RxBool isNewAlarm = false.obs;
  RefreshController postingRefreshController =
      RefreshController(initialRefresh: false);

  Rx<ScreenState> populartagstate = ScreenState.loading.obs;
  RxList<Tag> populartaglist = <Tag>[].obs;
  RxList<Tag> topTagList = <Tag>[].obs;

  Rx<User> myProfile = User.defaultuser().obs;

  RxInt enterMessageRoom = 0.obs;

  late String? myId;
  @override
  void onInit() async {
    // hometabcontroller = TabController(length: 3, vsync: this);

    // getpopulartag();
    // onPostingRefresh();
    // onQuestionRefresh();
    // onLoopRefresh();
    myId = await const FlutterSecureStorage().read(key: "id");

    await getProfile(int.parse(myId!)).then((value) async {
      if (value.isError == false) {
        myProfile.value = User.fromJson(value.data);
        print(myProfile.value.userid);
        isNewAlarm.value = value.data['new_alarm'];
        await updateNotreadMsg(myProfile.value.userid).then((value) {
          if (value.isError == false) {
            isNewMsg.value = value.data;
            print(value.data);
          }
        });
      }
    });

    postloadItem();
    super.onInit();
  }

  void onPostingRefresh() async {
    enablePostingPullup.value = true;
    posts.clear();
    newslist.clear();
    await postloadItem();
    postingRefreshController.refreshCompleted();
  }

  void onPostingLoading() async {
    //페이지 처리
    await postloadItem();
    postingRefreshController.loadComplete();
  }

  Future postloadItem() async {
    await mainload(posts.isNotEmpty ? posts.last.id : 0).then((value) async {
      if (value.isError == false) {
        List postlist = List.from(value.data['posting']);

        if (posts.isEmpty) {
          if (value.data['news'] != null) {
            newslist.value = List.from(value.data['news'])
                .map((news) => news['urls'].toString())
                .toList();
          }

          if (value.data['project'] != null) {
            recommendCareer = Project.fromJson(value.data['project']);
          }
        }

        if (postlist.isNotEmpty) {
          posts.addAll(postlist.map((post) => Post.fromJson(post)).toList());
        } else {
          enablePostingPullup(false);
        }

        contentsArrange();
      } else {}

      isPostingLoading(false);
    });
  }

  void contentsArrange() {
    List teptlist = [];
    teptlist.addAll(posts);
    teptlist.insert(3, newslist);
    // for (int i = 0; i < newslist.length / 10; i++) {
    //   if (teptlist.length > 3 + (i * 4)) {
    //     teptlist.insert(
    //         3 + (i * 4), newslist.sublist(i * 10, (i + 1) * 10).obs);
    //   } else {
    //     teptlist.add(newslist.sublist(i * 10, (i + 1) * 10).obs);
    //   }
    // }

    contents.value = teptlist;
  }

  void scrollToTop() {
    scrollController.value.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void tapBookmark(int postid) {
    if (posts.where((post) => post.id == postid).isNotEmpty) {
      Post post = posts.where((post) => post.id == postid).first;
      post.isMarked(1);
    }
    if (Get.isRegistered<BookmarkController>()) {
      BookmarkController.to.tapBookmark(postid);
    }
  }

  void tapunBookmark(int postid) {
    if (posts.where((post) => post.id == postid).isNotEmpty) {
      Post post = posts.where((post) => post.id == postid).first;
      post.isMarked(0);
    }
    if (Get.isRegistered<BookmarkController>()) {
      BookmarkController.to.tapunBookmark(postid);
    }
  }

  void tapLike(int postid, int likecount) {
    if (posts.where((post) => post.id == postid).isNotEmpty) {
      Post post = posts.where((post) => post.id == postid).first;
      post.isLiked(1);
      post.likeCount(likecount);
    }
    if (Get.isRegistered<BookmarkController>()) {
      BookmarkController.to.tapLike(postid, likecount);
    }
  }

  void tapunLike(int postid, int likecount) {
    if (posts.where((post) => post.id == postid).isNotEmpty) {
      Post post = posts.where((post) => post.id == postid).first;
      post.isLiked(0);
      post.likeCount(likecount);
    }
    if (Get.isRegistered<BookmarkController>()) {
      BookmarkController.to.tapunLike(postid, likecount);
    }
  }
}
