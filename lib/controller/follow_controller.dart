import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';

class FollowController extends GetxController {
  FollowController(
      {required this.islooped, required this.id, required this.lastislooped});
  static FollowController get to => Get.find();
  RxInt islooped;
  int lastislooped;
  int id;

  @override
  void onInit() {
    // TODO: implement onInit
    debounce(islooped, (loop) {
      if (islooped != lastislooped.obs) {
        if (islooped.value == 1) {
          postfollowRequest(id);
          print("팔로우");
        } else {
          deletefollow(id);
          print("팔로우 해제");
        }
        lastislooped = islooped.value;
      } else {
        print("아무일도 안 일어남");
      }
    }, time: Duration(milliseconds: 300));
    super.onInit();
  }
}
