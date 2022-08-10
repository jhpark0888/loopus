import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/rank_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LikePeopleController {
  LikePeopleController({required this.id, required this.likeType});
  Rx<ScreenState> likepeoplescreenstate = ScreenState.loading.obs;

  RefreshController refreshController = RefreshController();

  RxList<User> likeUserList = <User>[].obs;
  contentType likeType;

  int id;

  void onRefresh() {
    likePeopleLoad();
    refreshController.refreshCompleted();
  }

  void likePeopleLoad() async {
    await getlikepeoele(id, likeType).then((value) {
      if (value.isError == false) {
        likeUserList(
            List.from(value.data).map((user) => User.fromJson(user)).toList());
        likepeoplescreenstate(ScreenState.success);
      } else {
        errorSituation(value, screenState: likepeoplescreenstate);
      }
    });
  }
}
