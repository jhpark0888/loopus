import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
import 'package:loopus/screen/other_company_screen.dart';
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
import 'package:loopus/widget/tabbar_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/widget/user_widget.dart';
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
    careerDetailController = Get.put(
        CareerDetailController(
          career: career.obs,
        ),
        tag: career.id.toString());
    return Scaffold(
        body: NestedScrollView(
            controller: careerDetailController.scrollController,
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    backgroundColor: AppColors.mainWhite,
                    leading: _leading(
                      leading: true,
                    ),
                    actions: [
                      _leading(
                        leading: false,
                        career: careerDetailController.career.value,
                      )
                    ],
                    expandedHeight: 190,
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
                        joinCompany(context),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomPieChart(
                                career: career,
                                // careerList: careerList,
                                currentId: career.id,
                              ),
                              const SizedBox(width: 24),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text:
                                              '${fieldList[career.fieldId]} ??????',
                                          style: MyTextTheme.mainbold(context)),
                                      TextSpan(
                                          text: ' ?????????',
                                          style: MyTextTheme.mainbold(context))
                                    ])),
                                    const SizedBox(height: 8),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: '$name?????? ?????? ????????? ???\n',
                                          style:
                                              MyTextTheme.mainheight(context)),
                                      TextSpan(
                                          text:
                                              '${(career.postRatio! * 100).toInt()}%',
                                          style: MyTextTheme.mainbold(context)),
                                      TextSpan(
                                          text: '??? ???????????? ???????????????',
                                          style:
                                              MyTextTheme.mainheight(context))
                                    ])),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        DivideWidget(
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  '???????????? ?????????',
                                  style: MyTextTheme.mainbold(context),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                  height: 78,
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
                                            return addPeople(context);
                                          }
                                          if (ismanager) {
                                            return joinPeople(
                                                context,
                                                careerDetailController
                                                    .members[index - 1],
                                                career.managerId!);
                                          } else {
                                            return joinPeople(
                                                context,
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
                        )
                      ],
                    ),
                  ),
                ),
                SliverAppBar(
                  primary: false,
                  flexibleSpace:
                      adapt(careerDetailController.tabController, name),
                  backgroundColor: AppColors.mainWhite,
                  titleSpacing: 0,
                  toolbarHeight: 50,
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
                    careerId: career.id,
                    userId: career.userid!,
                  ),
                  GroupCareerScreen(
                    careerId: career.id,
                  )
                ])));
  }

  Widget joinCompany(BuildContext context) {
    return Obx(() => careerDetailController.career.value.company != null
        ? Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (careerDetailController.career.value.company != null) {
                    if (careerDetailController.career.value.company!.userId !=
                        0) {
                      Get.to(() => OtherCompanyScreen(
                          companyId: careerDetailController
                              .career.value.company!.userId,
                          companyName: careerDetailController
                              .career.value.company!.name));
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        UserImageWidget(
                          imageUrl: career.company != null
                              ? career.company!.profileImage
                              : '',
                          userType: UserType.company,
                          height: 36,
                          width: 36,
                        ),
                        const SizedBox(width: 8),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: career.company != null
                                  ? career.company!.name
                                  : '?????????',
                              style: MyTextTheme.mainbold(context)),
                          TextSpan(
                              text: '??? ????????? ???????????????',
                              style: MyTextTheme.main(context))
                        ]))
                      ]),
                ),
              ),
              DivideWidget(
                height: 1,
              ),
            ],
          )
        : const SizedBox.shrink());
  }

  Widget joinPeople(BuildContext context, User user, int manager) {
    return GestureDetector(
        onTap: () {
          Get.to(() =>
              OtherProfileScreen(userid: user.userId, realname: user.name));
        },
        child: manager == user.userId
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(36),
                            color: AppColors.rankred),
                        width: 5,
                        height: 5),
                  ),
                  const SizedBox(width: 3),
                  UserVerticalWidget(
                    user: user,
                    emptyHeight: 4,
                  )
                ],
              )
            : UserVerticalWidget(
                user: user,
                emptyHeight: 4,
              ));
  }

  Widget addPeople(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SelectCareerGroupMemberScreen(
              careerId: career.id,
            ));
      },
      child: Column(children: [
        SvgPicture.asset(
          'assets/icons/home_add.svg',
          width: 50,
          height: 50,
          color: AppColors.mainblue,
        ),
        const SizedBox(height: 8),
        Text(
          '??????',
          style: MyTextTheme.main(context).copyWith(color: AppColors.mainblue),
        )
      ]),
    );
  }

  Widget adapt(TabController tabController, String name) {
    return Container(
        width: Get.width,
        decoration: const BoxDecoration(color: AppColors.mainWhite),
        child: TabBarWidget(tabController: tabController, tabs: [
          Tab(
              height: 48,
              child: Text(
                '$name?????? ?????????',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
          const Tab(
              height: 48,
              child: Text(
                '?????? ?????? ?????????',
              )),
        ]));
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
                      context,
                      Get.find<CareerDetailController>(
                              tag: career.id.toString())
                          .career
                          .value
                          .careerName,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: opacity1,
                child: Hero(
                  tag: career.id.toString(),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: career.thumbnail == ""
                                ? const AssetImage(
                                    'assets/illustrations/default_image.png')
                                : NetworkImage(career.thumbnail)
                                    as ImageProvider,
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
                              context,
                              Get.find<CareerDetailController>(
                                      tag: career.id.toString())
                                  .career
                                  .value
                                  .careerName,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            career.updateDate != null
                                ? Text(
                                    '?????? ????????? ${calculateDate(Get.find<CareerDetailController>(tag: career.id.toString()).career.value.updateDate!)}',
                                    style: MyTextTheme.main(context)
                                        .copyWith(color: AppColors.mainWhite),
                                  )
                                : Container(
                                    color: AppColors.mainWhite,
                                    height: 2,
                                    width: 6,
                                  ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/group_career.svg'),
                                const SizedBox(width: 8),
                                Text('?????? ?????????',
                                    style: MyTextTheme.main(context)
                                        .copyWith(color: AppColors.mainWhite)),
                                const Spacer(),
                                Text(
                                  '????????? ${Get.find<CareerDetailController>(tag: career.id.toString()).career.value.post_count}',
                                  style: MyTextTheme.main(context)
                                      .copyWith(color: AppColors.mainWhite),
                                )
                              ],
                            )
                          ],
                        ),
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

  Widget getExpendTitle(BuildContext context, String text) {
    return Text(text,
        textAlign: TextAlign.start,
        style: MyTextTheme.navigationTitle(context)
            .copyWith(color: AppColors.mainWhite));
  }

  Widget getCollapseTitle(BuildContext context, String text) {
    return Text(text,
        textAlign: TextAlign.center,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: MyTextTheme.mainbold(context));
  }

  Widget careerType(bool isPublic) {
    return isPublic
        ? Row(children: [])
        : Row(
            children: [],
          );
  }
}

class GroupCareerScreen extends StatelessWidget {
  GroupCareerScreen({Key? key, required this.careerId}) : super(key: key);
  int careerId;
  @override
  Widget build(BuildContext context) {
    CareerDetailController controller = Get.find(tag: careerId.toString());
    // print(controller.postList.isNotEmpty);
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
        : controller.career.value.members.any(
                (member) => member.userId == int.parse(HomeController.to.myId!))
            ? Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.to(() => PostingAddScreen(
                                project_id: careerId,
                                route: PostaddRoute.career,
                              ));
                        },
                        child: EmptyPostWidget()),
                  ],
                ),
              )
            : EmptyContentWidget(text: "?????? ???????????? ?????????"));
  }
}

class MyCareerScreen extends StatelessWidget {
  MyCareerScreen({
    Key? key,
    required this.name,
    required this.careerId,
    required this.userId,
  }) : super(key: key);
  int careerId;
  String name;
  int userId;
  @override
  Widget build(BuildContext context) {
    CareerDetailController controller = Get.find(tag: careerId.toString());
    // print(controller.postList.isNotEmpty);
    return Obx(() =>
        controller.postList.where((post) => post.userid == userId).isNotEmpty
            ? CustomScrollView(slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        if (controller.postList[index].user.userId == userId) {
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
            : HomeController.to.myId == userId.toString()
                ? Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.to(() => PostingAddScreen(
                                    project_id: careerId,
                                    route: PostaddRoute.career,
                                  ));
                            },
                            child: EmptyPostWidget()),
                      ],
                    ),
                  )
                : EmptyContentWidget(text: "?????? ???????????? ?????????"));
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
            showBottomdialog(context, bareerColor: AppColors.popupGray,
                func2: () {
              Get.back();
              showButtonDialog(
                title: '??? ???????????? ????????? ????????????',
                startContent: '??? ???????????? ?????????\n',
                highlightContent: '?????? ???????????? ???????????? ?????? ????????????,\n????????? ???????????????.\n',
                highlightColor: AppColors.rankred,
                rightColor: AppColors.mainWhite,
                endContent: '?????? ??????????????????????',
                leftFunction: () {
                  Get.back();
                },
                rightFunction: () async {
                  dialogBack(modalIOS: true);
                  loading();
                  await deleteProject(career!.id, DeleteType.del).then((value) {
                    print(value.isError);
                    if (value.isError == false) {
                      // careerList!.remove(career);
                      deleteCareer(career!);
                      Get.back();
                      showCustomDialog("?????? ???????????? ??????????????????", 1400);
                    } else {
                      errorSituation(value);
                    }
                  });
                },
                rightText: '??????',
                leftText: '??????',
              );
            }, func1: () {
              Get.back();
              Get.to(() => ProjectAddTitleScreen(
                    screenType: Screentype.update,
                    careerId: career!.id,
                  ));
            },
                value1: '????????? ????????????',
                value2: '????????? ????????????',
                buttonColor1: AppColors.mainWhite,
                buttonColor2: AppColors.rankred,
                textColor1: AppColors.mainblack,
                isOne: false);
          } else if (career!.members
              .where((element) =>
                  element.userId == HomeController.to.myProfile.value.userId)
              .isNotEmpty) {
            showBottomdialog(context, bareerColor: AppColors.popupGray,
                func2: () {
              Get.back();
              showButtonDialog(
                  title: '?????? ??????????????? ????????? ??????',
                  startContent:
                      '??? ???????????? ${HomeController.to.myProfile.value.name}??????\n',
                  highlightContent: '????????? ?????? ?????? ??? ?????? ??????.\n',
                  highlightColor: AppColors.rankred,
                  rightColor: AppColors.mainWhite,
                  endContent:
                      '${HomeController.to.myProfile.value.name}?????? ????????? ??????\n ?????? ????????? ??? ?????? ?????? ??? ?????????.\n?????? ???????????????????',
                  leftFunction: () {
                    Get.back();
                  },
                  rightFunction: () async {
                    dialogBack(modalIOS: true);
                    loading();
                    await deleteProject(career!.id, DeleteType.exit)
                        .then((value) {
                      if (value.isError == false) {
                        deleteCareer(career!);
                        Get.back();
                        showCustomDialog("?????? ???????????? ????????????", 1400);
                      } else {
                        Get.back();
                        errorSituation(value);
                      }
                    });
                  },
                  rightText: '?????????',
                  leftText: '??????');
            },
                func1: () {},
                value1: '????????? ????????????',
                value2: '????????? ?????????',
                isOne: false,
                buttonColor1: AppColors.mainWhite,
                buttonColor2: AppColors.rankred,
                textColor1: AppColors.mainblack,
                textColor2: AppColors.mainWhite);
          } else {}
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
              color: opacity1 < 1 ? AppColors.mainblack : AppColors.mainWhite));
        },
      ),
    );
  }

  void deleteCareer(Project career) async {
    if (Get.isRegistered<ProfileController>()) {
      ProfileController controller = Get.find<ProfileController>();
      controller.myProjectList.removeWhere((element) => element == career);
      controller.myProjectList.refresh();
    }

    FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    int careerId = career.id;
    String? strGroupTpList = await secureStorage.read(key: "groupTpList");
    List<int> groupTpList = [];

    if (strGroupTpList != null) {
      groupTpList = json.decode(strGroupTpList).cast<int>();
    }
    groupTpList.remove(careerId);

    secureStorage.write(key: "groupTpList", value: json.encode(groupTpList));
    await FirebaseMessaging.instance.unsubscribeFromTopic("project$careerId");
  }
}
