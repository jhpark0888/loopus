import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';

class FollowPeopleController extends GetxController {
  FollowPeopleController({
    required this.userId,
    required this.listType,
  });
  static FollowPeopleController get to => Get.find();

  int userId;
  FollowListType listType;
  RxList<User> userList = <User>[].obs;
  Rx<ScreenState> followPeopleScreenState = ScreenState.loading.obs;

  void getfollowPeople() async {
    await getfollowlist(userId, listType).then((value) {
      if (value.isError == false) {
        List<User> templist = List.from(value.data["follow"])
                .map((friend) => User.fromJson(friend))
                .toList() +
            List.from(value.data["corp_follow"])
                .map((friend) => User.fromJson(friend))
                .toList();

        userList.addAll(templist);
        followPeopleScreenState(ScreenState.success);
      } else {
        errorSituation(value, screenState: followPeopleScreenState);
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getfollowPeople();
    super.onInit();
  }
}
