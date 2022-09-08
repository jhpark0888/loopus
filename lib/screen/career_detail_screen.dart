import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/custom_pie_chart.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/posting_widget.dart';

class CareerDetailScreen extends StatelessWidget {
  CareerDetailScreen({Key? key, required this.careerList, required this.career})
      : super(key: key);
  late CareerDetailController careerDetailController;
  List<Project> careerList;
  Project career;
  @override
  Widget build(BuildContext context) {
    careerDetailController = Get.put(CareerDetailController(career: career));
    return Scaffold(
      body: CustomScrollView(
        // physics: const BouncingScrollPhysics(),
        controller: careerDetailController.scrollController,
        slivers: [
          SliverAppBar(
            bottom: PreferredSize(
                child: Container(
                  color: Color(0xffe7e7e7),
                  height: 1,
                ),
                preferredSize: Size.fromHeight(4.0)),
            automaticallyImplyLeading: false,
            elevation: 0,
            stretch: true,
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: SvgPicture.asset(
                  'assets/icons/sliver_appbar_back.svg',
                  color: mainWhite,
                  width: 10,
                  height: 16,
                )),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                      'assets/icons/sliver_appbar_more_option.svg',
                      color: mainWhite,
                      width: 15,
                      height: 3)),
            ],
            pinned: true,
            flexibleSpace: _MyAppSpace(career: career),
            expandedHeight: 200,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                    child: Row(
                      children: [
                        CustomPieChart(
                          careerList: careerList,
                          currentId: career.id,
                        ),
                        const SizedBox(width: 32),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: 'IT 분야',
                                  style: kmainbold.copyWith(color: mainblue)),
                              const TextSpan(text: '커리어', style: kmainbold)
                            ])),
                            const SizedBox(height: 14),
                            Text(
                              '${ProfileController.to.myUserInfo.value.realName}님의 전체 커리어 중\n${career.postRatio! * 100}%를 차지하는 커리어에요',
                              style: kmainheight,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 0.5,
                        color: dividegray,
                      )),
                  // const SizedBox(height: 24),
                  Obx(() =>
                  careerDetailController.postList.isNotEmpty
                      ? ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, postindex) {
                            return PostingWidget(
                              item:
                                  careerDetailController.postList[postindex],
                              type: PostingWidgetType.profile,
                            );
                          },
                          separatorBuilder: (context, postindex) =>
                              DivideWidget(),
                          itemCount: careerDetailController.postList.length,
                        )
                      : EmptyContentWidget(text: '아직 포스팅이 없어요')
                  )
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _MyAppSpace extends StatelessWidget {
  _MyAppSpace({Key? key, required this.career}) : super(key: key);
  Project career;
  @override
  Widget build(
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder: (context, c) {
        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0);
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity1 = 1.0 - Interval(0.0, 0.75).transform(t);
        final opacity2 = 1.0 - Interval(fadeStart, fadeEnd).transform(t);

        return Stack(
          children: [
            SafeArea(
              child: Center(
                child: Opacity(
                  opacity: 1 - opacity2,
                  child: getCollapseTitle(
                    career.careerName,
                  ),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Opacity(
                  opacity: opacity1,
                  child: getImage(context,
                      "https://cdn.pixabay.com/photo/2022/08/28/18/03/dog-7417233__340.jpg"),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 44),
                        getExpendTitle(
                          career.careerName,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        if (career.updateTime != null)
                          Text(
                            '최근 포스트 ${calculateDate(career.updateTime!)}',
                            style:
                                kNavigationTitle.copyWith(color: selectimage),
                          ),
                        const SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                                'assets/icons/personal_career.svg'),
                            Text(
                              '포스트 ${career.post_count}',
                              style:
                                  kNavigationTitle.copyWith(color: selectimage),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  Widget getImage(BuildContext context, String? thumbnail) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Opacity(
        opacity: thumbnail != null ? 0.25 : 1,
        child: thumbnail != null
            ? Hero(
                tag: "career_screen",
                child: Image.network(
                  thumbnail,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                "assets/illustrations/default_image.png",
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget getExpendTitle(String text) {
    return Text(text,
        textAlign: TextAlign.start,
        style: kNavigationTitle.copyWith(color: mainWhite));
  }

  Widget getCollapseTitle(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Text(text,
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: kmain),
    );
  }
}
