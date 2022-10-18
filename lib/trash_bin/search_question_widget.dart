// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/profile_controller.dart';
// import 'package:loopus/model/question_model.dart';
// import 'package:loopus/screen/other_profile_screen.dart';
// import 'package:loopus/screen/question_detail_screen.dart';
// import 'package:loopus/widget/tag_widget.dart';

// import '../controller/hover_controller.dart';

// class SearchQuestionWidget extends StatelessWidget {
//   ProfileController profileController = Get.find();

//   QuestionItem item;

//   SearchQuestionWidget({
//     required this.item,
//   });
//   late final HoverController _hoverController =
//       Get.put(HoverController(), tag: 'searchQuestion${item.id}');

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (details) => _hoverController.isHoverState(),
//       onTapCancel: () => _hoverController.isNonHoverState(),
//       onTapUp: (details) => _hoverController.isNonHoverState(),
//       onTap: tapQuestion,
//       child: Obx(
//         () => AnimatedScale(
//           scale: _hoverController.scale.value,
//           duration: Duration(milliseconds: 100),
//           curve: kAnimationCurve,
//           child: Container(
//             decoration: kCardStyle,
//             margin: const EdgeInsets.symmetric(
//               vertical: 8,
//               horizontal: 16,
//             ),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 16,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Text(
//                   "${item.content}",
//                   style: kSubTitle1Style,
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: item.questionTag
//                         .map((tag) => Row(children: [
//                               Tagwidget(
//                                 tag: tag,
//                                 fontSize: 12,
//                               ),
//                               item.questionTag.indexOf(tag) !=
//                                       item.questionTag.length - 1
//                                   ? const SizedBox(
//                                       width: 8,
//                                     )
//                                   : Container()
//                             ]))
//                         .toList()),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         InkWell(
//                           onTap: tapProfile,
//                           child: Row(
//                             children: [
//                               ClipOval(
//                                 child: item.user.profileImage == null
//                                     ? ClipOval(
//                                         child: Image.asset(
//                                           "assets/illustrations/default_profile.png",
//                                           height: 32,
//                                           width: 32,
//                                         ),
//                                       )
//                                     : CachedNetworkImage(
//                                         height: 32,
//                                         width: 32,
//                                         imageUrl: item.user.profileImage!,
//                                         placeholder: (context, url) =>
//                                             kProfilePlaceHolder(),
//                                         fit: BoxFit.cover,
//                                       ),
//                               ),
//                               SizedBox(
//                                 width: 8,
//                               ),
//                               Text("${item.user.name} · ",
//                                   style: kButtonStyle),
//                             ],
//                           ),
//                         ),
//                         Text(
//                           "${item.user.department}",
//                           style: kBody2Style,
//                         ),
//                       ],
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset("assets/icons/Comment.svg"),
//                         const SizedBox(
//                           width: 4,
//                         ),
//                         (item.answercount == 0)
//                             ? Text(
//                                 '답변하기',
//                                 style: kButtonStyle.copyWith(height: 0.8),
//                               )
//                             : Text(
//                                 "${item.answercount}",
//                                 style: kButtonStyle.copyWith(height: 0.9),
//                               ),
//                       ],
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void tapQuestion() async {
//     // questionController.messageanswerlist.clear();
//     // await questionController.loadItem(item.id);
//     // await questionController.addanswer();
//     Get.to(() => QuestionDetailScreen(
//           questionid: item.id,
//           isuser: item.isuser,
//           realname: item.user.name,
//         ));
//   }

//   void tapProfile() {
//     // AppController.to.ismyprofile.value = false;
//     Get.to(() => OtherProfileScreen(
//           userid: item.userid,
//           isuser: item.isuser,
//           realname: item.user.name,
//         ));
//   }
// }
