import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'dart:math' as math;

class TagDetailScreen extends StatelessWidget {
  final TagController _tagController = Get.put(TagController());
  final SearchController searchController = Get.find();
  String title;
  var count;

  TagDetailScreen({
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Container(),
                ),
                pinned: true,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: SvgPicture.asset(
                    'assets/icons/Arrow.svg',
                    width: 28,
                    height: 28,
                  ),
                ),
                automaticallyImplyLeading: false,
                centerTitle: true,
                flexibleSpace: _CustomSpace(title, count.toString()),
                expandedHeight: Get.height * 0.18,
              ),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  bottom: false,
                  sliver: SliverAppBar(
                    pinned: true,
                    automaticallyImplyLeading: false,
                    expandedHeight: 43,
                    toolbarHeight: 43,
                    elevation: 0,
                    flexibleSpace: Column(
                      children: [
                        Theme(
                          data: ThemeData().copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: TabBar(
                            controller: searchController.tagtabController,
                            labelStyle: kButtonStyle,
                            labelColor: mainblack,
                            unselectedLabelStyle: kBody1Style,
                            unselectedLabelColor: mainblack.withOpacity(0.6),
                            indicator: const UnderlineIndicator(
                              strokeCap: StrokeCap.round,
                              borderSide: BorderSide(width: 2),
                            ),
                            indicatorColor: mainblack,
                            tabs: [
                              Tab(
                                height: 40,
                                child: Text(
                                  "활동",
                                ),
                              ),
                              Tab(
                                height: 40,
                                child: Text(
                                  "질문",
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Color(0xffe7e7e7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: searchController.tagtabController,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: searchController.searchtagprojectlist.value,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: searchController.searchtagquestionlist.value,
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

class _CustomSpace extends StatelessWidget {
  _CustomSpace(this.tagTitle, this.tagCount);
  String tagTitle;
  var tagCount;

  @override
  Widget build(
    BuildContext context,
  ) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return LayoutBuilder(
      builder: (context, c) {
        var top = c.biggest.height;

        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity1 = 1.0 - Interval(0.0, 0.3).transform(t);
        final opacity2 = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return Stack(
          children: [
            SafeArea(
              child: Center(
                child: Opacity(
                  opacity: 1 - opacity2,
                  child: getCollapseTitle(
                    tagTitle,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: opacity1,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  backgroundSpace(),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        getExpendTitle(
                          tagTitle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '관심도 $tagCount',
                              style: kSubTitle4Style.copyWith(
                                fontSize: 16,
                                color: mainblack.withOpacity(0.6),
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            GestureDetector(
                              onTap: () {
                                ModalController.to.showCustomDialog(
                                    '얼마나 많은 학생들이 관심을 가지고 있는지 알 수 있어요', 1400);
                              },
                              child: SvgPicture.asset(
                                'assets/icons/Question.svg',
                                width: 20,
                                height: 20,
                                color: mainblack.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget backgroundSpace() {
    return Container(
      width: Get.width,
      height: Get.height,
      color: mainWhite,
    );
  }

  Widget getExpendTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          height: 1.5,
          color: mainblack,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget getCollapseTitle(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Text(
        text,
        textAlign: TextAlign.center,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: mainblack,
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}