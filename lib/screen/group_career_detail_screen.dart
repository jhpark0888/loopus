import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'dart:math' as math;

import 'package:loopus/widget/custom_pie_chart.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class GroupCareerDetailScreen extends StatelessWidget {
  GroupCareerDetailScreen(
      {Key? key, required this.career, required this.careerList, required this.name})
      : super(key: key);
  String name;
  Project career;
  List<Project> careerList;
  late CareerDetailController careerDetailController;
  @override
  Widget build(BuildContext context) {
    careerDetailController = Get.put(CareerDetailController(career: career));
    return Scaffold(
        body: NestedScrollView(
            controller: careerDetailController.scrollController,
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    expandedHeight: 200,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    toolbarHeight: 48,
                    elevation: 0,
                    pinned: true,
                    flexibleSpace: _MyAppSpace(
                      career: career,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 64.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 20),
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
                                        style: kmainbold.copyWith(
                                            color: mainblue)),
                                    const TextSpan(
                                        text: '커리어', style: kmainbold)
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
                        DivideWidget(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child:
                                      const Text('함께하는 친구들', style: kmainbold),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                    height: 72,
                                    child: ListView.separated(
                                        padding: EdgeInsets.only(left: 20),
                                        scrollDirection: Axis.horizontal,
                                        primary: false,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return joinPeople();
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width: 14);
                                        },
                                        itemCount: 10))
                                // Expanded(child: ListView(primary: false,shrinkWrap: true,children: [joinPeople(),joinPeople(),joinPeople(),joinPeople(),joinPeople(),joinPeople(),joinPeople(),joinPeople(),joinPeople()],scrollDirection: Axis.horizontal,))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverAppBar(
                  title: adapt(careerDetailController.tabController,name),
                  automaticallyImplyLeading: false,
                  pinned: true,
                  elevation: 0,
                )
              ];
            }),
            body: TabBarView(
                controller: careerDetailController.tabController,
                children: [
                  MyCareerScreen(
                    name: name,
                  ),
                  GroupCareerScreen()
                ])));
  }

  Widget joinPeople() {
    return Column(
      children: [
        UserImageWidget(
            width: 50,
            height: 50,
            imageUrl:
                'https://loopusimage.s3.ap-northeast-2.amazonaws.com/profile_image/image_cropper_32C673FD-B1EF-4BBB-BF73-12460020261A-19058-000003EA26E58D41.jpg'),
        SizedBox(
          height: 7,
        ),
        Text(
          '김원우',
          style: kmain,
        )
      ],
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
            Opacity(
              opacity: opacity1,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: career.thumbnail == ""
                            ? const AssetImage(
                                'assets/illustrations/default_image.png')
                            : NetworkImage(career.thumbnail) as ImageProvider,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            const Color(0x00000000).withOpacity(0.4),
                            BlendMode.srcOver))),
                width: Get.width,
                height: Get.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 58, 20, 14),
                  child: SingleChildScrollView(
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
                        if (career.updateDate != null)
                          Text(
                            '최근 포스트 ${calculateDate(career.updateDate!)}',
                            style:
                                kNavigationTitle.copyWith(color: selectimage),
                          ),
                        const SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            career.isPublic
                                ? SvgPicture.asset('assets/icons/group_career.svg')
                                : SvgPicture.asset(
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
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget getExpendTitle(String text) {
    return Text(text,
        textAlign: TextAlign.start,
        style: kNavigationTitle.copyWith(color: mainWhite));
  }

  Widget getCollapseTitle(String text) {
    return Text(text,
        textAlign: TextAlign.center,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: kmain);
  }
}

Widget adapt(TabController tabController, String name) {
  return Container(
      decoration: BoxDecoration(color: mainWhite),
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            tabs: [
              Tab(
                  height: 48,
                  child: Container(
                    child: Text(
                      '${name} 님의 포스트',
                      style: kmainbold,
                    ),
                  )),
              Tab(
                  height: 48,
                  child: Container(
                    child: Text(
                      '그룹 전체 포스트',
                      style: kmainbold,
                    ),
                  ))
            ],
            labelStyle: kmainbold,
                labelColor: mainblack,
                unselectedLabelStyle: kmainbold.copyWith(color: dividegray),
                unselectedLabelColor: dividegray,
                automaticIndicatorColorAdjustment: false,
                indicator: const UnderlineIndicator(
                  strokeCap: StrokeCap.round,
                  borderSide: BorderSide(width: 2, color: mainblack),
                ),
          ),
          Divider(
          height: 1,
          thickness: 2,
          color: dividegray,
        )
        ],
      ));
}

class GroupCareerScreen extends StatelessWidget {
  const GroupCareerScreen(
      {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    CareerDetailController controller = Get.find();
    print(controller.postList.isNotEmpty);
    return Obx(() => controller.postList.isNotEmpty
        ? CustomScrollView(slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    return PostingWidget(
                      item: controller.postList[index],
                      type: PostingWidgetType.normal,
                    );
                  },
                  itemCount: controller.postList.length),
              // PostingWidget(
              //       item: controller.postList[index],
              //       type: PostingWidgetType.profile,
              //     ),
            ]))
          ])
        : EmptyContentWidget(text: '아직 포스트가 없어요'));
  }
}

class MyCareerScreen extends StatelessWidget {
  MyCareerScreen(
      {Key? key,
      required this.name})
      : super(key: key);
  String name;
  @override
  Widget build(BuildContext context) {
    CareerDetailController controller = Get.find();
    print(controller.postList.isNotEmpty);
    return Obx(() => controller.postList.isNotEmpty
        ? CustomScrollView(slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, index) {
                    if(controller.postList[index].user.realName == name){
                    return PostingWidget(
                      item: controller.postList[index],
                      type: PostingWidgetType.profile,
                    );
                    }
                    else{
                      return const SizedBox.shrink();
                    }
                  },
                  itemCount: controller.postList.length),
              // PostingWidget(
              //       item: controller.postList[index],
              //       type: PostingWidgetType.profile,
              //     ),
            ]))
          ])
        : EmptyContentWidget(text: '아직 포스트가 없어요'));
  }
}
