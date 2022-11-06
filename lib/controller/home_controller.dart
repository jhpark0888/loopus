import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/controller/career_board_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/issue_model.dart';
import 'package:loopus/screen/myProfile_screen.dart';
import 'package:loopus/screen/mycompany_screen.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/trash_bin/question_api.dart';
import 'package:loopus/api/tag_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/share_intent_controller.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/select_project_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static HomeController get to => Get.find();

  Project? recommendCareer;
  RxList<Post> posts = <Post>[].obs;
  // RxList<Contact> contact = <Contact>[].obs;
  RxList<Person> growthUsers = <Person>[].obs;
  RxList<NewsIssue> newsList = <NewsIssue>[].obs;
  RxList<YoutubeIssue> youtubeList = <YoutubeIssue>[].obs;
  RxList<BrunchIssue> brunchList = <BrunchIssue>[].obs;
  // RxList<Person> joinSenior1 = <Person>[].obs;
  // RxList<Person> joinSenior2 = <Person>[].obs;

  late Rx<ScrollController> scrollController;

  RxList contents = [].obs;

  RxBool bookmark = false.obs;
  RxBool isPostingEmpty = false.obs;

  Rx<ScreenState> homeScreenState = ScreenState.loading.obs;

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

  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  StreamSubscription? _dataStreamSubscription;

  late String? myId;
  @override
  void onInit() async {
    // hometabcontroller = TabController(length: 3, vsync: this);

    // getpopulartag();
    // onPostingRefresh();
    // onQuestionRefresh();
    // onLoopRefresh();
    Map<String, String> allValues = await FlutterSecureStorage().readAll();
    print("기기 저장 변수들 $allValues");
    getUserProfile();

    _dataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String text) {
      Get.put(ShareIntentController()).shareText = text;
      if (AppController.to.userType == UserType.student) {
        Get.to(() => SelectProjectScreen());
      } else if (AppController.to.userType == UserType.company) {
        Get.to(() => PostingAddScreen(
            project_id: companyCareerId, route: PostaddRoute.bottom));
      }
    });

    //Receive text data when app is closed
    ReceiveSharingIntent.getInitialText().then((String? text) {
      if (text != null) {
        Get.put(ShareIntentController()).shareText = text;
        Get.to(() => SelectProjectScreen());
      }
    });

    postloadItem();
    super.onInit();
  }

  void getUserProfile() async {
    myId = await secureStorage.read(key: "id");
    String? userType = await secureStorage.read(key: "type");
    print(userType);
    if (userType == UserType.student.name) {
      await getProfile(int.parse(myId!)).then((value) async {
        if (value.isError == false) {
          myProfile.value = Person.fromJson(value.data);
          print(myProfile.value.userId);
          isNewAlarm.value = value.data['new_alarm'];
          await updateNotreadMsg(myProfile.value.userId).then((value) {
            if (value.isError == false) {
              isNewMsg.value = value.data;
              print(value.data);
            }
          });
        }
      });
    } else if (userType == UserType.company.name) {
      await getCorpProfile(int.parse(myId!)).then((value) async {
        if (value.isError == false) {
          myProfile.value = Company.fromJson(value.data);
          // isNewAlarm.value = value.data['new_alarm'];
          await updateNotreadMsg(myProfile.value.userId).then((value) {
            if (value.isError == false) {
              isNewMsg.value = value.data;
              print(value.data);
            }
          });
        }
      });
    }
  }

  void onPostingRefresh() async {
    getUserProfile();

    enablePostingPullup.value = true;
    posts.clear();
    newsList.clear();
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
            newsList.value = List.from(value.data['news'])
                .map((news) => NewsIssue.fromJson(news))
                .toList();
          }

          if (value.data['brunch'] != null) {
            brunchList.value = List.from(value.data['brunch'])
                .map((brunch) => BrunchIssue.fromJson(brunch))
                .toList();
          }

          if (value.data['youtube'] != null) {
            youtubeList.value = List.from(value.data['youtube'])
                .map((youtube) => YoutubeIssue.fromJson(youtube))
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
        homeScreenState(ScreenState.success);
      } else {
        errorSituation(value, screenState: homeScreenState);
      }
    });
  }

  void contentsArrange() {
    List tempList = [];
    tempList.addAll(posts);
    // tempList.insert(3, newsList);

    List linkList = [newsList, youtubeList, brunchList];
    linkList.shuffle();
    int listIndex = 3;
    for (int i = 0; i < linkList.length; i++) {
      if (i != 0) {
        listIndex += 4; // 4, 8, 12번째에 링크리스트(뉴스, 유투브, 브런치) 보여줌
      }
      if (tempList.length >= listIndex) {
        tempList.insert(listIndex, linkList[i]);
      } else {
        tempList.add(linkList[i]);
      }
    }

    // for (int i = 0; i < newslist.length / 10; i++) {
    //   if (teptlist.length > 3 + (i * 4)) {
    //     teptlist.insert(
    //         3 + (i * 4), newslist.sublist(i * 10, (i + 1) * 10).obs);
    //   } else {
    //     teptlist.add(newslist.sublist(i * 10, (i + 1) * 10).obs);
    //   }
    // }

    contents.value = tempList;
  }

  void scrollToTop() {
    scrollController.value.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void postingRemove(int postId) {
    posts.removeWhere((post) => post.id == postId);
    contents.removeWhere((content) {
      if (content is Post) {
        return content.id == postId;
      } else {
        return false;
      }
    });
  }

  // void tapBookmark(int postid) {
  //   if (posts.where((post) => post.id == postid).isNotEmpty) {
  //     Post post = posts.where((post) => post.id == postid).first;
  //     post.isMarked(1);
  //   }
  // }

  // void tapunBookmark(int postid) {
  //   if (posts.where((post) => post.id == postid).isNotEmpty) {
  //     Post post = posts.where((post) => post.id == postid).first;
  //     post.isMarked(0);
  //   }
  // }

  // void tapLike(int postid, int likecount) {
  //   if (posts.where((post) => post.id == postid).isNotEmpty) {
  //     Post post = posts.where((post) => post.id == postid).first;
  //     post.isLiked(1);
  //     post.likeCount(likecount);
  //   }
  //   if (Get.isRegistered<BookmarkController>()) {
  //     BookmarkController.to.tapLike(postid, likecount);
  //   }
  // }

  // void tapunLike(int postid, int likecount) {
  //   if (posts.where((post) => post.id == postid).isNotEmpty) {
  //     Post post = posts.where((post) => post.id == postid).first;
  //     post.isLiked(0);
  //     post.likeCount(likecount);
  //   }
  //   if (Get.isRegistered<BookmarkController>()) {
  //     BookmarkController.to.tapunLike(postid, likecount);
  //   }
  // }

  void goMyProfile() {
    if (HomeController.to.myProfile.value.userType == UserType.student) {
      Get.to(() => MyProfileScreen(), transition: Transition.rightToLeft);
    } else {
      Get.to(() => MyCompanyScreen(), transition: Transition.rightToLeft);
    }
  }
}
