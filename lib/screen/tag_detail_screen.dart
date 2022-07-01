import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/tag_detail_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/custom_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'dart:math' as math;

class TagDetailScreen extends StatelessWidget {
  // final SearchController searchController = Get.find();
  TagDetailScreen({required this.tag});

  late final TagDetailController _controller =
      Get.put(TagDetailController(tag.tagId), tag: tag.tagId.toString());
  Tag tag;

  Widget emptyTagWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        '"${tag.tag}"에 대한 결과가 없습니다',
        style: kmain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollNoneffectWidget(
        child: NestedScrollView(
          // physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                title: Tagwidget(
                  tag: tag,
                  isonTap: false,
                ),
                centerTitle: true,
                // bottom: PreferredSize(
                //   preferredSize: Size.fromHeight(0),
                //   child: Container(),
                // ),
                pinned: true,
                toolbarHeight: 44,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: SvgPicture.asset(
                    'assets/icons/Back_icon.svg',
                  ),
                ),
                automaticallyImplyLeading: false,

                // flexibleSpace: _CustomSpace(tag.tag, tag.count.toString()),
                // expandedHeight: Get.height * 0.15,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      "최근 태그 사용 동향",
                      style: kmain.copyWith(color: maingray),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 130,
                            child: Obx(
                              () => Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: _controller.tagUsageTrendNum.entries
                                    .map((entry) => Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _controller.teptNumMap[entry.key]
                                                  .toString(),
                                              style: kmain.copyWith(
                                                  color: mainblue),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            AnimatedSize(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              child: Container(
                                                height: entry.value.toDouble(),
                                                width: 14,
                                                decoration: BoxDecoration(
                                                    color: mainblue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                              ),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: _controller.tagUsageTrendNum.keys
                                  .map((month) => Text(
                                        '$month월',
                                        style: kmain,
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: true,
                  bottom: false,
                  sliver: SliverAppBar(
                    pinned: true,
                    automaticallyImplyLeading: false,
                    expandedHeight: 43,
                    toolbarHeight: 43,
                    elevation: 0,
                    flexibleSpace: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TabBar(
                          controller: _controller.tabController,
                          labelStyle: kmainbold,
                          labelColor: mainblack,
                          unselectedLabelStyle:
                              kmainbold.copyWith(color: dividegray),
                          unselectedLabelColor: dividegray,
                          automaticIndicatorColorAdjustment: false,
                          indicator: const UnderlineIndicator(
                            strokeCap: StrokeCap.round,
                            borderSide: BorderSide(width: 2, color: mainblack),
                          ),
                          tabs: const [
                            Tab(
                              height: 40,
                              child: Text(
                                "인기",
                              ),
                            ),
                            Tab(
                              height: 40,
                              child: Text(
                                "최신",
                              ),
                            )
                          ],
                        ),
                        Divider(
                          height: 1,
                          thickness: 2,
                          color: dividegray,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _controller.tabController,
            children: [
              Obx(
                () => _controller.isTagLoadingList[0].value
                    ? const LoadingWidget()
                    : _controller.isTagEmptyList[0].value == true
                        ? emptyTagWidget()
                        : Obx(
                            () => SmartRefresher(
                              physics: const BouncingScrollPhysics(),
                              primary: true,
                              enablePullDown: false,
                              enablePullUp: true,
                              controller: _controller.refreshControllerList[0],
                              footer: const MyCustomFooter(),
                              onLoading: _controller.onLoading,
                              child: ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  itemBuilder: (context, index) {
                                    return PostingWidget(
                                      item: _controller.tagPopPostList[index],
                                      type: PostingWidgetType.search,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return DivideWidget(
                                      height: 10,
                                    );
                                  },
                                  itemCount: _controller.tagPopPostList.length),
                            ),
                          ),
              ),
              Obx(
                () => _controller.isTagLoadingList[1].value
                    ? const LoadingWidget()
                    : _controller.isTagEmptyList[1].value == true
                        ? emptyTagWidget()
                        : Obx(
                            () => SmartRefresher(
                              physics: const BouncingScrollPhysics(),
                              primary: true,
                              enablePullDown: false,
                              enablePullUp: true,
                              controller: _controller.refreshControllerList[1],
                              footer: const MyCustomFooter(),
                              onLoading: _controller.onLoading,
                              child: ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  itemBuilder: (context, index) {
                                    return PostingWidget(
                                      item: _controller.tagNewPostList[index],
                                      type: PostingWidgetType.search,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return DivideWidget(
                                      height: 10,
                                    );
                                  },
                                  itemCount: _controller.tagNewPostList.length),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class _CustomSpace extends StatelessWidget {
//   _CustomSpace(this.tagTitle, this.tagCount);
//   String tagTitle;
//   var tagCount;

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     final double statusBarHeight = MediaQuery.of(context).padding.top;
//     var numberFormat = NumberFormat('###,###,###,###');

//     return LayoutBuilder(
//       builder: (context, c) {
//         var top = c.biggest.height;

//         final settings = context
//             .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
//         final deltaExtent = settings!.maxExtent - settings.minExtent;
//         final t =
//             (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
//                 .clamp(0.0, 1.0);
//         final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
//         const fadeEnd = 1.0;
//         final opacity1 = 1.0 - Interval(0.0, 0.4).transform(t);
//         final opacity2 = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

//         return Stack(
//           children: [
//             SafeArea(
//               child: Center(
//                 child: Opacity(
//                   opacity: 1 - opacity2,
//                   child: getCollapseTitle(
//                     tagTitle,
//                   ),
//                 ),
//               ),
//             ),
//             Opacity(
//               opacity: opacity1,
//               child: Stack(
//                 alignment: Alignment.bottomCenter,
//                 children: [
//                   backgroundSpace(),
//                   SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         getExpendTitle(
//                           tagTitle,
//                         ),
//                         SizedBox(
//                           height: 8,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               '관심도 ${numberFormat.format(int.parse(tagCount))}',
//                               style: kSubTitle4Style.copyWith(
//                                 fontSize: 16,
//                                 color: mainblack.withOpacity(0.6),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 4,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 showCustomDialog(
//                                     '얼마나 많은 학생들이 관심을 가지고 있는지 알 수 있어요', 1400);
//                               },
//                               child: SvgPicture.asset(
//                                 'assets/icons/Question.svg',
//                                 width: 20,
//                                 height: 20,
//                                 color: mainblack.withOpacity(0.6),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget backgroundSpace() {
//     return Container(
//       width: Get.width,
//       height: Get.height,
//       color: mainWhite,
//     );
//   }

//   Widget getExpendTitle(String text) {
//     return Padding(
//         padding: const EdgeInsets.only(right: 16, left: 16),
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: kNavigationTitle,
//         ));
//   }

//   Widget getCollapseTitle(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 60),
//       child: Text(text,
//           textAlign: TextAlign.center,
//           softWrap: false,
//           overflow: TextOverflow.ellipsis,
//           style: kSubTitle3Style),
//     );
//   }
// }
