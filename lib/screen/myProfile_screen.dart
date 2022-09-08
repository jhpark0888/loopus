import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
import 'package:loopus/screen/profile_image_change_screen.dart';
import 'package:loopus/screen/profile_tag_change_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/career_widget.dart';
import 'package:loopus/widget/careertile_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/empty_contents_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:underline_indicator/underline_indicator.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({Key? key}) : super(key: key);
  final ProfileController profileController = Get.put(ProfileController());
  // final ImageController imageController = Get.put(ImageController());
  final HoverController _hoverController = HoverController();
  TagController tagController = Get.put(TagController(tagtype: Tagtype.profile),
      tag: Tagtype.profile.toString());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // try {
          //   if (Platform.isAndroid &&
          //       (AppController.to.currentIndex.value == 4)) {
          //     AppController.to.currentIndex(0);
          //     return false;
          //   }
          // } catch (e) {
          //   print(e);
          // }

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
              '프로필',
              style: ktitle,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(() => BookmarkScreen());
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/bookmark_inactive.svg',
                    width: 28,
                  )),
              IconButton(
                onPressed: () {
                  Get.to(() => SettingScreen());
                },
                icon: SvgPicture.asset(
                  'assets/icons/setting.svg',
                  width: 28,
                ),
              ),
            ],
          ),
          body: SmartRefresher(
            physics: const ClampingScrollPhysics(),
            controller: profileController.profilerefreshController,
            enablePullDown: (profileController.myprofilescreenstate.value ==
                    ScreenState.loading)
                ? false
                : true,
            enablePullUp: profileController.profileenablepullup.value,
            header: const MyCustomHeader(),
            footer: const MyCustomFooter(),
            onRefresh: profileController.onRefresh,
            onLoading: profileController.onLoading,
            child: NestedScrollView(
              // physics: const ClampingScrollPhysics(),
              floatHeaderSlivers: false,
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Obx(
                                  () => Text(
                                    profileController
                                        .myUserInfo.value.followerCount.value
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
                            const SizedBox(
                              width: 24,
                            ),
                            Stack(
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
                                        imageUrl: profileController.myUserInfo
                                                .value.profileImage ??
                                            '',
                                        width: 90,
                                        height: 90,
                                      )),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () => showModalIOS(context,
                                          func1: changeProfileImage,
                                          func2: changeDefaultImage,
                                          value1: '라이브러리에서 선택',
                                          value2: '기본 이미지로 변경',
                                          isValue1Red: false,
                                          isValue2Red: false,
                                          isOne: false),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: mainWhite),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    profileController
                                        .myUserInfo.value.followingCount.value
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
                          ],
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Obx(
                          () => Text(
                            profileController.myUserInfo.value.realName,
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
                                    imageUrl: profileController
                                        .myUserInfo.value.univlogo,
                                    width: 24,
                                    height: 24),
                                const SizedBox(width: 7),
                                Text(
                                  profileController.myUserInfo.value.univName,
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
                                  profileController.myUserInfo.value.department,
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
                      ],
                    ),
                  ),
                  SliverAppBar(
                    backgroundColor: mainWhite,
                    toolbarHeight: 44,
                    pinned: true,
                    primary: false,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    flexibleSpace: Column(
                      children: [
                        TabBar(
                            controller: profileController.tabController,
                            labelStyle: kmainbold,
                            labelColor: mainblack,
                            unselectedLabelStyle:
                                kmainbold.copyWith(color: dividegray),
                            unselectedLabelColor: dividegray,
                            automaticIndicatorColorAdjustment: false,
                            indicator: const UnderlineIndicator(
                              strokeCap: StrokeCap.round,
                              borderSide:
                                  BorderSide(width: 2, color: mainblack),
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
                                  child:
                                      profileController.currentIndex.value == 0
                                          ? SvgPicture.asset(
                                              'assets/icons/list_active.svg')
                                          : SvgPicture.asset(
                                              'assets/icons/list_inactive.svg'),
                                ),
                              ),
                              Obx(
                                () => Tab(
                                  height: 40,
                                  child:
                                      profileController.currentIndex.value == 1
                                          ? SvgPicture.asset(
                                              'assets/icons/post_active.svg')
                                          : SvgPicture.asset(
                                              'assets/icons/post_inactive.svg'),
                                ),
                              ),
                            ]),
                        Divider(
                          height: 1,
                          thickness: 2,
                          color: dividegray,
                        )
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: profileController.tabController,
                children: [_careerView(), _postView()],
              ),
            ),
          ),
        ));
  }

  void changeProfileImage() async {
    Get.to(() => ProfileImageChangeScreen());
  }

  void changeDefaultImage() async {
    await updateProfile(profileController.myUserInfo.value, null, null,
            ProfileUpdateType.image)
        .then((value) {
      if (value.isError == false) {
        User user = User.fromJson(value.data);
        profileController.myUserInfo(user);
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

  Widget _careerView() {
    return Obx(() => profileController.myProjectList.isEmpty
        ? EmptyContentWidget(text: '아직 커리어가 없어요')
        : SingleChildScrollView(
            key: const PageStorageKey("careerView"),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    field:
                        fieldList[profileController.myUserInfo.value.fieldId]!,
                    groupRatio: profileController.myUserInfo.value.groupRatio,
                    schoolRatio: profileController.myUserInfo.value.schoolRatio,
                    lastgroupRatio: 0.1,
                    lastschoolRatio: 0.1,
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
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "수정하기",
                          style: kmain.copyWith(color: mainblue),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 14),
                  ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Hero(
                      tag: profileController.myProjectList[index].id.toString(),
                      child: CareerWidget(
                          career: profileController.myProjectList[index]),
                    ),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 14,
                    ),
                    itemCount: profileController.myProjectList.length,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ));
  }

  Widget _postView() {
    return Obx(() => profileController.myProjectList.isEmpty
        ? EmptyContentWidget(text: '아직 포스팅이 없어요')
        : ListView.separated(
            key: const PageStorageKey("postView"),
            itemBuilder: (context, index) => PostingWidget(
                item: profileController.allPostList[index],
                type: PostingWidgetType.profile),
            separatorBuilder: (context, index) => DivideWidget(),
            itemCount: profileController.allPostList.length));
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

class CareerAnalysisWidget extends StatelessWidget {
  CareerAnalysisWidget(
      {Key? key,
      required this.field,
      required this.groupRatio,
      required this.schoolRatio,
      this.lastgroupRatio = 0.0,
      this.lastschoolRatio = 0.0})
      : super(key: key);

  String field;
  double groupRatio;
  double lastgroupRatio;
  double schoolRatio;
  double lastschoolRatio;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
              text: TextSpan(children: [
            TextSpan(text: field, style: kmain.copyWith(color: mainblue)),
            const TextSpan(text: ' 분야', style: kmain)
          ])),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('전국 ${(groupRatio * 100).toInt()}%', style: kmain),
              rate(((groupRatio - lastgroupRatio) * 100).toInt()),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('교내 ${(schoolRatio * 100).toInt()}%', style: kmain),
              rate(((schoolRatio - lastschoolRatio) * 100).toInt()),
            ],
          ),
        )
      ],
    );
  }

  Widget rate(int variance) {
    return Row(children: [
      arrowDirection(variance),
      const SizedBox(width: 3),
      if (variance != 0)
        Text('${variance.abs()}%',
            style:
                kcaption.copyWith(color: variance >= 1 ? rankred : mainblue)),
      const SizedBox(width: 8)
    ]);
  }

  Widget arrowDirection(int variance) {
    if (variance == 0) {
      return const SizedBox.shrink();
    } else if (variance >= 1) {
      return SvgPicture.asset('assets/icons/rate_upper_arrow.svg');
    } else {
      return SvgPicture.asset('assets/icons/rate_down_arrow.svg');
    }
  }
}
