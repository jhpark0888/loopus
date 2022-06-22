import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/search_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/home_screen.dart';
import 'package:loopus/screen/search_screen.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../controller/modal_controller.dart';

class SearchFocusScreen extends StatelessWidget {
  final SearchController _searchController = Get.find();
  final HomeController homeController = Get.find();

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
            TextButton(
              onPressed: () async {
                _searchController.focusNode.unfocus();
                var value = await AppController
                    .to.searcnPageNaviationKey.currentState!
                    .maybePop();
                if (value) {
                  Navigator.pop(context);
                }
                _searchController.clearSearchedList();
                _searchController.isnosearchpost(false);
                _searchController.isnosearchprofile(false);
                _searchController.isnosearchquestion(false);
                _searchController.isnosearchtag(false);
                _searchController.searchtextcontroller.clear();
                _searchController.postpagenumber = 1;
                _searchController.profilepagenumber = 1;
                _searchController.questionpagenumber = 1;
                _searchController.tagpagenumber = 1;
                _searchController.pagenumber = 1;
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

            // if (searchController.isFocused.value == false)
            //   SizedBox(
            //     width: 16,
            //   ),
          ],
          title: Container(
            width: MediaQuery.of(context).size.width - 70,
            height: 36,
            child: TextField(
                autocorrect: false,
                controller: _searchController.searchtextcontroller,
                onTap: () {
                  print(
                      '_searchController.tabController.index : ${_searchController.tabController.index}');

                  // _searchController.isnosearchpost(false);
                  // _searchController.isnosearchprofile(false);
                  // _searchController.isnosearchquestion(false);
                  // _searchController.isnosearchtag(false);

                  // _searchController.searchpostinglist.clear();
                  // _searchController.searchprofilelist.clear();
                  // _searchController.searchquestionlist.clear();
                  // _searchController.searchtaglist.clear();
                },
                onSubmitted: (value) async {
                  _searchController.isSearchLoading(true);
                  // if (_searchController.postpagenumber == 1) {
                  //   _searchController.searchpostinglist.clear();
                  // } else if (_searchController.profilepagenumber == 1) {
                  //   _searchController.searchprofilelist.clear();
                  // } else if (_searchController.questionpagenumber == 1) {
                  //   _searchController.searchquestionlist.clear();
                  // } else if (_searchController.tagpagenumber == 1) {
                  //   _searchController.searchtaglist.clear();
                  // }

                  if (_searchController.tabController.index == 0) {
                    await search(SearchType.post, value,
                        _searchController.postpagenumber);
                  } else if (_searchController.tabController.index == 1) {
                    await search(SearchType.profile, value,
                        _searchController.profilepagenumber);
                  } else if (_searchController.tabController.index == 2) {
                    await search(SearchType.question, value,
                        _searchController.questionpagenumber);
                  } else if (_searchController.tabController.index == 3) {
                    await tagsearch();
                  }
                  _searchController.isSearchLoading(false);
                },
                focusNode: _searchController.focusNode,
                style: TextStyle(color: mainblack, fontSize: 14),
                cursorColor: mainblue,
                cursorWidth: 1.2,
                cursorRadius: Radius.circular(5.0),
                autofocus: false,
                // focusNode: searchController.detailsearchFocusnode,
                textAlign: TextAlign.start,
                // selectionHeightStyle: BoxHeightStyle.tight,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: lightcardgray,
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
                  ),
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
        body: DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: WillPopScope(
            onWillPop: () async {
              Get.back();
              _searchController.clearSearchedList();
              _searchController.postpagenumber = 1;
              _searchController.profilepagenumber = 1;
              _searchController.questionpagenumber = 1;
              _searchController.tabController.index = 0;
              _searchController.searchtextcontroller.clear();
              return false;
            },
            child: GestureDetector(
              onTap: () {
                _searchController.focusNode.unfocus();
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
                              TabBar(
                                  controller: _searchController.tabController,
                                  labelStyle: kButtonStyle,
                                  labelColor: mainblack,
                                  unselectedLabelStyle: kBody2Style,
                                  unselectedLabelColor:
                                      mainblack.withOpacity(0.6),
                                  indicator: UnderlineIndicator(
                                      strokeCap: StrokeCap.round,
                                      borderSide: BorderSide(width: 1.2),
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
                                  ]),
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
                    physics: NeverScrollableScrollPhysics(),
                    controller: _searchController.tabController,
                    children: [
                      SingleChildScrollView(
                        child: Obx(
                          () => _searchController.isSearchLoading.value
                              ? searchloading()
                              : _searchController.isnosearchpost.value == false
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        children: _searchController
                                            .searchpostinglist.value,
                                      ))
                                  : Container(
                                      height: 80,
                                      child: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: '아직 ',
                                              ),
                                              TextSpan(
                                                text:
                                                    '${_searchController.searchtextcontroller.text.trim().replaceAll(RegExp("\\s+"), " ")}',
                                                style: kSubTitle1Style.copyWith(
                                                    color: mainblue),
                                              ),
                                              const TextSpan(
                                                text: '에 대한 포스팅이 없어요',
                                              ),
                                            ],
                                            style: kSubTitle1Style.copyWith(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Obx(
                          () => _searchController.isSearchLoading.value
                              ? searchloading()
                              : _searchController.isnosearchprofile.value ==
                                      false
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        children: _searchController
                                            .searchprofilelist.value,
                                      ))
                                  : Container(
                                      height: 80,
                                      child: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: '아직 ',
                                              ),
                                              TextSpan(
                                                text:
                                                    '${_searchController.searchtextcontroller.text.trim().replaceAll(RegExp("\\s+"), " ")}',
                                                style: kSubTitle1Style.copyWith(
                                                    color: mainblue),
                                              ),
                                              const TextSpan(
                                                text: '(이)란 학생이 없어요',
                                              ),
                                            ],
                                            style: kSubTitle1Style.copyWith(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                      // SingleChildScrollView(
                      //   child: Obx(
                      //     () => _searchController.isSearchLoading.value
                      //         ? searchloading()
                      //         : _searchController.isnosearchquestion.value ==
                      //                 false
                      //             ? Padding(
                      //                 padding: const EdgeInsets.only(top: 10.0),
                      //                 child: Column(
                      //                   children: _searchController
                      //                       .searchquestionlist.value,
                      //                 ),
                      //               )
                      //             : Container(
                      //                 height: 80,
                      //                 child: Center(
                      //                   child: RichText(
                      //                     text: TextSpan(
                      //                       children: [
                      //                         const TextSpan(
                      //                           text: '아직 ',
                      //                         ),
                      //                         TextSpan(
                      //                           text:
                      //                               '${_searchController.searchtextcontroller.text.trim().replaceAll(RegExp("\\s+"), " ")}',
                      //                           style: kSubTitle1Style.copyWith(
                      //                               color: mainblue),
                      //                         ),
                      //                         const TextSpan(
                      //                           text: '에 대한 질문이 없어요',
                      //                         ),
                      //                       ],
                      //                       style: kSubTitle1Style.copyWith(
                      //                         fontWeight: FontWeight.normal,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //   ),
                      // ),
                      SingleChildScrollView(
                        child: Obx(
                          () => _searchController.isSearchLoading.value
                              ? searchloading()
                              : _searchController.isnosearchtag.value == false
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        children: _searchController
                                            .searchtaglist.value,
                                      ),
                                    )
                                  : Container(
                                      height: 80,
                                      child: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: '아직 ',
                                              ),
                                              TextSpan(
                                                text:
                                                    '${_searchController.searchtextcontroller.text.trim().replaceAll(RegExp("\\s+"), " ")}',
                                                style: kSubTitle1Style.copyWith(
                                                    color: mainblue),
                                              ),
                                              const TextSpan(
                                                text: '(와)과 관련된 태그가 없어요',
                                              ),
                                            ],
                                            style: kSubTitle1Style.copyWith(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ));
  }
}
