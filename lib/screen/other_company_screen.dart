import 'dart:io';

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
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/screen/profile_image_change_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/empty_post_widget.dart';
import 'package:loopus/widget/follow_button_widget.dart';
import 'package:loopus/widget/news_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:loopus/widget/user_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as sr;
import 'package:underline_indicator/underline_indicator.dart';
import 'dart:math' as math;

class OtherCompanyScreen extends StatefulWidget {
  OtherCompanyScreen(
      {Key? key,
      required this.companyId,
      required this.companyName,
      this.company})
      : super(key: key);
  Company? company;
  int companyId;
  String companyName;

  @override
  State<OtherCompanyScreen> createState() => _OtherCompanyScreenState();
}

class _OtherCompanyScreenState extends State<OtherCompanyScreen>
    with SingleTickerProviderStateMixin {
  late final OtherCompanyController _controller = Get.put(
      OtherCompanyController(
          companyId: widget.companyId,
          otherCompany: widget.company != null
              ? widget.company!.obs
              : Company.defaultCompany().obs),
      tag: widget.companyId.toString());

  final sr.RefreshController _otherCompanyrefreshController =
      sr.RefreshController(initialRefresh: false);

  final sr.RefreshController _otherpostLoadingController =
      sr.RefreshController(initialRefresh: false);

  late TabController _tabController;
  RxInt currentIndex = 0.obs;

  Future onRefresh() async {
    _controller.profileenablepullup.value = true;
    _controller.postPageNum = 1;
    _controller.allPostList.clear();
    _controller.loadOtherCompany(widget.companyId);
    _otherCompanyrefreshController.refreshCompleted();
  }

  void onLoading() async {
    // await Future.delayed(Duration(seconds: 2));
    int statusCode = await _controller.getCompanyPosting(widget.companyId);
    if (statusCode == 204) {
      _otherpostLoadingController.loadNoData();
    } else {
      _otherpostLoadingController.loadComplete();
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      currentIndex.value = _tabController.index;
    });
  }

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
        centerTitle: true,
        title: Text(
          '${widget.companyName} 프로필',
          style: MyTextTheme.navigationTitle(context)
              .copyWith(color: AppColors.mainWhite),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset(
            'assets/icons/appbar_back.svg',
            color: AppColors.mainWhite,
          ),
        ),
        actions: [
          Obx(
            () => _controller.otherprofilescreenstate.value !=
                        ScreenState.success ||
                    _controller.isBanned.value
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
                                  title: '계정 차단',
                                  startContent:
                                      '${_controller.otherCompany.value.name}님을 차단하시겠어요?',
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
                                            "${_controller.otherCompany.value.name}님이 차단되었습니다",
                                            1000);
                                      } else {
                                        errorSituation(value);
                                      }
                                    });
                                  });
                            },
                            func2: () {
                              TextEditingController reportController =
                                  TextEditingController();
                              showTextFieldDialog(
                                  title: '계정 신고',
                                  hintText:
                                      '신고 사유를 입력해주세요. 관리자 확인 \n 이후 해당 계정은 이용약관에 따라 제재를 \n받을 수 있습니다.',
                                  rightText: '신고',
                                  textEditingController: reportController,
                                  leftFunction: () {
                                    Get.back();
                                  },
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
                                  },
                                  leftBoxColor: AppColors.maingray,
                                  rightBoxColor: AppColors.rankred);
                            },
                            value1: '계정 차단하기',
                            value2: '계정 신고하기',
                            buttonColor1: AppColors.mainWhite,
                            buttonColor2: AppColors.rankred,
                            textColor1: AppColors.rankred,
                            isOne: false,
                          );
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/more_option.svg',
                          color: AppColors.mainWhite,
                        ),
                      ),
          ),
        ],
      ),
      body: Obx(
        () => _controller.isBanned.value
            ? Container()
            : RefreshIndicator(
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
                    controller: _tabController,
                    // physics: const NeverScrollableScrollPhysics(),
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
                      buttonColor1: AppColors.maingray,
                      buttonColor2: AppColors.mainblue,
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
            style: MyTextTheme.mainbold(context)
                .copyWith(color: AppColors.mainWhite),
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
                  _controller.otherCompany.value.address,
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
                WebViewScreen(url: _controller.otherCompany.value.homepage));
          },
          child: Obx(
            () => Text(
              _controller.otherCompany.value.homepage,
              style:
                  MyTextTheme.main(context).copyWith(color: AppColors.mainblue),
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
                                    company: _controller.otherCompany.value,
                                  ));
                            },
                            child: Text(
                              "전체보기",
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
      color: AppColors.mainblack,
      child: Column(
        children: [
          Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.maingray, width: 2.0),
                  ),
                ),
              ),
              TabBar(
                  controller: _tabController,
                  labelStyle: MyTextTheme.mainbold(context),
                  labelColor: AppColors.mainWhite,
                  unselectedLabelStyle: MyTextTheme.mainbold(context)
                      .copyWith(color: AppColors.dividegray),
                  unselectedLabelColor: AppColors.dividegray,
                  automaticIndicatorColorAdjustment: false,
                  indicator: const UnderlineIndicator(
                    strokeCap: StrokeCap.round,
                    borderSide:
                        BorderSide(width: 2, color: AppColors.mainWhite),
                  ),
                  isScrollable: false,
                  onTap: (index) {
                    currentIndex(index);
                  },
                  tabs: [
                    Obx(
                      () => Tab(
                        height: 40,
                        icon: SvgPicture.asset(
                          'assets/icons/company_intro.svg',
                          color: currentIndex.value == 0
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
                          color: currentIndex.value == 1
                              ? AppColors.mainWhite
                              : AppColors.dividegray,
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
    return ScrollNoneffectWidget(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: _controller
                                .otherCompany.value.images[index].image,
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
                          if (index == 0)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "기업소개",
                                    style: MyTextTheme.mainbold(context)
                                        .copyWith(color: AppColors.mainWhite),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "\"${_controller.otherCompany.value.slogan}\"",
                                    style: MyTextTheme.mainboldheight(context)
                                        .copyWith(color: AppColors.mainWhite),
                                  ),
                                ],
                              ),
                            ),
                          if (_controller
                                  .otherCompany.value.images[index].imageInfo !=
                              "")
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                _controller
                                    .otherCompany.value.images[index].imageInfo,
                                style: MyTextTheme.mainheight(context)
                                    .copyWith(color: AppColors.mainWhite),
                              ),
                            )
                        ],
                      ),
                  itemCount: _controller.otherCompany.value.images.length),
            ),
            if (_controller.otherCompany.value.userId ==
                int.parse(HomeController.to.myId!))
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomExpandedButton(
                        onTap: () {
                          Get.to(() => CompanyIntroEditScreen(
                                name: _controller.otherCompany.value.name,
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
                  ? KeepAliveWidget(
                      child: NewsListWidget(
                        title: "기업 뉴스",
                        issueList: _controller.newsList,
                        isDark: true,
                      ),
                    )
                  : Container(),
            ),
            if (_controller.isFake.value == 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    "루프어스에서 기업 정보를 조사하여 제공하는 페이지입니다."
                    "\n기업의 서비스 가입 유무는 다를 수 있습니다.",
                    style: MyTextTheme.caption(context)
                        .copyWith(color: AppColors.iconcolor),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _postView() {
    return Obx(() => _controller.allPostList.isEmpty
        ? HomeController.to.myId ==
                _controller.otherCompany.value.userId.toString()
            ? Center(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: GestureDetector(
                          onTap: () {
                            Get.to(() => PostingAddScreen(
                                project_id: companyCareerId,
                                route: PostaddRoute.career));
                          },
                          child: EmptyPostWidget())),
                ),
              )
            : Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: EmptyContentWidget(text: '아직 포스팅이 없어요'),
                  ),
                ),
              )
        : sr.SmartRefresher(
            controller: _otherpostLoadingController,
            enablePullDown: false,
            enablePullUp: true,
            footer: const MyCustomFooter(),
            onLoading: onLoading,
            child: ListView.builder(
                primary: false,
                shrinkWrap: true,
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
    return GestureDetector(
      onTap: () {
        Get.to(
            () => OtherProfileScreen(
                  userid: user.userId,
                  realname: user.name,
                  user: user as Person,
                ),
            preventDuplicates: false);
      },
      child: UserVerticalWidget(
        user: user,
        emptyHeight: 4,
        isDark: true,
      ),
    );
  }
}
