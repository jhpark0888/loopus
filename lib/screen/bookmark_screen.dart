import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/bookmark_widget.dart';
import 'package:loopus/widget/custom_refresher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarkScreen extends StatelessWidget {
  final BookmarkController bookmarkController = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '북마크',
        bottomBorder: false,
      ),
      body: Obx(
        () => SmartRefresher(
          controller: bookmarkController.refreshController,
          enablePullDown: true,
          enablePullUp: bookmarkController.enableBookmarkPullup.value,
          header: ClassicHeader(
            textStyle: const TextStyle(color: mainblack),
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
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '북마크 새로고침 중...',
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
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '북마크 새로고침 중...',
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
            textStyle: TextStyle(color: mainblack),
            loadingText: "",
            canLoadingText: "",
            idleText: "",
            loadingIcon: Image.asset(
              'assets/icons/loading.gif',
              scale: 6,
            ),
            canLoadingIcon: Image.asset(
              'assets/icons/loading.gif',
              scale: 6,
            ),
          ),
          onRefresh: bookmarkController.onBookmarkRefresh,
          onLoading: bookmarkController.onBookmarkLoading,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            key: const PageStorageKey("key1"),
            slivers: [
              (bookmarkController.isBookmarkEmpty.value == false)
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: (index == 0) ? 16 : 8,
                            right: 16,
                            left: 16,
                            bottom: (index ==
                                    bookmarkController.bookmarkResult.value
                                            .postingitems.length -
                                        1)
                                ? 24
                                : 8,
                          ),
                          child: (bookmarkController.isBookmarkLoading.value ==
                                  false)
                              ? BookmarkWidget(
                                  index: index,
                                  item: bookmarkController
                                      .bookmarkResult.value.postingitems[index],
                                )
                              : Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/loading.gif',
                                      scale: 6,
                                    ),
                                    Text(
                                      '북마크한 포스팅 받아오는 중...',
                                      style: TextStyle(
                                          fontSize: 10, color: mainblue),
                                    )
                                  ],
                                ),
                        );
                      },
                      childCount:
                          (bookmarkController.isBookmarkLoading.value == false)
                              ? bookmarkController
                                  .bookmarkResult.value.postingitems.length
                              : 1,
                    ))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          width: Get.width,
                          height: Get.height * 0.75,
                          child: Center(
                            child: Text(
                              '아직 북마크한 포스팅이 없어요',
                              style: kSubTitle2Style,
                            ),
                          ),
                        );
                      }, childCount: 1),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
