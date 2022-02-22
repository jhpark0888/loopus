import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/posting_widget.dart';

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
