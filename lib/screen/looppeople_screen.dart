// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/looppeople_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/contact_email_screen.dart';
import 'package:loopus/screen/privacypolicy_screen.dart';
import 'package:loopus/screen/termsofservice_screen.dart';
import 'package:loopus/screen/userinfo_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class LoopPeopleScreen extends StatelessWidget {
  LoopPeopleScreen({Key? key, required this.userid, required this.loopcount})
      : super(key: key);

  late LoopPeopleController controller =
      Get.put(LoopPeopleController(userid: userid), tag: userid.toString());
  int userid;
  int loopcount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
        ),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverSafeArea(
                      top: false,
                      bottom: false,
                      sliver: SliverAppBar(
                        pinned: true,
                        automaticallyImplyLeading: false,
                        expandedHeight: 43,
                        toolbarHeight: 43,
                        elevation: 0,
                        flexibleSpace: Column(
                          children: [
                            TabBar(
                              labelStyle: kButtonStyle,
                              labelColor: mainblack,
                              unselectedLabelStyle: kBody1Style,
                              unselectedLabelColor: mainblack.withOpacity(0.6),
                              indicator: const UnderlineIndicator(
                                strokeCap: StrokeCap.round,
                                borderSide: BorderSide(width: 1.2),
                              ),
                              indicatorColor: mainblack,
                              tabs: const [
                                Tab(
                                  height: 40,
                                  child: Text(
                                    "팔로워",
                                  ),
                                ),
                                Tab(
                                  height: 40,
                                  child: Text(
                                    "팔로잉",
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: 1,
                              color: const Color(0xffe7e7e7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ];
              },
              body: TabBarView(children: [
                Obx(
                  () => controller.followerscreenstate.value ==
                          ScreenState.loading
                      ? Column(children: [
                          SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: Image.asset(
                              'assets/icons/loading.gif',
                              scale: 7,
                            ),
                          ),
                        ])
                      : controller.followerscreenstate.value ==
                              ScreenState.disconnect
                          ? DisconnectReloadWidget(reload: () {
                              getfollowlist(userid, followlist.follower);
                            })
                          : controller.followerscreenstate.value ==
                                  ScreenState.error
                              ? ErrorReloadWidget(reload: () {
                                  getfollowlist(userid, followlist.follower);
                                })
                              : controller.followerlist.isNotEmpty
                                  ? ListView(
                                      children: controller.followerlist
                                          .map((friend) =>
                                              PersonTileWidget(user: friend))
                                          .toList())
                                  : Container(
                                      width: Get.width,
                                      height: Get.height * 0.75,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '아직 팔로워가 없어요',
                                            style: kSubTitle3Style.copyWith(
                                              color:
                                                  mainblack.withOpacity(0.38),
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.1,
                                          ),
                                        ],
                                      ),
                                    ),
                ),
                Obx(
                  () => controller.followingscreenstate.value ==
                          ScreenState.loading
                      ? Column(children: [
                          SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: Image.asset(
                              'assets/icons/loading.gif',
                              scale: 7,
                            ),
                          ),
                        ])
                      : controller.followingscreenstate.value ==
                              ScreenState.disconnect
                          ? DisconnectReloadWidget(reload: () {
                              getfollowlist(userid, followlist.following);
                            })
                          : controller.followingscreenstate.value ==
                                  ScreenState.error
                              ? ErrorReloadWidget(reload: () {
                                  getfollowlist(userid, followlist.following);
                                })
                              : controller.followinglist.isNotEmpty
                                  ? ListView(
                                      children: controller.followinglist
                                          .map((friend) =>
                                              PersonTileWidget(user: friend))
                                          .toList())
                                  : Container(
                                      width: Get.width,
                                      height: Get.height * 0.75,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '아직 아무도 팔로잉하지 않았어요',
                                            style: kSubTitle3Style.copyWith(
                                              color:
                                                  mainblack.withOpacity(0.38),
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.height * 0.1,
                                          ),
                                        ],
                                      ),
                                    ),
                ),
              ])),
        ));
  }
}
