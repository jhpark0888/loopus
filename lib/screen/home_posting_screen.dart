import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/scroll_controller.dart';
import 'package:loopus/screen/question_add_content_screen.dart';
import 'package:loopus/screen/question_screen.dart';
import 'package:loopus/widget/home_posting_widget.dart';
import 'package:loopus/widget/my_question_posting_widget.dart';
import 'package:loopus/widget/question_posting_widget.dart';
import 'package:loopus/widget/custom_refresher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePostingScreen extends StatelessWidget {
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => CustomRefresher(
            controller: homeController.refreshController1,
            enablePullDown: true,
            enablePullUp: homeController.enablepullup1,
            onRefresh: homeController.onRefresh1,
            onLoading: homeController.onLoading1,
            child: CustomScrollView(
              // controller:
              //     CustomScrollController.to.customScrollController.value,
              physics: BouncingScrollPhysics(),
              key: PageStorageKey("key1"),
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      //on tap event 발생시
                      onTap: () async {},
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                          left: 16,
                          bottom: 8,
                          top: 8,
                        ),
                        child: HomePostingWidget(
                          index: index,
                          key: Key(
                            toString(),
                          ),
                          item: homeController
                              .postingResult.value.postingitems[index],
                        ),
                      ),
                    );
                  },
                  childCount:
                      homeController.postingResult.value.postingitems.length,
                )),
              ],
            ),
          )),
    );
  }
}
