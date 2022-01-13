// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/inquiry_screen.dart';
import 'package:loopus/screen/privacypolicy_screen.dart';
import 'package:loopus/screen/termsofservice_screen.dart';
import 'package:loopus/screen/userinfo_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';

class LoopPeopleScreen extends StatelessWidget {
  LoopPeopleScreen({Key? key, required this.userid, required this.loopcount})
      : super(key: key);

  int userid;
  int loopcount;
  RxList<User> looplist = <User>[].obs;

  @override
  Widget build(BuildContext context) {
    getlooplist(userid).then((value) {
      looplist(value);
      ProfileController.to.isLoopPeopleLoading(false);
    });
    return Scaffold(
        appBar: AppBarWidget(
          title: '루프 ${loopcount.toString()}명',
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => ProfileController.to.isLoopPeopleLoading.value
                ? Column(children: [
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/icons/loading.gif',
                        scale: 5,
                      ),
                    ),
                  ])
                : Column(
                    children: looplist
                        .map((friend) => PersonTileWidget(user: friend))
                        .toList()),
          ),
        )
        // FutureBuilder<List<User>>(
        //     future: getlooplist(userid.toString()),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return Center(
        //           child: Image.asset(
        //             'assets/icons/loading.gif',
        //             scale: 10,
        //           ),
        //         );
        //       } else {
        //         return Padding(
        //           padding: const EdgeInsets.only(
        //             top: 16,
        //             bottom: 32,
        //           ),
        //           child: ListView(
        //               children: snapshot.data!
        //                   .map((friend) => PersonTileWidget(user: friend))
        //                   .toList()),
        //         );
        //       }
        //     })
        );
  }
}
