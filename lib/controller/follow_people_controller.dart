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
  RxList<Person> userList = <Person>[].obs;
  Rx<ScreenState> followPeopleScreenState = ScreenState.loading.obs;

  void getfollowPeople() {
    getfollowlist(userId, listType).then((value) {
      if (value.isError == false) {
        List<Person> templist = List.from(value.data["follow"])
            .map((friend) => Person.fromJson(friend))
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
