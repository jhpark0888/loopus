import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/question_add_content_screen.dart';
import 'package:loopus/screen/question_screen.dart';
import 'package:loopus/screen/search_screen.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/home_posting_widget.dart';
import 'package:loopus/widget/my_question_posting_widget.dart';
import 'package:loopus/widget/question_posting_widget.dart';
import 'package:loopus/widget/custom_refresher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LoopScreen extends StatelessWidget {
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SmartRefresher(
          controller: homeController.loopRefreshController,
          enablePullDown: !homeController.isLoopEmpty.value
              ? (homeController.isLoopLoading.value == true)
                  ? false
                  : true
              : false,
          enablePullUp: (homeController.isLoopLoading.value == true)
              ? false
              : homeController.enableLoopPullup.value,
          header: ClassicHeader(
            textStyle: TextStyle(color: mainblack),
            releaseText: "",
            completeText: "",
            idleText: "",
            refreshingText: "",
            refreshingIcon: Column(
              children: [
                Image.asset(
                  'assets/icons/loading.gif',
                  scale: 6,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '새로운 포스팅 받는 중...',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mainblue.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            releaseIcon: Column(
              children: [
                Image.asset(
                  'assets/icons/loading.gif',
                  scale: 6,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '새로운 포스팅 받는 중...',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mainblue.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            completeIcon: Column(
              children: [
                Icon(
                  Icons.check_rounded,
                  color: mainblue,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '완료!',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mainblue.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            idleIcon: Column(
              children: [
                Image.asset(
                  'assets/icons/loading.png',
                  scale: 12,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '당겨주세요',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: mainblue.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
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
          onRefresh: homeController.onLoopRefresh,
          onLoading: homeController.onLoopLoading,
          child: Obx(
            () => CustomScrollView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              key: PageStorageKey("key3"),
              slivers: [
                (homeController.isLoopEmpty.value == false)
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                            //on tap event 발생시
                            onTap: () async {},
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 16,
                                left: 16,
                                top: 8,
                                bottom: 8,
                              ),
                              child:
                                  (homeController.isLoopLoading.value == false)
                                      ? HomePostingWidget(
                                          index: index,
                                          item: homeController.loopResult.value
                                              .postingitems[index],
                                        )
                                      : Column(
                                          children: [
                                            Image.asset(
                                              'assets/icons/loading.gif',
                                              scale: 6,
                                            ),
                                            Text(
                                              '포스팅 받아오는 중...',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: mainblue),
                                            )
                                          ],
                                        ),
                            ),
                          );
                        },
                        childCount:
                            homeController.loopResult.value.postingitems.length,
                      ))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Column(
                              children: [
                                Text(
                                  '아직 루프를 한 학생이 없어요',
                                  style: kSubTitle2Style,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.to(SearchTypingScreen());
                                  },
                                  child: Text(
                                    '관심사가 비슷한 학생 찾아보기',
                                    style: kButtonStyle.copyWith(
                                      color: mainblue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }, childCount: 1),
                      ),
                if (homeController.enableLoopPullup.value == false)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Container(
                          height: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  '포스팅을 모두 보여드렸어요',
                                  style: kSubTitle2Style.copyWith(
                                    color: mainblack,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // homeController.hometabcontroller.animateTo(
                                  //   2,
                                  //   curve: Curves.easeInOut,
                                  //   duration: Duration(milliseconds: 300),
                                  // );
                                },
                                child: Text(
                                  '루프한 학생들의 포스팅 읽기',
                                  style: kButtonStyle.copyWith(
                                    color: mainblue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
