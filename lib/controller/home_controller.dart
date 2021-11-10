import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/widget/home_posting_widget.dart';
import 'package:loopus/widget/question_posting_widget.dart';
import 'package:loopus/widget/recommend_posting_widget.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  List<HomePostingWidget> posting = [];
  List<QuestionPostingWidget> qustion_posting = [];
  List<RecommendPostingWidget> recommend_posting = [];

  @override
  void onInit() {
    for (int i = 0; i < 4; i++) {
      posting.add(HomePostingWidget());
      qustion_posting.add(QuestionPostingWidget());
      recommend_posting.add(RecommendPostingWidget());
    }
    super.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
