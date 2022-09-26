// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/model/question_model.dart';
// import 'package:loopus/screen/other_profile_screen.dart';
// import 'package:loopus/utils/duration_calculate.dart';

// class QuestionDetailWidget extends StatelessWidget {
//   QuestionItem question;

//   QuestionDetailWidget({
//     required this.question,
//   });
//   // const MessageQuestionWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 "${question.content}",
//                 style: ktempFont,
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Get.to(() => OtherProfileScreen(
//                                 userid: question.userid,
//                                 realname: question.user.realName,
//                               ));
//                         },
//                         child: Row(
//                           children: [
//                             ClipOval(
//                                 child: question.user.profileImage == null
//                                     ? Image.asset(
//                                         "assets/illustrations/default_profile.png",
//                                         height: 32,
//                                         width: 32,
//                                       )
//                                     : CachedNetworkImage(
//                                         height: 32,
//                                         width: 32,
//                                         imageUrl: question.user.profileImage!,
//                                         placeholder: (context, url) =>
//                                             kProfilePlaceHolder(),
//                                         fit: BoxFit.cover,
//                                       )),
//                             SizedBox(
//                               width: 8,
//                             ),
//                             Text(
//                               "${question.user.realName} · ",
//                               style: ktempFont,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Text("${question.user.department}", style: ktempFont),
//                     ],
//                   ),
//                   Text(
//                     " · ${messageDurationCalculate(question.date!)}",
//                     style:
//                         ktempFont.copyWith(color: mainblack.withOpacity(0.6)),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
