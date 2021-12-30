import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/model/post_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarkController extends GetxController {
  static BookmarkController get to => Get.find();
  RxBool enablepullup = true.obs;
  int pageNumber = 1;

  Rx<PostingModel> bookmarkResult =
      PostingModel(postingitems: <Post>[].obs).obs;

  RefreshController refreshController =
      new RefreshController(initialRefresh: false);

  @override
  void onInit() {
    onRefresh1();
    super.onInit();
  }

  void onRefresh1() async {
    enablepullup.value = true;
    bookmarkResult(PostingModel(postingitems: <Post>[].obs));

    pageNumber = 1;
    bookmarkloadItem();
    await Future.delayed(Duration(microseconds: 500));
    refreshController.refreshCompleted();
  }

  void onLoading1() async {
    pageNumber += 1;
    await Future.delayed(Duration(microseconds: 500));
    //페이지 처리
    bookmarkloadItem();
    refreshController.loadComplete();
  }

  void bookmarkloadItem() async {
    PostingModel bookmarkModel = await bookmarklist(pageNumber);
    PostingModel bookmarkModel2 = await bookmarklist(pageNumber + 1);

    if (bookmarkModel.postingitems[0].id == bookmarkModel2.postingitems[0].id) {
      enablepullup.value = false;
    }
    print(bookmarkModel.postingitems);
    // if (pageNumber == 1) {
    //   questionResult.update((val) {
    //     val!.questionitems.addAll(questionModel.questionitems);
    //   });
    // }
    bookmarkResult.update((val) {
      val!.postingitems.addAll(bookmarkModel.postingitems);
    });
  }
}
