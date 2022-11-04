import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/my_company_controller.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/bookmark_screen.dart';
import 'package:loopus/screen/comp_intro_edit_screen.dart';
import 'package:loopus/screen/company_interesting_screen.dart';
import 'package:loopus/screen/company_visit_screen.dart';
import 'package:loopus/screen/follow_people_screen.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/screen/profile_image_change_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/empty_post_widget.dart';
import 'package:loopus/widget/news_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/search_widget.dart';
import 'package:loopus/widget/tabbar_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/widget/user_tile_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as sr;
import 'package:underline_indicator/underline_indicator.dart';
import 'dart:math' as math;

class MyCompanyScreen extends StatelessWidget {
  MyCompanyScreen({Key? key}) : super(key: key);
  final MyCompanyController _controller = Get.put(MyCompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainblack,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: mainblack,
            statusBarIconBrightness:
                Brightness.light, // For Android (dark icons)
            statusBarBrightness: Brightness.light // For iOS (dark icons),
            ),
        backgroundColor: mainblack,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: Obx(
          () => Text(
            '${_controller.myCompanyInfo.value.name} 프로필',
            style: kNavigationTitle.copyWith(color: mainWhite),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: SvgPicture.asset(
            'assets/icons/appbar_back.svg',
            color: mainWhite,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => BookmarkScreen());
              },
              icon: SvgPicture.asset(
                'assets/icons/bookmark_inactive.svg',
                width: 28,
                color: mainWhite,
              )),
          GestureDetector(
            onTap: () {
              Get.to(() => SettingScreen());
            },
            child: SvgPicture.asset(
              'assets/icons/setting.svg',
              color: mainWhite,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        notificationPredicate: (notification) {
          return notification.depth == 2;
        },
        onRefresh: _controller.onRefresh,
        child: ExtendedNestedScrollView(
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
            controller: _controller.tabController,
            children: [_introView(), _postView(), _visitView()],
          ),
        ),
      ),
    );
  }

  void changeProfileImage() async {
    Get.to(() => ProfileImageChangeScreen(
          user: _controller.myCompanyInfo.value,
        ));
  }

  void changeDefaultImage() async {
    // await updateProfile(_controller.myCompanyInfo.value, null, null,
    //         ProfileUpdateType.image)
    //     .then((value) {
    //   if (value.isError == false) {
    //     Person user = Person.fromJson(value.data);
    //     _controller.myCompanyInfo(user);
    //     HomeController.to.myProfile(user);
    //     if (Get.isRegistered<OtherProfileController>(
    //         tag: user.userid.toString())) {
    //       Get.find<OtherProfileController>(tag: user.userid.toString())
    //           .otherUser(user);
    //     }
    //   } else {
    //     errorSituation(value);
    //   }
    // });
  }

  Widget _profileView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
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
                imageUrl: _controller.myCompanyInfo.value.profileImage,
                width: 90,
                height: 90,
                userType: _controller.myCompanyInfo.value.userType,
              )),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Text(
            _controller.myCompanyInfo.value.name,
            style: kmainbold.copyWith(color: mainWhite),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fieldList[_controller.myCompanyInfo.value.fieldId]!,
                  style: kmain.copyWith(color: mainWhite),
                ),
                const SizedBox(
                  height: 9,
                  child: VerticalDivider(
                    thickness: 1,
                    width: 16,
                    color: mainWhite,
                  ),
                ),
                Text(
                  _controller.myCompanyInfo.value.address,
                  style: kmain.copyWith(color: mainWhite),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Get.to(() =>
                WebViewScreen(url: _controller.myCompanyInfo.value.homepage));
          },
          child: Obx(
            () => Text(
              _controller.myCompanyInfo.value.homepage,
              style: kmain.copyWith(color: mainblue),
            ),
          ),
        ),
        Obx(
          () => _controller.myCompanyInfo.value.itrUsers.isNotEmpty
              ? Column(
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            "이 기업에 관심있는 프로필",
                            style: kmainbold.copyWith(color: mainWhite),
                          ),
                          const SizedBox(width: 8),
                          Center(
                            child: SvgPicture.asset(
                              'assets/icons/information.svg',
                              color: dividegray,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => CompanyInterestingScreen(
                                    company: _controller.myCompanyInfo.value,
                                  ));
                            },
                            child: Text(
                              "전체보기",
                              style: kmain.copyWith(color: mainblue),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 74,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) => interestingUser(
                              _controller.myCompanyInfo.value.itrUsers[index]),
                          separatorBuilder: (context, index) => const SizedBox(
                                width: 16,
                              ),
                          itemCount:
                              _controller.myCompanyInfo.value.itrUsers.length),
                    ),
                  ],
                )
              : Container(),
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }

  Widget _tabView() {
    return Container(
      color: mainblack,
      child: TabBarWidget(
        tabController: _controller.tabController,
        isDark: true,
        tabs: [
          Obx(
            () => Tab(
              height: 40,
              icon: SvgPicture.asset(
                'assets/icons/company_intro.svg',
                color: _controller.currentIndex.value == 0
                    ? mainWhite
                    : dividegray,
              ),
            ),
          ),
          Obx(
            () => Tab(
              height: 40,
              icon: SvgPicture.asset(
                'assets/icons/post_active.svg',
                color: _controller.currentIndex.value == 1
                    ? mainWhite
                    : dividegray,
              ),
            ),
          ),
          Obx(
            () => Tab(
              height: 40,
              icon: SvgPicture.asset(
                'assets/icons/company_view.svg',
                color: _controller.currentIndex.value == 2
                    ? mainWhite
                    : dividegray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _introView() {
    return ScrollNoneffectWidget(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: _controller
                                .myCompanyInfo.value.images[index].image,
                            width: Get.width,
                            fit: BoxFit.cover,
                            placeholder: (context, string) {
                              return Container(
                                color: maingray,
                              );
                            },
                            errorWidget: (context, string, widget) {
                              return Container(
                                color: maingray,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          if (index == 0)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "기업소개",
                                    style: kmainbold.copyWith(color: mainWhite),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "\"${_controller.myCompanyInfo.value.slogan}\"",
                                    style: kmainboldHeight.copyWith(
                                        color: mainWhite),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          if (_controller.myCompanyInfo.value.images[index]
                                  .imageInfo !=
                              "")
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                _controller.myCompanyInfo.value.images[index]
                                    .imageInfo,
                                style: kmainheight.copyWith(color: mainWhite),
                              ),
                            )
                        ],
                      ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: _controller.myCompanyInfo.value.images.length),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomExpandedButton(
                      onTap: () {
                        Get.to(() => CompanyIntroEditScreen(
                              name: _controller.myCompanyInfo.value.name,
                            ));
                      },
                      isBlue: true,
                      title: "기업 소개 수정하기",
                      isBig: true),
                ],
              ),
            ),
            Obx(
              () => _controller.newsList.isNotEmpty
                  ? NewsListWidget(
                      title: "기업 뉴스",
                      issueList: _controller.newsList,
                      isDark: true,
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  // Widget _introView() {
  //   return Obx(() => _controller.myCompanyInfo.value.intro == ""
  //       ? Column(
  //           children: [
  //             const SizedBox(
  //               height: 14,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 15),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   CustomExpandedButton(
  //                       onTap: () {
  //                         Get.to(() => CompanyIntroEditScreen());
  //                       },
  //                       isBlue: true,
  //                       title: "기업 소개 수정하기",
  //                       isBig: true),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         )
  //       : Column(
  //           children: [
  //             const SizedBox(
  //               height: 14,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 20),
  //               child: Text(
  //                 _controller.myCompanyInfo.value.intro,
  //                 style: kmainheight.copyWith(color: mainWhite),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 24,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 15),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   CustomExpandedButton(
  //                       onTap: () {
  //                         Get.to(() => CompanyIntroEditScreen());
  //                       },
  //                       isBlue: true,
  //                       title: "기업 소개 수정하기",
  //                       isBig: true),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ));
  // }

  Widget _postView() {
    return Obx(() => _controller.allPostList.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: GestureDetector(
                onTap: () {
                  Get.to(() => PostingAddScreen(
                      project_id: companyCareerId, route: PostaddRoute.career));
                },
                child: EmptyPostWidget()))
        : sr.SmartRefresher(
            controller: _controller.postLoadingController,
            enablePullDown: false,
            enablePullUp: true,
            footer: const MyCustomFooter(),
            onLoading: _controller.onPostLoading,
            child: ListView.builder(
                // key: const PageStorageKey("postView"), 이거 넣으면 포스팅들이 마지막 사진이나 링크로 가게됨
                itemBuilder: (context, index) => PostingWidget(
                      item: _controller.allPostList[index],
                      type: PostingWidgetType.normal,
                      isDark: true,
                    ),
                itemCount: _controller.allPostList.length),
          ));
  }

  Widget _visitView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              "이 탭은 관리 탭으로 계정 주인만 확인할 수 있어요",
              style: kmain.copyWith(color: maingray),
            ),
            const SizedBox(height: 16),
            _labelRow(
              "팔로워",
              () {
                Get.to(() => FollowPeopleScreen(
                    userId: _controller.myCompanyInfo.value.userId,
                    listType: FollowListType.follower));
              },
              count: _controller.myCompanyInfo.value.followerCount.value,
            ),
            const SizedBox(height: 16),
            _labelRow(
              "팔로잉",
              () {
                Get.to(() => FollowPeopleScreen(
                    userId: _controller.myCompanyInfo.value.userId,
                    listType: FollowListType.following));
              },
              count: _controller.myCompanyInfo.value.followingCount.value,
            ),
            const SizedBox(height: 16),
            Obx(
              () => _labelRow(
                "최근 ${_controller.myCompanyInfo.value.name}가 살펴본 프로필",
                () {
                  Get.to(() => CompanyVisitScreen(
                        isCompVisit: true,
                        company: _controller.myCompanyInfo.value,
                      ));
                },
              ),
            ),
            Obx(
              () => ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemBuilder: (context, index) => UserTileWidget(
                        user: _controller.showUserList[index],
                        isDark: true,
                      ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 24),
                  itemCount: _controller.showUserList.length),
            ),
            const SizedBox(height: 16),
            Obx(
              () => _labelRow(
                "최근 ${_controller.myCompanyInfo.value.name}를 조회한 프로필",
                () {
                  Get.to(() => CompanyVisitScreen(
                        isCompVisit: false,
                        company: _controller.myCompanyInfo.value,
                      ));
                },
              ),
            ),
            Obx(
              () => ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemBuilder: (context, index) => UserTileWidget(
                        user: _controller.visitUserList[index],
                        isDark: true,
                      ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 24),
                  itemCount: _controller.visitUserList.length),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _labelRow(String label, Function() onTap, {int? count}) {
    return Row(
      children: [
        Text(label, style: kmainbold.copyWith(color: mainWhite)),
        const SizedBox(width: 8),
        if (count != null)
          Text("$count명", style: kmain.copyWith(color: mainWhite)),
        const Spacer(),
        GestureDetector(
            onTap: onTap,
            child: Text("전체보기", style: kmain.copyWith(color: mainblue))),
      ],
    );
  }

  Widget interestingUser(User user) {
    return Column(
      children: [
        GestureDetector(
            child: UserImageWidget(
                imageUrl: user.profileImage, userType: user.userType)),
        const SizedBox(
          height: 4,
        ),
        Text(
          user.name,
          style: kmain.copyWith(color: mainWhite),
        )
      ],
    );
  }
}
