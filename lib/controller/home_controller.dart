// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:loopus/api/post_api.dart';
// import 'package:loopus/api/profile_api.dart';
// import 'package:loopus/api/question_api.dart';
// import 'package:loopus/api/tag_api.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/app_controller.dart';
// import 'package:loopus/controller/modal_controller.dart';
// import 'package:loopus/controller/notification_controller.dart';
// import 'package:loopus/controller/search_controller.dart';
// import 'package:loopus/model/contact_model.dart';
// import 'package:loopus/model/httpresponse_model.dart';
// import 'package:loopus/model/post_model.dart';
// import 'package:loopus/model/question_model.dart';
// import 'package:loopus/model/tag_model.dart';
// import 'package:loopus/model/user_model.dart';
// import 'package:loopus/screen/start_screen.dart';
// import 'package:loopus/widget/posting_widget.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class HomeController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   static HomeController get to => Get.find();
//   NotificationController notificationController =
//       Get.put(NotificationController());
//   List<PostingWidget> posting = [];

//   RxList<Post> posts = <Post>[].obs;
//   RxList<Contact> contact = <Contact>[].obs;
//   RxList<User> growthUsers = <User>[].obs;
//   RxList<String> news = <String>[].obs;
//   RxList<User> joinSenior1 = <User>[].obs;
//   RxList<User> joinSenior2 = <User>[].obs;

//   RxList<Widget> contents = <Widget>[].obs;

//   RxBool bookmark = false.obs;
//   // RxBool isLoopEmpty = false.obs;
//   RxBool isPostingEmpty = false.obs;

//   RxBool isRecommandFull = false.obs;

//   RxBool isPostingLoading = true.obs;

//   RxBool enablePostingPullup = true.obs;

//   Rx<PostingModel> recommandpostingResult =
//       PostingModel(postingitems: <Post>[].obs).obs;
//   Rx<PostingModel> latestpostingResult =
//       PostingModel(postingitems: <Post>[].obs).obs;
//   RefreshController postingRefreshController =
//       RefreshController(initialRefresh: false);

//   int recommandpagenum = 1;

//   Rx<ScreenState> populartagstate = ScreenState.loading.obs;
//   RxList<Tag> populartaglist = <Tag>[].obs;

//   @override
//   void onInit() async {
//     // hometabcontroller = TabController(length: 3, vsync: this);

//     // getpopulartag();
//     // onPostingRefresh();
//     // onQuestionRefresh();
//     // onLoopRefresh();
//     // logindetect();
//     String? islogindetect =
//         await FlutterSecureStorage().read(key: 'login detect');
//     if (islogindetect == 'true') {
//       showoneButtonDialog(
//         title: '로그인 감지',
//         content: '다른 기기에서 해당 계정으로 로그인 하여 로그아웃합니다',
//         oneFunction: () {
//           AppController.to.currentIndex.value = 0;
//           FlutterSecureStorage().delete(key: "token");
//           FlutterSecureStorage().delete(key: "id");
//           FlutterSecureStorage().delete(key: "login detect");
//           Get.delete<AppController>();
//           Get.delete<HomeController>();
//           Get.delete<SearchController>();
//           Get.offAll(() => StartScreen());
//         },
//         oneText: '확인',
//       );
//     }
//     super.onInit();
//   }

//   void onPostingRefresh() async {
//     recommandpagenum = 1;
//     isRecommandFull(false);
//     enablePostingPullup.value = true;
//     recommandpostingResult(PostingModel(postingitems: <Post>[].obs));
//     latestpostingResult(PostingModel(postingitems: <Post>[].obs));

//     await postloadItem().then((value) => isPostingLoading.value = false);
//     postingRefreshController.refreshCompleted();
//   }

//   void onPostingLoading() async {
//     //페이지 처리
//     await postloadItem();
//     postingRefreshController.loadComplete();
//   }

//   Future<void> postloadItem() async {
//     HTTPResponse httpresult;

//       if (isRecommandFull.value == false) {
//         httpresult = await recommandpost(recommandpagenum);
//       } else {
//         httpresult = await mainload(
//             latestpostingResult.value.postingitems.isEmpty
//                 ? 0
//                 : latestpostingResult.value.postingitems.last.id);
//       }

//       if (httpresult.isError == false) {
//         PostingModel postingModel = httpresult.data;
//         if (postingModel.postingitems.isEmpty &&
//             recommandpostingResult.value.postingitems.isEmpty &&
//             isRecommandFull.value == false) {
//           print("1");
//           getpopulartag();
//           isPostingEmpty.value = true;
//           isRecommandFull(true);
//           postloadItem();
//         } else if (postingModel.postingitems.isNotEmpty &&
//             recommandpostingResult.value.postingitems.isEmpty &&
//             isPostingEmpty.value == true &&
//             isRecommandFull.value == false) {
//           print("2");

//           isPostingEmpty.value = false;
//         } else if (postingModel.postingitems.isEmpty &&
//             recommandpostingResult.value.postingitems.isNotEmpty &&
//             latestpostingResult.value.postingitems.isEmpty) {
//           print("3");

//           isRecommandFull(true);
//         } else if (postingModel.postingitems.isEmpty &&
//             isRecommandFull.value == true) {
//           print("4");
//           enablePostingPullup.value = false;
//         }
//         if (isRecommandFull.value == false) {
//           for (var originpost in recommandpostingResult.value.postingitems) {
//             postingModel.postingitems
//                 .removeWhere((post) => post.id == originpost.id);
//           }

//           recommandpostingResult.value.postingitems
//               .addAll(postingModel.postingitems);
//         } else {
//           latestpostingResult.value.postingitems
//               .addAll(postingModel.postingitems);
//         }
//       }

//   }

//   void tapBookmark(int postid) async {
//     if (recommandpostingResult.value.postingitems
//         .where((post) => post.id == postid)
//         .isNotEmpty) {
//       recommandpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .isMarked(1);
//     }
//     if (latestpostingResult.value.postingitems
//         .where((post) => post.id == postid)
//         .isNotEmpty) {
//       latestpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .isMarked(1);
//     }

//     if (SearchController.to.searchpostinglist
//         .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
//         .isNotEmpty) {
//       SearchController.to.searchpostinglist
//           .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
//           .first
//           .post
//           .isMarked(1);
//     }

//     await bookmarkpost(postid);
//     showCustomDialog('북마크 탭에 저장했어요', 1000);
//   }

//   void tapunBookmark(int postid) async {
//     if (recommandpostingResult.value.postingitems
//         .where((post) => post.id == postid)
//         .isNotEmpty) {
//       recommandpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .isMarked(0);
//     }
//     if (latestpostingResult.value.postingitems
//         .where((post) => post.id == postid)
//         .isNotEmpty) {
//       latestpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .isMarked(0);
//     }

//     if (SearchController.to.searchpostinglist
//         .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
//         .isNotEmpty) {
//       SearchController.to.searchpostinglist
//           .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
//           .first
//           .post
//           .isMarked(0);
//     }

//     await bookmarkpost(postid);
//     showCustomDialog("북마크 탭에서 삭제했어요.", 1000);
//   }

//   void tapLike(int postid, int likecount) {
//     if (recommandpostingResult.value.postingitems
//         .where((post) => post.id == postid)
//         .isNotEmpty) {
//       recommandpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .isLiked(1);
//       recommandpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .likeCount(likecount);
//     }
//     if (latestpostingResult.value.postingitems
//         .where((post) => post.id == postid)
//         .isNotEmpty) {
//       latestpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .isLiked(1);
//       latestpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .likeCount(likecount);
//     }

//     if (SearchController.to.searchpostinglist
//         .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
//         .isNotEmpty) {
//       SearchController.to.searchpostinglist
//           .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
//           .first
//           .post
//           .isLiked(1);
//       SearchController.to.searchpostinglist
//           .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
//           .first
//           .post
//           .likeCount(likecount);
//     }
//   }

//   void tapunLike(int postid, int likecount) {
//     if (recommandpostingResult.value.postingitems
//         .where((post) => post.id == postid)
//         .isNotEmpty) {
//       recommandpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .isLiked(0);
//       recommandpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .likeCount(likecount);
//     }
//     if (latestpostingResult.value.postingitems
//         .where((post) => post.id == postid)
//         .isNotEmpty) {
//       latestpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .isLiked(0);
//       latestpostingResult.value.postingitems
//           .where((post) => post.id == postid)
//           .first
//           .likeCount(likecount);
//     }

//     if (SearchController.to.searchpostinglist
//         .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
//         .isNotEmpty) {
//       SearchController.to.searchpostinglist
//           .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
//           .first
//           .post
//           .isLiked(0);
//       SearchController.to.searchpostinglist
//           .where((searchpostingwidget) => searchpostingwidget.post.id == postid)
//           .first
//           .post
//           .likeCount(likecount);
//     }
//   }
// }

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
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/notification_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/model/contact_model.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/post_model.dart';
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

  RxList<Post> posts = <Post>[].obs;
  RxList<Contact> contact = <Contact>[].obs;
  RxList<User> growthUsers = <User>[].obs;
  RxList<String> newslist = <String>[].obs;
  RxList<User> joinSenior1 = <User>[].obs;
  RxList<User> joinSenior2 = <User>[].obs;

  ScrollController scrollController = ScrollController();

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
    // logindetect();

    String? islogindetect =
        await FlutterSecureStorage().read(key: 'login detect');
    if (islogindetect == 'true') {
      showoneButtonDialog(
        title: '로그인 감지',
        content: '다른 기기에서 해당 계정으로 로그인 하여 로그아웃합니다',
        oneFunction: () {
          AppController.to.currentIndex.value = 0;
          FlutterSecureStorage().delete(key: "token");
          FlutterSecureStorage().delete(key: "id");
          FlutterSecureStorage().delete(key: "login detect");
          Get.delete<AppController>();
          Get.delete<HomeController>();
          Get.delete<SearchController>();
          Get.offAll(() => StartScreen());
        },
        oneText: '확인',
      );
    }
    myId = await const FlutterSecureStorage().read(key: "id");

    await getProfile(int.parse(myId!)).then((value) async{
      if (value.isError == false) {
        myProfile.value = User.fromJson(value.data);
        print(myProfile.value.userid);
        isNewAlarm.value = value.data['new_alarm'];
        await updateNotreadMsg(myProfile.value.userid).then((value) { if(value.isError == false){
          isNewMsg.value = value.data;
          print(value.data);        }});
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
        if (postlist.isNotEmpty) {
          posts.addAll(postlist.map((post) => Post.fromJson(post)).toList());
        } else {
          enablePostingPullup(false);
        }

        if (value.data['news'] != null) {
          newslist.value = List.from(value.data['news'])
              .map((news) => news['urls'].toString())
              .toList();
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

  void tapBookmark(int postid) {
    if (posts.where((post) => post.id == postid).isNotEmpty) {
      Post post = posts.where((post) => post.id == postid).first;
      post.isMarked(1);
    }
  }

  void tapunBookmark(int postid) {
    if (posts.where((post) => post.id == postid).isNotEmpty) {
      Post post = posts.where((post) => post.id == postid).first;
      post.isMarked(0);
    }
  }

  void tapLike(int postid, int likecount) {
    if (posts.where((post) => post.id == postid).isNotEmpty) {
      Post post = posts.where((post) => post.id == postid).first;
      post.isLiked(1);
      post.likeCount(likecount);
    }
  }

  void tapunLike(int postid, int likecount) {
    if (posts.where((post) => post.id == postid).isNotEmpty) {
      Post post = posts.where((post) => post.id == postid).first;
      post.isLiked(0);
      post.likeCount(likecount);
    }
  }
}
