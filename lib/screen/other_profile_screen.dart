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
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/group_career_detail_screen.dart';
import 'package:loopus/screen/career_arrange_screen.dart';
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

class OtherProfileScreen extends StatelessWidget {
  OtherProfileScreen(
      {Key? key,
      this.user,
      required this.userid,
      required this.realname,
      this.careerName})
      : super(key: key);
  String? careerName;
  late final OtherProfileController _controller = Get.put(
      OtherProfileController(
          userid: userid,
          otherUser: user != null ? user!.obs : User.defaultuser().obs,
          careerName: careerName),
      tag: userid.toString());

  // final ImageController imageController = Get.put(ImageController());
  final HoverController _hoverController = HoverController();

  User? user;
  int userid;
  String realname;

  final Debouncer _debouncer = Debouncer();

  final sr.RefreshController _otherprofilerefreshController =
      sr.RefreshController(initialRefresh: false);
  final sr.RefreshController _otherpostLoadingController =
      sr.RefreshController(initialRefresh: false);

  Future onRefresh() async {
    _controller.profileenablepullup.value = true;
    _controller.postPageNum = 1;
    _controller.allPostList.clear();
    _controller.loadotherProfile(userid);
    _otherprofilerefreshController.refreshCompleted();
  }

  void onLoading() async {
    // await Future.delayed(Duration(seconds: 2));
    int statusCode = await _controller.getOtherPosting(userid);
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
        appBar: AppBarWidget(
          title: '$realname님의 프로필',
          actions: [
            Obx(
              () => _controller.otherprofilescreenstate.value !=
                      ScreenState.success
                  ? Container()
                  : _controller.otherUser.value.isuser == 1
                      ? IconButton(
                          onPressed: () {
                            Get.to(() => SettingScreen());
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/setting.svg',
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
                                      userreport(_controller.userid)
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

                                          showCustomDialog(
                                              "해당 유저가 차단 되었습니다", 1000);
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
                            'assets/icons/more_option.svg',
                          ),
                        ),
            ),
          ],
          bottomBorder: false,
        ),
        body: RefreshIndicator(
          notificationPredicate: (notification) {
            return notification.depth == 2;
          },

          // controller: profileController.profilerefreshController,
          // enablePullDown: true,
          // header: const MyCustomHeader(),
          onRefresh: onRefresh,
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
              physics: const NeverScrollableScrollPhysics(),
              children: [_careerView(context), _postView()],
            ),
          ),
        ),
      ),
    );
  }

  void changeProfileImage() async {
    Get.to(() => ProfileImageChangeScreen());
  }

  void changeDefaultImage() async {
    await updateProfile(
            _controller.otherUser.value, null, null, ProfileUpdateType.image)
        .then((value) {
      if (value.isError == false) {
        User user = User.fromJson(value.data);
        _controller.otherUser(user);
        HomeController.to.myProfile(user);
        if (Get.isRegistered<OtherProfileController>(
            tag: user.userid.toString())) {
          Get.find<OtherProfileController>(tag: user.userid.toString())
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
                      userId: userid,
                      listType: followlist.follower,
                    ));
              },
              behavior: HitTestBehavior.translucent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Obx(
                    () => Text(
                      _controller.otherUser.value.followerCount.toString(),
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
                      onTap: () {
                        if (_controller.otherUser.value.isuser == 1) {
                          showBottomdialog(context,
                              func1: changeProfileImage,
                              func2: changeDefaultImage,
                              value1: '사진첩에서 사진 선택',
                              value2: '기본 이미지로 변경',
                              isOne: false);
                        }
                      },
                      child: UserImageWidget(
                        imageUrl:
                            _controller.otherUser.value.profileImage ?? '',
                        width: 90,
                        height: 90,
                      )),
                ),
                if (_controller.otherUser.value.isuser == 1)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () => showBottomdialog(context,
                            func1: changeProfileImage,
                            func2: changeDefaultImage,
                            value1: '사진첩에서 사진 선택',
                            value2: '기본 이미지로 변경',
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
                      userId: userid,
                      listType: followlist.following,
                    ));
              },
              behavior: HitTestBehavior.translucent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      _controller.otherUser.value.followingCount.toString(),
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
            _controller.otherUser.value.realName,
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
                    imageUrl: _controller.otherUser.value.univlogo,
                    width: 24,
                    height: 24),
                const SizedBox(width: 7),
                Text(
                  _controller.otherUser.value.univName,
                  style: kmain,
                ),
                const SizedBox(
                  height: 12,
                  child: VerticalDivider(
                    thickness: 1,
                    width: 14,
                    color: mainblack,
                  ),
                ),
                Text(
                  _controller.otherUser.value.department,
                  style: kmain,
                ),
                const SizedBox(
                  height: 12,
                  child: VerticalDivider(
                    thickness: 1,
                    width: 14,
                    color: mainblack,
                  ),
                ),
                Text(
                  "${_controller.otherUser.value.admissionYear.substring(2)}년도 입학",
                  style: kmain,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
        if (_controller.otherUser.value.isuser != 1)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomExpandedBoldButton(
                        onTap: followMotion,
                        isBlue: _controller.otherUser.value.looped.value ==
                                    FollowState.follower ||
                                _controller.otherUser.value.looped.value ==
                                    FollowState.normal ||
                                _controller.otherUser.value.banned ==
                                    BanState.ban
                            ? true
                            : false,
                        title: _controller.otherUser.value.banned ==
                                BanState.ban
                            ? '차단 해제'
                            : _controller.otherUser.value.looped.value ==
                                    FollowState.normal
                                ? '팔로우'
                                : _controller.otherUser.value.looped.value ==
                                        FollowState.follower
                                    ? '나도 팔로우하기'
                                    : _controller
                                                .otherUser.value.looped.value ==
                                            FollowState.following
                                        ? '팔로우 중'
                                        : '팔로우 중',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: CustomExpandedBoldButton(
                        onTap: () async {
                          if (HomeController.to.enterMessageRoom.value ==
                              _controller.otherUser.value.userid) {
                            Get.back();
                          } else {
                            Get.to(() => MessageDetatilScreen(
                                  partner: _controller.otherUser.value,
                                  myProfile: HomeController.to.myProfile.value,
                                  enterRoute: EnterRoute.otherProfile,
                                ));
                            HomeController.to.enterMessageRoom.value =
                                _controller.otherUser.value.userid;
                          }
                        },
                        isBlue: false,
                        title: '메시지',
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

  Widget _tabView() {
    return Column(
      children: [
        TabBar(
            labelStyle: kmainbold,
            labelColor: mainblack,
            unselectedLabelStyle: kmainbold.copyWith(color: dividegray),
            unselectedLabelColor: dividegray,
            automaticIndicatorColorAdjustment: false,
            indicator: const UnderlineIndicator(
              strokeCap: StrokeCap.round,
              borderSide: BorderSide(width: 2, color: mainblack),
            ),
            onTap: (index) {
              _controller.currentIndex(index);
            },
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
                  child: SvgPicture.asset(
                    'assets/icons/list_active.svg',
                    color:
                        _controller.currentIndex.value == 0 ? null : dividegray,
                  ),
                ),
              ),
              Obx(
                () => Tab(
                  height: 40,
                  child: SvgPicture.asset(
                    'assets/icons/post_active.svg',
                    color:
                        _controller.currentIndex.value == 1 ? null : dividegray,
                  ),
                ),
              ),
            ]),
        Divider(
          height: 1,
          thickness: 2,
          color: dividegray,
        )
      ],
    );
  }

  Widget _careerView(BuildContext context) {
    return SafeArea(
      child: Obx(() => _controller.otherProjectList.isEmpty
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('커리어 분석', style: kmainbold),
                                const SizedBox(width: 7),
                                SvgPicture.asset(
                                  'assets/icons/information.svg',
                                  width: 20,
                                  height: 20,
                                  color: mainblack.withOpacity(0.6),
                                )
                              ],
                            ),
                            const SizedBox(height: 14),
                            CareerAnalysisWidget(
                              field: fieldList[
                                  _controller.otherUser.value.fieldId]!,
                              groupRatio:
                                  _controller.otherUser.value.groupRatio,
                              schoolRatio:
                                  _controller.otherUser.value.schoolRatio,
                              lastgroupRatio:
                                  _controller.otherUser.value.groupRatio +
                                      _controller
                                          .otherUser.value.groupRatioVariance,
                              lastschoolRatio:
                                  _controller.otherUser.value.schoolRatio +
                                      _controller
                                          .otherUser.value.schoolRatioVariance,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('커리어', style: kmainbold),
                                const SizedBox(width: 7),
                                SvgPicture.asset(
                                  'assets/icons/information.svg',
                                  width: 20,
                                  height: 20,
                                  color: mainblack.withOpacity(0.6),
                                ),
                                const Spacer(),
                                if (_controller.otherUser.value.userid ==
                                    HomeController.to.myProfile.value.userid)
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => CareerArrangeScreen());
                                    },
                                    child: Text(
                                      "정렬 수정",
                                      style: kmain.copyWith(color: mainblue),
                                    ),
                                  )
                              ],
                            ),
                            const SizedBox(height: 14),
                            ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  goCareerScreen(
                                      _controller.otherProjectList[index],
                                      _controller.otherUser.value.realName);
                                },
                                child: CareerWidget(
                                    career:
                                        _controller.otherProjectList[index]),
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 14,
                              ),
                              itemCount: _controller.otherProjectList.length,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            )),
    );
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

  // Widget _tagView() {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Text(
  //             '상위 태그',
  //             style: kmain.copyWith(color: maingray),
  //           ),
  //           const SizedBox(
  //             width: 7,
  //           ),
  //           Obx(
  //             () => Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: _controller.otherUser.value.profileTag
  //                     .map((tag) => Row(children: [
  //                           Tagwidget(
  //                             tag: tag,
  //                           ),
  //                           _controller.otherUser.value.profileTag
  //                                       .indexOf(tag) !=
  //                                   _controller.otherUser.value
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
  //                     in _controller.otherUser.value.profileTag) {
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
  //               title: '관심 태그 변경하기',
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

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
          // followController.islooped(1);
          _controller.otherUser.value.looped(FollowState.following);
          _controller.otherUser.value.followerCount.value += 1;
        } else if (_controller.otherUser.value.looped.value ==
            FollowState.follower) {
          // followController.islooped(1);

          _controller.otherUser.value.looped(FollowState.wefollow);
          _controller.otherUser.value.followerCount.value += 1;
        } else if (_controller.otherUser.value.looped.value ==
            FollowState.following) {
          // followController.islooped(0);

          _controller.otherUser.value.looped(FollowState.normal);
          _controller.otherUser.value.followerCount.value -= 1;
        } else if (_controller.otherUser.value.looped.value ==
            FollowState.wefollow) {
          // followController.islooped(0);

          _controller.otherUser.value.looped(FollowState.follower);
          _controller.otherUser.value.followerCount.value -= 1;
        }

        _debouncer.run(() {
          if (_controller.otherUser.value.looped.value.index !=
              _controller.lastisFollowed) {
            if (<int>[2, 3]
                .contains(_controller.otherUser.value.looped.value.index)) {
              postfollowRequest(userid);
              print("팔로우");
            } else {
              deletefollow(userid);
              print("팔로우 해제");
            }
            _controller.lastisFollowed =
                _controller.otherUser.value.looped.value.index;
          } else {
            print("아무일도 안 일어남");
          }
        });
      }
    }
  }
}
