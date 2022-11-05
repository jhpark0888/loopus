import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();
  // RxBool isBookmarkEmpty = false.obs;
  Rx<ScreenState> bookmarkScreenState = ScreenState.loading.obs;
  int pageNumber = 1;

  RxList<Post> posts = <Post>[].obs;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() {
    onBookmarkRefresh();
    super.onInit();
  }

  void onBookmarkRefresh() async {
    pageNumber = 1;
    bookmarkLoad();
    refreshController.refreshCompleted();
  }

  void onBookmarkLoading() async {
    //페이지 처리
    bookmarkLoad();
  }

  void bookmarkLoad() async {
    await bookmarklist(pageNumber).then((value) async {
      if (value.isError == false) {
        List templist = List.from(value.data);
        if (templist.isNotEmpty) {
          List<Post> postList =
              templist.map((post) => Post.fromJson(post)).toList();
          if (pageNumber == 1) {
            posts(postList);
          } else {
            posts.addAll(postList);
          }
          pageNumber += 1;
        } else if (templist.isEmpty && pageNumber == 1) {
          posts.clear();
        }

        refreshController.loadComplete();
        bookmarkScreenState(ScreenState.success);
      } else {
        if (value.errorData!['statusCode'] == 204) {
          refreshController.loadNoData();
          bookmarkScreenState(ScreenState.success);
        } else {
          errorSituation(value, screenState: bookmarkScreenState);
          refreshController.loadComplete();
        }
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
  //   posts.removeWhere((post) => post.id == postid);
  // }

  // void tapLike(int postid, int likecount) {
  //   if (posts.where((post) => post.id == postid).isNotEmpty) {
  //     Post post = posts.where((post) => post.id == postid).first;
  //     post.isLiked(1);
  //     post.likeCount(likecount);
  //   }
  // }

  // void tapunLike(int postid, int likecount) {
  //   if (posts.where((post) => post.id == postid).isNotEmpty) {
  //     Post post = posts.where((post) => post.id == postid).first;
  //     post.isLiked(0);
  //     post.likeCount(likecount);
  //   }
  // }
}
