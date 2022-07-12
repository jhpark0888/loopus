// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loopus/api/post_api.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/post_detail_controller.dart';
// import 'package:loopus/controller/posting_add_controller.dart';
// import 'package:loopus/screen/posting_add_tag_screen.dart';
// import 'package:loopus/widget/appbar_widget.dart';
// import 'package:loopus/widget/custom_textfield.dart';

// import '../controller/modal_controller.dart';

// class PostingAddNameScreen extends StatelessWidget {
//   PostingAddNameScreen(
//       {Key? key, this.postid, required this.project_id, required this.route})
//       : super(key: key);
//   late PostingAddController postingAddController =
//       Get.put(PostingAddController(route: route));
//   final FocusNode _focusNode = FocusNode();
//   int project_id;
//   int? postid;
//   PostaddRoute route;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         appBar: AppBarWidget(
//           bottomBorder: false,
//           actions: [
//             postingAddController.route != PostaddRoute.update
//                 ? Obx(
//                     () => TextButton(
//                       onPressed: postingAddController.isPostingTitleEmpty.value
//                           ? () {}
//                           : () {
//                               _focusNode.unfocus();
//                               postingAddController.isPostingContentEmpty.value =
//                                   false;

//                               Get.to(() => PostingAddTagScreen(
//                                     projectId: project_id,
//                                     screenType: Screentype.add,
//                                   ));
//                             },
//                       child: Text(
//                         '다음',
//                         style: kSubTitle2Style.copyWith(
//                           color: postingAddController.isPostingTitleEmpty.value
//                               ? mainblack.withOpacity(0.38)
//                               : mainblue,
//                         ),
//                       ),
//                     ),
//                   )
//                 : Obx(
//                     () => Get.find<PostingDetailController>(
//                                 tag: postid.toString())
//                             .isPostUpdateLoading
//                             .value
//                         ? Image.asset(
//                             'assets/icons/loading.gif',
//                             scale: 9,
//                           )
//                         : TextButton(
//                             onPressed: postingAddController
//                                     .isPostingTitleEmpty.value
//                                 ? () {}
//                                 : () async {
//                                     PostingDetailController controller =
//                                         Get.find<PostingDetailController>(
//                                             tag: postid.toString());
//                                     _focusNode.unfocus();
//                                     controller.isPostUpdateLoading.value = true;
//                                     await updateposting(
//                                             postid!, PostingUpdateType.title)
//                                         .then((value) {
//                                       controller.isPostUpdateLoading(false);
//                                     });
//                                   },
//                             child: Text(
//                               '저장',
//                               style: kSubTitle2Style.copyWith(
//                                 color: postingAddController
//                                         .isPostingTitleEmpty.value
//                                     ? mainblack.withOpacity(0.38)
//                                     : mainblue,
//                               ),
//                             ),
//                           ),
//                   ),
//           ],
//           title: '포스트 작성',
//         ),
//         body: Padding(
//           padding: const EdgeInsets.fromLTRB(
//             32,
//             24,
//             32,
//             40,
//           ),
//           child: Column(
//             children: [
//               RichText(
//                 textAlign: TextAlign.center,
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: '포스팅 내용',
//                       style: kSubTitle2Style.copyWith(
//                         color: mainblue,
//                       ),
//                     ),
//                     TextSpan(
//                       text: '을 작성해주세요',
//                       style: kSubTitle2Style,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 12,
//               ),
//               Text('나중에 얼마든지 수정할 수 있어요', style: kBody2Style),
//               SizedBox(
//                 height: 32,
//               ),
//               CustomTextField(
//                   counterText: null,
//                   maxLength: 500,
//                   textController: postingAddController.textcontroller,
//                   hintText: '포스팅 내용...',
//                   validator: null,
//                   obscureText: false,
//                   maxLines: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
