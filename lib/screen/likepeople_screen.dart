// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class LikePeopleScreen extends StatelessWidget {
  LikePeopleScreen({Key? key, required this.postid}) : super(key: key);

  int postid;
  RxBool isLikeListLoading = true.obs;
  RxList<User> likelist = <User>[].obs;

  @override
  Widget build(BuildContext context) {
    getlikepeoele(postid).then((value) {
      likelist(value);
      isLikeListLoading(false);
    });
    return Scaffold(
      appBar: AppBarWidget(
        title: "좋아요 리스트",
        bottomBorder: false,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => isLikeListLoading.value
              ? Column(children: [
                  SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: Image.asset('assets/icons/loading.gif', scale: 9),
                  ),
                ])
              : Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 40),
                  child: Column(
                      children: likelist
                          .map((user) => PersonTileWidget(user: user))
                          .toList()),
                ),
        ),
      ),
    );
  }
}
