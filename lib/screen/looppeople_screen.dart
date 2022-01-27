// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/contact_email_screen.dart';
import 'package:loopus/screen/privacypolicy_screen.dart';
import 'package:loopus/screen/termsofservice_screen.dart';
import 'package:loopus/screen/userinfo_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class LoopPeopleScreen extends StatelessWidget {
  LoopPeopleScreen({Key? key, required this.userid, required this.loopcount})
      : super(key: key);

  int userid;
  int loopcount;
  RxList<User> followerlist = <User>[].obs;
  RxList<User> followinglist = <User>[].obs;

  @override
  Widget build(BuildContext context) {
    getfollowlist(userid, followlist.follower).then((value) {
      followerlist(value);
    });
    getfollowlist(userid, followlist.following).then((value) {
      followinglist(value);
      ProfileController.to.isLoopPeopleLoading(false);
    });
    return Scaffold(
        appBar: AppBarWidget(),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: true,
                    automaticallyImplyLeading: false,
                    expandedHeight: 43,
                    toolbarHeight: 43,
                    elevation: 0,
                    flexibleSpace: TabBar(
                      labelStyle: kButtonStyle,
                      labelColor: mainblack,
                      unselectedLabelStyle: kBody1Style,
                      unselectedLabelColor: mainblack.withOpacity(0.6),
                      indicator: const UnderlineIndicator(
                        strokeCap: StrokeCap.round,
                        borderSide: BorderSide(width: 2),
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
                  )
                ];
              },
              body: TabBarView(children: [
                Obx(
                  () => ProfileController.to.isLoopPeopleLoading.value
                      ? Column(children: [
                          SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: Image.asset(
                              'assets/icons/loading.gif',
                              scale: 5,
                            ),
                          ),
                        ])
                      : Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 40),
                          child: Column(
                              children: followerlist
                                  .map((friend) =>
                                      PersonTileWidget(user: friend))
                                  .toList()),
                        ),
                ),
                Obx(
                  () => ProfileController.to.isLoopPeopleLoading.value
                      ? Column(children: [
                          SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: Image.asset(
                              'assets/icons/loading.gif',
                              scale: 5,
                            ),
                          ),
                        ])
                      : Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 40),
                          child: Column(
                              children: followinglist
                                  .map((friend) =>
                                      PersonTileWidget(user: friend))
                                  .toList()),
                        ),
                ),
              ])),
        ));
  }
}
