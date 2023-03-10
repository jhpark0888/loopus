import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/model/company_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/bookmark_screen.dart';
import 'package:loopus/screen/group_career_detail_screen.dart';
import 'package:loopus/screen/career_arrange_screen.dart';
import 'package:loopus/screen/other_company_screen.dart';
import 'package:loopus/screen/profile_sns_add_screen.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/follow_button_widget.dart';
import 'package:loopus/widget/profile_sns_image_widget.dart';
import 'personal_career_detail_screen.dart';
import 'package:loopus/screen/follow_people_screen.dart';
import 'package:loopus/screen/personal_career_detail_screen.dart';
import 'package:loopus/screen/profile_image_change_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/career_analysis_widget.dart';
import 'package:loopus/widget/career_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as sr;

import '../controller/hover_controller.dart';

class OtherProfileScreen extends StatefulWidget {
  OtherProfileScreen({
    Key? key,
    this.user,
    required this.userid,
    required this.realname,
  }) : super(key: key);
  Person? user;
  int userid;
  String realname;

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen>
    with SingleTickerProviderStateMixin {
  late final OtherProfileController _controller = Get.put(
      OtherProfileController(
        userid: widget.userid,
        otherUser:
            widget.user != null ? widget.user!.obs : Person.defaultuser().obs,
      ),
      tag: widget.userid.toString());

  // final ImageController imageController = Get.put(ImageController());
  final HoverController _hoverController = HoverController();

  final sr.RefreshController _otherprofilerefreshController =
      sr.RefreshController(initialRefresh: false);

  final sr.RefreshController _otherpostLoadingController =
      sr.RefreshController(initialRefresh: false);

  late TabController _tabController;
  RxInt currentIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      currentIndex.value = _tabController.index;
    });
  }

  Future onRefresh() async {
    _controller.profileenablepullup.value = true;
    _controller.postPageNum = 1;
    _controller.companyPageNum = 1;
    _controller.allPostList.clear();
    _controller.interestedCompanies.clear();
    _controller.loadotherProfile(widget.userid);
    _otherprofilerefreshController.refreshCompleted();
    _otherpostLoadingController.loadComplete();
  }

  void onLoading() async {
    // await Future.delayed(Duration(seconds: 2));
    int statusCode = await _controller.getOtherPosting(widget.userid);
    if (statusCode == 204) {
      _otherpostLoadingController.loadNoData();
    } else {
      _otherpostLoadingController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        titleSpacing: 0.0,
        centetTitle: _controller.otherUser.value.isuser != 1,
        title: '?????????',
        actions: [
          if (_controller.otherUser.value.isuser == 1)
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Get.to(() => BookmarkScreen());
                },
                icon: SvgPicture.asset('assets/icons/appbar_bookmark.svg')),
          Obx(
            () => _controller.otherprofilescreenstate.value !=
                        ScreenState.success ||
                    _controller.isBanned.value
                ? Container()
                : HomeController.to.myId == widget.userid.toString()
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
                                  leftText: '??????',
                                  rightText: '??????',
                                  title: '?????? ??????',
                                  startContent: '${widget.realname}?????? ??????????????????????',
                                  leftFunction: () => Get.back(),
                                  rightFunction: () {
                                    userban(_controller.userid).then((value) {
                                      if (value.isError == false) {
                                        dialogBack();
                                        _controller.otherUser.value
                                            .banned(BanState.ban);

                                        showCustomDialog(
                                            "?????? ????????? ?????? ???????????????", 1000);
                                      } else {
                                        errorSituation(value);
                                      }
                                    });
                                    userResign(
                                        HomeController
                                            .to.myProfile.value.userId,
                                        BanType.ban,
                                        _controller.userid);
                                  });
                            },
                            func2: () {
                              TextEditingController reportController =
                                  TextEditingController();
                              showTextFieldDialog(
                                  title: '?????? ??????',
                                  hintText:
                                      '?????? ????????? ??????????????????. ????????? ?????? \n ?????? ?????? ????????? ??????????????? ?????? ????????? \n?????? ??? ????????????.',
                                  rightText: '??????',
                                  rightBoxColor: AppColors.rankred,
                                  textEditingController: reportController,
                                  leftFunction: () {
                                    Get.back();
                                  },
                                  rightFunction: () {
                                    userreport(_controller.userid)
                                        .then((value) {
                                      if (value.isError == false) {
                                        dialogBack(modalIOS: true);
                                        showCustomDialog("????????? ?????????????????????", 1000);
                                      } else {
                                        errorSituation(value);
                                      }
                                    });
                                  });
                            },
                            value1: '?????? ????????????',
                            value2: '?????? ????????????',
                            buttonColor1: AppColors.mainWhite,
                            buttonColor2: AppColors.rankred,
                            textColor1: AppColors.rankred,
                            isOne: false,
                          );
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/more_option.svg',
                        ),
                      ),
          ),
        ],
        bottomBorder: false,
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
                    // physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [_careerView(context), _postView()],
                  ),
                ),
              ),
      ),
    );
  }

  void changeProfileImage() async {
    Get.to(() => ProfileImageChangeScreen(
          user: _controller.otherUser.value,
        ));
  }

  void changeDefaultImage() async {
    await updateProfile(
            user: _controller.otherUser.value,
            updateType: ProfileUpdateType.image)
        .then((value) {
      if (value.isError == false) {
        Person user = Person.fromJson(value.data);
        _controller.otherUser(user);
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
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => FollowPeopleScreen(
                      userId: widget.userid,
                      listType: FollowListType.follower,
                    ));
              },
              behavior: HitTestBehavior.translucent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(
                    () => Text(
                      _controller.otherUser.value.followerCount.toString(),
                      style: MyTextTheme.mainbold(context).copyWith(
                          color: _hoverController.isHover.value
                              ? AppColors.mainblack.withOpacity(0.6)
                              : AppColors.mainblack),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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
                      onTap: () {
                        if (HomeController.to.myId ==
                            widget.userid.toString()) {
                          showBottomdialog(context,
                              func1: changeDefaultImage,
                              func2: changeProfileImage,
                              value1: '?????? ???????????? ??????',
                              value2: '??????????????? ?????? ??????',
                              buttonColor1: AppColors.maingray,
                              buttonColor2: AppColors.mainblue,
                              isOne: false);
                        }
                      },
                      child: UserImageWidget(
                        imageUrl: _controller.otherUser.value.profileImage,
                        width: 90,
                        height: 90,
                        userType: _controller.otherUser.value.userType,
                      )),
                ),
                if (HomeController.to.myId == widget.userid.toString())
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
                              shape: BoxShape.circle,
                              color: AppColors.mainWhite),
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
                      userId: widget.userid,
                      listType: FollowListType.following,
                    ));
              },
              behavior: HitTestBehavior.translucent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      _controller.otherUser.value.followingCount.toString(),
                      style: MyTextTheme.mainbold(context).copyWith(
                          color: _hoverController.isHover.value
                              ? AppColors.mainblack.withOpacity(0.6)
                              : AppColors.mainblack),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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
          height: 13,
        ),
        Obx(
          () => Text(
            _controller.otherUser.value.name,
            style: MyTextTheme.mainbold(context),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Obx(
          () => IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserImageWidget(
                  imageUrl: _controller.otherUser.value.univlogo,
                  width: 24,
                  height: 24,
                  userType: _controller.otherUser.value.userType,
                ),
                const SizedBox(width: 8),
                Text(
                  _controller.userUnivName.value,
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
                  _controller.otherUser.value.department,
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
                  "${_controller.otherUser.value.admissionYear.substring(2)}?????? ??????",
                  style: MyTextTheme.main(context),
                ),
              ],
            ),
          ),
        ),
        _snsView(),
        const SizedBox(
          height: 8,
        ),
        if (HomeController.to.myId != widget.userid.toString())
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Obx(
                        () => FollowButtonWidget(
                            user: _controller.otherUser.value),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: CustomExpandedBoldButton(
                        onTap: () async {
                          if (HomeController.to.enterMessageRoom.value ==
                              _controller.otherUser.value.userId) {
                            Get.back();
                          } else {
                            Get.to(() => MessageDetatilScreen(
                                  partner: _controller.otherUser.value,
                                  myProfile: HomeController.to.myProfile.value,
                                  enterRoute: EnterRoute.otherProfile,
                                ));
                            HomeController.to.enterMessageRoom.value =
                                _controller.otherUser.value.userId;
                          }
                        },
                        isBlue: false,
                        title: '?????????',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
      ],
    );
  }

  Widget _snsListWidget() {
    return SizedBox(
      height: 28,
      child: ListView.separated(
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return ProfileSnsImageWidget(
              sns: _controller.otherUser.value.snsList[index],
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                width: 8,
              ),
          itemCount: _controller.otherUser.value.snsList.length),
    );
  }

  Widget _snsView() {
    return Obx(
      () => HomeController.to.myId == widget.userid.toString()
          ? Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _controller.otherUser.value.snsList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _snsListWidget(),
                        )
                      : Container(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ProfileSnsAddScreen(
                            snsList: _controller.otherUser.value.snsList,
                          ));
                    },
                    child: SvgPicture.asset(
                      "assets/icons/home_add.svg",
                      width: 28,
                      height: 28,
                      color: AppColors.mainblue,
                    ),
                  ),
                  _controller.otherUser.value.snsList.isNotEmpty
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            Get.to(() => ProfileSnsAddScreen(
                                  snsList: _controller.otherUser.value.snsList,
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
                        )
                ],
              ),
            )
          : _controller.otherUser.value.snsList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _snsListWidget())
              : Container(),
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
                  bottom: BorderSide(color: AppColors.maingray, width: 2.0),
                ),
              ),
            ),
            TabBar(
                controller: _tabController,
                labelStyle: MyTextTheme.mainbold(context),
                labelColor: AppColors.mainblack,
                unselectedLabelStyle: MyTextTheme.mainbold(context)
                    .copyWith(color: AppColors.dividegray),
                unselectedLabelColor: AppColors.dividegray,
                automaticIndicatorColorAdjustment: false,
                indicator: const UnderlineIndicator(
                  strokeCap: StrokeCap.round,
                  borderSide: BorderSide(width: 2, color: AppColors.mainblack),
                ),
                onTap: (index) {
                  currentIndex(index);
                },
                isScrollable: false,
                tabs: [
                  Obx(
                    () => Tab(
                      height: 40,
                      child: SvgPicture.asset(
                        'assets/icons/list_active.svg',
                        color: currentIndex.value == 0
                            ? null
                            : AppColors.dividegray,
                      ),
                    ),
                  ),
                  Obx(
                    () => Tab(
                      height: 40,
                      child: SvgPicture.asset(
                        'assets/icons/post_active.svg',
                        color: currentIndex.value == 1
                            ? null
                            : AppColors.dividegray,
                      ),
                    ),
                  ),
                ]),
          ],
        ),
      ],
    );
  }

  Widget _careerView(BuildContext context) {
    return SafeArea(
        child: Obx(() => _controller.otherProjectList.isEmpty
            ? CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                      child: EmptyContentWidget(text: '?????? ???????????? ?????????')),
                  if (_controller.isOfficial.value == 2)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            "?????????????????? ??????????????? ????????? ?????? ?????? ?????? ????????? ??????????????????."
                            "\n?????? ????????? ?????? ????????? ?????? ??? ????????????.",
                            style: MyTextTheme.caption(context)
                                .copyWith(color: AppColors.popupGray),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                ],
              )
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
                        //   sliver:
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
                                    Text('${widget.realname}?????? ???????????? ??????',
                                        style: MyTextTheme.mainbold(context)),
                                    const SizedBox(width: 8),
                                    if (_controller.otherUser.value.isuser == 1)
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            showPopUpDialog(
                                              '???????????? ??????',
                                              '?????????????????? ???????????? ?????????\n????????? ????????? ??????, ??????\n???????????? ?????? ???????????? ??????\n????????? ???????????? ????????????',
                                            );
                                          },
                                          icon: SvgPicture.asset(
                                            'assets/icons/information.svg',
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Obx(() => _controller
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
                                          return companyTile(_controller
                                              .interestedCompanies[index]);
                                        },
                                        itemCount: _controller
                                            .interestedCompanies.length,
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width: 16);
                                        },
                                      ),
                                    )
                                  : Text(
                                      '?????? ${_controller.otherUser.value.name}?????? ???????????? ????????? ?????????',
                                      style: MyTextTheme.main(context)
                                          .copyWith(color: AppColors.maingray),
                                    )),
                              // CareerAnalysisWidget(
                              //   field: fieldList[
                              //       _controller.otherUser.value.fieldId]!,
                              //   groupRatio:
                              //       _controller.otherUser.value.groupRatio,
                              //   // schoolRatio:
                              //   //     _controller.otherUser.value.schoolRatio,
                              //   // lastgroupRatio:
                              //   //     _controller.otherUser.value.groupRatio +
                              //   //         _controller
                              //   //             .otherUser.value.groupRatioVariance,
                              //   // lastschoolRatio:
                              //   //     _controller.otherUser.value.schoolRatio +
                              //   //         _controller
                              //   //             .otherUser.value.schoolRatioVariance,
                              // ),
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
                                      field: fieldList[
                                          _controller.otherUser.value.fieldId]!,
                                      groupRatio: _controller
                                          .otherUser.value.groupRatio,
                                      // schoolRatio:
                                      //     _controller.otherUser.value.schoolRatio,
                                      lastgroupRatio:
                                          // _controller.otherUser.value.groupRatio +
                                          _controller.otherUser.value
                                              .groupRatioVariance,
                                      // lastschoolRatio:
                                      //     _controller.otherUser.value.schoolRatio +
                                      //         _controller
                                      //             .otherUser.value.schoolRatioVariance,
                                    ),
                                    // const SizedBox(width: 8),
                                    if (_controller.otherUser.value.isuser == 1)
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
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
                                    if (HomeController.to.myId ==
                                        widget.userid.toString())
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
                              const SizedBox(height: 14),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      goCareerScreen(
                                        _controller.otherProjectList[index],
                                        _controller.otherUser.value.name,
                                      );
                                    },
                                    child: CareerWidget(
                                        career: _controller
                                            .otherProjectList[index]),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 16,
                                  ),
                                  itemCount:
                                      _controller.otherProjectList.length,
                                ),
                              ),

                              const SizedBox(height: 24),

                              if (_controller.isOfficial.value == 2)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: Text(
                                      "?????????????????? ??????????????? ????????? ?????? ?????? ?????? ????????? ??????????????????."
                                      "\n?????? ????????? ?????? ????????? ?????? ??? ????????????.",
                                      style: MyTextTheme.caption(context)
                                          .copyWith(color: AppColors.popupGray),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              // const SizedBox(height: 24),
                            ],
                          ),
                        ),

                        // ),
                      ]);
                },
              )));
  }

  Widget _postView() {
    return Obx(() => _controller.allPostList.isEmpty
        ? Center(
            child: SingleChildScrollView(
                child: EmptyContentWidget(text: '?????? ???????????? ?????????')))
        : sr.SmartRefresher(
            controller: _otherpostLoadingController,
            enablePullDown: false,
            enablePullUp: true,
            footer: const MyCustomFooter(),
            onLoading: onLoading,
            child: ListView.builder(
                // key: const PageStorageKey("postView"), ?????? ????????? ??????????????? ????????? ???????????? ????????? ?????????
                itemBuilder: (context, index) => PostingWidget(
                    item: _controller.allPostList[index],
                    type: PostingWidgetType.normal),
                itemCount: _controller.allPostList.length),
          ));
  }

  Widget companyTile(Company company) {
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
