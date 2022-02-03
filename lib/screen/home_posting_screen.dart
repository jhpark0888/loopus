import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/scroll_controller.dart';
import 'package:loopus/screen/home_loop_screen.dart';
import 'package:loopus/screen/question_add_content_screen.dart';
import 'package:loopus/screen/question_detail_screen.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/my_question_posting_widget.dart';
import 'package:loopus/widget/question_widget.dart';
import 'package:loopus/widget/custom_refresher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePostingScreen extends StatelessWidget {
  final HomeController homeController = Get.find();
  // final HoverController _hoverController = Get.put(HoverController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SmartRefresher(
          controller: homeController.postingRefreshController,
          enablePullDown:
              (homeController.isPostingLoading.value == true) ? false : true,
          enablePullUp: (homeController.isPostingLoading.value == true)
              ? false
              : homeController.enablePostingPullup.value,
          header: ClassicHeader(
            spacing: 0.0,
            height: 60,
            completeDuration: Duration(milliseconds: 600),
            textStyle: TextStyle(color: mainblack),
            refreshingText: '',
            releaseText: "",
            completeText: "",
            idleText: "",
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
                const Icon(
                  Icons.check_rounded,
                  color: mainblue,
                ),
                const SizedBox(
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
                const SizedBox(
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
            completeDuration: Duration.zero,
            loadingText: "",
            canLoadingText: "",
            idleText: "",
            idleIcon: Container(),
            noMoreIcon: Container(
              child: Text('as'),
            ),
            loadingIcon: Image.asset(
              'assets/icons/loading.gif',
              scale: 6,
            ),
            canLoadingIcon: Image.asset(
              'assets/icons/loading.gif',
              scale: 6,
            ),
          ),
          onRefresh: homeController.onPostingRefresh,
          onLoading: homeController.onPostingLoading,
          child: CustomScrollView(
            // controller:
            //     CustomScrollController.to.customScrollController.value,
            physics: const BouncingScrollPhysics(),
            key: const PageStorageKey("key1"),
            slivers: [
              (homeController.isPostingEmpty.value == false)
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: 16,
                              left: 16,
                              bottom: 8,
                              top: 8,
                            ),
                            child:
                                (homeController.isPostingLoading.value == false)
                                    ? PostingWidget(
                                        item: homeController
                                            .recommandpostingResult
                                            .value
                                            .postingitems[index],
                                      )
                                    : Padding(
                                        padding: EdgeInsets.zero,
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/icons/loading.gif',
                                              scale: 6,
                                            ),
                                            const Text(
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
                            (homeController.isPostingLoading.value == false)
                                ? homeController.recommandpostingResult.value
                                    .postingitems.length
                                : 1,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Text('더 많은 관심을 받는 태그를 알려드릴게요',
                                    style: kSubTitle2Style),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Container(
                                height: 200,
                                child: PageView(
                                  controller: PageController(
                                    viewportFraction: 0.9,
                                    initialPage: 0,
                                  ),
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      color: Colors.red,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      color: Colors.yellow,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }, childCount: 1),
                    ),
              if (homeController.isRecommandFull.value == true)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                '추천 포스팅을 모두 보여드렸어요',
                                style: kSubTitle2Style.copyWith(
                                  color: mainblack,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: Text(
                                '이제부터는 최신 포스팅을 보여드릴게요',
                                style: kButtonStyle.copyWith(
                                  color: mainblue,
                                ),
                              ),
                            ),
                            // TextButton(
                            //   onPressed: () {
                            //     // homeController.hometabcontroller.animateTo(
                            //     //   2,
                            //     //   curve: Curves.easeInOut,
                            //     //   duration: Duration(milliseconds: 300),
                            //     // );
                            //   },
                            //   child: Text(
                            //     '루프한 학생들의 포스팅 읽기',
                            //     style: kButtonStyle.copyWith(
                            //       color: mainblue,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              if (homeController.isRecommandFull.value == true)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                          left: 16,
                          bottom: 8,
                          top: 8,
                        ),
                        child: (homeController.isPostingLoading.value == false)
                            ? PostingWidget(
                                item: homeController.latestpostingResult.value
                                    .postingitems[index],
                              )
                            : Padding(
                                padding: EdgeInsets.zero,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/loading.gif',
                                      scale: 6,
                                    ),
                                    const Text(
                                      '포스팅 받아오는 중...',
                                      style: TextStyle(
                                          fontSize: 10, color: mainblue),
                                    )
                                  ],
                                ),
                              ),
                      );
                    },
                    childCount: (homeController.isPostingLoading.value == false)
                        ? homeController
                            .latestpostingResult.value.postingitems.length
                        : 1,
                  ),
                ),
              if (homeController.enablePostingPullup.value == false)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                '모든 포스팅을 보여드렸어요',
                                style: kSubTitle2Style.copyWith(
                                  color: mainblack,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Center(
                              child: Text(
                                '팔로잉한 학생들의 포스팅도 확인해보세요',
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
    );
  }
}
