import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/question_add_content_screen.dart';
import 'package:loopus/screen/question_screen.dart';
import 'package:loopus/widget/home_posting_widget.dart';
import 'package:loopus/widget/my_question_posting_widget.dart';
import 'package:loopus/widget/question_posting_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePostingScreen extends StatelessWidget {
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => SmartRefresher(
          controller: homeController.refreshController1,
          enablePullDown: true,
          enablePullUp: homeController.enablepullup1.value,
          header: ClassicHeader(
            textStyle: TextStyle(color: mainblack),
            refreshingText: '',
            releaseText: "",
            completeText: "",
            idleText: "",
            releaseIcon: Icon(Icons.refresh_rounded, color: mainblack),
            completeIcon: Icon(Icons.done_rounded, color: mainblue),
            idleIcon: Icon(Icons.arrow_downward_rounded, color: mainblack),
          ),
          footer: ClassicFooter(
            textStyle: TextStyle(color: mainblack),
            loadingText: "",
            canLoadingText: "",
            idleText: "",
            idleIcon: CircularProgressIndicator(
              color: mainblack,
              strokeWidth: 1.2,
            ),
            canLoadingIcon: CircularProgressIndicator(
              color: mainblack,
              strokeWidth: 1.2,
            ),
          ),
          onRefresh: homeController.onRefresh1,
          onLoading: homeController.onLoading1,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            key: PageStorageKey("key1"),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ])),
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
        ),
      ),
    );
  }
}
