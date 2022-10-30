import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/httpresponse_model.dart';
import 'package:loopus/model/user_model.dart';

class BanPeopleController extends GetxController {
  static BanPeopleController get to => Get.find();
  Rx<ScreenState> banpeoplescreenstate = ScreenState.loading.obs;

  RxList<Person> banlist = <Person>[].obs;

  void loadbanlist() async {
    banpeoplescreenstate(ScreenState.loading);
    HTTPResponse result = await getbanlist();
    if (result.isError == false) {
      List<Person> userlist = List.from(result.data['banlist'])
          .map((banuser) => Person.fromJson(banuser))
          .toList();
      banlist(userlist);
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
