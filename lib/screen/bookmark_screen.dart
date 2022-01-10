import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/widget/bookmark_widget.dart';
import 'package:loopus/widget/custom_refresher.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarkScreen extends StatelessWidget {
  BookmarkController bookmarkController = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            color: Color(0xffe7e7e7),
            height: 1,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          '북마크',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Nanum',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 54.0),
        child: Obx(() => CustomRefresher(
              controller: bookmarkController.refreshController,
              enablePullDown: true,
              enablePullUp: bookmarkController.enablepullup,
              onRefresh: bookmarkController.onRefresh1,
              onLoading: bookmarkController.onLoading1,
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                key: PageStorageKey("key1"),
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Column(
                      children: [
                        SizedBox(
                          height: 15,
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
                          child: BookmarkWidget(
                            index: index,
                            post: bookmarkController
                                .bookmarkResult.value.postingitems[index],
                          ),
                        ),
                      );
                    },
                    childCount: bookmarkController
                        .bookmarkResult.value.postingitems.length,
                  )),
                ],
              ),
            )),
      ),
    );
  }
}
