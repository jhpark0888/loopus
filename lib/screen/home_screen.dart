import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/issue_model.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/screen/spec_screen.dart';
import 'package:loopus/screen/myProfile_screen.dart';
import 'package:loopus/screen/mycompany_screen.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/signup_tutorial_screen.dart';
import 'package:loopus/utils/custom_linkpreview.dart';
// import 'package:loopus/screen/post_add_test.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/news_widget.dart';
import 'package:loopus/widget/posting_widget.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/scroll_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/screen/message_screen.dart';
import 'package:loopus/screen/notification_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

class HomeScreen extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  // final SearchController _searchController = Get.put(SearchController());
  // final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    _homeController.scrollController = PrimaryScrollController.of(context)!.obs;
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.mainWhite,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          toolbarHeight: 58,
          elevation: 0,
          titleSpacing: 20,
          title: GestureDetector(
            onTap: () async {
              _homeController.scrollController.value.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear);
            },
            child: SvgPicture.asset(
              'assets/icons/home_logo_letter.svg',
            ),
          ),
          actions: [
            // IconButton(
            //   onPressed: () => Get.to(() => SearchScreen()),
            //   icon: SvgPicture.asset(
            //     "assets/icons/Search.svg",
            //     width: 28,
            //     height: 28,
            //   ),
            // ),
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      // ProfileController.to.isnewalarm(false);
                      // Get.to(() => DatabaseList());
                      // Get.to(() => NotificationScreen());
                      Get.to(() => SpecScreen());
                    },
                    child: Obx(
                      () => SvgPicture.asset(
                        HomeController.to.isNewAlarm.value == true
                            ? "assets/icons/alarm_active.svg"
                            : "assets/icons/alarm_inactive.svg",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => MessageScreen());
                    },
                    child: Obx(
                      () => SvgPicture.asset(
                        HomeController.to.isNewMsg.value == true
                            ? "assets/icons/message_active.svg"
                            : "assets/icons/message_inactive.svg",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Obx(() => HomeController.to.isNewMsg.value == true
                          ? Container(
                              height: 8,
                              width: 8,
                              decoration: const BoxDecoration(
                                  color: AppColors.rankred,
                                  shape: BoxShape.circle),
                            )
                          : Container()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Center(
              child: GestureDetector(
                onTap: () => _homeController.goMyProfile(),
                child: Obx(
                  () => UserImageWidget(
                    imageUrl: HomeController.to.myProfile.value.profileImage
                    // ProfileController.to.myUserInfo.value.profileImage ??
                    ,
                    width: 36,
                    height: 36,
                    userType: HomeController.to.myProfile.value.userType,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        body: Obx(
          () => _homeController.homeScreenState.value == ScreenState.loading
              ? const Center(child: LoadingWidget())
              : _homeController.homeScreenState.value == ScreenState.disconnect
                  ? DisconnectReloadWidget(reload: () {
                      _homeController.getUserProfile();
                      _homeController.onPostingRefresh();
                    })
                  : _homeController.homeScreenState.value == ScreenState.error
                      ? ErrorReloadWidget(reload: () {
                          _homeController.getUserProfile();
                          _homeController.onPostingRefresh();
                        })
                      : ScrollNoneffectWidget(
                          child: SmartRefresher(
                            primary: false,
                            physics: const BouncingScrollPhysics(),
                            scrollController:
                                _homeController.scrollController.value,
                            controller:
                                _homeController.postingRefreshController,
                            enablePullDown: true,
                            enablePullUp:
                                _homeController.enablePostingPullup.value,
                            header: MyCustomHeader(),
                            footer: const MyCustomFooter(),
                            onRefresh: _homeController.onPostingRefresh,
                            onLoading: _homeController.onPostingLoading,
                            child: SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  children: [
                                    _homeController.recommendCareer != null
                                        ? GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              Get.to(() => PostingAddScreen(
                                                  project_id: _homeController
                                                      .recommendCareer!.id,
                                                  route: PostaddRoute.project));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    '\'${_homeController.recommendCareer!.careerName}\'\n???????????? ?????? ?????? ?????? ?????????????',
                                                    style:
                                                        MyTextTheme.mainheight(
                                                            context),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '???????????? ?????? ????????? ?????????',
                                                    style: MyTextTheme.main(
                                                            context)
                                                        .copyWith(
                                                            color: AppColors
                                                                .maingray),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Divider(
                                                      height: 1,
                                                      thickness: 1,
                                                      color:
                                                          AppColors.maingray),
                                                ],
                                              ),
                                            ),
                                          )
                                        : GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              Get.to(() =>
                                                  ProjectAddTitleScreen(
                                                    screenType: Screentype.add,
                                                  ));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    '?????? ???????????? ????????? ????????? ???????????? ??????????????????!',
                                                    style:
                                                        MyTextTheme.mainheight(
                                                            context),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    '???????????? ?????? ????????? ?????????',
                                                    style: MyTextTheme.main(
                                                            context)
                                                        .copyWith(
                                                            color: AppColors
                                                                .maingray),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Divider(
                                                      height: 1,
                                                      thickness: 1,
                                                      color:
                                                          AppColors.maingray),
                                                ],
                                              ),
                                            ),
                                          ),
                                    Obx(
                                      () => ListView.builder(
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          if (_homeController.contents[index]
                                              is Post) {
                                            return PostingWidget(
                                              item: _homeController
                                                  .contents[index],
                                              type: PostingWidgetType.normal,
                                            );
                                          } else if (_homeController
                                                  .contents[index]
                                              is RxList<Issue>) {
                                            return Obx(
                                              () => NewsListWidget(
                                                  issueList: _homeController
                                                      .contents[index]),
                                            );
                                          } else {
                                            return Text(
                                              '??????',
                                              style:
                                                  MyTextTheme.mainbold(context),
                                            );
                                          }
                                        },
                                        itemCount:
                                            _homeController.contents.length,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
        ));
  }

  Widget homeSearchBar(SearchController _searchController) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {
          // _searchController.clearSearchedList();
          Get.toNamed('/search');
          print('search posting list : ${_searchController.searchPostList}');
          print('search profile list : ${_searchController.searchUserList}');

          // print(
          //     'search question list : ${_searchController.searchquestionlist}');

          print('search tag list : ${_searchController.searchTagList}');
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightcardgray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/search_inactive.svg',
                      width: 16,
                      height: 16,
                      color: AppColors.mainblack.withOpacity(0.6),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "?????? ????????? ????????????????",
                      style: TextStyle(
                        color: AppColors.mainblack.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget activatedOfficialAccount() {
  //   return SliverToBoxAdapter(
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 16,
  //             vertical: 12,
  //           ),
  //           child: Row(
  //             children: [
  //               Text(
  //                 "???????????? ?????? ??????",
  //                 style: kButtonStyle.copyWith(
  //                   color: AppColors.mainblack.withOpacity(0.6),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 4,
  //               ),
  //               GestureDetector(
  //                 onTap: () =>
  //                     showCustomDialog('?????? ??? ??? ?????? ?????? ???????????? ????????? ?????????????????? ', 1400),
  //                 child: SvgPicture.asset(
  //                   'assets/icons/information.svg',
  //                   width: 20,
  //                   height: 20,
  //                   color: AppColors.mainblack.withOpacity(0.6),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(
  //             bottom: 8,
  //           ),
  //           child: SingleChildScrollView(
  //             scrollDirection: Axis.horizontal,
  //             child: Row(
  //               mainAxisSize: MainAxisSize.max,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () => showCustomDialog(
  //                     '?????? ?????????????????? ????????? ?????? ?????? ????????? (?????? ???????????? ??????)',
  //                     1400,
  //                   ),
  //                   child: Container(
  //                     margin: EdgeInsets.only(
  //                       left: 16,
  //                     ),
  //                     padding: EdgeInsets.symmetric(
  //                       vertical: 8,
  //                       horizontal: 12,
  //                     ),
  //                     decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Color(0xffe7e7e7),
  //                           width: 1,
  //                         ),
  //                         borderRadius: BorderRadius.circular(8)),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(16),
  //                             border: Border.all(
  //                               width: 1,
  //                               color: Color(0xffe7e7e7),
  //                             ),
  //                           ),
  //                           child: ClipOval(
  //                             child: CachedNetworkImage(
  //                               width: 32,
  //                               height: 32,
  //                               imageUrl:
  //                                   "http://www.lg.co.kr/images/common/default_og_image_new.jpg",
  //                               placeholder: (context, url) => CircleAvatar(
  //                                 backgroundColor: Color(0xffe7e7e7),
  //                                 child: Container(),
  //                               ),
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(
  //                           width: 8,
  //                         ),
  //                         Text(
  //                           "LG ???????????????",
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: kCaptionStyle.copyWith(
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () => showCustomDialog(
  //                     '?????? ?????????????????? ????????? ?????? ?????? ????????? (?????? ???????????? ??????)',
  //                     1400,
  //                   ),
  //                   child: Container(
  //                     margin: const EdgeInsets.only(
  //                       left: 4,
  //                     ),
  //                     padding: const EdgeInsets.symmetric(
  //                       vertical: 8,
  //                       horizontal: 12,
  //                     ),
  //                     decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: const Color(0xffe7e7e7),
  //                           width: 1,
  //                         ),
  //                         borderRadius: BorderRadius.circular(8)),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(16),
  //                             border: Border.all(
  //                               width: 1,
  //                               color: const Color(0xffe7e7e7),
  //                             ),
  //                           ),
  //                           child: ClipOval(
  //                             child: CachedNetworkImage(
  //                               width: 32,
  //                               height: 32,
  //                               imageUrl:
  //                                   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3KEuCtQgm3AS4bd8RbO9kWyE0xpP--1e-hQ&usqp=CAU",
  //                               placeholder: (context, url) => CircleAvatar(
  //                                 backgroundColor: Color(0xffe7e7e7),
  //                                 child: Container(),
  //                               ),
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 8,
  //                         ),
  //                         Text(
  //                           "KaKao Brain",
  //                           overflow: TextOverflow.ellipsis,
  //                           style: kCaptionStyle.copyWith(
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () => showCustomDialog(
  //                     '?????? ?????????????????? ????????? ?????? ?????? ????????? (?????? ???????????? ??????)',
  //                     1400,
  //                   ),
  //                   child: Container(
  //                     margin: EdgeInsets.only(
  //                       left: 4,
  //                       right: 16,
  //                     ),
  //                     padding: EdgeInsets.symmetric(
  //                       vertical: 8,
  //                       horizontal: 12,
  //                     ),
  //                     decoration: BoxDecoration(
  //                         border: Border.all(
  //                           color: Color(0xffe7e7e7),
  //                           width: 1,
  //                         ),
  //                         borderRadius: BorderRadius.circular(8)),
  //                     child: Row(
  //                       children: [
  //                         Container(
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(16),
  //                             border: Border.all(
  //                               width: 1,
  //                               color: Color(0xffe7e7e7),
  //                             ),
  //                           ),
  //                           child: ClipOval(
  //                             child: CachedNetworkImage(
  //                               width: 32,
  //                               height: 32,
  //                               imageUrl:
  //                                   "https://ww.namu.la/s/fa7510d2897ae3fce73ba629a3b51ebc4035e9737d916adb03e6d38e139b2a61e2a29e7e5cfd845e01c7d69889c719edce83330202c0161d9373a960b3dede25c1ed31bc52da585c154fe035e29a92dd",
  //                               placeholder: (context, url) => CircleAvatar(
  //                                 backgroundColor: Color(0xffe7e7e7),
  //                                 child: Container(),
  //                               ),
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 8,
  //                         ),
  //                         Text(
  //                           "????????????",
  //                           overflow: TextOverflow.ellipsis,
  //                           style: kCaptionStyle.copyWith(
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget sliverTabBar(BuildContext context, HomeController homeController) {
  //   return SliverOverlapAbsorber(
  //     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
  //     sliver: SliverSafeArea(
  //       top: false,
  //       sliver: SliverAppBar(
  //         expandedHeight: 43,
  //         toolbarHeight: 43,
  //         automaticallyImplyLeading: false,
  //         elevation: 0,
  //         pinned: true,
  //         floating: false,
  //         backgroundColor: AppColors.mainWhite,
  //         flexibleSpace: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             TabBar(
  //               controller: _homeController.hometabcontroller,
  //               labelStyle: kButtonStyle,
  //               labelColor: AppColors.mainblack,
  //               unselectedLabelStyle: kBody2Style,
  //               unselectedLabelColor: AppColors.mainblack.withOpacity(0.6),
  //               indicator: const UnderlineIndicator(
  //                 strokeCap: StrokeCap.round,
  //                 borderSide: BorderSide(width: 1.2),
  //                 insets: EdgeInsets.symmetric(horizontal: 16.0),
  //               ),
  //               isScrollable: true,
  //               indicatorColor: AppColors.mainblack,
  //               tabs: const [
  //                 Tab(
  //                   height: 40,
  //                   child: Text(
  //                     "??????",
  //                   ),
  //                 ),
  //                 Tab(
  //                   height: 40,
  //                   child: Text(
  //                     "?????????",
  //                   ),
  //                 ),
  //                 Tab(
  //                   height: 40,
  //                   child: Text(
  //                     "????????? ??????",
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               height: 1,
  //               color: const Color(0xffe7e7e7),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
