// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/banpeople_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';

class BanPeopleScreen extends StatelessWidget {
  BanPeopleScreen({
    Key? key,
  }) : super(key: key);

  late BanPeopleController controller = Get.put(BanPeopleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "차단 목록",
        bottomBorder: false,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => controller.banpeoplescreenstate.value == ScreenState.loading
              ? Column(children: [
                  SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: Image.asset('assets/icons/loading.gif', scale: 9),
                  ),
                ])
              : controller.banpeoplescreenstate.value == ScreenState.disconnect
                  ? DisconnectReloadWidget(reload: () {
                      controller.loadbanlist();
                    })
                  : controller.banpeoplescreenstate.value == ScreenState.error
                      ? ErrorReloadWidget(reload: () {
                          controller.loadbanlist();
                        })
                      : Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 40),
                          child: Obx(
                            () => controller.banlist.isEmpty
                                ? Column(
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: Get.height / 3),
                                          child: Text(
                                            '차단한 유저가 없어요',
                                            style: kSubTitle3Style.copyWith(
                                              color:
                                                  mainblack.withOpacity(0.38),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: controller.banlist
                                        .map((user) =>
                                            PersonTileWidget(user: user))
                                        .toList()),
                          ),
                        ),
        ),
      ),
    );
  }
}
