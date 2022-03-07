import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/user_model.dart';

class BanPeopleController extends GetxController {
  static BanPeopleController get to => Get.find();
  Rx<ScreenState> banpeoplescreenstate = ScreenState.loading.obs;

  RxList<User> banlist = <User>[].obs;

  void loadbanlist() async {
    banpeoplescreenstate(ScreenState.loading);
    HTTPResponse result = await getbanlist();
    if (result.isError == false) {
      banlist(result.data);
      banpeoplescreenstate(ScreenState.success);
    } else {
      if (result.errorData!["statusCode"] == 59) {
        banpeoplescreenstate(ScreenState.disconnect);
      } else {
        banpeoplescreenstate(ScreenState.error);
      }
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    loadbanlist();
    super.onInit();
  }
}
