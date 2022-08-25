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
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({Key? key}) : super(key: key);
  final ProfileController profileController = Get.put(ProfileController());
  // final ImageController imageController = Get.put(ImageController());
  final HoverController _hoverController = HoverController();
  TagController tagController = Get.put(TagController(tagtype: Tagtype.profile),
      tag: Tagtype.profile.toString());

  RxBool isLoop = false.obs;

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
            centerTitle: false,
            title: const Text(
              '프로필',
              style: kNavigationTitle,
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
          body: Obx(
            () => SmartRefresher(
              physics: const BouncingScrollPhysics(),
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
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Obx(
                                      () => Text(
                                        profileController.myUserInfo.value
                                            .followerCount.value
                                            .toString(),
                                        style: kmainbold.copyWith(
                                            color:
                                                _hoverController.isHover.value
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
                                            imageUrl: profileController
                                                    .myUserInfo
                                                    .value
                                                    .profileImage ??
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
                                        profileController.myUserInfo.value
                                            .followingCount.value
                                            .toString(),
                                        style: kmainbold.copyWith(
                                            color:
                                                _hoverController.isHover.value
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
                                        width: 28,
                                        height: 28),
                                    const SizedBox(width: 14),
                                    Text(
                                      profileController
                                          .myUserInfo.value.univName,
                                      style: kmainbold,
                                    ),
                                    const SizedBox(
                                      height: 14,
                                      child: VerticalDivider(
                                        thickness: 1,
                                        width: 28,
                                        color: mainblack,
                                      ),
                                    ),
                                    Text(
                                      profileController
                                          .myUserInfo.value.department,
                                      style: kmainbold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: profileController
                                          .myUserInfo.value.profileTag
                                          .map((tag) => Row(children: [
                                                Tagwidget(
                                                  tag: tag,
                                                ),
                                                profileController.myUserInfo
                                                            .value.profileTag
                                                            .indexOf(tag) !=
                                                        profileController
                                                                .myUserInfo
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
                                      tagController.tagsearchContoller.text =
                                          "";
                                      for (var tag in profileController
                                          .myUserInfo.value.profileTag) {
                                        tagController.selectedtaglist
                                            .add(SelectedTagWidget(
                                          id: tag.tagId,
                                          text: tag.tag,
                                          selecttagtype:
                                              SelectTagtype.interesting,
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
                                const Text('스카우터 컨택', style: kNavigationTitle),
                                const SizedBox(width: 7),
                                SvgPicture.asset(
                                  'assets/icons/information.svg',
                                  width: 16,
                                  height: 16,
                                ),
                                const Spacer(),
                                InkWell(
                                    onTap: () {
                                      AppController.to.changeBottomNav(3);
                                    },
                                    child: Text(
                                      '전체 보기(000개)',
                                      style: kmain.copyWith(color: mainblue),
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
                                            color: mainblack.withOpacity(0.1),
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
                                            color: mainblack.withOpacity(0.1),
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
                                            color: mainblack.withOpacity(0.1),
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Divider(thickness: 1, color: cardGray),
                                const SizedBox(height: 24),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     const Text('커리어 분석', style: k18Semibold),
                                //     const SizedBox(width: 7),
                                //     SvgPicture.asset(
                                //       'assets/icons/information.svg',
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
                                    const Text('커리어', style: kNavigationTitle),
                                    const SizedBox(width: 7),
                                    SvgPicture.asset(
                                      'assets/icons/information.svg',
                                      width: 16,
                                      height: 16,
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Get.to(ProjectAddTitleScreen(
                                            screenType: Screentype.add));
                                      },
                                      child: Text(
                                        '추가하기',
                                        style: kmain.copyWith(color: mainblue),
                                      ),
                                      splashColor: kSplashColor,
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => profileController.myProjectList.isEmpty
                                      ? EmptyContentWidget(text: '아직 커리어가 없어요')
                                      : Column(
                                          children: profileController
                                              .myProjectList
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                          return GestureDetector(
                                            onTap: () {
                                              profileController
                                                  .careerCurrentPage
                                                  .value = entry.key.toDouble();
                                              profileController
                                                  .careertitleController
                                                  .jumpToPage(
                                                entry.key,
                                                // duration: const Duration(milliseconds: 300), curve: Curves.ease
                                              );
                                              profileController
                                                  .careerPageController
                                                  .jumpToPage(
                                                entry.key,
                                                // duration: const Duration(milliseconds: 300), curve: Curves.ease
                                              );
                                            },
                                            child: CareerTile(
                                                index: entry.key,
                                                currentPage: profileController
                                                    .careerCurrentPage,
                                                title:
                                                    entry.value.careerName.obs,
                                                time: entry.value.startDate!),
                                          );
                                        }).toList()),
                                ),
                                const SizedBox(height: 24),
                                const Divider(thickness: 1, color: cardGray),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    const Text('포스트', style: kNavigationTitle),
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
                                          '전체 보기(${profileController.myUserInfo.value.totalposting}개)',
                                          style:
                                              kmain.copyWith(color: mainblue),
                                        ))
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      profileController.myProjectList.isEmpty
                          ? EmptyContentWidget(text: '아직 커리어가 없어요')
                          : Column(
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.center,
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
                                            centerSpaceRadius: 100,
                                            sections: profileController
                                                .showingSections()),
                                        swapAnimationDuration:
                                            Duration(milliseconds: 300),
                                      ),
                                    ),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              '${fieldList[profileController.myProjectList[profileController.careerCurrentPage.toInt()].fieldIds.first]}',
                                          style:
                                              kmain.copyWith(color: mainblue),
                                        ),
                                        TextSpan(
                                          text:
                                              '분야\n${profileController.myUserInfo.value.totalposting}개의 포스트\n전체 커리어 중 ${(profileController.myProjectList[profileController.careerCurrentPage.toInt()].postRatio! * 100).toInt()}%',
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
                                      controller: profileController
                                          .careertitleController,
                                      scrollDirection: Axis.horizontal,
                                      onPageChanged: (index) {
                                        if (index.toDouble() !=
                                            profileController
                                                .careerCurrentPage.value) {
                                          profileController.careerCurrentPage
                                              .value = index.toDouble();
                                          profileController.careerPageController
                                              .animateToPage(index,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease);
                                        }
                                      },
                                      itemBuilder: (context, index) {
                                        var _scale = profileController
                                                    .careerCurrentPage.value
                                                    .toInt() ==
                                                index
                                            ? 1.0
                                            : 0.8;
                                        var _color = profileController
                                                    .careerCurrentPage.value
                                                    .toInt() ==
                                                index
                                            ? mainblack
                                            : mainblack.withOpacity(0.2);
                                        return TweenAnimationBuilder(
                                          duration:
                                              const Duration(milliseconds: 350),
                                          tween:
                                              Tween(begin: _scale, end: _scale),
                                          curve: Curves.ease,
                                          child: Center(
                                            child: Text(
                                              profileController
                                                  .myProjectList[index]
                                                  .careerName,
                                              style: kNavigationTitle.copyWith(
                                                  color: _color),
                                            ),
                                          ),
                                          builder:
                                              (context, double value, child) {
                                            return Transform.scale(
                                              scale: value,
                                              child: child,
                                            );
                                          },
                                        );
                                      },
                                      itemCount: profileController
                                          .myProjectList.length,
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
                                            profileController
                                                .careerCurrentPage.value) {
                                          profileController.careerCurrentPage
                                              .value = index.toDouble();
                                          profileController
                                              .careertitleController
                                              .animateToPage(index,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease);
                                        }
                                      },
                                      controller: profileController
                                          .careerPageController,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                '함께한 친구',
                                                style: ktempFont.copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            // profileController
                                            //             .myProjectList[profileController.careerCurrentPage.to]
                                            SizedBox(
                                              height: 90,
                                              child: profileController
                                                      .myProjectList[index]
                                                      .members
                                                      .isEmpty
                                                  ? EmptyContentWidget(
                                                      text: '혼자서 진행한 커리어입니다')
                                                  : ListView.separated(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 24),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
                                                        Project project =
                                                            profileController
                                                                    .myProjectList[
                                                                index];
                                                        return Column(
                                                          children: [
                                                            ClipOval(
                                                              child:
                                                                  Image.network(
                                                                project
                                                                        .members[
                                                                            index]
                                                                        .profileImage ??
                                                                    '',
                                                                width: 50,
                                                                height: 50,
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
                                                              style: ktempFont.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            )
                                                          ],
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return const SizedBox(
                                                          width: 8,
                                                        );
                                                      },
                                                      itemCount: profileController
                                                          .myProjectList[
                                                              profileController
                                                                  .careerCurrentPage
                                                                  .value
                                                                  .toInt()]
                                                          .members
                                                          .length),
                                            ),
                                            Obx(
                                              () => profileController
                                                      .careerLoading.value
                                                  ? const LoadingWidget()
                                                  : profileController
                                                          .myProjectList[index]
                                                          .posts
                                                          .isNotEmpty
                                                      ? ListView.separated(
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          itemBuilder: (context,
                                                              postindex) {
                                                            return PostingWidget(
                                                              item: profileController
                                                                  .myProjectList[
                                                                      index]
                                                                  .posts[postindex],
                                                              type:
                                                                  PostingWidgetType
                                                                      .profile,
                                                            );
                                                          },
                                                          separatorBuilder:
                                                              (context,
                                                                      postindex) =>
                                                                  DivideWidget(),
                                                          itemCount:
                                                              profileController
                                                                  .myProjectList[
                                                                      index]
                                                                  .posts
                                                                  .length,
                                                        )
                                                      : EmptyContentWidget(
                                                          text: '아직 포스팅이 없어요'),
                                            ),
                                          ],
                                        );
                                      },
                                      itemCount: profileController
                                          .myProjectList.length,
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  )),
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
}
