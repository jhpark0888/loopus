import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/screen/myProfile_screen.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/divide_widget.dart';
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
  final SearchController _searchController = Get.put(SearchController());
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 58,
          elevation: 0,
          titleSpacing: 20,
          title: GestureDetector(
            onTap: () {
              _homeController.scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear);
            },
            child: 
            SvgPicture.asset(
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
                      Get.to(() => NotificationScreen());
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
              width: 24,
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
                                  color: rankred, shape: BoxShape.circle),
                            )
                          : Container()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  Get.to(() => MyProfileScreen());

                }
                // Get.to(() => DatabaseList())

                ,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Obx(
                    () => UserImageWidget(
                      imageUrl: HomeController
                              .to.myProfile.value.profileImage ??
                          // ProfileController.to.myUserInfo.value.profileImage ??
                          '',
                      width: 36,
                      height: 36,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: Obx(
          () => ScrollNoneffectWidget(
            child: SmartRefresher(
              primary: false,
              physics: const BouncingScrollPhysics(),
              scrollController: _homeController.scrollController,
              controller: _homeController.postingRefreshController,
              enablePullDown: (_homeController.isPostingLoading.value == true)
                  ? false
                  : true,
              enablePullUp: (_homeController.isPostingLoading.value == true)
                  ? false
                  : _homeController.enablePostingPullup.value,
              header: const MyCustomHeader(),
              footer: const MyCustomFooter(),
              onRefresh: _homeController.onPostingRefresh,
              onLoading: _homeController.onPostingLoading,
              child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    children: [
                      _homeController.recommendCareer != null
                          ? GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Get.to(() => PostingAddScreen(
                                    project_id:
                                        _homeController.recommendCareer!.id,
                                    route: PostaddRoute.project));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      '\'${_homeController.recommendCareer!.careerName}\'\n커리어엔 최근 어떤 일이 있었나요?',
                                      style: kmainheight,
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      '포스트를 바로 작성해 보세요',
                                      style: kmain.copyWith(color: maingray),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Divider(thickness: 1, color: maingray),
                                  ],
                                ),
                              ),
                            )
                          : GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Get.to(() => ProjectAddTitleScreen(
                                      screenType: Screentype.add,
                                    ));
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    const Text(
                                      '지금 커리어를 만들고 새로운 포스트를 기록해보세요!',
                                      style: kmainheight,
                                    ),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      '커리어를 바로 작성해 보세요',
                                      style: kmain.copyWith(color: maingray),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Divider(thickness: 1, color: maingray),
                                  ],
                                ),
                              ),
                            ),
                      Obx(
                        () => ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            if (_homeController.contents[index] is Post) {
                              return PostingWidget(
                                item: _homeController.contents[index],
                                type: PostingWidgetType.normal,
                              );
                            } else if (_homeController.contents[index]
                                is RxList<String>) {
                              return NewsListWidget(
                                  newslist: _homeController.contents[index]);
                            } else {
                              return const Text(
                                '에러',
                                style: kmainbold,
                              );
                            }
                          },
                          separatorBuilder: (context, index) {
                            return DivideWidget();
                          },
                          itemCount: _homeController.contents.length,
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
                  color: lightcardgray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/search_inactive.svg',
                      width: 16,
                      height: 16,
                      color: mainblack.withOpacity(0.6),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "어떤 정보를 찾으시나요?",
                      style: TextStyle(
                        color: mainblack.withOpacity(0.6),
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
  //                 "활동중인 공식 계정",
  //                 style: kButtonStyle.copyWith(
  //                   color: mainblack.withOpacity(0.6),
  //                 ),
  //               ),
  //               SizedBox(
  //                 width: 4,
  //               ),
  //               GestureDetector(
  //                 onTap: () =>
  //                     showCustomDialog('최근 한 달 내에 학생 프로필을 열람한 기업들입니다 ', 1400),
  //                 child: SvgPicture.asset(
  //                   'assets/icons/information.svg',
  //                   width: 20,
  //                   height: 20,
  //                   color: mainblack.withOpacity(0.6),
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
  //                     '해당 기업들로부터 오퍼를 받을 수도 있어요 (추후 업데이트 예정)',
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
  //                           "LG 디스플레이",
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
  //                     '해당 기업들로부터 오퍼를 받을 수도 있어요 (추후 업데이트 예정)',
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
  //                     '해당 기업들로부터 오퍼를 받을 수도 있어요 (추후 업데이트 예정)',
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
  //                           "삼성전자",
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
  //         backgroundColor: mainWhite,
  //         flexibleSpace: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             TabBar(
  //               controller: _homeController.hometabcontroller,
  //               labelStyle: kButtonStyle,
  //               labelColor: mainblack,
  //               unselectedLabelStyle: kBody2Style,
  //               unselectedLabelColor: mainblack.withOpacity(0.6),
  //               indicator: const UnderlineIndicator(
  //                 strokeCap: StrokeCap.round,
  //                 borderSide: BorderSide(width: 1.2),
  //                 insets: EdgeInsets.symmetric(horizontal: 16.0),
  //               ),
  //               isScrollable: true,
  //               indicatorColor: mainblack,
  //               tabs: const [
  //                 Tab(
  //                   height: 40,
  //                   child: Text(
  //                     "추천",
  //                   ),
  //                 ),
  //                 Tab(
  //                   height: 40,
  //                   child: Text(
  //                     "팔로잉",
  //                   ),
  //                 ),
  //                 Tab(
  //                   height: 40,
  //                   child: Text(
  //                     "질문과 답변",
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
