import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:underline_indicator/underline_indicator.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/scroll_controller.dart';
import 'package:loopus/controller/search_controller.dart';

import 'package:loopus/screen/home_posting_screen.dart';
import 'package:loopus/screen/home_loop_screen.dart';
import 'package:loopus/screen/message_screen.dart';
import 'package:loopus/screen/notification_screen.dart';
import 'package:loopus/screen/home_question_screen.dart';

class HomeScreen extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  final ModalController _modalController = Get.put(ModalController());
  final SearchController _searchController = Get.put(SearchController());
  final MessageController _messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: _homeController.hometabcontroller.index,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: GestureDetector(
            onTap: () => CustomScrollController.to.scrollToTop(),
            child: Image.asset(
              'assets/illustrations/Home_Logo.png',
              width: 54,
              height: 30,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Get.to(() => const NotificationScreen()),
              icon: SvgPicture.asset(
                "assets/icons/Bell_Inactive.svg",
                width: 28,
                height: 28,
              ),
            ),
            IconButton(
              onPressed: () {
                _messageController.isMessageRoomListLoading(true);
                Get.to(() => MessageScreen());
                getmessageroomlist().then((value) {
                  _messageController.isMessageRoomListLoading(false);
                });
              },
              icon: SvgPicture.asset(
                "assets/icons/Chat.svg",
                width: 28,
                height: 28,
              ),
            ),
          ],
        ),
        body: NestedScrollView(
          controller: CustomScrollController.to.customScrollController.value,
          headerSliverBuilder: (context, value) {
            return [
              //홈 검색 탭
              // homeSearchBar(_searchController),
              //활동중인 공식계정
              activatedOfficialAccount(_modalController),
              //탭 바
              sliverTabBar(context, _homeController),
            ];
          },
          body: TabBarView(
              physics: const PageScrollPhysics(),
              controller: _homeController.hometabcontroller,
              children: [
                HomePostingScreen(),
                HomeQuestionScreen(),
                HomeLoopScreen(),
              ]),
        ),
      ),
    );
  }

  Widget homeSearchBar(SearchController _searchController) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {
          _searchController.clearSearchedList();
          Get.toNamed('/search');
          print('search posting list : ${_searchController.searchpostinglist}');
          print('search profile list : ${_searchController.searchprofilelist}');

          print(
              'search question list : ${_searchController.searchquestionlist}');

          print('search tag list : ${_searchController.searchtaglist}');
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
                  color: mainlightgrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/Search_Inactive.svg',
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

  Widget activatedOfficialAccount(ModalController _modalController) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              children: [
                Text(
                  "활동중인 공식 계정",
                  style: kButtonStyle.copyWith(
                    color: mainblack.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  onTap: () => _modalController.showCustomDialog(
                      '최근 한 달 내에 학생 프로필을 열람한 기업들입니다 ', 1400),
                  child: SvgPicture.asset(
                    'assets/icons/Question.svg',
                    width: 20,
                    height: 20,
                    color: mainblack.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  GestureDetector(
                    onTap: () => _modalController.showCustomDialog(
                      '해당 기업들로부터 오퍼를 받을 수도 있어요 (추후 업데이트 예정)',
                      1400,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 16,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffe7e7e7),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 1,
                                color: Color(0xffe7e7e7),
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                width: 32,
                                height: 32,
                                imageUrl:
                                    "http://www.lg.co.kr/images/common/default_og_image_new.jpg",
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundColor: Color(0xffe7e7e7),
                                  child: Container(),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "LG 디스플레이",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kCaptionStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _modalController.showCustomDialog(
                      '해당 기업들로부터 오퍼를 받을 수도 있어요 (추후 업데이트 예정)',
                      1400,
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffe7e7e7),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xffe7e7e7),
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                width: 32,
                                height: 32,
                                imageUrl:
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3KEuCtQgm3AS4bd8RbO9kWyE0xpP--1e-hQ&usqp=CAU",
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundColor: Color(0xffe7e7e7),
                                  child: Container(),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "KaKao Brain",
                            overflow: TextOverflow.ellipsis,
                            style: kCaptionStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _modalController.showCustomDialog(
                      '해당 기업들로부터 오퍼를 받을 수도 있어요 (추후 업데이트 예정)',
                      1400,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 4,
                        right: 16,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffe7e7e7),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 1,
                                color: Color(0xffe7e7e7),
                              ),
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                width: 32,
                                height: 32,
                                imageUrl:
                                    "https://ww.namu.la/s/fa7510d2897ae3fce73ba629a3b51ebc4035e9737d916adb03e6d38e139b2a61e2a29e7e5cfd845e01c7d69889c719edce83330202c0161d9373a960b3dede25c1ed31bc52da585c154fe035e29a92dd",
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundColor: Color(0xffe7e7e7),
                                  child: Container(),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "삼성전자",
                            overflow: TextOverflow.ellipsis,
                            style: kCaptionStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sliverTabBar(BuildContext context, HomeController homeController) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverSafeArea(
        top: false,
        sliver: SliverAppBar(
          expandedHeight: 43,
          toolbarHeight: 43,
          automaticallyImplyLeading: false,
          elevation: 0,
          pinned: true,
          floating: false,
          backgroundColor: mainWhite,
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabBar(
                controller: _homeController.hometabcontroller,
                labelStyle: kButtonStyle,
                labelColor: mainblack,
                unselectedLabelStyle: kBody2Style,
                unselectedLabelColor: mainblack.withOpacity(0.6),
                indicator: const UnderlineIndicator(
                  strokeCap: StrokeCap.round,
                  borderSide: BorderSide(width: 2),
                  insets: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                isScrollable: true,
                indicatorColor: mainblack,
                tabs: const [
                  Tab(
                    height: 40,
                    child: Text(
                      "포스팅",
                    ),
                  ),
                  Tab(
                    height: 40,
                    child: Text(
                      "질문과 답변",
                    ),
                  ),
                  Tab(
                    height: 40,
                    child: Text(
                      "루프",
                    ),
                  ),
                ],
              ),
              Container(
                height: 1,
                color: const Color(0xffe7e7e7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
