import 'dart:io';

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
import 'package:loopus/widget/user_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as sr;
import 'package:underline_indicator/underline_indicator.dart';
import 'dart:math' as math;

class MyCompanyScreen extends StatelessWidget {
  MyCompanyScreen({Key? key}) : super(key: key);
  final MyCompanyController _controller = Get.put(MyCompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainblack,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.mainblack,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: AppColors.mainblack,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: Obx(
          () => Text(
            '${_controller.myCompanyInfo.value.name} ?????????',
            style: MyTextTheme.navigationTitle(context)
                .copyWith(color: AppColors.mainWhite),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: SvgPicture.asset(
            'assets/icons/appbar_back.svg',
            color: AppColors.mainWhite,
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
                color: AppColors.mainWhite,
              )),
          GestureDetector(
            onTap: () {
              Get.to(() => SettingScreen());
            },
            child: SvgPicture.asset(
              'assets/icons/setting.svg',
              color: AppColors.mainWhite,
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
            controller: _controller.tabController,
            children: [_introView(), _postView(), _visitView(context)],
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
                  value1: '?????? ???????????? ??????',
                  value2: '??????????????? ?????? ??????',
                  buttonColor1: AppColors.maingray,
                  buttonColor2: AppColors.mainblue,
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
            style: MyTextTheme.mainbold(context)
                .copyWith(color: AppColors.mainWhite),
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
                  style: MyTextTheme.main(context)
                      .copyWith(color: AppColors.mainWhite),
                ),
                const SizedBox(
                  height: 9,
                  child: VerticalDivider(
                    thickness: 1,
                    width: 16,
                    color: AppColors.mainWhite,
                  ),
                ),
                Text(
                  _controller.myCompanyInfo.value.address,
                  style: MyTextTheme.main(context)
                      .copyWith(color: AppColors.mainWhite),
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
              style:
                  MyTextTheme.main(context).copyWith(color: AppColors.mainblue),
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
                            "??? ????????? ???????????? ?????????",
                            style: MyTextTheme.mainbold(context)
                                .copyWith(color: AppColors.mainWhite),
                          ),
                          const SizedBox(width: 8),
                          Center(
                            child: SvgPicture.asset(
                              'assets/icons/information.svg',
                              color: AppColors.dividegray,
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
                              "????????????",
                              style: MyTextTheme.main(context)
                                  .copyWith(color: AppColors.mainblue),
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
                          itemBuilder: (context, index) => UserVerticalWidget(
                                user: _controller
                                    .myCompanyInfo.value.itrUsers[index],
                                emptyHeight: 4,
                                isDark: true,
                              ),
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
      color: AppColors.mainblack,
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
                    ? AppColors.mainWhite
                    : AppColors.dividegray,
              ),
            ),
          ),
          Obx(
            () => Tab(
              height: 40,
              icon: SvgPicture.asset(
                'assets/icons/post_active.svg',
                color: _controller.currentIndex.value == 1
                    ? AppColors.mainWhite
                    : AppColors.dividegray,
              ),
            ),
          ),
          Obx(
            () => Tab(
              height: 40,
              icon: SvgPicture.asset(
                'assets/icons/company_view.svg',
                color: _controller.currentIndex.value == 2
                    ? AppColors.mainWhite
                    : AppColors.dividegray,
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
                                color: AppColors.maingray,
                              );
                            },
                            errorWidget: (context, string, widget) {
                              return Container(
                                color: AppColors.maingray,
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
                                    "????????????",
                                    style: MyTextTheme.mainbold(context)
                                        .copyWith(color: AppColors.mainWhite),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "\"${_controller.myCompanyInfo.value.slogan}\"",
                                    style: MyTextTheme.mainboldheight(context)
                                        .copyWith(color: AppColors.mainWhite),
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
                                style: MyTextTheme.mainheight(context)
                                    .copyWith(color: AppColors.mainWhite),
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
                      title: "?????? ?????? ????????????",
                      isBig: true),
                ],
              ),
            ),
            Obx(
              () => _controller.newsList.isNotEmpty
                  ? NewsListWidget(
                      title: "?????? ??????",
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
  //                       title: "?????? ?????? ????????????",
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
  //                 style: MyTextTheme.mainheight(context).copyWith(color: AppColors.mainWhite),
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
  //                       title: "?????? ?????? ????????????",
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
                // key: const PageStorageKey("postView"), ?????? ????????? ??????????????? ????????? ???????????? ????????? ?????????
                itemBuilder: (context, index) => PostingWidget(
                      item: _controller.allPostList[index],
                      type: PostingWidgetType.normal,
                      isDark: true,
                    ),
                itemCount: _controller.allPostList.length),
          ));
  }

  Widget _visitView(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              "??? ?????? ?????? ????????? ?????? ????????? ????????? ??? ?????????",
              style:
                  MyTextTheme.main(context).copyWith(color: AppColors.maingray),
            ),
            const SizedBox(height: 16),
            _labelRow(
              context,
              "?????????",
              () {
                Get.to(() => FollowPeopleScreen(
                    userId: _controller.myCompanyInfo.value.userId,
                    listType: FollowListType.follower));
              },
              count: _controller.myCompanyInfo.value.followerCount.value,
            ),
            const SizedBox(height: 16),
            _labelRow(
              context,
              "?????????",
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
                context,
                "?????? ${_controller.myCompanyInfo.value.name}??? ????????? ?????????",
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
                context,
                "?????? ${_controller.myCompanyInfo.value.name}??? ????????? ?????????",
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

  Widget _labelRow(BuildContext context, String label, Function() onTap,
      {int? count}) {
    return Row(
      children: [
        Text(label,
            style: MyTextTheme.mainbold(context)
                .copyWith(color: AppColors.mainWhite)),
        const SizedBox(width: 8),
        if (count != null)
          Text("$count???",
              style: MyTextTheme.main(context)
                  .copyWith(color: AppColors.mainWhite)),
        const Spacer(),
        GestureDetector(
            onTap: onTap,
            child: Text("????????????",
                style: MyTextTheme.main(context)
                    .copyWith(color: AppColors.mainblue))),
      ],
    );
  }
}
