import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/utils/error_control.dart';

class BanPeopleController extends GetxController {
  static BanPeopleController get to => Get.find();
  Rx<ScreenState> banpeoplescreenstate = ScreenState.loading.obs;

  RxList<User> banlist = <User>[].obs;

  void loadbanlist() async {
    banpeoplescreenstate(ScreenState.loading);
    HTTPResponse result = await getbanlist();
    if (result.isError == false) {
      List<Person> userlist = result.data;
      if(userlist.isNotEmpty){

      for (var user in userlist) {
        user.banned(BanState.ban);
      }
      banlist(userlist);
      }
      banpeoplescreenstate(ScreenState.success);
    } else {
      errorSituation(result, screenState: banpeoplescreenstate);
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    loadbanlist();
    super.onInit();
  }
}
