import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/profile_image_controller.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/bookmark_screen.dart';
import 'package:loopus/screen/career_arrange_screen.dart';
import 'package:loopus/screen/group_career_detail_screen.dart';
import 'package:loopus/screen/personal_career_detail_screen.dart';
import 'package:loopus/screen/follow_people_screen.dart';
import 'package:loopus/screen/profile_image_change_screen.dart';
import 'package:loopus/screen/profile_sns_add_screen.dart';
import 'package:loopus/screen/profile_tag_change_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/career_analysis_widget.dart';
import 'package:loopus/widget/career_widget.dart';
import 'package:loopus/widget/careertile_widget.dart';
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
          titleSpacing: 0,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            '프로필',
            style: kNavigationTitle,
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
                color: mainblack,
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
          //   //   backgroundColor: mainWhite,
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
                backgroundColor: mainWhite,
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
                      style: kmainbold.copyWith(
                          color: _hoverController.isHover.value
                              ? mainblack.withOpacity(0.6)
                              : mainblack),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    '팔로워',
                    style: kmain.copyWith(color: maingray),
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
                          value1: '기본 이미지로 변경',
                          value2: '사진첩에서 사진 선택',
                          buttonColor1: maingray,
                          buttonColor2: mainblue,
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
                          value1: '기본 이미지로 변경',
                          value2: '사진첩에서 사진 선택',
                          buttonColor1: maingray,
                          buttonColor2: mainblue,
                          isOne: false),
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: mainWhite),
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
                      style: kmainbold.copyWith(
                          color: _hoverController.isHover.value
                              ? mainblack.withOpacity(0.6)
                              : mainblack),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    '팔로잉',
                    style: kmain.copyWith(color: maingray),
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
            style: kmainbold,
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
                  profileController.myUserInfo.value.univName,
                  style: kmain,
                ),
                const SizedBox(
                  height: 9,
                  child: VerticalDivider(
                    thickness: 1,
                    width: 16,
                    color: mainblack,
                  ),
                ),
                Text(
                  profileController.myUserInfo.value.department,
                  style: kmain,
                ),
                const SizedBox(
                  height: 9,
                  child: VerticalDivider(
                    thickness: 1,
                    width: 16,
                    color: mainblack,
                  ),
                ),
                Text(
                  "${profileController.myUserInfo.value.admissionYear.substring(2)}년도 입학",
                  style: kmain,
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
                    color: mainblue,
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
                            "SNS를 등록해주세요",
                            style: kmain.copyWith(color: mainblue),
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
              color:
                  profileController.currentIndex.value == 0 ? null : dividegray,
            ),
          ),
        ),
        Obx(
          () => Tab(
            height: 40,
            icon: SvgPicture.asset(
              'assets/icons/post_active.svg',
              color:
                  profileController.currentIndex.value == 1 ? null : dividegray,
            ),
          ),
        ),
      ],
    );
  }

  Widget _careerView(BuildContext context) {
    return SafeArea(
        child: Obx(() => profileController.myProjectList.isEmpty
            ? EmptyContentWidget(text: '아직 커리어가 없어요')
            : Builder(
                builder: (context) {
                  return CustomScrollView(
                    // key: const PageStorageKey<String>("careerView"),
                    slivers: [
                      // SliverOverlapInjector(
                      //     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      //         context)),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      '${profileController.myUserInfo.value.name}님과 관련있는 기업',
                                      style: kmainbold),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        showPopUpDialog(
                                            '관련있는 기업',
                                            '루프어스에서 활동하는 기업이\n관심을 보이는 경우, 또는\n프로필과 분야 연관성이 높은\n기업을 추천하여 보여줘요',
                                            3000);
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
                              const SizedBox(height: 16),
                              Text(
                                '아직 ${profileController.myUserInfo.value.name} 관련있는 기업이 없어요',
                                style: kmain.copyWith(color: maingray),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('커리어', style: kmainbold),
                                  const SizedBox(width: 8),
                                  CareerAnalysisWidget(
                                    field: fieldList[profileController
                                        .myUserInfo.value.fieldId]!,
                                    groupRatio: profileController
                                        .myUserInfo.value.groupRatio,
                                    // schoolRatio: profileController
                                    //     .myUserInfo.value.schoolRatio,
                                    lastgroupRatio: profileController
                                            .myUserInfo.value.groupRatio +
                                        profileController.myUserInfo.value
                                            .groupRatioVariance,
                                    // lastschoolRatio: profileController
                                    //         .myUserInfo.value.schoolRatio +
                                    //     profileController
                                    //         .myUserInfo.value.schoolRatioVariance,
                                  ),
                                  // const SizedBox(width: 8),
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        showPopUpDialog(
                                            '커리어',
                                            '루프어스 자체 점수 체계를 통해\n가입된 전체 프로필 중 상위 몇 퍼센트\n커리어 수준을 가지고 있는지 알려줘요',
                                            3000);
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
                                      "수정하기",
                                      style: kmain.copyWith(color: mainblue),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              ListView.separated(
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
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              )));
  }

  Widget _postView() {
    return Obx(() => profileController.allPostList.isEmpty
        ? EmptyContentWidget(text: '아직 포스팅이 없어요')
        : sr.SmartRefresher(
            controller: profileController.postLoadingController,
            enablePullDown: false,
            enablePullUp: true,
            footer: const MyCustomFooter(),
            onLoading: profileController.onPostLoading,
            child: ListView.builder(
                // key: const PageStorageKey("postView"), 이거 넣으면 포스팅들이 마지막 사진이나 링크로 가게됨
                itemBuilder: (context, index) => PostingWidget(
                    item: profileController.allPostList[index],
                    type: PostingWidgetType.normal),
                itemCount: profileController.allPostList.length),
          ));
  }

  Widget _tagView() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '상위 태그',
              style: kmain.copyWith(color: maingray),
            ),
            const SizedBox(
              width: 7,
            ),
            Obx(
              () => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: profileController.myUserInfo.value.profileTag
                      .map((tag) => Row(children: [
                            Tagwidget(
                              tag: tag,
                            ),
                            profileController.myUserInfo.value.profileTag
                                        .indexOf(tag) !=
                                    profileController.myUserInfo.value
                                            .profileTag.length -
                                        1
                                ? const SizedBox(
                                    width: 8,
                                  )
                                : Container()
                          ]))
                      .toList()),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CustomExpandedButton(
                onTap: () {
                  tagController.selectedtaglist.clear();
                  tagController.tagsearchContoller.text = "";
                  for (var tag
                      in profileController.myUserInfo.value.profileTag) {
                    tagController.selectedtaglist.add(SelectedTagWidget(
                      id: tag.tagId,
                      text: tag.tag,
                      selecttagtype: SelectTagtype.interesting,
                      tagtype: Tagtype.profile,
                    ));
                  }
                  Get.to(() => ProfileTagChangeScreen());
                },
                isBlue: false,
                isBig: false,
                title: '관심 태그 변경하기',
              ),
            ),
          ],
        ),
      ],
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
 