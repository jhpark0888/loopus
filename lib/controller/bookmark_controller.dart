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

  RxList posts = <Post>[].obs;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() {
    onBookmarkRefresh();
    super.onInit();
  }

  void onBookmarkRefresh() async {
    pageNumber = 1;
    posts.clear();
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
        List postlist = List.from(value.data);
        if (postlist.isNotEmpty) {
          posts.addAll(postlist.map((post) => Post.fromJson(post)).toList());
          pageNumber += 1;
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
}
