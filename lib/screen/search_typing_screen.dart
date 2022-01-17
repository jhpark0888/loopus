// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/search_controller.dart';
// import 'package:loopus/controller/tag_controller.dart';
// import 'package:loopus/screen/home_screen.dart';
// import 'package:loopus/screen/search_screen.dart';
// import 'package:underline_indicator/underline_indicator.dart';

// class SearchTypingScreen extends StatelessWidget {
//   SearchController _searchController = Get.put(SearchController());
//   TagController tagController = Get.put(TagController());

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       initialIndex: 0,
//       child: WillPopScope(
//         onWillPop: () async {
//           Get.back();
//           _searchController.searchpostinglist.clear();
//           _searchController.searchprofilelist.clear();
//           _searchController.searchquestionlist.clear();
//           _searchController.postpagenumber = 1;
//           _searchController.profilepagenumber = 1;
//           _searchController.questionpagenumber = 1;
//           _searchController.tabController.index = 0;
//           _searchController.searchtextcontroller.clear();
//           return false;
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             automaticallyImplyLeading: false,
//             toolbarHeight: 52,
//             centerTitle: false,
//             titleSpacing: 0,
//             elevation: 0,
//             backgroundColor: mainWhite,
//             leading: Text(''),
//             leadingWidth: 16,
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   print(
//                       '_searchController.isFocused.value : ${SearchController.to.isFocused.value}');
//                   _searchController.focusNode.unfocus();
//                   Get.back();
//                   _searchController.postpagenumber = 1;
//                   _searchController.profilepagenumber = 1;
//                   _searchController.questionpagenumber = 1;
//                   _searchController.tagpagenumber = 1;
//                   _searchController.pagenumber = 1;
//                   _searchController.searchpostinglist.clear();
//                   _searchController.searchprofilelist.clear();
//                   _searchController.searchquestionlist.clear();
//                   _searchController.tabController.index = 0;
//                   _searchController.searchtextcontroller.clear();
//                   _searchController.focusChange();
//                 },
//                 child: Center(
//                   child: Text(
//                     '닫기',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: mainblue,
//                     ),
//                   ),
//                 ),
//               ),
//               // if (searchController.isFocused.value == false)
//               //   SizedBox(
//               //     width: 16,
//               //   ),
//             ],
//             title: Obx(
//               () => AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 width: _searchController.isFocused.value
//                     ? MediaQuery.of(context).size.width - 70
//                     : MediaQuery.of(context).size.width,
//                 curve: Curves.easeOut,
//                 height: 36,
//                 child: TextField(
//                     autocorrect: false,
//                     controller: _searchController.istag.value
//                         ? tagController.tagsearch
//                         : _searchController.searchtextcontroller,
//                     onTap: () {
//                       _searchController.isnosearchpost(false);
//                       _searchController.isnosearchprofile(false);
//                       _searchController.isnosearchquestion(false);
//                       _searchController.isnosearchtag(false);

//                       _searchController.searchpostinglist.clear();
//                       _searchController.searchprofilelist.clear();
//                       _searchController.searchquestionlist.clear();
//                     },
//                     onSubmitted: (value) async {
//                       // if (searchController.pagenumber == 1) {
//                       //   searchController.searchpostinglist.clear();
//                       //   searchController.searchprofilelist.clear();
//                       //   searchController.searchquestionlist.clear();
//                       // }
//                       if (value.trim() != '') {
//                         if (_searchController.postpagenumber == 1) {
//                           _searchController.searchpostinglist.clear();
//                         } else if (_searchController.profilepagenumber == 1) {
//                           _searchController.searchprofilelist.clear();
//                         } else if (_searchController.questionpagenumber == 1) {
//                           _searchController.searchquestionlist.clear();
//                         }
//                         if (_searchController.tabController.index == 0) {
//                           await _searchController.search(SearchType.post, value,
//                               _searchController.postpagenumber);
//                         } else if (_searchController.tabController.index == 1) {
//                           await _searchController.search(SearchType.profile,
//                               value, _searchController.profilepagenumber);
//                         } else if (_searchController.tabController.index == 2) {
//                           await _searchController.search(SearchType.question,
//                               value, _searchController.questionpagenumber);
//                         }
//                       }

//                       print(value);
//                       // searchController.searchtextcontroller.clear();
//                     },
//                     style: kBody2Style,
//                     cursorColor: Colors.grey,
//                     cursorWidth: 1.2,
//                     cursorRadius: Radius.circular(5.0),
//                     autofocus: true,
//                     // focusNode: searchController.detailsearchFocusnode,
//                     textAlign: TextAlign.start,
//                     // selectionHeightStyle: BoxHeightStyle.tight,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: mainlightgrey,
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(8)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(8)),
//                       // focusColor: Colors.black,
//                       // border: OutlineInputBorder(borderSide: BorderSide.none),
//                       contentPadding: EdgeInsets.only(right: 16),
//                       isDense: true,
//                       hintText: "어떤 정보를 찾으시나요?",
//                       hintStyle: TextStyle(
//                           fontSize: 14,
//                           color: mainblack.withOpacity(0.6),
//                           height: 1.5),
//                       prefixIcon: Padding(
//                         padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
//                         child: SvgPicture.asset(
//                           "assets/icons/Search_Inactive.svg",
//                           width: 16,
//                           height: 16,
//                           color: mainblack.withOpacity(0.6),
//                         ),
//                       ),
//                     )),
//               ),
//             ),
//           ),
//           body: GestureDetector(
//             onTap: () {
//               _searchController.focusNode.unfocus();
//             },
//             child: NestedScrollView(
//               headerSliverBuilder: (context, value) {
//                 return [
//                   SliverOverlapAbsorber(
//                     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                         context),
//                     sliver: SliverSafeArea(
//                       top: false,
//                       sliver: SliverAppBar(
//                         backgroundColor: mainWhite,
//                         toolbarHeight: 43,
//                         pinned: true,
//                         elevation: 0,
//                         automaticallyImplyLeading: false,
//                         flexibleSpace: Column(
//                           children: [
//                             Theme(
//                               data: ThemeData().copyWith(
//                                 splashColor: Colors.transparent,
//                                 highlightColor: Colors.transparent,
//                               ),
//                               child: TabBar(
//                                   controller: _searchController.tabController,
//                                   labelStyle: TextStyle(
//                                     color: mainblack,
//                                     fontSize: 14,
//                                     fontFamily: 'Nanum',
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   labelColor: mainblack,
//                                   unselectedLabelStyle: TextStyle(
//                                     color: Colors.yellow,
//                                     fontSize: 14,
//                                     fontFamily: 'Nanum',
//                                     fontWeight: FontWeight.normal,
//                                   ),
//                                   unselectedLabelColor:
//                                       mainblack.withOpacity(0.6),
//                                   indicator: UnderlineIndicator(
//                                       strokeCap: StrokeCap.round,
//                                       borderSide: BorderSide(width: 2),
//                                       insets: EdgeInsets.symmetric(
//                                           horizontal: 10.0)),
//                                   isScrollable: false,
//                                   indicatorColor: mainblack,
//                                   tabs: [
//                                     Tab(
//                                       height: 40,
//                                       child: Text(
//                                         "포스팅",
//                                       ),
//                                     ),
//                                     Tab(
//                                       height: 40,
//                                       child: Text(
//                                         "프로필",
//                                       ),
//                                     ),
//                                     Tab(
//                                       height: 40,
//                                       child: Text(
//                                         "질문",
//                                       ),
//                                     ),
//                                     Tab(
//                                       height: 40,
//                                       child: Text(
//                                         "태그",
//                                       ),
//                                     ),
//                                   ]),
//                             ),
//                             Container(
//                               height: 1,
//                               color: Color(0xffe7e7e7),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   // SliverToBoxAdapter(child: de\,)
//                 ];
//               },
//               body: TabBarView(
//                   physics: PageScrollPhysics().parent,
//                   controller: _searchController.tabController,
//                   children: [
//                     SingleChildScrollView(
//                                     child: Obx(() => _searchController
//                                             .isSearchLoading.value
//                                         ? searchloading()
//                                         : _searchController
//                                                     .isnosearchpost.value ==
//                                                 false
//                                             ? Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 10.0),
//                                                 child: Column(
//                                                   children: _searchController
//                                                       .searchpostinglist,
//                                                 ))
//                                             : Container(
//                                                 height: 80,
//                                                 child: Center(
//                                                     child: Text(
//                                                   "아직 검색어와 일치하는 포스팅이 없어요",
//                                                   style: kSubTitle2Style,
//                                                 )))),
//                                   ),
//                                   SingleChildScrollView(
//                                     child: Obx(() => _searchController
//                                             .isSearchLoading.value
//                                         ? searchloading()
//                                         : _searchController
//                                                     .isnosearchprofile.value ==
//                                                 false
//                                             ? Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 10.0),
//                                                 child: Column(
//                                                   children: _searchController
//                                                       .searchprofilelist,
//                                                 ))
//                                             : Container(
//                                                 height: 80,
//                                                 child: Center(
//                                                     child: Text(
//                                                   "아직 검색어와 일치하는 학생이 없어요",
//                                                   style: kSubTitle2Style,
//                                                 )))),
//                                   ),
//                                   SingleChildScrollView(
//                                     child: Obx(() => _searchController
//                                             .isSearchLoading.value
//                                         ? searchloading()
//                                         : _searchController
//                                                     .isnosearchquestion.value ==
//                                                 false
//                                             ? Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     top: 10.0),
//                                                 child: Column(
//                                                   children: _searchController
//                                                       .searchquestionlist,
//                                                 ),
//                                               )
//                                             : Container(
//                                                 height: 80,
//                                                 child: Center(
//                                                     child: Text(
//                                                   "아직 검색어와 일치하는 질문이 없어요",
//                                                   style: kSubTitle2Style,
//                                                 )))),
//                                   ),
//                                   SingleChildScrollView(
//                                     child: Obx(
//                                       () => _searchController
//                                               .isSearchLoading.value
//                                           ? searchloading()
//                                           : _searchController
//                                                       .isnosearchtag.value ==
//                                                   false
//                                               ? Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           top: 10.0),
//                                                   child: Column(
//                                                     children: _searchController
//                                                         .searchtaglist,
//                                                   ),
//                                                 )
//                                               : Container(
//                                                   height: 80,
//                                                   child: Center(
//                                                     child: Text(
//                                                       "아직 검색어와 일치하는 태그가 없어요.",
//                                                       style: kSubTitle2Style,
//                                                     ),
//                                                   ),
//                                                 ),
//                                     ),
//                                   ),
//                   ]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
