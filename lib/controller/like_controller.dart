import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/widget/posting_widget.dart';

class LikeController extends GetxController {
  LikeController(
      {required this.isliked, required this.id, required this.lastisliked});
  static LikeController get to => Get.find();
  RxInt isliked;
  int lastisliked;
  int id;

  @override
  void onInit() {
    // TODO: implement onInit
    debounce(isliked, (like) {
      if (isliked != lastisliked.obs) {
        print("좋아요");
        lastisliked = isliked.value;
        likepost(id);
      } else {
        print("아무일도 안 일어남");
      }
    }, time: Duration(milliseconds: 300));
    super.onInit();
  }
}
