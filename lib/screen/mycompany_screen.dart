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
import 'package:loopus/screen/comp_intro_edit_screen.dart';
import 'package:loopus/screen/company_interesting_screen.dart';
import 'package:loopus/screen/profile_image_change_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
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
        centerTitle: true,
        title: Text(
          '내 기업 프로필',
          style: ktitle.copyWith(color: mainWhite),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(
            'assets/icons/appbar_back.svg',
            color: mainWhite,
          ),
        ),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Get.to(() => BookmarkScreen());
          //     },
          //     icon: SvgPicture.asset(
          //       'assets/icons/bookmark_inactive.svg',
          //       width: 28,
          //     )),
          IconButton(
            onPressed: () {
              Get.to(() => SettingScreen());
            },
            icon: SvgPicture.asset(
              'assets/icons/setting.svg',
              width: 28,
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
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller.tabController,
            children: [_introView(), _postView()],
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
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => GestureDetector(
                  onTap: () => showModalIOS(context,
                      func1: changeProfileImage,
                      func2: changeDefaultImage,
                      value1: '라이브러리에서 선택',
                      value2: '기본 이미지로 변경',
                      isValue1Red: false,
                      isValue2Red: false,
                      isOne: false),
                  child: UserImageWidget(
                    imageUrl: _controller.myCompanyInfo.value.profileImage,
                    width: 90,
                    height: 90,
                    userType: _controller.myCompanyInfo.value.userType,
                  )),
            ),
            // Positioned.fill(
            //   child: Align(
            //     alignment: Alignment.bottomRight,
            //     child: GestureDetector(
            //       onTap: () => showModalIOS(context,
            //           func1: changeProfileImage,
            //           func2: changeDefaultImage,
            //           value1: '라이브러리에서 선택',
            //           value2: '기본 이미지로 변경',
            //           isValue1Red: false,
            //           isValue2Red: false,
            //           isOne: false),
            //       child: Container(
            //         decoration: const BoxDecoration(
            //             shape: BoxShape.circle, color: mainWhite),
            //         child: SvgPicture.asset(
            //           "assets/icons/profile_image.svg",
            //           width: 28,
            //           height: 28,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        const SizedBox(
          height: 14,
        ),
        Obx(
          () => Text(
            _controller.myCompanyInfo.value.name,
            style: kmainbold.copyWith(color: mainWhite),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
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
                  width: 7,
                ),
                const VerticalDivider(
                  thickness: 2,
                  color: mainWhite,
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  _controller.myCompanyInfo.value.address,
                  style: kmain.copyWith(color: mainWhite),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        Obx(
          () => Text(
            _controller.myCompanyInfo.value.homepage,
            style: kmain.copyWith(color: mainblue),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "이 기업에 관심있는 프로필",
                style: kmainbold.copyWith(color: mainWhite),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => CompanyInterestingScreen(
                      userId: _controller.myCompanyInfo.value.userId,
                      listType: FollowListType.follower));
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
          height: 14,
        ),
        Obx(
          () => SizedBox(
            height: 72,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) =>
                    interestingUser(_controller.followerList[index]),
                separatorBuilder: (context, index) => const SizedBox(
                      width: 14,
                    ),
                itemCount: math.min(_controller.followerList.length, 10)),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }

  Widget _tabView() {
    return Column(
      children: [
        Material(
          color: mainblack,
          child: TabBar(
              controller: _controller.tabController,
              labelStyle: kmainbold,
              labelColor: mainWhite,
              unselectedLabelStyle: kmainbold.copyWith(color: dividegray),
              unselectedLabelColor: dividegray,
              automaticIndicatorColorAdjustment: false,
              indicator: const UnderlineIndicator(
                strokeCap: StrokeCap.round,
                borderSide: BorderSide(width: 2, color: mainWhite),
              ),
              isScrollable: false,
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
              ]),
        ),
        Divider(
          height: 1,
          thickness: 2,
          color: dividegray,
        )
      ],
    );
  }

  Widget _introView() {
    return Obx(() => _controller.myCompanyInfo.value.intro == ""
        ? Column(
            children: [
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomExpandedButton(
                        onTap: () {
                          Get.to(() => CompanyIntroEditScreen());
                        },
                        isBlue: true,
                        title: "기업 소개 수정하기",
                        isBig: true),
                  ],
                ),
              ),
            ],
          )
        : Column(
            children: [
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _controller.myCompanyInfo.value.intro,
                  style: kmainheight.copyWith(color: mainWhite),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomExpandedButton(
                        onTap: () {
                          Get.to(() => CompanyIntroEditScreen());
                        },
                        isBlue: true,
                        title: "기업 소개 수정하기",
                        isBig: true),
                  ],
                ),
              ),
            ],
          ));
  }

  Widget _postView() {
    return Obx(() => _controller.allPostList.isEmpty
        ? EmptyContentWidget(text: '아직 포스팅이 없어요')
        : sr.SmartRefresher(
            controller: _controller.postLoadingController,
            enablePullDown: false,
            enablePullUp: true,
            footer: const MyCustomFooter(),
            onLoading: _controller.onPostLoading,
            child: ListView.separated(
                // key: const PageStorageKey("postView"), 이거 넣으면 포스팅들이 마지막 사진이나 링크로 가게됨
                itemBuilder: (context, index) => PostingWidget(
                      item: _controller.allPostList[index],
                      type: PostingWidgetType.profile,
                      isDark: true,
                    ),
                separatorBuilder: (context, index) => DivideWidget(
                      height: 10,
                    ),
                itemCount: _controller.allPostList.length),
          ));
  }

  Widget interestingUser(User user) {
    return Column(
      children: [
        UserImageWidget(imageUrl: user.profileImage, userType: user.userType),
        const SizedBox(
          height: 7,
        ),
        Text(
          user.name,
          style: kmain.copyWith(color: mainWhite),
        )
      ],
    );
  }
}
