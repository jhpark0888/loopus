// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/likepeople_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class LikePeopleScreen extends StatelessWidget {
  LikePeopleScreen({Key? key, required this.postid}) : super(key: key);

  late LikePeopleController controller =
      Get.put(LikePeopleController(postid: postid), tag: postid.toString());

  int postid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "좋아요 리스트",
        bottomBorder: false,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => controller.likepeoplescreenstate.value == ScreenState.loading
              ? Column(children: [
                  SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: Image.asset('assets/icons/loading.gif', scale: 9),
                  ),
                ])
              : controller.likepeoplescreenstate.value == ScreenState.disconnect
                  ? DisconnectReloadWidget(reload: () {
                      getlikepeoele(postid);
                    })
                  : controller.likepeoplescreenstate.value == ScreenState.error
                      ? ErrorReloadWidget(reload: () {
                          getlikepeoele(postid);
                        })
                      : Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 40),
                          child: Column(
                              children: controller.likelist
                                  .map((user) => PersonTileWidget(user: user))
                                  .toList()),
                        ),
        ),
      ),
    );
  }
}
