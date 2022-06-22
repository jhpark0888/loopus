import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';

enum Liketype { post, comment, reply }

class LikeController extends GetxController {
  LikeController(
      {required this.isliked,
      required this.id,
      required this.lastisliked,
      required this.liketype});
  static LikeController get to => Get.find();
  RxInt isliked;
  int lastisliked;
  int id;
  Liketype liketype;

  @override
  void onInit() {
    // TODO: implement onInit
    debounce(isliked, (like) {
      if (isliked != lastisliked.obs) {
        print("좋아요");
        lastisliked = isliked.value;

        likepost(id, liketype.name);
      } else {
        print("아무일도 안 일어남");
      }
    }, time: Duration(milliseconds: 300));
    super.onInit();
  }
}
