import 'package:get/get.dart';
import 'package:loopus/api/spec_api.dart';
import 'package:loopus/model/activity_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActivityDetailController extends GetxController {
  static ActivityDetailController get to => Get.find();
  ActivityDetailController({required this.activity});

  Activity activity;
  RxList<Post> posts = <Post>[].obs;

  RefreshController loadController = RefreshController();

  @override
  void onInit() async {
    // TODO: implement onInit
    actiDetailLoad();
    classPostsLoad();
    super.onInit();
  }

  void actiDetailLoad() async {
    String actiType = activity is SchoolActi ? "school" : "activity";
    getDetailSpec(
      activity.id,
      actiType,
    ).then((value) {
      if (value.isError == false) {
        List<Person> memberList = List.from(value.data["member"])
            .map((member) => Person.fromJson(member))
            .toList();

        activity.member.value = memberList;
      } else {
        errorSituation(value);
      }
    });
  }

  void classPostsLoad() {
    if (activity.career != null) {
      getDetailPosts(activity.career!.id, posts.isNotEmpty ? posts.last.id : 0)
          .then((value) {
        if (value.isError == false) {
          List<Post> postList =
              List.from(value.data).map((post) => Post.fromJson(post)).toList();

          if (postList.isNotEmpty) {
            posts.addAll(postList);
            loadController.loadComplete();
          } else {
            loadController.loadNoData();
          }
        } else {
          errorSituation(value);
        }
      });
    }
  }
}
