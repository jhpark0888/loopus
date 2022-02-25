import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';

class LoopPeopleController extends GetxController {
  LoopPeopleController({required this.userid});
  static LoopPeopleController get to => Get.find();
  Rx<ScreenState> followerscreenstate = ScreenState.loading.obs;
  Rx<ScreenState> followingscreenstate = ScreenState.loading.obs;

  int userid;
  RxList<User> followerlist = <User>[].obs;
  RxList<User> followinglist = <User>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getfollowlist(userid, followlist.follower);
    getfollowlist(userid, followlist.following);
    super.onInit();
  }
}
