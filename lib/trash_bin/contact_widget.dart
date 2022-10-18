// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/model/contact_model.dart';
// import 'package:loopus/screen/other_profile_screen.dart';
// import 'package:loopus/utils/duration_calculate.dart';
// import 'package:loopus/widget/company_image_widget.dart';
// import 'package:loopus/widget/user_image_widget.dart';

// class ContactWidget extends StatelessWidget {
//   ContactWidget({Key? key, required this.contact}) : super(key: key);

//   Contact contact;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {},
//       splashColor: kSplashColor,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Column(
//                     children: <Widget>[
//                       CompanyImageWidget(
//                           imageUrl: contact.company.companyImage),
//                       const SizedBox(
//                         height: 14,
//                       ),
//                       Text(
//                         contact.company.companyName,
//                         style: kmain,
//                       ),
//                       const SizedBox(
//                         height: 14,
//                       ),
//                       RichText(
//                         text: TextSpan(children: [
//                           TextSpan(
//                             text: contact.company.contactField.split(",").first,
//                             style: kmainheight
//                           ),
//                           // const TextSpan(
//                           //   text: ' 분야 컨택 중',
//                           //   style: kmainheight,
//                           // ),
//                         ]),
//                       ),
//                       Text(
//                         "${contact.company.contactcount.value}건의 컨택 진행",
//                         style: kmainheight,
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: tapProfile,
//                     behavior: HitTestBehavior.translucent,
//                     child: Column(
//                       children: <Widget>[
//                         UserImageWidget(
//                             imageUrl: contact.user.profileImage ?? ""),
//                         const SizedBox(
//                           height: 14,
//                         ),
//                         Text(
//                           contact.user.realName,
//                           style: kmain,
//                         ),
//                         const SizedBox(
//                           height: 14,
//                         ),
//                         Text(
//                           "땡땡대",
//                           style: kmainheight,
//                         ),
//                         Text(
//                           contact.user.department,
//                           style: kmainheight,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               child: Text(
//                 calculateDate(contact.date),
//                 style: kmain,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void tapProfile() {
//     Get.to(
//         () => OtherProfileScreen(
//             user: contact.user,
//             userid: contact.user.userid,
//             realname: contact.user.realName),
//         preventDuplicates: false);
//   }
// }

// // class ContactWidget extends StatelessWidget {
// //   ContactWidget({Key? key, required this.contact}) : super(key: key);

// //   Contact contact;

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: () {},
// //       splashColor: kSplashColor,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceAround,
// //               children: <Widget>[
// //                 Column(
// //                   children: <Widget>[
// //                     CompanyImageWidget(imageUrl: contact.company.companyImage),
// //                     const SizedBox(
// //                       height: 14,
// //                     ),
// //                     Text(
// //                       contact.company.companyName,
// //                       style: kmain,
// //                     ),
// //                     const SizedBox(
// //                       height: 14,
// //                     ),
// //                   ],
// //                 ),
// //                 Center(
// //                   child: Text(
// //                     calculateDate(contact.date),
// //                     style: kmain,
// //                   ),
// //                 ),
// //                 Column(
// //                   children: <Widget>[
// //                     UserImageWidget(imageUrl: contact.user.profileImage ?? ""),
// //                     const SizedBox(
// //                       height: 14,
// //                     ),
// //                     Text(
// //                       contact.user.realName,
// //                       style: kmain,
// //                     ),
// //                     const SizedBox(
// //                       height: 14,
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 RichText(
// //                   text: TextSpan(children: [
// //                     TextSpan(
// //                       text: contact.company.contactField.split(",").first,
// //                       style: kmainheight.copyWith(color: mainblue),
// //                     ),
// //                     TextSpan(
// //                       text:
// //                           ' 분야 컨택 중\n${contact.company.contactcount.value}건의 컨택 진행',
// //                       style: kmainheight,
// //                     ),
// //                   ]),
// //                 ),
// //                 Text(
// //                   "땡땡대\n${contact.user.department}",
// //                   style: kmainheight,
// //                 ),
// //               ],
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
