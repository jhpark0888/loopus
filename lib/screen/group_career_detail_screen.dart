import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/select_career_group_member_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
import 'dart:math' as math;

import 'package:loopus/widget/custom_pie_chart.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class GroupCareerDetailScreen extends StatelessWidget {
  GroupCareerDetailScreen(
      {Key? key,
      required this.career,
      // required this.careerList,
      required this.name})
      : super(key: key);
  String name;
  Project career;
  // List<Project> careerList;
  late CareerDetailController careerDetailController;
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    careerDetailController = Get.put(CareerDetailController(career: career));
    return Scaffold(
        body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    leading: _leading(
                      leading: true,
                    ),
                    actions: [_leading(leading: false)],
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
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 20),
                          child: Row(
                            children: [
                              CustomPieChart(
                                career: career,
                                // careerList: careerList,
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
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: '$name님의 전체 커리어 중\n',
                                        style: kmainheight),
                                    TextSpan(
                                        text: '${career.postRatio! * 100}%',
                                        style: kmainbold),
                                    const TextSpan(
                                        text: '를 차지하는 커리어에요',
                                        style: kmainheight)
                                  ])),
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    '함께하는 친구들',
                                    style: kmainbold,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                    height: 72,
                                    child: Obx(
                                      () => ListView.separated(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          scrollDirection: Axis.horizontal,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            bool ismanager = career.managerId ==
                                                HomeController
                                                    .to.myProfile.value.userId;
                                            if (ismanager && index == 0) {
                                              return addPeople();
                                            }
                                            if (ismanager) {
                                              return joinPeople(
                                                  careerDetailController
                                                      .members[index - 1],
                                                  career.managerId!);
                                            } else {
                                              return joinPeople(
                                                  careerDetailController
                                                      .members[index],
                                                  career.managerId!);
                                            }
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(width: 14);
                                          },
                                          itemCount: career.managerId ==
                                                  HomeController
                                                      .to.myProfile.value.userId
                                              ? careerDetailController
                                                      .members.length +
                                                  1
                                              : careerDetailController
                                                  .members.length),
                                    ))
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
                  titleSpacing: 0,
                  title: adapt(careerDetailController.tabController, name),
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

  Widget joinPeople(User user, int manager) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => OtherProfileScreen(userid: user.userId, realname: user.name));
      },
      child: Column(
        children: [
          UserImageWidget(
            width: 50,
            height: 50,
            imageUrl: user.profileImage,
            userType: UserType.student,
          ),
          const SizedBox(
            height: 7,
          ),
          Row(
            children: [
              if (manager == user.userId)
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: rankred),
                    width: 5,
                    height: 5),
              if (manager == user.userId) const SizedBox(width: 3),
              Text(
                user.name,
                style: kmain,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget addPeople() {
    return GestureDetector(
      onTap: () {
        Get.to(() => SelectCareerGroupMemberScreen());
      },
      child: Column(children: [
        SvgPicture.asset(
          'assets/icons/home_add.svg',
          width: 50,
          height: 50,
          color: mainblue,
        ),
        const SizedBox(height: 7),
        Text(
          '추가',
          style: kmain.copyWith(color: mainblue),
        )
      ]),
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
                          children: [
                            SvgPicture.asset('assets/icons/group_career.svg'),
                            const SizedBox(width: 7),
                            Text('그룹 커리어',
                                style: kNavigationTitle.copyWith(
                                    color: selectimage)),
                            const Spacer(),
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
        style: kmainbold);
  }

  Widget careerType(bool isPublic) {
    return isPublic
        ? Row(children: [])
        : Row(
            children: [],
          );
  }
}

Widget adapt(TabController tabController, String name) {
  return Container(
      width: Get.width,
      decoration: const BoxDecoration(color: mainWhite),
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
  const GroupCareerScreen({Key? key}) : super(key: key);
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
        : const EmptyPostWidget());
  }
}

class EmptyPostWidget extends StatelessWidget {
  const EmptyPostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SvgPicture.asset('assets/icons/career_post_add.svg'),
      const SizedBox(width: 7),
      Text(
        '지금 바로 새로운 포스트를 작성해보세요',
        style: kmainbold.copyWith(color: mainblue),
      )
    ]);
  }
}

class MyCareerScreen extends StatelessWidget {
  MyCareerScreen({Key? key, required this.name}) : super(key: key);
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
                    if (controller.postList[index].user.name == name) {
                      return PostingWidget(
                        item: controller.postList[index],
                        type: PostingWidgetType.profile,
                      );
                    } else {
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
        : const Center(child: EmptyPostWidget()));
  }
}

class _leading extends StatelessWidget {
  _leading({Key? key, required this.leading, this.career}) : super(key: key);
  bool leading;
  Project? career;
  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        if (leading) {
          Get.back();
        } else {
          if (career!.managerId == HomeController.to.myProfile.value.userId) {
            showModalIOS(context, func1: () {
              showButtonDialog(
                  title: '커리어를 삭제하시겠어요?',
                  startContent: '삭제한 커리어는 복구할 수 없어요',
                  leftFunction: () {
                    Get.back();
                  },
                  rightFunction: () {
                    dialogBack(modalIOS: true);
                    loading();
                    deleteProject(career!.id).then((value) {
                      if (value.isError == false) {
                        Get.back();
                        // careerList!.remove(career);
                        deleteCareer(career!);
                        Get.back();
                        showCustomDialog("포스팅이 삭제되었습니다", 1400);
                      } else {
                        errorSituation(value);
                      }
                    });
                  },
                  rightText: '삭제',
                  leftText: '취소');
            },
                func2: () {},
                value1: '커리어 삭제',
                value2: '취소',
                isValue1Red: true,
                isValue2Red: false,
                isOne: true);
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(17.11, 14, 17.11, 14),
        child: Container(
          child: LayoutBuilder(
            builder: (context, c) {
              final settings = context.dependOnInheritedWidgetOfExactType<
                  FlexibleSpaceBarSettings>();
              final deltaExtent = settings!.maxExtent - settings.minExtent;
              final t = (1.0 -
                      (settings.currentExtent - settings.minExtent) /
                          deltaExtent)
                  .clamp(0.0, 1.0);
              final opacity1 = (1.0 - Interval(0.0, 0.75).transform(t)).obs;
              return Obx(() => SvgPicture.asset(
                  'assets/icons/${leading ? 'sliver_appbar_back' : 'sliver_appbar_more_option'}.svg',
                  color: opacity1 < 1 ? mainblack : mainWhite));
            },
          ),
        ),
      ),
    );
  }

  void deleteCareer(Project career) {
    if (Get.isRegistered<ProfileController>()) {
      ProfileController controller = Get.find<ProfileController>();
      controller.myProjectList.removeWhere((element) => element == career);
      controller.myProjectList.refresh();
    }
  }
}
