// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/home_controller.dart';
// import 'package:loopus/model/post_model.dart';
// import 'package:loopus/screen/posting_screen.dart';
// import 'package:loopus/screen/other_profile_screen.dart';

// import '../controller/hover_controller.dart';

// class SearchPostingWidget extends StatelessWidget {
//   SearchPostingWidget({
//     required this.post,
//   });

//   Post post;
//   final HomeController homeController = Get.find();
//   late final HoverController _hoverController =
//       Get.put(HoverController(), tag: 'searchPosting${post.id}');

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (details) => _hoverController.isHoverState(),
//       onTapCancel: () => _hoverController.isNonHoverState(),
//       onTapUp: (details) => _hoverController.isNonHoverState(),
//       onTap: () {
//         Get.to(
//             () => PostingScreen(
//                   post: null,
//                   postid: post.id,
//                   // likecount: post.likeCount,
//                   // isLiked: post.isLiked,
//                 ),
//             opaque: false,
//             preventDuplicates: false);
//       },
//       child: Obx(
//         () => AnimatedScale(
//           scale: _hoverController.scale.value,
//           duration: Duration(milliseconds: 100),
//           curve: kAnimationCurve,
//           child: Container(
//             margin: const EdgeInsets.symmetric(
//               vertical: 8,
//               horizontal: 16,
//             ),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 16,
//             ),
//             decoration: kCardStyle,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Container(
//                   child: Text(
//                     post.content.value,
//                     style: kSubTitle4Style,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 Text(
//                   post.project!.careerName,
//                   style: kBody2Style.copyWith(
//                     color: mainblack.withOpacity(
//                       0.6,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Container(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           InkWell(
//                             onTap: tapProfile,
//                             child: Row(
//                               children: [
//                                 ClipOval(
//                                     child: post.user.profileImage == null
//                                         ? Image.asset(
//                                             "assets/illustrations/default_profile.png",
//                                             height: 32,
//                                             width: 32,
//                                           )
//                                         : CachedNetworkImage(
//                                             height: 32,
//                                             width: 32,
//                                             imageUrl:
//                                                 "${post.user.profileImage}",
//                                             placeholder: (context, url) =>
//                                                 kProfilePlaceHolder(),
//                                             fit: BoxFit.cover,
//                                           )),
//                                 SizedBox(
//                                   width: 8,
//                                 ),
//                                 Text(
//                                   "${post.user.realName} · ",
//                                   style: kButtonStyle,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Text(
//                             "${post.user.department}",
//                             style: kBody2Style,
//                           ),
//                         ],
//                       ),
//                       Obx(
//                         () => Row(
//                           children: [
//                             // InkWell(
//                             //   onTap: () {
//                             //     if (post.isLiked.value == 0) {
//                             //       post.likeCount.value += 1;
//                             //       HomeController.to
//                             //           .tapLike(post.id, post.likeCount.value);
//                             //       post.isLiked.value = 1;
//                             //     } else {
//                             //       post.likeCount.value -= 1;
//                             //       HomeController.to
//                             //           .tapunLike(post.id, post.likeCount.value);
//                             //       post.isLiked.value = 0;
//                             //     }
//                             //   },
//                             //   child: post.isLiked.value == 0
//                             //       ? SvgPicture.asset(
//                             //           "assets/icons/Favorite_Inactive.svg")
//                             //       : SvgPicture.asset(
//                             //           "assets/icons/Favorite_Active.svg"),
//                             // ),
//                             // SizedBox(
//                             //   width: 4,
//                             // ),
//                             // Text(
//                             //   "${post.likeCount.value}",
//                             //   style: TextStyle(fontWeight: FontWeight.bold),
//                             // ),
//                             // SizedBox(
//                             //   width: 16,
//                             // ),
//                             InkWell(
//                               onTap: tapBookmark,
//                               child: post.isMarked.value == 0
//                                   ? SvgPicture.asset(
//                                       "assets/icons/bookmark_inactive.svg",
//                                       color: mainblack,
//                                     )
//                                   : SvgPicture.asset(
//                                       "assets/icons/bookmark_active.svg"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void tapBookmark() {
//     if (post.isMarked.value == 0) {
//       HomeController.to.tapBookmark(post.id);
//       post.isMarked.value = 1;
//     } else {
//       HomeController.to.tapunBookmark(post.id);
//       post.isMarked.value = 0;
//     }
//   }

//   void tapProfile() {
//     Get.to(() => OtherProfileScreen(
//           userid: post.userid,
//           realname: post.user.realName,
//         ));
//   }
// }
