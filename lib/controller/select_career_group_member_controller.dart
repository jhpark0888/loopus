import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'package:loopus/controller/home_controller.dart';

import '../model/user_model.dart';

class SelectCareerGroupMemberController extends GetxController {
  RxString searchWord = ''.obs;
  RxList<Person> followList = <Person>[].obs;
  RxList<Person> searchList = <Person>[].obs;
  RxList<Person> selectList = <Person>[].obs;
  RxBool isLoadaing = false.obs;
  @override
  void onInit() {
    getfollowlist(
            HomeController.to.myProfile.value.userId, FollowListType.following)
        .then((value) {
      if (value.isError == false) {
        List<Person> tempList = [];
        if (value.data['follow'] != []) {
          tempList = List.from(value.data['follow'])
              .map((e) => Person.fromJson(e))
              .toList();
          // CareerDetailController.to.members.forEach((element) {
          //   print(element.realName);
          //   print(tempList.where((e)=>e == element));
          //   print(tempList);
          // });
          tempList.sort((a, b) => a.name.compareTo(b.name));
        }
        followList.value = tempList;
      }
    });
    debounce(searchWord, (_) {
      if (searchWord.value != '') {}
    });
    super.onInit();
  }
}
