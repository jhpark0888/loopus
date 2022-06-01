// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/home_controller.dart';
// import 'package:loopus/screen/question_add_content_screen.dart';
// import 'package:loopus/widget/question_widget.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

// class HomeQuestionScreen extends StatelessWidget {
//   final HomeController homeController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(
//         () => SmartRefresher(
//           controller: homeController.questionRefreshController,
//           enablePullDown: (homeController.selectgroup.value == '모든 질문')
//               ? (homeController.isAllQuestionLoading.value == false)
//                   ? true
//                   : false
//               : (homeController.isMyQuestionLoading.value == false)
//                   ? true
//                   : false,
//           enablePullUp: (homeController.selectgroup.value == '모든 질문')
//               ? (homeController.isAllQuestionLoading.value == false)
//                   ? homeController.enableQuestionPullup.value
//                   : false
//               : (homeController.isMyQuestionLoading.value == false)
//                   ? homeController.enableQuestionPullup.value
//                   : false,
//           header: ClassicHeader(
//             textStyle: const TextStyle(color: mainblack),
//             refreshingText: '',
//             releaseText: "",
//             completeText: "",
//             idleText: "",
//             refreshingIcon: Column(
//               children: [
//                 Image.asset(
//                   'assets/icons/loading.gif',
//                   scale: 6,
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 Text(
//                   '새로운 질문 받는 중...',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500,
//                     color: mainblue,
//                   ),
//                 ),
//               ],
//             ),
//             releaseIcon: Column(
//               children: [
//                 Image.asset(
//                   'assets/icons/loading.gif',
//                   scale: 6,
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 Text(
//                   '새로운 질문 받는 중...',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500,
//                     color: mainblue,
//                   ),
//                 ),
//               ],
//             ),
//             completeIcon: Column(
//               children: [
//                 const Icon(
//                   Icons.check_rounded,
//                   color: mainblue,
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 Text(
//                   '완료!',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500,
//                     color: mainblue,
//                   ),
//                 ),
//               ],
//             ),
//             idleIcon: Column(
//               children: [
//                 Image.asset(
//                   'assets/icons/loading.png',
//                   scale: 12,
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Text(
//                   '당겨주세요',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w500,
//                     color: mainblue,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           footer: ClassicFooter(
//             completeDuration: Duration.zero,
//             textStyle: TextStyle(color: mainblack),
//             loadingText: "",
//             canLoadingText: "",
//             idleText: "",
//             idleIcon: Container(),
//             loadingIcon: Image.asset(
//               'assets/icons/loading.gif',
//               scale: 6,
//             ),
//             canLoadingIcon: Image.asset(
//               'assets/icons/loading.gif',
//               scale: 6,
//             ),
//           ),
//           onRefresh: homeController.onQuestionRefresh,
//           onLoading: homeController.onQuestionLoading,
//           child: CustomScrollView(
//             physics: BouncingScrollPhysics(),
//             key: PageStorageKey("key2"),
//             slivers: [
//               SliverList(
//                 delegate: SliverChildListDelegate(
//                   [
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   DropdownButtonHideUnderline(
//                                     child: DropdownButton2(
//                                       itemHeight: 48,
//                                       isDense: true,
//                                       items: ["모든 질문", "나의 질문"].map((value) {
//                                         return DropdownMenuItem(
//                                           value: value,
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                               right: 4,
//                                             ),
//                                             child: Text(value,
//                                                 style: kSubTitle2Style),
//                                           ),
//                                         );
//                                       }).toList(),
//                                       value: homeController.selectgroup.value,
//                                       onChanged: (String? value) {
//                                         homeController.selectgroup(value);

//                                         homeController
//                                             .onQuestionRefresh()
//                                             .then((_) {
//                                           if (value == '모든 질문') {
//                                             homeController.isMyQuestionLoading
//                                                 .value = true;
//                                           } else {
//                                             homeController.isAllQuestionLoading
//                                                 .value = true;
//                                           }
//                                         });
//                                       },
//                                       icon: const Icon(
//                                         Icons.expand_more_rounded,
//                                         color: mainblack,
//                                       ),
//                                       iconSize: 24,
//                                       buttonHeight: 48,
//                                       buttonPadding: const EdgeInsets.only(
//                                           left: 16, right: 16),
//                                       buttonElevation: 0,
//                                       dropdownMaxHeight: 200,
//                                       dropdownPadding: null,
//                                       dropdownDecoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8),
//                                         color: mainWhite,
//                                       ),
//                                       dropdownElevation: 1,
//                                       offset: const Offset(16, 0),
//                                     ),
//                                   ),
//                                   (homeController.selectgroup.value == '모든 질문')
//                                       ? (homeController
//                                                   .isAllQuestionEmpty.value ==
//                                               false)
//                                           ? InkWell(
//                                               onTap: () {
//                                                 Get.to(() =>
//                                                     QuestionAddContentScreen());
//                                               },
//                                               child: Text(
//                                                 "질문 남기기",
//                                                 style: kSubTitle2Style.copyWith(
//                                                     color: mainblue),
//                                               ),
//                                             )
//                                           : Container()
//                                       : Container(),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               (homeController.selectgroup.value == "모든 질문")
//                   ? (homeController.isAllQuestionEmpty.value == false)
//                       ? SliverList(
//                           delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                               return GestureDetector(
//                                 //on tap event 발생시
//                                 onTap: () async {},
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                     right: 16,
//                                     left: 16,
//                                     top: 8,
//                                   ),
//                                   child: (homeController
//                                               .isAllQuestionLoading.value ==
//                                           false)
//                                       ? QuestionWidget(
//                                           item: homeController.questionResult
//                                               .value.questionitems[index],
//                                         )
//                                       : Column(
//                                           children: [
//                                             Image.asset(
//                                               'assets/icons/loading.gif',
//                                               scale: 6,
//                                             ),
//                                             const Text(
//                                               '모든 질문 받아오는 중...',
//                                               style: TextStyle(
//                                                   fontSize: 10,
//                                                   color: mainblue),
//                                             )
//                                           ],
//                                         ),
//                                 ),
//                               );
//                             },
//                             childCount:
//                                 (homeController.isAllQuestionLoading.value ==
//                                         false)
//                                     ? homeController.questionResult.value
//                                         .questionitems.length
//                                     : 1,
//                           ),
//                         )
//                       : SliverList(
//                           delegate:
//                               SliverChildBuilderDelegate((context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.only(top: 24),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     '아직 관심사와 관련된 질문이 없어요',
//                                     style: kSubTitle2Style,
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Get.to(() => QuestionAddContentScreen());
//                                     },
//                                     child: Text(
//                                       '질문 남기기',
//                                       style: kSubTitle2Style.copyWith(
//                                         color: mainblue,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }, childCount: 1),
//                         )
//                   : (homeController.isMyQuestionEmpty.value == false)
//                       ? SliverList(
//                           delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                               return GestureDetector(
//                                 //on tap event 발생시
//                                 onTap: () async {},
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(16, 8, 16, 8),
//                                   child: (homeController
//                                               .isMyQuestionLoading.value ==
//                                           false)
//                                       ? QuestionWidget(
//                                           item: homeController.questionResult
//                                               .value.questionitems[index],
//                                         )
//                                       : Column(
//                                           children: [
//                                             Image.asset(
//                                               'assets/icons/loading.gif',
//                                               scale: 6,
//                                             ),
//                                             Text(
//                                               '나의 질문 받아오는 중...',
//                                               style: TextStyle(
//                                                   fontSize: 10,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: mainblue),
//                                             )
//                                           ],
//                                         ),
//                                 ),
//                               );
//                             },
//                             childCount:
//                                 (homeController.isMyQuestionLoading.value ==
//                                         false)
//                                     ? homeController.questionResult.value
//                                         .questionitems.length
//                                     : 1,
//                           ),
//                         )
//                       : SliverList(
//                           delegate: SliverChildBuilderDelegate(
//                             (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.only(top: 20),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       '아직 남긴 질문이 없어요',
//                                       style: kSubTitle2Style,
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         Get.to(
//                                             () => QuestionAddContentScreen());
//                                       },
//                                       child: Text(
//                                         '질문 남기기',
//                                         style: kSubTitle2Style.copyWith(
//                                           color: mainblue,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                             childCount: 1,
//                           ),
//                         ),
//               if (homeController.enableQuestionPullup.value == false)
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Center(
//                               child: Text(
//                                 '질문을 모두 보여드렸어요',
//                                 style: kSubTitle2Style.copyWith(
//                                   color: mainblack,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             Center(
//                               child: Text(
//                                 '검색을 통해 더 많은 질문들을 찾아보세요',
//                                 style: kButtonStyle.copyWith(
//                                   color: mainblack.withOpacity(0.6),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     childCount: 1,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
