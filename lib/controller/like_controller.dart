import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';

enum Liketype { post, comment, reply }

class LikeController extends GetxController {
  LikeController(
      {required this.isLiked,
      required this.id,
      required this.lastisliked,
      required this.liketype});
  static LikeController get to => Get.find();
  RxInt isLiked;
  int lastisliked;
  int id;
  Liketype liketype;

  @override
  void onInit() {
    // TODO: implement onInit
    debounce(isLiked, (like) {
      if (isLiked != lastisliked.obs) {
        print("좋아요");
        lastisliked = isLiked.value;

        // likepost(id, liketype.name);
      } else {
        print("아무일도 안 일어남");
      }
    }, time: Duration(milliseconds: 300));
    super.onInit();
  }
}
