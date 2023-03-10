import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/bookmark_screen.dart';
import 'package:loopus/screen/career_arrange_screen.dart';
import 'package:loopus/screen/group_career_detail_screen.dart';
import 'package:loopus/screen/other_company_screen.dart';
import 'package:loopus/screen/personal_career_detail_screen.dart';
import 'package:loopus/screen/follow_people_screen.dart';
import 'package:loopus/screen/profile_image_change_screen.dart';
import 'package:loopus/screen/profile_sns_add_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/career_analysis_widget.dart';
import 'package:loopus/widget/career_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/profile_sns_image_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/tabbar_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as sr;

import 'package:underline_indicator/underline_indicator.dart';
import 'dart:math' as math;

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({Key? key}) : super(key: key);
  final ProfileController profileController = Get.put(ProfileController());
  // final ImageController imageController = Get.put(ImageController());
  final HoverController _hoverController = HoverController();
  TagController tagController = Get.put(TagController(tagtype: Tagtype.profile),
      tag: Tagtype.profile.toString());

  ScrollController mainScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.mainWhite,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          titleSpacing: 0,
          elevation: 0,
          centerTitle: false,
          title: Text(
            '?????????',
            style: MyTextTheme.navigationTitle(context),
          ),
          leading: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset('assets/icons/appbar_back.svg')),
          actions: [
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Get.to(() => BookmarkScreen());
                },
                icon: SvgPicture.asset(
                  'assets/icons/appbar_bookmark.svg',
                )),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.to(() => SettingScreen());
              },
              icon: SvgPicture.asset(
                'assets/icons/setting.svg',
                color: AppColors.mainblack,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        notificationPredicate: (notification) {
          return notification.depth == 2;
        },

        // controller: profileController.profilerefreshController,
        // enablePullDown: true,
        // header: const MyCustomHeader(),
        onRefresh: profileController.onRefresh,
        child: ExtendedNestedScrollView(
          // primary: true,
          // slivers: [
          //   SliverToBoxAdapter(
          //     child: _profileView(context),
          //   ),
          //   // SliverOverlapAbsorber(
          //   //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
          //   //       context),
          //   //   sliver:

          //   SliverPersistentHeader(
          //     pinned: true,
          //     delegate: _SliverTabBarViewDelegate(child: _tabView()),
          //   ),
          //   // SliverAppBar(
          //   //   backgroundColor: AppColors.mainWhite,
          //   //   toolbarHeight: 44,
          //   //   pinned: true,
          //   //   primary: false,
          //   //   elevation: 0,
          //   //   automaticallyImplyLeading: false,
          //   //   flexibleSpace: _tabView(),
          //   // ),
          //   // ),
          //   // NestedScrollView(headerSliverBuilder: headerSliverBuilder, body: body)
          //   SliverFillRemaining(
          //     hasScrollBody: true,
          //     child: TabBarView(
          //       physics: const NeverScrollableScrollPhysics(),
          //       controller: profileController.tabController,
          //       children: [_careerView(context), _postView()],
          //     ),
          //   )
          // ],
          onlyOneScrollInBody: true,
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: _profileView(context),
              ),
              // SliverOverlapAbsorber(
              //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
              //       context),
              //   sliver:
              SliverAppBar(
                backgroundColor: AppColors.mainWhite,
                toolbarHeight: 44,
                pinned: true,
                primary: false,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: _tabView(),
              ),
              // ),
            ];
          },
          body: TabBarView(
            // physics: const NeverScrollableScrollPhysics(),
            controller: profileController.tabController,
            children: [_careerView(context), _postView()],
          ),
        ),
      ),
    );
  }

  void changeProfileImage() async {
    Get.to(() => ProfileImageChangeScreen(
          user: profileController.myUserInfo.value,
        ));
  }

  void changeDefaultImage() async {
    await updateProfile(
            user: profileController.myUserInfo.value,
            updateType: ProfileUpdateType.image)
        .then((value) {
      if (value.isError == false) {
        Person user = Person.fromJson(value.data);
        profileController.myUserInfo(user);
        HomeController.to.myProfile(user);
        if (Get.isRegistered<OtherProfileController>(
            tag: user.userId.toString())) {
          Get.find<OtherProfileController>(tag: user.userId.toString())
              .otherUser(user);
        }
      } else {
        errorSituation(value);
      }
    });
  }

  Widget _profileView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => FollowPeopleScreen(
                      userId: profileController.myUserInfo.value.userId,
                      listType: FollowListType.follower,
                    ));
              },
              behavior: HitTestBehavior.translucent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(
                    () => Text(
                      profileController.myUserInfo.value.followerCount.value
                          .toString(),
                      style: MyTextTheme.mainbold(context).copyWith(
                          color: _hoverController.isHover.value
                              ? AppColors.mainblack.withOpacity(0.6)
                              : AppColors.mainblack),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    '?????????',
                    style: MyTextTheme.main(context)
                        .copyWith(color: AppColors.maingray),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Stack(
              children: [
                Obx(
                  () => GestureDetector(
                      onTap: () => showBottomdialog(context,
                          func1: changeDefaultImage,
                          func2: changeProfileImage,
                          value1: '?????? ???????????? ??????',
                          value2: '??????????????? ?????? ??????',
                          buttonColor1: AppColors.maingray,
                          buttonColor2: AppColors.mainblue,
                          isOne: false),
                      child: UserImageWidget(
                        imageUrl:
                            profileController.myUserInfo.value.profileImage,
                        width: 90,
                        height: 90,
                        userType: profileController.myUserInfo.value.userType,
                      )),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () => showBottomdialog(context,
                          func1: changeDefaultImage,
                          func2: changeProfileImage,
                          value1: '?????? ???????????? ??????',
                          value2: '??????????????? ?????? ??????',
                          buttonColor1: AppColors.maingray,
                          buttonColor2: AppColors.mainblue,
                          isOne: false),
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.mainWhite),
                        child: SvgPicture.asset(
                          "assets/icons/profile_image.svg",
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 24,
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => FollowPeopleScreen(
                      userId: profileController.myUserInfo.value.userId,
                      listType: FollowListType.following,
                    ));
              },
              behavior: HitTestBehavior.translucent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      profileController.myUserInfo.value.followingCount.value
                          .toString(),
                      style: MyTextTheme.mainbold(context).copyWith(
                          color: _hoverController.isHover.value
                              ? AppColors.mainblack.withOpacity(0.6)
                              : AppColors.mainblack),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    '?????????',
                    style: MyTextTheme.main(context)
                        .copyWith(color: AppColors.maingray),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 14,
        ),
        Obx(
          () => Text(
            profileController.myUserInfo.value.name,
            style: MyTextTheme.mainbold(context),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        Obx(
          () => IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserImageWidget(
                  imageUrl: profileController.myUserInfo.value.univlogo,
                  width: 24,
                  height: 24,
                  userType: profileController.myUserInfo.value.userType,
                ),
                const SizedBox(width: 8),
                Text(
                  profileController.myUnivName.value,
                  style: MyTextTheme.main(context),
                ),
                const SizedBox(
                  height: 9,
                  child: VerticalDivider(
                    thickness: 1,
                    width: 16,
                    color: AppColors.mainblack,
                  ),
                ),
                Text(
                  profileController.myUserInfo.value.department,
                  style: MyTextTheme.main(context),
                ),
                const SizedBox(
                  height: 9,
                  child: VerticalDivider(
                    thickness: 1,
                    width: 16,
                    color: AppColors.mainblack,
                  ),
                ),
                Text(
                  "${profileController.myUserInfo.value.admissionYear.substring(2)}?????? ??????",
                  style: MyTextTheme.main(context),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => profileController.myUserInfo.value.snsList.isNotEmpty
                    ? SizedBox(
                        height: 28,
                        child: ListView.separated(
                            padding: const EdgeInsets.only(right: 8),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return ProfileSnsImageWidget(
                                sns: profileController
                                    .myUserInfo.value.snsList[index],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 7,
                                ),
                            itemCount: profileController
                                .myUserInfo.value.snsList.length),
                      )
                    : Container()),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ProfileSnsAddScreen(
                          snsList: profileController.myUserInfo.value.snsList,
                        ));
                  },
                  child: SvgPicture.asset(
                    "assets/icons/home_add.svg",
                    width: 28,
                    height: 28,
                    color: AppColors.mainblue,
                  ),
                ),
                Obx(() => profileController.myUserInfo.value.snsList.isNotEmpty
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          Get.to(() => ProfileSnsAddScreen(
                                snsList:
                                    profileController.myUserInfo.value.snsList,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "SNS??? ??????????????????",
                            style: MyTextTheme.main(context)
                                .copyWith(color: AppColors.mainblue),
                          ),
                        ),
                      ))
              ],
            ),
            const SizedBox(
              height: 14,
            ),
          ],
        ),
      ],
    );
  }

  Widget _tabView() {
    return TabBarWidget(
      tabController: profileController.tabController,
      tabs: [
        // const Tab(
        //   height: 40,
        //   icon: Icon(
        //     Icons.format_list_bulleted_rounded,
        //   ),
        // ),
        // const Tab(
        //   height: 40,
        //   icon: Icon(Icons.line_weight_rounded),
        // ),
        Obx(
          () => Tab(
            height: 40,
            icon: SvgPicture.asset(
              'assets/icons/list_active.svg',
              color: profileController.currentIndex.value == 0
                  ? null
                  : AppColors.dividegray,
            ),
          ),
        ),
        Obx(
          () => Tab(
            height: 40,
            icon: SvgPicture.asset(
              'assets/icons/post_active.svg',
              color: profileController.currentIndex.value == 1
                  ? null
                  : AppColors.dividegray,
            ),
          ),
        ),
      ],
    );
  }

  Widget _careerView(BuildContext context) {
    return SafeArea(
        child: Obx(() => profileController.myProjectList.isEmpty
            ? Center(
                child: SingleChildScrollView(
                    child: EmptyContentWidget(text: '?????? ???????????? ?????????')))
            : Builder(
                builder: (context) {
                  return CustomScrollView(
                      // key: const PageStorageKey<String>("careerView"),
                      slivers: [
                        // SliverOverlapInjector(
                        //     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        //         context)),
                        // SliverPadding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16),
                        // sliver:
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${profileController.myUserInfo.value.name}?????? ???????????? ??????',
                                        style: MyTextTheme.mainbold(context)),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 20,
                                      height: 21,
                                      child: IconButton(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 1),
                                        onPressed: () {
                                          showPopUpDialog(
                                            '???????????? ??????',
                                            '?????????????????? ???????????? ?????????\n????????? ????????? ??????, ??????\n???????????? ?????? ???????????? ??????\n????????? ???????????? ????????????',
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/icons/information.svg',
                                          width: 16,
                                          height: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Obx(() => profileController
                                      .interestedCompanies.isNotEmpty
                                  ? SizedBox(
                                      width: Get.width,
                                      height: 44,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        shrinkWrap: true,
                                        primary: false,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return companyTile(
                                              context,
                                              profileController
                                                  .interestedCompanies[index]);
                                        },
                                        itemCount: profileController
                                            .interestedCompanies.length,
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width: 16);
                                        },
                                      ),
                                    )
                                  : Text(
                                      '?????? ${profileController.myUserInfo.value.name}?????? ???????????? ????????? ?????????',
                                      style: MyTextTheme.main(context)
                                          .copyWith(color: AppColors.maingray),
                                    )),
                              const SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('?????????',
                                        style: MyTextTheme.mainbold(context)),
                                    const SizedBox(width: 8),
                                    CareerAnalysisWidget(
                                      field: fieldList[profileController
                                          .myUserInfo.value.fieldId]!,
                                      groupRatio: profileController
                                          .myUserInfo.value.groupRatio,
                                      // schoolRatio: profileController
                                      //     .myUserInfo.value.schoolRatio,
                                      lastgroupRatio:
                                          // profileController
                                          //         .myUserInfo.value.groupRatio +
                                          profileController.myUserInfo.value
                                              .groupRatioVariance,
                                      // lastschoolRatio: profileController
                                      //         .myUserInfo.value.schoolRatio +
                                      //     profileController
                                      //         .myUserInfo.value.schoolRatioVariance,
                                    ),
                                    // const SizedBox(width: 8),
                                    SizedBox(
                                      width: 20,
                                      height: 21,
                                      child: IconButton(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 1),
                                        onPressed: () {
                                          showPopUpDialog(
                                            '?????????',
                                            '???????????? ?????? ?????? ????????? ??????\n????????? ?????? ????????? ??? ?????? ??? ?????????\n????????? ????????? ????????? ????????? ????????????',
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/icons/information.svg',
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => CareerArrangeScreen());
                                      },
                                      child: Text(
                                        "????????????",
                                        style: MyTextTheme.main(context)
                                            .copyWith(
                                                color: AppColors.mainblue),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      print(profileController
                                          .myProjectList[index].isPublic);
                                      goCareerScreen(
                                        profileController.myProjectList[index],
                                        profileController.myUserInfo.value.name,
                                      );
                                    },
                                    child: CareerWidget(
                                        career: profileController
                                            .myProjectList[index]),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 16,
                                  ),
                                  itemCount:
                                      profileController.myProjectList.length,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ]);
                  // ],
                  // );
                },
              )));
  }

  Widget _postView() {
    return Obx(() => profileController.allPostList.isEmpty
        ? Center(
            child: SingleChildScrollView(
                child: EmptyContentWidget(text: '?????? ???????????? ?????????')))
        : sr.SmartRefresher(
            controller: profileController.postLoadingController,
            enablePullDown: false,
            enablePullUp: true,
            footer: const MyCustomFooter(),
            onLoading: profileController.onPostLoading,
            child: ListView.builder(
                // key: const PageStorageKey("postView"), ?????? ????????? ??????????????? ????????? ???????????? ????????? ?????????
                itemBuilder: (context, index) => PostingWidget(
                    item: profileController.allPostList[index],
                    type: PostingWidgetType.normal),
                itemCount: profileController.allPostList.length),
          ));
  }

  // Widget _tagView() {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Text(
  //             '?????? ??????',
  //             style: MyTextTheme.main(context).copyWith(color: AppColors.maingray),
  //           ),
  //           const SizedBox(
  //             width: 7,
  //           ),
  //           Obx(
  //             () => Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: profileController.myUserInfo.value.profileTag
  //                     .map((tag) => Row(children: [
  //                           Tagwidget(
  //                             tag: tag,
  //                           ),
  //                           profileController.myUserInfo.value.profileTag
  //                                       .indexOf(tag) !=
  //                                   profileController.myUserInfo.value
  //                                           .profileTag.length -
  //                                       1
  //                               ? const SizedBox(
  //                                   width: 8,
  //                                 )
  //                               : Container()
  //                         ]))
  //                     .toList()),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(
  //         height: 16,
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Expanded(
  //             child: CustomExpandedButton(
  //               onTap: () {
  //                 tagController.selectedtaglist.clear();
  //                 tagController.tagsearchContoller.text = "";
  //                 for (var tag
  //                     in profileController.myUserInfo.value.profileTag) {
  //                   tagController.selectedtaglist.add(SelectedTagWidget(
  //                     id: tag.tagId,
  //                     text: tag.tag,
  //                     selecttagtype: SelectTagtype.interesting,
  //                     tagtype: Tagtype.profile,
  //                   ));
  //                 }
  //                 Get.to(() => ProfileTagChangeScreen());
  //               },
  //               isBlue: false,
  //               isBig: false,
  //               title: '?????? ?????? ????????????',
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget companyTile(BuildContext context, Company company) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => OtherCompanyScreen(
                  company: company,
                  companyId: company.userId,
                  companyName: company.name,
                ),
            preventDuplicates: false);
      },
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        UserImageWidget(
            width: 36,
            height: 36,
            imageUrl: company.profileImage,
            userType: company.userType),
        const SizedBox(width: 8),
        Container(
          constraints: const BoxConstraints(minWidth: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(company.name, style: MyTextTheme.main(context)),
              const SizedBox(height: 4),
              Text(
                fieldList[company.fieldId]!,
                style: MyTextTheme.main(context)
                    .copyWith(color: AppColors.maingray),
              )
            ],
          ),
        )
      ]),
    );
  }
}

// class ProfileTab extends AnimatedWidget {
//   const ProfileTab({
//     Key? key,
//     required Animation<double> animation,
//     required this.selected,
//     required this.labelColor,
//     required this.unselectedLabelColor,
//     required this.child,
//   }) : super(key: key, listenable: animation);

//   final bool selected;
//   final Color? labelColor;
//   final Color? unselectedLabelColor;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     final Animation<double> animation = listenable as Animation<double>;
//     final Color color = selected
//         ? Color.lerp(labelColor, unselectedLabelColor, animation.value)!
//         : Color.lerp(unselectedLabelColor, labelColor, animation.value)!;

//     return IconTheme.merge(
//       data: IconThemeData(
//         size: 24.0,
//         color: color,
//       ),
//       child: child,
//     );
//   }
// }

// class _SliverTabBarViewDelegate extends SliverPersistentHeaderDelegate {
//   _SliverTabBarViewDelegate({
//     required this.child,
//   });

//   final Widget child;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Material(
//       child: child,
//     );
//   }

//   @override
//   double get maxExtent => kTextTabBarHeight;

//   @override
//   double get minExtent => kTextTabBarHeight;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }

// class ProfileSmartRefresher extends smartRefresh.SmartRefresher {

// }
