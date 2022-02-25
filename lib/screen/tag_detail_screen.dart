import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/tag_detail_controller.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'dart:math' as math;

class TagDetailScreen extends StatelessWidget {
  // final SearchController searchController = Get.find();
  late TagDetailController controller =
      Get.put(TagDetailController(tag.tagId), tag: tag.tagId.toString());
  Tag tag;

  TagDetailScreen({required this.tag});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Container(),
                ),
                pinned: true,
                stretch: true,
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
                flexibleSpace: _CustomSpace(tag.tag, tag.count.toString()),
                expandedHeight: Get.height * 0.15,
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
                          controller: controller.tagtabController,
                          labelStyle: kButtonStyle,
                          labelColor: mainblack,
                          unselectedLabelStyle: kBody2Style,
                          unselectedLabelColor: mainblack.withOpacity(0.6),
                          indicator: const UnderlineIndicator(
                            strokeCap: StrokeCap.round,
                            borderSide: BorderSide(width: 1.2),
                          ),
                          indicatorColor: mainblack,
                          tabs: const [
                            Tab(
                              height: 40,
                              child: Text(
                                "관련 활동",
                              ),
                            ),
                            Tab(
                              height: 40,
                              child: Text(
                                "관련 질문",
                              ),
                            )
                          ],
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
          body: Obx(
            () => TabBarView(
              controller: controller.tagtabController,
              children: [
                controller.tagprojectscreenstate.value == ScreenState.loading
                    ? Column(
                        children: [
                          SizedBox(
                            height: 24,
                          ),
                          Image.asset(
                            'assets/icons/loading.gif',
                            scale: 6,
                          ),
                        ],
                      )
                    : controller.tagprojectscreenstate.value ==
                            ScreenState.disconnect
                        ? DisconnectReloadWidget(reload: () {
                            controller.loadproject();
                          })
                        : controller.tagprojectscreenstate.value ==
                                ScreenState.error
                            ? ErrorReloadWidget(reload: () {
                                controller.loadproject();
                              })
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    bottom: 40,
                                  ),
                                  child: Obx(
                                    () => Column(
                                      children: controller
                                              .searchtagprojectlist.isNotEmpty
                                          ? controller
                                              .searchtagprojectlist.value
                                          : [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Center(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text: '아직 ',
                                                        ),
                                                        TextSpan(
                                                          text: tag.tag,
                                                          style: kSubTitle1Style
                                                              .copyWith(
                                                                  color:
                                                                      mainblue),
                                                        ),
                                                        const TextSpan(
                                                          text:
                                                              '와(과) 관련된 활동이 없어요',
                                                        ),
                                                      ],
                                                      style: kSubTitle1Style
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                    ),
                                  ),
                                ),
                              ),
                controller.tagquestionscreenstate.value == ScreenState.loading
                    ? Column(
                        children: [
                          SizedBox(
                            height: 24,
                          ),
                          Image.asset(
                            'assets/icons/loading.gif',
                            scale: 6,
                          ),
                        ],
                      )
                    : controller.tagquestionscreenstate.value ==
                            ScreenState.disconnect
                        ? DisconnectReloadWidget(reload: () {
                            controller.loadquestion();
                          })
                        : controller.tagquestionscreenstate.value ==
                                ScreenState.error
                            ? ErrorReloadWidget(reload: () {
                                controller.loadquestion();
                              })
                            : SingleChildScrollView(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 32),
                                  child: Obx(
                                    () => Column(
                                      children: controller
                                              .searchtagquestionlist.isNotEmpty
                                          ? controller
                                              .searchtagquestionlist.value
                                          : [
                                              Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: '아직 ',
                                                      ),
                                                      TextSpan(
                                                        text: tag.tag,
                                                        style: kSubTitle1Style
                                                            .copyWith(
                                                                color:
                                                                    mainblue),
                                                      ),
                                                      const TextSpan(
                                                        text:
                                                            '와(과) 관련된 질문이 없어요',
                                                      ),
                                                    ],
                                                    style: kSubTitle1Style
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                    ),
                                  ),
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

class _CustomSpace extends StatelessWidget {
  _CustomSpace(this.tagTitle, this.tagCount);
  String tagTitle;
  var tagCount;

  @override
  Widget build(
    BuildContext context,
  ) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var numberFormat = NumberFormat('###,###,###,###');

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
        final opacity1 = 1.0 - Interval(0.0, 0.4).transform(t);
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
                              '관심도 ${numberFormat.format(int.parse(tagCount))}',
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
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: kHeaderH1Style,
        ));
  }

  Widget getCollapseTitle(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Text(text,
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: kSubTitle3Style),
    );
  }
}
