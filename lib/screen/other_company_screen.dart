import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/other_company_controller.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/comp_intro_edit_screen.dart';
import 'package:loopus/screen/company_interesting_screen.dart';
import 'package:loopus/screen/profile_image_change_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as sr;
import 'package:underline_indicator/underline_indicator.dart';
import 'dart:math' as math;

class OtherCompanyScreen extends StatelessWidget {
  OtherCompanyScreen(
      {Key? key,
      required this.companyId,
      required this.companyName,
      this.company})
      : super(key: key);
  late final OtherCompanyController _controller = Get.put(
      OtherCompanyController(
          companyId: companyId,
          otherCompany:
              company != null ? company!.obs : Company.defaultCompany().obs),
      tag: companyId.toString());

  Company? company;
  int companyId;
  String companyName;

  final Debouncer _debouncer = Debouncer();

  final sr.RefreshController _otherCompanyrefreshController =
      sr.RefreshController(initialRefresh: false);
  final sr.RefreshController _otherpostLoadingController =
      sr.RefreshController(initialRefresh: false);

  Future onRefresh() async {
    _controller.profileenablepullup.value = true;
    _controller.postPageNum = 1;
    _controller.allPostList.clear();
    _controller.loadOtherCompany(companyId);
    _otherCompanyrefreshController.refreshCompleted();
  }

  void onLoading() async {
    // await Future.delayed(Duration(seconds: 2));
    int statusCode = await _controller.getCompanyPosting(companyId);
    if (statusCode == 204) {
      _otherpostLoadingController.loadNoData();
    } else {
      _otherpostLoadingController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            '$companyName 프로필',
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
            Obx(
              () => _controller.otherprofilescreenstate.value !=
                      ScreenState.success
                  ? Container()
                  : _controller.otherCompany.value.userId ==
                          int.parse(HomeController.to.myId!)
                      ? IconButton(
                          onPressed: () {
                            Get.to(() => SettingScreen());
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/setting.svg',
                          ),
                        )
                      : Container(),
            ),
          ],
        ),
        body: RefreshIndicator(
          notificationPredicate: (notification) {
            return notification.depth == 2;
          },
          onRefresh: onRefresh,
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
              children: [
                _introView(),
                _postView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changeProfileImage() async {
    Get.to(() => ProfileImageChangeScreen(
          user: _controller.otherCompany.value,
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
                  onTap: () {
                    if (_controller.otherCompany.value.userId ==
                        int.parse(HomeController.to.myId!)) {
                      showModalIOS(context,
                          func1: changeProfileImage,
                          func2: changeDefaultImage,
                          value1: '라이브러리에서 선택',
                          value2: '기본 이미지로 변경',
                          isValue1Red: false,
                          isValue2Red: false,
                          isOne: false);
                    }
                  },
                  child: UserImageWidget(
                    imageUrl: _controller.otherCompany.value.profileImage,
                    width: 90,
                    height: 90,
                    userType: _controller.otherCompany.value.userType,
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: 14,
        ),
        Obx(
          () => Text(
            _controller.otherCompany.value.name,
            style: kmainbold,
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
                  fieldList[_controller.otherCompany.value.fieldId]!,
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
                  _controller.otherCompany.value.address,
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
            _controller.otherCompany.value.homepage,
            style: kmain.copyWith(color: mainblue),
          ),
        ),
        Obx(
          () => _controller.otherCompany.value.userId ==
                  int.parse(HomeController.to.myId!)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: CustomExpandedBoldButton(
                    onTap: followMotion,
                    isBlue: _controller.otherCompany.value.followed.value ==
                            FollowState.follower ||
                        _controller.otherCompany.value.followed.value ==
                            FollowState.normal ||
                        false,
                    title: _controller.otherCompany.value.followed.value ==
                            FollowState.normal
                        ? '팔로우'
                        : _controller.otherCompany.value.followed.value ==
                                FollowState.follower
                            ? '나도 팔로우하기'
                            : _controller.otherCompany.value.followed.value ==
                                    FollowState.following
                                ? '팔로우 중'
                                : '팔로우 중',
                  ),
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
                      userId: _controller.otherCompany.value.userId,
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
        Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: maingray, width: 2.0),
                ),
              ),
            ),
            Material(
              color: mainblack,
              child: TabBar(
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
          ],
        ),
      ],
    );
  }

  Widget _introView() {
    return Obx(() => _controller.otherCompany.value.userId ==
            int.parse(HomeController.to.myId!)
        ? _controller.otherCompany.value.intro == ""
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
                      _controller.otherCompany.value.intro,
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
              )
        : Column(
            children: [
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _controller.otherCompany.value.intro,
                  style: kmainheight.copyWith(color: mainWhite),
                ),
              ),
            ],
          ));
  }

  Widget _postView() {
    return Obx(() => _controller.allPostList.isEmpty
        ? EmptyContentWidget(text: '아직 포스팅이 없어요')
        : sr.SmartRefresher(
            controller: _otherpostLoadingController,
            enablePullDown: false,
            enablePullUp: true,
            footer: const MyCustomFooter(),
            onLoading: onLoading,
            child: ListView.separated(
                // key: const PageStorageKey("postView"), 이거 넣으면 포스팅들이 마지막 사진이나 링크로 가게됨
                itemBuilder: (context, index) => PostingWidget(
                    item: _controller.allPostList[index],
                    type: PostingWidgetType.profile),
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

  void followMotion() {
    _controller.otherCompany.value.followClick();

    _debouncer.run(() {
      if (_controller.otherCompany.value.followed.value.index !=
          _controller.lastisFollowed) {
        if (<int>[2, 3]
            .contains(_controller.otherCompany.value.followed.value.index)) {
          postfollowRequest(companyId);
          print("팔로우");
        } else {
          deletefollow(companyId);
          print("팔로우 해제");
        }
        _controller.lastisFollowed =
            _controller.otherCompany.value.followed.value.index;
      } else {
        print("아무일도 안 일어남");
      }
    });
  }
}
