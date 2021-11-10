import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/screen/posting_detail_screen.dart';
import 'package:loopus/screen/question_answer_screen.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/home_posting_widget.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homecontroller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: const Text(
            'LOOPUS',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.near_me,
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 13,
                              ),
                              Icon(Icons.search),
                              Text(
                                "   어떤 정보를 찾으시나요?",
                                style: TextStyle(color: Colors.grey[600]),
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
                    Row(
                      children: const [
                        TabBar(
                            indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(width: 1.7),
                                insets: EdgeInsets.symmetric(horizontal: 7.0)),
                            isScrollable: true,
                            indicatorColor: Colors.black,
                            tabs: [
                              Tab(
                                child: Text(
                                  "포스팅",
                                  style: TextStyle(
                                      color: mainFontDark,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "질문과 답변",
                                  style: TextStyle(
                                      color: mainFontDark,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "루프",
                                  style: TextStyle(
                                      color: mainFontDark,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              // new Container(
                              //   width: 100,
                              // )
                            ]),
                      ],
                    ),
                    Divider(
                      thickness: 0.5,
                      height: 0.3,
                      color: lightGray,
                    )
                  ],
                ),
              ),
              // SliverToBoxAdapter(child: de\,)
            ];
          },
          body: Container(
            child: TabBarView(physics: PageScrollPhysics(), children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Column(
                      children: HomeController.to.posting,
                    ),
                    Container(
                      height: 250,
                      color: Colors.grey,
                      child: Center(
                        child: Text(
                          "채용 공고 / 활동 공고 / 기타 공고",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "추천하는 정보",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      // margin: const EdgeInsets.symmetric(vertical: 20.0),
                      height: 360,
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: HomeController.to.recommend_posting),
                    ),
                  ],
                ),
              ),
              QuestionAnswerScreen(),
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: HomeController.to.posting,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
