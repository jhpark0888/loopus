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

class LoopScreen extends StatelessWidget {
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => SmartRefresher(
          controller: homeController.refreshController3,
          enablePullDown: true,
          enablePullUp: homeController.enablepullup3.value,
          header: ClassicHeader(
              textStyle: TextStyle(color: mainblack),
              releaseText: "새로고침",
              completeText: "완료",
              idleText: "",
              releaseIcon: Icon(Icons.refresh, color: mainblack),
              completeIcon: Icon(Icons.done, color: mainblue),
              idleIcon: Icon(Icons.arrow_downward, color: mainblack)),
          footer: ClassicFooter(
            textStyle: TextStyle(color: mainblack),
            loadingText: "",
            canLoadingText: "",
            idleText: "",
            idleIcon: CircularProgressIndicator(
              color: mainblack,
              strokeWidth: 3,
            ),
            canLoadingIcon: CircularProgressIndicator(
              color: mainblack,
              strokeWidth: 3,
            ),
          ),
          onRefresh: homeController.onRefresh3,
          onLoading: homeController.onLoading3,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            key: PageStorageKey("key3"),
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
                        item:
                            homeController.loopResult.value.postingitems[index],
                      ),
                    ),
                  );
                },
                childCount: homeController.loopResult.value.postingitems.length,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
