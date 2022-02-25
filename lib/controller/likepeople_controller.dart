import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/user_model.dart';

class LikePeopleController extends GetxController {
  LikePeopleController({required this.postid});
  static LikePeopleController get to => Get.find();
  Rx<ScreenState> likepeoplescreenstate = ScreenState.loading.obs;

  RxList<User> likelist = <User>[].obs;

  int postid;

  @override
  void onInit() {
    // TODO: implement onInit
    getlikepeoele(postid);
    super.onInit();
  }
}
