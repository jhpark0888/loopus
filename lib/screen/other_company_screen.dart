import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/other_company_controller.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/comp_intro_edit_screen.dart';
import 'package:loopus/screen/company_interesting_screen.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/screen/profile_image_change_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/follow_button_widget.dart';
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
            style: kNavigationTitle.copyWith(color: mainWhite),
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
                      ? GestureDetector(
                          onTap: () {
                            Get.to(() => SettingScreen());
                          },
                          child: SvgPicture.asset(
                            'assets/icons/setting.svg',
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            showBottomdialog(
                              context,
                              func1: () {
                                showButtonDialog(
                                    leftText: '취소',
                                    rightText: '차단',
                                    title:
                                        '<${_controller.otherCompany.value.name}> 유저를 차단하시겠어요?',
                                    startContent:
                                        '차단하면 <${_controller.otherCompany.value.name}> 유저와의 팔로우도 해제됩니다',
                                    leftFunction: () => Get.back(),
                                    rightFunction: () {
                                      userban(_controller
                                              .otherCompany.value.userId)
                                          .then((value) {
                                        if (value.isError == false) {
                                          dialogBack();
                                          _controller.otherCompany.value
                                              .banClick();

                                          showCustomDialog(
                                              "해당 유저가 차단 되었습니다", 1000);
                                        } else {
                                          errorSituation(value);
                                        }
                                      });
                                    });
                              },
                              func2: () {
                                showButtonDialog(
                                    leftText: '취소',
                                    rightText: '신고',
                                    title:
                                        '<${_controller.otherCompany.value.name}> 유저를 신고하시겠어요?',
                                    startContent: '관리자가 검토할 예정이에요',
                                    leftFunction: () => Get.back(),
                                    rightFunction: () {
                                      userreport(_controller
                                              .otherCompany.value.userId)
                                          .then((value) {
                                        if (value.isError == false) {
                                          dialogBack(modalIOS: true);
                                          showCustomDialog("신고가 접수되었습니다", 1000);
                                        } else {
                                          errorSituation(value);
                                        }
                                      });
                                    });
                              },
                              value1: '계정 차단하기',
                              value2: '계정 신고하기',
                              buttonColor1: mainWhite,
                              buttonColor2: rankred,
                              textColor1: rankred,
                              isOne: false,
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/more_option.svg',
                            color: mainWhite,
                          ),
                        ),
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
          height: 16,
        ),
        Obx(
          () => GestureDetector(
              onTap: () {
                if (_controller.otherCompany.value.userId ==
                    int.parse(HomeController.to.myId!)) {
                  showBottomdialog(context,
                      func1: changeDefaultImage,
                      func2: changeProfileImage,
                      value1: '기본 이미지로 변경',
                      value2: '사진첩에서 사진 선택',
                      buttonColor1: maingray,
                      buttonColor2: mainblue,
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
        const SizedBox(
          height: 8,
        ),
        Obx(
          () => Text(
            _controller.otherCompany.value.name,
            style: kmainbold.copyWith(color: mainWhite),
          ),
        ),
        const SizedBox(
          height: 8,
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
                const SizedBox(width: 8),
                const VerticalDivider(
                  thickness: 2,
                  color: mainWhite,
                ),
                const SizedBox(width: 8),
                Text(
                  _controller.otherCompany.value.address,
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
                WebViewScreen(url: _controller.otherCompany.value.homepage));
          },
          child: Obx(
            () => Text(
              _controller.otherCompany.value.homepage,
              style: kmain.copyWith(color: mainblue),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (_controller.otherCompany.value.userId !=
            int.parse(HomeController.to.myId!))
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Obx(
                        () => FollowButtonWidget(
                            user: _controller.otherCompany.value),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: CustomExpandedBoldButton(
                        onTap: () async {
                          if (HomeController.to.enterMessageRoom.value ==
                              _controller.otherCompany.value.userId) {
                            Get.back();
                          } else {
                            Get.to(() => MessageDetatilScreen(
                                  partner: _controller.otherCompany.value,
                                  myProfile: HomeController.to.myProfile.value,
                                  enterRoute: EnterRoute.otherProfile,
                                ));
                            HomeController.to.enterMessageRoom.value =
                                _controller.otherCompany.value.userId;
                          }
                        },
                        isBlue: false,
                        title: '메시지',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        Obx(
          () => _controller.otherCompany.value.itrUsers.isNotEmpty
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
                                    company: _controller.otherCompany.value,
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
                      height: 72,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) => interestingUser(
                              _controller.otherCompany.value.itrUsers[index]),
                          separatorBuilder: (context, index) => const SizedBox(
                                width: 16,
                              ),
                          itemCount:
                              _controller.otherCompany.value.itrUsers.length),
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
      child: Column(
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
              TabBar(
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _introView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) => Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: _controller
                              .otherCompany.value.images[index].image,
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
                        Text(
                          _controller
                              .otherCompany.value.images[index].imageInfo,
                          style: kmainheight.copyWith(color: mainWhite),
                        )
                      ],
                    ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: _controller.otherCompany.value.images.length),
          ),
          if (_controller.otherCompany.value.userId ==
              int.parse(HomeController.to.myId!))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
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
      ),
    );
  }

  Widget _postView() {
    return Obx(() => _controller.allPostList.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: EmptyContentWidget(text: '아직 포스팅이 없어요'),
          )
        : sr.SmartRefresher(
            controller: _otherpostLoadingController,
            enablePullDown: false,
            enablePullUp: true,
            footer: const MyCustomFooter(),
            onLoading: onLoading,
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

  Widget interestingUser(User user) {
    return Column(
      children: [
        UserImageWidget(imageUrl: user.profileImage, userType: user.userType),
        const SizedBox(
          height: 8,
        ),
        Text(
          user.name,
          style: kmain.copyWith(color: mainWhite),
        )
      ],
    );
  }
}
