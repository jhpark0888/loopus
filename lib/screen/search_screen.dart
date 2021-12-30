import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/search_student_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class SearchScreen extends StatelessWidget {
  // const SearchScreen({Key? key}) : super(key: key);
  SearchController _searchController = Get.put(SearchController());
  ModalController _modalController = Get.put(ModalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Obx(
            () => (_searchController.isFocused.value == true)
                ? TextButton(
                    onPressed: () {
                      _searchController.focusChange();
                      _searchController.focusNode.unfocus();
                      _searchController.searchpostinglist.clear();
                      _searchController.searchprofilelist.clear();
                      _searchController.searchquestionlist.clear();
                      Get.back();
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
                  )
                : Container(
                    width: 16,
                  ),
          )

          // if (searchController.isFocused.value == false)
          //   SizedBox(
          //     width: 16,
          //   ),
        ],
        title: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: _searchController.isFocused.value
                ? MediaQuery.of(context).size.width - 70
                : MediaQuery.of(context).size.width,
            curve: Curves.easeInOut,
            height: 36,
            child: TextField(
                autocorrect: false,
                controller: _searchController.searchtextcontroller,
                onTap: () {
                  _searchController.isnosearch1.value = false;
                  _searchController.isnosearch2.value = false;

                  _searchController.isnosearch3.value = false;
                },
                onSubmitted: (value) async {
                  _searchController.searchpostinglist.clear();
                  _searchController.searchprofilelist.clear();
                  _searchController.searchquestionlist.clear();
                  await _searchController.search(
                      _searchController.tabController.index,
                      value,
                      _searchController.pagenumber);
                  print(value);
                  _searchController.searchtextcontroller.clear();
                },
                focusNode: _searchController.focusNode,
                style: TextStyle(color: mainblack, fontSize: 14),
                cursorColor: Colors.grey,
                cursorWidth: 1.5,
                cursorHeight: 14,
                cursorRadius: Radius.circular(5.0),
                autofocus: false,
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
      body: Obx(
        () => Stack(
          children: [
            GestureDetector(
                onTap: () => _searchController.focusNode.unfocus(),
                child: Obx(
                  () => AnimatedOpacity(
                    opacity: _searchController.isFocused.value ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 16,
                              left: 16,
                              top: 24,
                              bottom: 16,
                            ),
                            child: Text(
                              "인기 태그",
                              style: kSubTitle2Style,
                            ),
                          ),
                          Container(
                            height: 24,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 7,
                                itemBuilder: (BuildContext context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: (index == 0) ? 16 : 0,
                                        right: (index == 6) ? 16 : 0),
                                    child: Row(
                                      children: [
                                        Tagwidget(
                                          content: '공모전',
                                          fontSize: 14,
                                        ),
                                        index != 6
                                            ? SizedBox(
                                                width: 8,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 16,
                              left: 16,
                              top: 28,
                              bottom: 32,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "이 주의 학생",
                                      style: kSubTitle2Style,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _modalController.showCustomDialog(
                                          '이 주의 활동 수, 포스팅 수, 답변 수 등을 점수로 환산해 매긴 순위입니다',
                                          2,
                                        );
                                      },
                                      child: Text(
                                        "선정 기준이 뭔가요?",
                                        style: kButtonStyle.copyWith(
                                            color: mainblue),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      SearchStudentWidget(),
                                      SearchStudentWidget(),
                                      SearchStudentWidget(),
                                      SearchStudentWidget(),
                                      SearchStudentWidget(),
                                      SearchStudentWidget(),
                                      SearchStudentWidget(),
                                      SearchStudentWidget(),
                                      SearchStudentWidget(),
                                      SearchStudentWidget(),
                                      SizedBox(
                                        height: 55,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            if (_searchController.isFocused.value == true)
              Obx(
                () => AnimatedOpacity(
                  opacity: _searchController.isFocused.value ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: DefaultTabController(
                    length: 5,
                    initialIndex: 0,
                    child: WillPopScope(
                      onWillPop: () async {
                        _searchController.searchpostinglist.clear();
                        _searchController.searchprofilelist.clear();
                        _searchController.searchquestionlist.clear();
                        Get.back();
                        return false;
                      },
                      child: GestureDetector(
                        onTap: () {
                          _searchController.focusNode.unfocus();
                        },
                        child: NestedScrollView(
                          headerSliverBuilder: (context, value) {
                            return [
                              SliverAppBar(
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
                                          controller:
                                              _searchController.tabController,
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
                              // SliverToBoxAdapter(child: de\,)
                            ];
                          },
                          body: TabBarView(
                              physics: PageScrollPhysics().parent,
                              controller: _searchController.tabController,
                              children: [
                                SingleChildScrollView(
                                  child: Obx(() => _searchController
                                              .isnosearch1.value ==
                                          false
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Column(
                                            children: _searchController
                                                .searchpostinglist,
                                          ))
                                      : Container(
                                          height: 80,
                                          child: Center(
                                              child: Text(
                                            "검색 결과가 존재하지 않습니다.",
                                            style: kSubTitle2Style,
                                          )))),
                                ),
                                SingleChildScrollView(
                                  child: Obx(() => _searchController
                                              .isnosearch2.value ==
                                          false
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Column(
                                            children: _searchController
                                                .searchprofilelist,
                                          ))
                                      : Container(
                                          height: 80,
                                          child: Center(
                                              child: Text(
                                            "검색 결과가 존재하지 않습니다.",
                                            style: kSubTitle2Style,
                                          )))),
                                ),
                                SingleChildScrollView(
                                  child: Obx(() => _searchController
                                              .isnosearch3.value ==
                                          false
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Column(
                                            children: _searchController
                                                .searchquestionlist,
                                          ),
                                        )
                                      : Container(
                                          height: 80,
                                          child: Center(
                                              child: Text(
                                            "검색 결과가 존재하지 않습니다.",
                                            style: kSubTitle2Style,
                                          )))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: Center(child: Text("태그")),
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
                ),
              )
          ],
        ),
      ),
    );
  }
}
