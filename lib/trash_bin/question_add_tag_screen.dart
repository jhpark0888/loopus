// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loopus/api/question_api.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/question_add_controller.dart';
// import 'package:loopus/controller/tag_controller.dart';
// import 'package:loopus/widget/appbar_widget.dart';
// import 'package:loopus/widget/tagsearchwidget.dart';

// class QuestionAddTagScreen extends StatelessWidget {
//   QuestionAddController questionaddController = Get.find();
//   TagController tagController = Get.put(
//       TagController(tagtype: Tagtype.question),
//       tag: Tagtype.question.toString());

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Stack(children: [
//         Scaffold(
//           appBar: AppBarWidget(
//             bottomBorder: false,
//             actions: [
//               Obx(
//                 () => TextButton(
//                     onPressed: postQuestion,
//                     child: Text(
//                       '올리기',
//                       style: tagController.selectedtaglist.length == 3
//                           ? kSubTitle2Style.copyWith(color: mainblue)
//                           : kSubTitle2Style.copyWith(
//                               color: mainblack.withOpacity(0.38)),
//                     )),
//               ),
//             ],
//             title: "질문 태그",
//           ),
//           body: GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: NestedScrollView(
//                 headerSliverBuilder: (context, value) {
//                   return [
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(
//                           32,
//                           24,
//                           32,
//                           12,
//                         ),
//                         child: Column(
//                           children: [
//                             RichText(
//                               textAlign: TextAlign.center,
//                               text: TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: '질문 태그',
//                                     style: kSubTitle2Style.copyWith(
//                                       color: mainblue,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: '를 선택해주세요',
//                                     style: kSubTitle2Style,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16,
//                             ),
//                             Text(
//                               '해당 태그에 관심있는 학생에게 질문을 보여드릴게요',
//                               style: kBody1Style,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ];
//                 },
//                 body: TagSearchWidget(
//                   tagtype: Tagtype.question,
//                 )),
//           ),
//         ),
//         if (questionaddController.isQuestionUploading.value)
//           Container(
//             height: Get.height,
//             width: Get.width,
//             color: mainblack.withOpacity(0.3),
//             child: Image.asset(
//               'assets/icons/loading.gif',
//               scale: 6,
//             ),
//           ),
//       ]),
//     );
//   }

//   void postQuestion() {
//     if (tagController.selectedtaglist.length == 3) {
//       tagController.tagsearchfocusNode.unfocus();
//       questionaddController.isQuestionUploading(true);
//       postquestion(questionaddController.contentcontroller.text).then((value) {
//         questionaddController.isQuestionUploading(false);
//       });
//     }
//   }
// }
