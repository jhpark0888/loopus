// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/model/user_model.dart';
// import 'package:loopus/screen/other_profile_screen.dart';
// import 'package:loopus/widget/person_image_widget.dart';
// import 'package:loopus/widget/user_image_widget.dart';

// class RealTimeRankWidget extends StatelessWidget {
//   RealTimeRankWidget({Key? key, required this.user}) : super(key: key);

//   User user;

//   // RxString text = ''.obs;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//       child: Row(children: [
//         Column(
//           children: [
//             PersonImageWidget(user: user),
//             const SizedBox(height: 7),
//             Text(
//               user.realName,
//               style: k15normal,
//             )
//           ],
//         ),
//         const SizedBox(width: 14),
//         Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//           Text(
//             user.rank.toString(),
//             style: k15normal.copyWith(fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 3),
//           rate(user.trend)
//         ]),
//         const SizedBox(width: 14),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(user.univ != "" ? user.univ : '땡땡대', style: k15normal),
//             const SizedBox(height: 7),
//             Text(user.department, style: k15normal),
//             const SizedBox(height: 7),
//             RichText(
//               text: TextSpan(children: [
//                 TextSpan(
//                     text: '최근 포스트 ',
//                     style:
//                         k15normal.copyWith(color: maingray.withOpacity(0.5))),
//                 TextSpan(
//                     text: '${user.resentPostCount.toString()}개',
//                     style: k15normal)
//               ]),
//               textAlign: TextAlign.start,
//             )
//           ],
//         ),
//         const Spacer(),
//         // const SizedBox(width: 14),
//         //Obx(() =>
//         //GestureDetector(
//         Obx(
//           () => Column(children: [
//             Container(
//               width: 74,
//               height: 42,
//               child: RaisedButton(
//                   elevation: 0.0,
//                   color: user.looped.value == FollowState.normal ||
//                           user.looped.value == FollowState.follower
//                       ? mainblue
//                       : cardGray,
//                   child: Center(
//                     child: Text(
//                       user.looped.value == FollowState.normal ||
//                               user.looped.value == FollowState.follower
//                           ? "팔로우"
//                           : "팔로잉",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 16,
//                           fontFamily: 'SUIT',
//                           color: user.looped.value == FollowState.normal ||
//                                   user.looped.value == FollowState.follower
//                               ? mainWhite
//                               : mainblack),
//                     ),
//                   ),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50)),
//                   onPressed: () {
//                     print(user.looped.value);
//                     user.looped.value = user.looped.value == FollowState.normal
//                         ? FollowState.following
//                         : user.looped.value == FollowState.follower
//                             ? FollowState.wefollow
//                             : user.looped.value == FollowState.following
//                                 ? FollowState.normal
//                                 : FollowState.follower;
//                   }),
//             )
//           ]),
//         )
//       ]),
//     );
//   }
// }

// Widget rate(int variance) {
//   return Row(children: [
//     const SizedBox(width: 4),
//     arrowDirection(variance),
//     const SizedBox(width: 2),
//     if (variance != 0)
//       Text('${variance.abs()}',
//           style: kcaption.copyWith(color: variance >= 1 ? rankred : rankblue)),
//   ]);
// }

// Widget arrowDirection(int variance) {
//   if (variance == 0) {
//     return const SizedBox.shrink();
//   } else if (variance >= 1) {
//     return SvgPicture.asset('assets/icons/rate_upper_arrow.svg');
//   } else {
//     return SvgPicture.asset('assets/icons/rate_down_arrow.svg');
//   }
// }
