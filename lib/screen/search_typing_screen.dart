import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/home_screen.dart';
import 'package:underline_indicator/underline_indicator.dart';

class SearchTypingScreen extends StatelessWidget {
  SearchController searchController = Get.put(SearchController());
  TagController tagController = Get.put(TagController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: WillPopScope(
        onWillPop: () async {
          Get.back();
          searchController.searchpostinglist.clear();
          searchController.searchprofilelist.clear();
          searchController.searchquestionlist.clear();
          searchController.postpagenumber = 1;
          searchController.profilepagenumber = 1;
          searchController.questionpagenumber = 1;
          searchController.tabController.index = 0;
          searchController.searchtextcontroller.clear();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 52,
            centerTitle: false,
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: mainWhite,
            leading: Text(''),
            leadingWidth: 16,
            actions: [
              TextButton(
                onPressed: () {
                  print(
                      '_searchController.isFocused.value : ${SearchController.to.isFocused.value}');
                  searchController.focusNode.unfocus();
                  Get.back();
                  searchController.postpagenumber = 1;
                  searchController.profilepagenumber = 1;
                  searchController.questionpagenumber = 1;
                  searchController.tagpagenumber = 1;
                  searchController.pagenumber = 1;
                  searchController.searchpostinglist.clear();
                  searchController.searchprofilelist.clear();
                  searchController.searchquestionlist.clear();
                  searchController.tabController.index = 0;
                  searchController.searchtextcontroller.clear();
                  searchController.focusChange();
                },
                child: Center(
                  child: Text(
                    '닫기',
                    style: TextStyle(
                      fontSize: 14,
                      color: mainblue,
                    ),
                  ),
                ),
              ),
              // if (searchController.isFocused.value == false)
              //   SizedBox(
              //     width: 16,
              //   ),
            ],
            title: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: searchController.isFocused.value
                    ? MediaQuery.of(context).size.width - 70
                    : MediaQuery.of(context).size.width,
                curve: Curves.easeOut,
                height: 36,
                child: TextField(
                    autocorrect: false,
                    controller: searchController.istag.value
                        ? tagController.tagsearch
                        : searchController.searchtextcontroller,
                    onTap: () {
                      searchController.isnosearchpost(false);
                      searchController.isnosearchprofile(false);
                      searchController.isnosearchquestion(false);
                      searchController.isnosearchtag(false);

                      searchController.searchpostinglist.clear();
                      searchController.searchprofilelist.clear();
                      searchController.searchquestionlist.clear();
                    },
                    onSubmitted: (value) async {
                      // if (searchController.pagenumber == 1) {
                      //   searchController.searchpostinglist.clear();
                      //   searchController.searchprofilelist.clear();
                      //   searchController.searchquestionlist.clear();
                      // }
                      if (value.trim() != '') {
                        if (searchController.postpagenumber == 1) {
                          searchController.searchpostinglist.clear();
                        } else if (searchController.profilepagenumber == 1) {
                          searchController.searchprofilelist.clear();
                        } else if (searchController.questionpagenumber == 1) {
                          searchController.searchquestionlist.clear();
                        }
                        if (searchController.tabController.index == 0) {
                          await searchController.search(SearchType.post, value,
                              searchController.postpagenumber);
                        } else if (searchController.tabController.index == 1) {
                          await searchController.search(SearchType.profile,
                              value, searchController.profilepagenumber);
                        } else if (searchController.tabController.index == 2) {
                          await searchController.search(SearchType.question,
                              value, searchController.questionpagenumber);
                        }
                      }

                      print(value);
                      // searchController.searchtextcontroller.clear();
                    },
                    style: TextStyle(color: mainblack, fontSize: 14),
                    cursorColor: Colors.grey,
                    cursorWidth: 1.5,
                    cursorHeight: 14,
                    cursorRadius: Radius.circular(5.0),
                    autofocus: true,
                    // focusNode: searchController.detailsearchFocusnode,
                    textAlign: TextAlign.start,
                    // selectionHeightStyle: BoxHeightStyle.tight,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: mainlightgrey,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      // focusColor: Colors.black,
                      // border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.only(right: 16),
                      isDense: true,
                      hintText: "어떤 정보를 찾으시나요?",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: mainblack.withOpacity(0.6),
                          height: 1.5),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                        child: SvgPicture.asset(
                          "assets/icons/Search_Inactive.svg",
                          width: 16,
                          height: 16,
                          color: mainblack.withOpacity(0.6),
                        ),
                      ),
                    )),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {
              searchController.focusNode.unfocus();
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                        backgroundColor: mainWhite,
                        toolbarHeight: 43,
                        pinned: true,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        flexibleSpace: Column(
                          children: [
                            Theme(
                              data: ThemeData().copyWith(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: TabBar(
                                  controller: searchController.tabController,
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
                                  unselectedLabelColor:
                                      mainblack.withOpacity(0.6),
                                  indicator: UnderlineIndicator(
                                      strokeCap: StrokeCap.round,
                                      borderSide: BorderSide(width: 2),
                                      insets: EdgeInsets.symmetric(
                                          horizontal: 10.0)),
                                  isScrollable: false,
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
                                        "프로필",
                                      ),
                                    ),
                                    Tab(
                                      height: 40,
                                      child: Text(
                                        "질문",
                                      ),
                                    ),
                                    Tab(
                                      height: 40,
                                      child: Text(
                                        "태그",
                                      ),
                                    ),
                                    Tab(
                                      height: 40,
                                      child: Text(
                                        "공고",
                                      ),
                                    ),
                                  ]),
                            ),
                            Container(
                              height: 1,
                              color: Color(0xffe7e7e7),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SliverToBoxAdapter(child: de\,)
                ];
              },
              body: TabBarView(
                  physics: PageScrollPhysics().parent,
                  controller: searchController.tabController,
                  children: [
                    SingleChildScrollView(
                      child: Obx(
                          () => searchController.isnosearchpost.value == false
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    children: searchController
                                        .searchpostinglist.value,
                                  ))
                              : Padding(
                                  padding: EdgeInsets.only(
                                    top: 32,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "아직 검색어와 일치하는 포스팅이 없어요",
                                    style: kSubTitle2Style,
                                  )))),
                    ),
                    SingleChildScrollView(
                      child: Obx(() =>
                          searchController.isnosearchprofile.value == false
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    children: searchController
                                        .searchprofilelist.value,
                                  ))
                              : Padding(
                                  padding: EdgeInsets.only(
                                    top: 32,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "아직 검색어와 일치하는 학생이 없어요",
                                    style: kSubTitle2Style,
                                  )))),
                    ),
                    SingleChildScrollView(
                      child: Obx(() =>
                          searchController.isnosearchquestion.value == false
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    children: searchController
                                        .searchquestionlist.value,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                    top: 32,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "아직 검색어와 일치하는 질문이 없어요",
                                    style: kSubTitle2Style,
                                  )))),
                    ),
                    SingleChildScrollView(
                      child: Obx(
                          () => searchController.isnosearchtag.value == false
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    children:
                                        searchController.searchtaglist.value,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                    top: 32,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "아직 검색어와 일치하는 질문이 없어요",
                                    style: kSubTitle2Style,
                                  )))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: Center(child: Text("공고")),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
