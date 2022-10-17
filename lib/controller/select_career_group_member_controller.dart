import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'package:loopus/controller/home_controller.dart';

import '../model/user_model.dart';

class SelectCareerGroupMemberController extends GetxController {
  RxString searchWord = ''.obs;
  RxList<User> followList = <User>[].obs;
  RxList<User> searchList = <User>[].obs;
  RxList<User> selectList = <User>[].obs;
  @override
  void onInit() {
    getfollowlist(
            HomeController.to.myProfile.value.userid, followlist.following)
        .then((value) {
      if (value.isError == false) {
        List<User> tempList = [];
        if (value.data['follow'] != []) {
          tempList = List.from(value.data['follow'])
              .map((e) => User.fromJson(e))
              .toList();
          // CareerDetailController.to.members.forEach((element) {
          //   print(element.realName);
          //   print(tempList.where((e)=>e == element));
          //   print(tempList);
          // });
          tempList.sort((a, b) => a.realName.compareTo(b.realName));
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