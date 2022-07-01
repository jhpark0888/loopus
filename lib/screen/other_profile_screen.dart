import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/ban_api.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/follow_controller.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/screen/profile_tag_change_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/looppeople_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/careertile_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_footer.dart';
import 'package:loopus/widget/custom_header.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controller/hover_controller.dart';

class OtherProfileScreen extends StatelessWidget {
  OtherProfileScreen(
      {Key? key,
      required this.userid,
      required this.isuser,
      required this.realname})
      : super(key: key);
  late OtherProfileController _controller =
      Get.put(OtherProfileController(userid), tag: userid.toString());

  late final FollowController followController = Get.put(
      FollowController(
          islooped: _controller.otherUser.value.looped.value ==
                  FollowState.normal
              ? 0.obs
              : _controller.otherUser.value.looped.value == FollowState.follower
                  ? 0.obs
                  : _controller.otherUser.value.looped.value ==
                          FollowState.following
                      ? 1.obs
                      : 1.obs,
          id: userid,
          lastislooped: _controller.otherUser.value.looped.value ==
                  FollowState.normal
              ? 0
              : _controller.otherUser.value.looped.value == FollowState.follower
                  ? 0
                  : _controller.otherUser.value.looped.value ==
                          FollowState.following
                      ? 1
                      : 1),
      tag: userid.toString());

  final ImageController imageController = Get.put(ImageController());
  final HoverController _hoverController = Get.put(HoverController());

  int userid;
  int isuser;
  String realname;

  RefreshController _otherprofilerefreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    _controller.careerCurrentPage(0.0);
    _controller.careertitleController.jumpTo(0);
    _controller.careerPageController.jumpTo(0);
    _controller.profileenablepullup.value = true;
    _controller.loadotherProfile(userid);
    _otherprofilerefreshController.refreshCompleted();
  }

  void onLoading() async {
    // await Future.delayed(Duration(seconds: 2));
    if (_controller.otherProjectList.isNotEmpty) {
      _controller.getProfilePost();
    }
    _otherprofilerefreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/icons/Arrow.svg'),
        ),
        title: '$realname님의 프로필',
        actions: [
          isuser == 1
              ? IconButton(
                  onPressed: () {
                    Get.to(() => SettingScreen());
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/Setting.svg',
                  ),
                )
              : IconButton(
                  onPressed: () {
                    showModalIOS(
                      context,
                      func1: () {
                        showButtonDialog(
                            leftText: '취소',
                            rightText: '신고',
                            title: '<$realname> 유저를 신고하시겠어요?',
                            content: '관리자가 검토할 예정이에요',
                            leftFunction: () => Get.back(),
                            rightFunction: () {
                              userreport(_controller.userid).then((value) {
                                if (value.isError == false) {
                                  dialogBack();
                                  showCustomDialog("신고가 접수되었습니다", 1000);
                                } else {
                                  errorSituation(value);
                                }
                              });
                            });
                      },
                      func2: () {
                        showButtonDialog(
                            leftText: '취소',
                            rightText: '차단',
                            title: '<$realname> 유저를 차단하시겠어요?',
                            content: '차단하면 <$realname> 유저와의 팔로우도 해제됩니다',
                            leftFunction: () => Get.back(),
                            rightFunction: () {
                              userban(_controller.userid).then((value) {
                                if (value.isError == false) {
                                  dialogBack();
                                  _controller.otherUser.value
                                      .banned(BanState.ban);

                                  showCustomDialog("해당 유저가 차단 되었습니다", 1000);
                                } else {
                                  errorSituation(value);
                                }
                              });
                            });
                      },
                      value1: '이 유저 신고하기',
                      value2: '이 유저 차단하기',
                      isValue1Red: true,
                      isValue2Red: true,
                      isOne: false,
                    );
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/More.svg',
                  ),
                ),
        ],
        bottomBorder: false,
      ),
      body: Obx(
        () => _controller.otherprofilescreenstate.value == ScreenState.loading
            ? const Center(child: LoadingWidget())
            : _controller.otherprofilescreenstate.value ==
                    ScreenState.disconnect
                ? DisconnectReloadWidget(reload: () {
                    _controller.loadotherProfile(userid);
                  })
                : _controller.otherprofilescreenstate.value == ScreenState.error
                    ? ErrorReloadWidget(reload: () {
                        _controller.loadotherProfile(userid);
                      })
                    : Obx(
                        () => SmartRefresher(
                          physics: const BouncingScrollPhysics(),
                          controller: _otherprofilerefreshController,
                          enablePullDown:
                              (_controller.otherprofilescreenstate.value ==
                                      ScreenState.loading)
                                  ? false
                                  : true,
                          enablePullUp: _controller.profileenablepullup.value,
                          header: const MyCustomHeader(),
                          footer: const MyCustomFooter(),
                          onRefresh: onRefresh,
                          onLoading: onLoading,
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Obx(
                                              () => Text(
                                                _controller
                                                    .otherUser.value.loopcount
                                                    .toString(),
                                                style: kmainbold.copyWith(
                                                    color: _hoverController
                                                            .isHover.value
                                                        ? mainblack
                                                            .withOpacity(0.6)
                                                        : mainblack),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              '팔로워',
                                              style: kmain.copyWith(
                                                  color: maingray),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 24,
                                        ),
                                        Stack(
                                          children: [
                                            Obx(
                                              () => GestureDetector(
                                                  onTap: () {
                                                    if (isuser == 1) {
                                                      showModalIOS(context,
                                                          func1:
                                                              changeProfileImage,
                                                          func2:
                                                              changeDefaultImage,
                                                          value1: '라이브러리에서 선택',
                                                          value2: '기본 이미지로 변경',
                                                          isValue1Red: false,
                                                          isValue2Red: false,
                                                          isOne: false);
                                                    }
                                                  },
                                                  child: UserImageWidget(
                                                    imageUrl: _controller
                                                            .otherUser
                                                            .value
                                                            .profileImage ??
                                                        '',
                                                    width: 90,
                                                    height: 90,
                                                  )),
                                            ),
                                            if (isuser == 1)
                                              Positioned.fill(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: GestureDetector(
                                                    onTap: () => showModalIOS(
                                                        context,
                                                        func1:
                                                            changeProfileImage,
                                                        func2:
                                                            changeDefaultImage,
                                                        value1: '라이브러리에서 선택',
                                                        value2: '기본 이미지로 변경',
                                                        isValue1Red: false,
                                                        isValue2Red: false,
                                                        isOne: false),
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: mainWhite),
                                                      child: SvgPicture.asset(
                                                        "assets/icons/Image.svg",
                                                        width: 24,
                                                        height: 24,
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(
                                              () => Text(
                                                _controller
                                                    .otherUser.value.loopcount
                                                    .toString(),
                                                style: kmainbold.copyWith(
                                                    color: _hoverController
                                                            .isHover.value
                                                        ? mainblack
                                                            .withOpacity(0.6)
                                                        : mainblack),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              '팔로잉',
                                              style: kmain.copyWith(
                                                  color: maingray),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Obx(
                                      () => Text(
                                        _controller.otherUser.value.realName,
                                        style: kmainbold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Obx(
                                      () => Text(
                                        _controller.otherUser.value.department,
                                        style: kmainbold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '상위 태그',
                                          style:
                                              kmain.copyWith(color: maingray),
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Obx(
                                          () => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: _controller
                                                  .otherUser.value.profileTag
                                                  .map((tag) => Row(children: [
                                                        Tagwidget(
                                                          tag: tag,
                                                        ),
                                                        _controller
                                                                    .otherUser
                                                                    .value
                                                                    .profileTag
                                                                    .indexOf(
                                                                        tag) !=
                                                                _controller
                                                                        .otherUser
                                                                        .value
                                                                        .profileTag
                                                                        .length -
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
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: CustomExpandedButton(
                                            onTap: _controller.otherUser.value
                                                        .isuser ==
                                                    1
                                                ? () {
                                                    Get.to(() =>
                                                        ProfileTagChangeScreen());
                                                  }
                                                : () {
                                                    // MessageDetailController
                                                    //     messagecontroller =
                                                    //     Get.put(
                                                    //         MessageDetailController(
                                                    //             userid:
                                                    //                 userid,
                                                    //             user: _controller
                                                    //                 .otherUser),
                                                    //         tag: _controller
                                                    //             .otherUser
                                                    //             .value
                                                    //             .userid
                                                    //             .toString());
                                                    // messagecontroller
                                                    //     .firstmessagesload();
                                                    Get.to(() =>
                                                        MessageDetailScreen(
                                                          realname: _controller
                                                              .otherUser
                                                              .value
                                                              .realName,
                                                          userid: _controller
                                                              .otherUser
                                                              .value
                                                              .userid,
                                                          user: _controller
                                                              .otherUser.value,
                                                        ));
                                                  },
                                            isBlue: false,
                                            isBig: false,
                                            buttonTag: '메시지 보내기',
                                            title: _controller.otherUser.value
                                                        .isuser ==
                                                    1
                                                ? '관심 태그 변경하기'
                                                : '메시지 보내기',
                                          ),
                                        ),
                                        if (_controller
                                                .otherUser.value.isuser !=
                                            1)
                                          const SizedBox(
                                            width: 8,
                                          ),
                                        if (_controller
                                                .otherUser.value.isuser !=
                                            1)
                                          Expanded(
                                            child: CustomExpandedButton(
                                              onTap: followMotion,
                                              isBlue: _controller
                                                              .otherUser
                                                              .value
                                                              .looped
                                                              .value ==
                                                          FollowState
                                                              .follower ||
                                                      _controller
                                                              .otherUser
                                                              .value
                                                              .looped
                                                              .value ==
                                                          FollowState.normal ||
                                                      _controller.otherUser
                                                              .value.banned ==
                                                          BanState.ban
                                                  ? true
                                                  : false,
                                              isBig: false,
                                              buttonTag: '팔로우',
                                              title: _controller.otherUser.value
                                                          .banned ==
                                                      BanState.ban
                                                  ? '차단 해제'
                                                  : _controller.otherUser.value
                                                              .looped.value ==
                                                          FollowState.normal
                                                      ? '팔로우하기'
                                                      : _controller
                                                                  .otherUser
                                                                  .value
                                                                  .looped
                                                                  .value ==
                                                              FollowState
                                                                  .follower
                                                          ? '나도 팔로우하기'
                                                          : _controller
                                                                      .otherUser
                                                                      .value
                                                                      .looped
                                                                      .value ==
                                                                  FollowState
                                                                      .following
                                                              ? '팔로잉 중'
                                                              : '팔로잉 중',
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      color: cardGray,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Row(
                                      children: [
                                        const Text('스카우터 컨택',
                                            style: kNavigationTitle),
                                        const SizedBox(width: 7),
                                        SvgPicture.asset(
                                          'assets/icons/Question.svg',
                                          width: 20,
                                          height: 20,
                                          color: mainblack.withOpacity(0.6),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                            onTap: () {
                                              AppController.to
                                                  .changePageIndex(3);
                                            },
                                            child: Text(
                                              '전체 보기(000개)',
                                              style: kBody1Style.copyWith(
                                                  color: mainblue),
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    SizedBox(
                                      height: 60,
                                      child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: mainblack
                                                        .withOpacity(0.1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              height: 60,
                                              width: 60,
                                              child: Image.network(
                                                'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
                                                height: 60,
                                                width: 60,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: mainblack
                                                        .withOpacity(0.1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              height: 60,
                                              width: 60,
                                              child: Image.network(
                                                'https://images.samsung.com/kdp/aboutsamsung/brand_identity/logo/360_197_1.png?\$FB_TYPE_B_PNG\$',
                                                height: 60,
                                                width: 60,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: mainblack
                                                        .withOpacity(0.1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              height: 60,
                                              width: 60,
                                              child: Image.network(
                                                'https://w7.pngwing.com/pngs/240/71/png-transparent-hyundai-motor-company-car-logo-berkeley-payments-hyundai-blue-cdr-text.png',
                                                height: 60,
                                                width: 60,
                                              ),
                                            ),
                                          ]),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Divider(
                                            thickness: 1, color: cardGray),
                                        const SizedBox(height: 24),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                        //   children: [
                                        //     const Text('커리어 분석', style: k18Semibold),
                                        //     const SizedBox(width: 7),
                                        //     SvgPicture.asset(
                                        //       'assets/icons/Question.svg',
                                        //       width: 20,
                                        //       height: 20,
                                        //       color: mainblack.withOpacity(0.6),
                                        //     )
                                        //   ],
                                        // ),
                                        // Column(
                                        //     children:
                                        //         profileController.careerAnalysis),
                                        // const SizedBox(height: 24),
                                        // const Divider(thickness: 1, color: cardGray),
                                        // const SizedBox(height: 24),
                                        Row(
                                          children: [
                                            const Text('커리어',
                                                style: kNavigationTitle),
                                            const SizedBox(width: 7),
                                            SvgPicture.asset(
                                              'assets/icons/Question.svg',
                                              width: 20,
                                              height: 20,
                                              color: mainblack.withOpacity(0.6),
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              onTap: () {
                                                Get.to(ProjectAddTitleScreen(
                                                    screenType:
                                                        Screentype.add));
                                              },
                                              child: Text(
                                                '추가하기',
                                                style: k15normal.copyWith(
                                                    color: mainblue),
                                              ),
                                              splashColor: kSplashColor,
                                            ),
                                          ],
                                        ),
                                        Obx(
                                          () => Column(
                                              children: _controller
                                                  .otherProjectList
                                                  .asMap()
                                                  .entries
                                                  .map((entry) {
                                            return GestureDetector(
                                              onTap: () {
                                                _controller.careerCurrentPage
                                                        .value =
                                                    entry.key.toDouble();
                                                _controller
                                                    .careertitleController
                                                    .jumpToPage(
                                                  entry.key,
                                                );
                                                _controller.careerPageController
                                                    .jumpToPage(
                                                  entry.key,
                                                );
                                              },
                                              child: CareerTile(
                                                index: entry.key,
                                                title:
                                                    entry.value.careerName.obs,
                                                time: entry.value.startDate!,
                                                currentPage: _controller
                                                    .careerCurrentPage,
                                              ),
                                            );
                                          }).toList()),
                                        ),
                                        const SizedBox(height: 24),
                                        const Divider(
                                            thickness: 1, color: cardGray),
                                        const SizedBox(height: 24),
                                        Row(
                                          children: [
                                            const Text('포스트',
                                                style: kNavigationTitle),
                                            const Spacer(),
                                            InkWell(
                                                onTap: () {
                                                  // Get.to(() =>
                                                  //     PostingAddImagesScreen(
                                                  //       project_id: profileController
                                                  //           .myProjectList[
                                                  //               profileController
                                                  //                   .careerCurrentPage
                                                  //                   .toInt()]
                                                  //           .id,
                                                  //       route:
                                                  //           PostaddRoute.project,
                                                  //     ));
                                                },
                                                child: Text(
                                                  '전체 보기(${_controller.otherUser.value.totalposting}개)',
                                                  style: kmain.copyWith(
                                                      color: mainblue),
                                                ))
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              _controller.otherProjectList.isEmpty
                                  ? EmptyContentWidget(text: '아직 커리어가 없어요')
                                  : Column(
                                      children: [
                                        Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: [
                                            AspectRatio(
                                              aspectRatio: 1.3,
                                              child: PieChart(
                                                PieChartData(
                                                    pieTouchData: PieTouchData(
                                                        touchCallback:
                                                            (FlTouchEvent event,
                                                                pieTouchResponse) {
                                                      // if (!event.isInterestedForInteractions ||
                                                      //     pieTouchResponse == null ||
                                                      //     pieTouchResponse.touchedSection ==
                                                      //         null) {
                                                      //   selectedIndex.value = -1;
                                                      //   return;
                                                      // }
                                                      // selectedIndex.value = pieTouchResponse
                                                      //     .touchedSection!.touchedSectionIndex;
                                                    }),
                                                    borderData: FlBorderData(
                                                      show: false,
                                                    ),
                                                    sectionsSpace: 0,
                                                    centerSpaceRadius: 80,
                                                    sections: _controller
                                                        .showingSections()),
                                                swapAnimationDuration:
                                                    Duration(milliseconds: 300),
                                              ),
                                            ),
                                            RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: 'IT',
                                                  style: kmain.copyWith(
                                                      color: mainblue),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '분야\n${_controller.otherUser.value.totalposting}개의 포스트\n전체 커리어 중 ${(_controller.otherProjectList[_controller.careerCurrentPage.toInt()].postRatio! * 100).toInt()}%',
                                                  style: kmain,
                                                ),
                                              ]),
                                            )
                                          ],
                                        ),
                                        Obx(
                                          () => Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24),
                                            height: 25,
                                            child: PageView.builder(
                                              controller: _controller
                                                  .careertitleController,
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index) {
                                                if (index.toDouble() !=
                                                    _controller
                                                        .careerCurrentPage
                                                        .value) {
                                                  _controller.careerCurrentPage
                                                      .value = index.toDouble();
                                                  _controller
                                                      .careerPageController
                                                      .animateToPage(index,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve: Curves.ease);
                                                }
                                              },
                                              itemBuilder: (context, index) {
                                                var _scale = _controller
                                                            .careerCurrentPage
                                                            .value
                                                            .toInt() ==
                                                        index
                                                    ? 1.0
                                                    : 0.8;
                                                var _color = _controller
                                                            .careerCurrentPage
                                                            .value
                                                            .toInt() ==
                                                        index
                                                    ? mainblack
                                                    : mainblack
                                                        .withOpacity(0.2);
                                                return TweenAnimationBuilder(
                                                  duration: const Duration(
                                                      milliseconds: 350),
                                                  tween: Tween(
                                                      begin: _scale,
                                                      end: _scale),
                                                  curve: Curves.ease,
                                                  child: Center(
                                                    child: Text(
                                                      _controller
                                                          .otherProjectList[
                                                              index]
                                                          .careerName,
                                                      style: kNavigationTitle
                                                          .copyWith(
                                                              color: _color),
                                                    ),
                                                  ),
                                                  builder: (context,
                                                      double value, child) {
                                                    return Transform.scale(
                                                      scale: value,
                                                      child: child,
                                                    );
                                                  },
                                                );
                                              },
                                              itemCount: _controller
                                                  .otherProjectList.length,
                                            ),
                                          ),
                                        ),
                                        // profileController.myProjectList.isEmpty
                                        //     ? Container(
                                        //         padding: const EdgeInsets.only(bottom: 20),
                                        //         alignment: Alignment.center,
                                        //         child: Text(
                                        //           '아직 커리어가 없어요',
                                        //           style: kBody1Style.copyWith(
                                        //               color: mainblack.withOpacity(0.6)),
                                        //         ),
                                        //       )
                                        //     :
                                        Obx(
                                          () => ScrollNoneffectWidget(
                                            child: ExpandablePageView.builder(
                                              onPageChanged: (index) {
                                                if (index.toDouble() !=
                                                    _controller
                                                        .careerCurrentPage
                                                        .value) {
                                                  _controller.careerCurrentPage
                                                      .value = index.toDouble();
                                                  _controller
                                                      .careertitleController
                                                      .animateToPage(index,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          curve: Curves.ease);
                                                }
                                              },
                                              controller: _controller
                                                  .careerPageController,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 24),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        '함께한 친구',
                                                        style:
                                                            k15normal.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    // profileController
                                                    //             .myProjectList[profileController.careerCurrentPage.to]
                                                    SizedBox(
                                                      height: 90,
                                                      child: _controller
                                                              .otherProjectList[
                                                                  index]
                                                              .members
                                                              .isEmpty
                                                          ? EmptyContentWidget(
                                                              text:
                                                                  '혼자서 진행한 커리어입니다')
                                                          : ListView.separated(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      24),
                                                              scrollDirection:
                                                                  Axis
                                                                      .horizontal,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                Project
                                                                    project =
                                                                    _controller
                                                                            .otherProjectList[
                                                                        index];
                                                                return Column(
                                                                  children: [
                                                                    ClipOval(
                                                                      child: Image
                                                                          .network(
                                                                        project.members[index].profileImage ??
                                                                            '',
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 6,
                                                                    ),
                                                                    Text(
                                                                      project
                                                                          .members[
                                                                              index]
                                                                          .realName,
                                                                      style: k15normal.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    )
                                                                  ],
                                                                );
                                                              },
                                                              separatorBuilder:
                                                                  (context,
                                                                      index) {
                                                                return const SizedBox(
                                                                  width: 8,
                                                                );
                                                              },
                                                              itemCount: _controller
                                                                  .otherProjectList[
                                                                      _controller
                                                                          .careerCurrentPage
                                                                          .value
                                                                          .toInt()]
                                                                  .members
                                                                  .length),
                                                    ),
                                                    Obx(
                                                      () => _controller
                                                              .careerLoading
                                                              .value
                                                          ? const LoadingWidget()
                                                          : _controller
                                                                  .otherProjectList[
                                                                      index]
                                                                  .posts
                                                                  .isNotEmpty
                                                              ? ListView
                                                                  .separated(
                                                                  primary:
                                                                      false,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          postindex) {
                                                                    return PostingWidget(
                                                                      item: _controller
                                                                          .otherProjectList[
                                                                              index]
                                                                          .posts[postindex],
                                                                      type: PostingWidgetType
                                                                          .profile,
                                                                    );
                                                                  },
                                                                  separatorBuilder:
                                                                      (context,
                                                                              postindex) =>
                                                                          DivideWidget(),
                                                                  itemCount: _controller
                                                                      .otherProjectList[
                                                                          index]
                                                                      .posts
                                                                      .length,
                                                                )
                                                              : EmptyContentWidget(
                                                                  text:
                                                                      '아직 포스팅이 없어요'),
                                                    ),
                                                  ],
                                                );
                                              },
                                              itemCount: _controller
                                                  .otherProjectList.length,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: GestureDetector(
                              //         onTap: () {},
                              //         child: Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //             vertical: 12.0,
                              //           ),
                              //           child: Column(
                              //             children: [
                              //               Text(
                              //                 '포스팅',
                              //                 style: kBody1Style,
                              //               ),
                              //               SizedBox(
                              //                 height: 8,
                              //               ),
                              //               Text(
                              //                 _controller.otherUser.value
                              //                     .totalposting
                              //                     .toString(),
                              //                 style: kSubTitle2Style,
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     Expanded(
                              //       child: GestureDetector(
                              //         behavior: HitTestBehavior.translucent,
                              //         onTapDown: (details) =>
                              //             _hoverController.isHover(true),
                              //         onTapCancel: () =>
                              //             _hoverController.isHover(false),
                              //         onTapUp: (details) =>
                              //             _hoverController.isHover(false),
                              //         onTap: () {
                              //           // _controller.isLoopPeopleLoading(true);
                              //           if (_controller
                              //                   .otherUser.value.banned ==
                              //               BanState.normal) {
                              //             Get.to(() => LoopPeopleScreen(
                              //                   userid: _controller
                              //                       .otherUser.value.userid,
                              //                   loopcount: _controller
                              //                       .otherUser
                              //                       .value
                              //                       .loopcount
                              //                       .value,
                              //                 ));
                              //           }
                              //         },
                              //         child: Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               vertical: 12.0),
                              //           child: Column(
                              //             children: [
                              //               Obx(
                              //                 () => Text(
                              //                   '팔로워',
                              //                   style: kBody1Style.copyWith(
                              //                       color: _hoverController
                              //                               .isHover.value
                              //                           ? mainblack
                              //                               .withOpacity(
                              //                                   0.6)
                              //                           : mainblack),
                              //                 ),
                              //               ),
                              //               SizedBox(
                              //                 height: 8,
                              //               ),
                              //               Obx(
                              //                 () => Text(
                              //                   _controller.otherUser.value
                              //                               .banned !=
                              //                           BanState.normal
                              //                       ? '0'
                              //                       : _controller.otherUser
                              //                           .value.loopcount
                              //                           .toString(),
                              //                   style: kSubTitle2Style.copyWith(
                              //                       color: _hoverController
                              //                               .isHover.value
                              //                           ? mainblack
                              //                               .withOpacity(
                              //                                   0.6)
                              //                           : mainblack),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          )),
                        ),
                      ),
      ),
    );
  }

  void changeProfileImage() async {
    File? image = await imageController.getcropImage(ImageType.profile);
    if (image != null) {
      User? user = await updateProfile(
          _controller.otherUser.value, image, null, ProfileUpdateType.image);
      if (user != null) {
        _controller.otherUser(user);
      }
    }
  }

  void changeDefaultImage() async {
    User? user = await updateProfile(
            _controller.otherUser.value, null, null, ProfileUpdateType.image)
        .then((user) {
      imageController.isProfileImagePickerLoading.value = false;
      if (user != null) {
        _controller.otherUser(user);
      }
    });
  }

  void followMotion() {
    if (_controller.otherUser.value.isuser == 1) {
      // KakaoShareManager()
      //     .isKakaotalkInstalled()
      //     .then((installed) {
      //   if (installed) {
      //     KakaoShareManager().shareMyCode();
      //   } else {
      //     // show alert
      //   }
      // });
    } else {
      if (_controller.otherUser.value.banned == BanState.ban) {
        userbancancel(userid);
      } else {
        if (_controller.otherUser.value.looped.value == FollowState.normal) {
          followController.islooped(1);
          _controller.otherUser.value.looped(FollowState.following);
        } else if (_controller.otherUser.value.looped.value ==
            FollowState.follower) {
          followController.islooped(1);

          _controller.otherUser.value.looped(FollowState.wefollow);

          // ProfileController.to.myUserInfo
          //         .value.loopcount -
          //     1;

        } else if (_controller.otherUser.value.looped.value ==
            FollowState.following) {
          followController.islooped(0);

          _controller.otherUser.value.looped(FollowState.normal);
        } else if (_controller.otherUser.value.looped.value ==
            FollowState.wefollow) {
          followController.islooped(0);

          _controller.otherUser.value.looped(FollowState.follower);
        }
      }
    }
  }
}
