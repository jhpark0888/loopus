import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();
  RxBool enableBookmarkPullup = true.obs;
  RxBool isBookmarkEmpty = false.obs;
  RxBool isBookmarkLoading = true.obs;
  // Rx<ScreenState> followerscreenstate = ScreenState.loading.obs;
  int pageNumber = 1;

  // Rx<PostingModel> bookmarkResult =
  //     PostingModel(postingitems: <Post>[].obs).obs;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() {
    onBookmarkRefresh();
    super.onInit();
  }

  void onBookmarkRefresh() async {
    enableBookmarkPullup.value = true;
    // bookmarkResult(PostingModel(postingitems: <Post>[].obs));

    pageNumber = 1;
    // await bookmarkLoadItem().then((value) => isBookmarkLoading.value = false);
    refreshController.refreshCompleted();
  }

  void onBookmarkLoading() async {
    pageNumber += 1;
    //페이지 처리
    // await bookmarkLoadItem();
    refreshController.loadComplete();
  }

  // Future<void> bookmarkLoadItem() async {
  //   ConnectivityResult result = await initConnectivity();
  //   if (result == ConnectivityResult.none) {
  //     showdisconnectdialog();
  //   } else {
  //     HTTPResponse httpresult = await bookmarklist(pageNumber);
  //     HTTPResponse nexthttpresult = await bookmarklist(pageNumber + 1);
  //     if (httpresult.isError == false) {
  //       PostingModel bookmarkModel = httpresult.data;
  //       PostingModel nextBookmarkModel = nexthttpresult.data;
  //       if (bookmarkModel.postingitems.isEmpty) {
  //         isBookmarkEmpty.value = true;
  //       } else {
  //         isBookmarkEmpty.value = false;

  //         if (bookmarkModel.postingitems[0].id ==
  //             nextBookmarkModel.postingitems[0].id) {
  //           enableBookmarkPullup.value = false;
  //         }
  //       }

  //       print('bookmark length : ${bookmarkModel.postingitems.length}');
  //       bookmarkResult.update((val) {
  //         val!.postingitems.addAll(bookmarkModel.postingitems);
  //       });
  //     }
  //   }
  // }
}
