import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/screen/home_posting_screen.dart';
import 'package:loopus/screen/posting_detail_screen.dart';
import 'package:loopus/screen/question_answer_screen.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/home_posting_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homecontroller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: homecontroller.hometabcontroller.index,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Image.asset(
            'assets/illustrations/Home_Logo.png',
            width: 54,
            height: 30,
          ),
          actions: [
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/Bell_Inactive.svg",
                width: 28,
                height: 28,
              ),
            ),
            IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {},
                icon: SvgPicture.asset(
                  "assets/icons/Chat.svg",
                  width: 28,
                  height: 28,
                )),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Get.to(SearchTypingScreen());
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8.0, 8.0),
                      child: Row(
                        children: [
                          Text(
                            "활동중인 공식 계정 ",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: mainblack.withOpacity(0.6)),
                          ),
                          Icon(
                            Icons.help_outline,
                            size: 18,
                            color: mainblack.withOpacity(0.6),
                          )
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                            child: Container(
                                height: 50,
                                width: 140,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 7,
                                    ),
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        width: 34,
                                        height: 34,
                                        imageUrl:
                                            "http://www.lg.co.kr/images/common/default_og_image_new.jpg",
                                        placeholder: (context, url) =>
                                            const CircleAvatar(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "  LG DISPLAY",
                                        overflow: TextOverflow.ellipsis,
                                        style: kButtonStyle,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Container(
                                height: 50,
                                width: 140,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 7,
                                    ),
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        width: 34,
                                        height: 34,
                                        imageUrl:
                                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3KEuCtQgm3AS4bd8RbO9kWyE0xpP--1e-hQ&usqp=CAU",
                                        placeholder: (context, url) =>
                                            const CircleAvatar(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "  KaKao Brain",
                                        overflow: TextOverflow.ellipsis,
                                        style: kButtonStyle,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Container(
                                height: 50,
                                width: 140,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 7,
                                    ),
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        width: 34,
                                        height: 34,
                                        imageUrl:
                                            "https://ww.namu.la/s/fa7510d2897ae3fce73ba629a3b51ebc4035e9737d916adb03e6d38e139b2a61e2a29e7e5cfd845e01c7d69889c719edce83330202c0161d9373a960b3dede25c1ed31bc52da585c154fe035e29a92dd",
                                        placeholder: (context, url) =>
                                            const CircleAvatar(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        "  삼성전자",
                                        overflow: TextOverflow.ellipsis,
                                        style: kButtonStyle,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Theme(
                          data: ThemeData().copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: TabBar(
                              controller: homecontroller.hometabcontroller,
                              labelStyle: TextStyle(
                                color: mainblack,
                                fontSize: 14,
                                fontFamily: 'Nanum',
                                fontWeight: FontWeight.bold,
                              ),
                              labelColor: mainblack,
                              unselectedLabelStyle: TextStyle(
                                color: Colors.yellow,
                                fontSize: 14,
                                fontFamily: 'Nanum',
                                fontWeight: FontWeight.normal,
                              ),
                              unselectedLabelColor: mainblack.withOpacity(0.6),
                              indicator: UnderlineIndicator(
                                  strokeCap: StrokeCap.round,
                                  borderSide: BorderSide(width: 2),
                                  insets:
                                      EdgeInsets.symmetric(horizontal: 16.0)),
                              isScrollable: true,
                              indicatorColor: mainblack,
                              tabs: [
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
                                // new Container(
                                //   width: 100,
                                // )
                              ]),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: Color(0xffe7e7e7),
                    )
                  ],
                ),
              ),
              // SliverToBoxAdapter(child: de\,)
            ];
          },
          body: TabBarView(
              physics: PageScrollPhysics(),
              controller: homecontroller.hometabcontroller,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: HomePostingScreen(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: QuestionAnswerScreen(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 80,
                  ),
                  child: SingleChildScrollView(
                    key: const PageStorageKey("key3"),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: HomeController.to.posting,
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
