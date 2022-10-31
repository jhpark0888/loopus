import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/career_detail_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/main.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/select_career_group_member_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
import 'dart:math' as math;

import 'package:loopus/widget/custom_pie_chart.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/empty_post_widget.dart';
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
    careerDetailController =
        Get.put(CareerDetailController(career: Rx(career)));
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
                    actions: [
                      _leading(
                        leading: false,
                        career: career,
                      )
                    ],
                    expandedHeight: 180,
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
                    padding:
                        EdgeInsets.only(top: Platform.isAndroid ? 70 : 100),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 30.5),
                          child: Row(
                            children: [
                              CustomPieChart(
                                career: career,
                                // careerList: careerList,
                                currentId: career.id,
                              ),
                              const SizedBox(width: 24),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(text: 'IT 분야', style: kmainbold),
                                    const TextSpan(
                                        text: ' 커리어', style: kmainbold)
                                  ])),
                                  const SizedBox(height: 8),
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
                        DivideWidget(
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
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
                                const SizedBox(height: 16),
                                SizedBox(
                                    height: 72,
                                    child: Obx(
                                      () => ListView.separated(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16),
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
                    id: career.id,
                  ),
                  GroupCareerScreen(
                    id: career.id,
                  )
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
            height: 8,
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
        const SizedBox(height: 8),
        Text(
          '초대',
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

        return Obx(
          () => Stack(
            children: [
              SafeArea(
                child: Center(
                  child: Opacity(
                    opacity: 1 - opacity2,
                    child: getCollapseTitle(
                      CareerDetailController.to.career.value.careerName,
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
                    padding: EdgeInsets.fromLTRB(
                        16, Platform.isAndroid ? 44 : 60, 16, 26),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 44),
                          getExpendTitle(
                            CareerDetailController.to.career.value.careerName,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (career.updateDate != null)
                            Text(
                              '최근 포스트 ${calculateDate(career.updateDate!)}',
                              style: kmain.copyWith(color: mainWhite),
                            ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/group_career.svg'),
                              const SizedBox(width: 8),
                              Text('그룹 커리어',
                                  style: kmain.copyWith(color: mainWhite)),
                              const Spacer(),
                              Text(
                                '포스트 ${career.post_count}',
                                style: kmain.copyWith(color: mainWhite),
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
          ),
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
        mainAxisSize: MainAxisSize.min,
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
  GroupCareerScreen({Key? key, required this.id}) : super(key: key);
  int id;
  @override
  Widget build(BuildContext context) {
    CareerDetailController controller = Get.find();
    print(controller.postList.isNotEmpty);
    return Obx(() => controller.postList.isNotEmpty
        ? CustomScrollView(slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              ListView.builder(
                padding: EdgeInsets.zero,
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
        : GestureDetector(
            onTap: () {
              Get.to(() => PostingAddScreen(
                    project_id: id,
                    route: PostaddRoute.career,
                  ));
            },
            child: EmptyPostWidget(),
          ));
  }
}

class MyCareerScreen extends StatelessWidget {
  MyCareerScreen({Key? key, required this.name, required this.id})
      : super(key: key);
  String name;
  int id;
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
                        type: PostingWidgetType.normal,
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
        : Center(child: EmptyPostWidget()));
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
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        if (leading) {
          Get.back();
        } else {
          if (career!.managerId == HomeController.to.myProfile.value.userId) {
            showBottomdialog(context, bareerColor: popupGray, func2: () {
              Get.back();
              showButtonDialog(
                  title: '이 커리어는 완전히 삭제돼요',
                  startContent: '이 커리어에 작성된\n',
                  highlightContent: '모든 포스트와 데이터는 완전 삭제되며,\n복구가 불가능해요.\n',
                  highlightColor: rankred,
                  rightColor: mainWhite,
                  endContent: '정말 삭제하시겠어요?',
                  leftFunction: () {
                    Get.back();
                  },
                  rightFunction: () {
                    dialogBack(modalIOS: true);
                    loading();
                    deleteProject(career!.id, DeleteType.del).then((value) {
                      print(value.isError);
                      if (value.isError == false) {
                        // careerList!.remove(career);
                        deleteCareer(career!);
                        Get.back();
                        showCustomDialog("해당 커리어가 삭제되었어요", 1400);
                      } else {
                        errorSituation(value);
                      }
                    });
                  },
                  rightText: '삭제',
                  leftText: '취소',);
            }, func1: () {
              Get.back();
              Get.to(
                  () => ProjectAddTitleScreen(screenType: Screentype.update));
            },
                value1: '커리어 수정하기',
                value2: '커리어 삭제하기',
                buttonColor1: mainWhite,
                buttonColor2: rankred,
                textColor1: mainblack,
                isOne: false);
          } else if (career!.members
              .where((element) =>
                  element.userId == HomeController.to.myProfile.value.userId)
              .isNotEmpty) {
            showBottomdialog(context, bareerColor: popupGray, func2: () {
              Get.back();
              showButtonDialog(
                  title: '그룹 커리어에서 나가게 돼요',
                  startContent:
                      '이 커리어에 ${HomeController.to.myProfile.value.name}님은\n',
                  highlightContent: '더이상 글을 남길 수 없게 돼요.\n',
                  highlightColor: rankred,
                  rightColor: mainWhite,
                  endContent:
                      '${HomeController.to.myProfile.value.name}님이 작성한 글은\n 그룹 커리어 내 남아 있을 수 있어요.\n정말 나가시겠어요?',
                  leftFunction: () {
                    Get.back();
                  },
                  rightFunction: () {
                    dialogBack(modalIOS: true);
                    loading();
                    deleteProject(career!.id, DeleteType.exit).then((value) {
                      if (value.isError == false) {
                        deleteCareer(career!);
                        Get.back();
                        showCustomDialog("해당 커리어를 나갔어요", 1400);
                      } else {
                        errorSituation(value);
                      }
                    });
                  },
                  rightText: '나가기',
                  leftText: '취소');
            },
                func1: () {},
                value1: '커리어 신고하기',
                value2: '커리어 나가기',
                isOne: false,
                buttonColor1: mainWhite,
                buttonColor2: rankred,
                textColor1: mainblack,
                textColor2: mainWhite);
          } else {
          }
        }
      },
      icon: LayoutBuilder(
        builder: (context, c) {
          final settings = context
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          final deltaExtent = settings!.maxExtent - settings.minExtent;
          final t = (1.0 -
                  (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0);
          final opacity1 = (1.0 - Interval(0.0, 0.75).transform(t)).obs;
          return Obx(() => SvgPicture.asset(
              'assets/icons/${leading ? 'sliver_appbar_back' : 'sliver_appbar_more_option'}.svg',
              color: opacity1 < 1 ? mainblack : mainWhite));
        },
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
