// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/home_controller.dart';
// import 'package:loopus/controller/like_controller.dart';
// import 'package:loopus/controller/project_detail_controller.dart';
// import 'package:loopus/model/post_model.dart';
// import 'package:loopus/screen/likepeople_screen.dart';
// import 'package:loopus/screen/posting_screen.dart';
// import 'package:intl/intl.dart';

// class ProjectPostingWidget extends StatelessWidget {
//   ProjectPostingWidget({
//     Key? key,
//     required this.isuser,
//     required this.item,
//     required this.realname,
//     required this.profileimage,
//     required this.department,
//   }) : super(key: key);

//   late LikeController likeController = Get.put(
//       LikeController(
//           isliked: item.value.isLiked,
//           id: item.value.id,
//           lastisliked: item.value.isLiked.value),
//       tag: item.value.id.toString());
//   Rx<Post> item;
//   int isuser;
//   String realname;
//   var profileimage;
//   String department;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Get.to(
//             () => PostingScreen(
//                   post: item.value,
//                   postid: item.value.id,
//                   likecount: item.value.likeCount,
//                   isLiked: item.value.isLiked,
//                 ),
//             preventDuplicates: false);
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(
//           bottom: 16,
//         ),
//         child: Column(
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Obx(
//                   () => Container(
//                     width: Get.width,
//                     height: Get.width / 2,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         image: DecorationImage(
//                             image: item.value.images[0] != null
//                                 ? NetworkImage(item.value.images[0])
//                                 : const AssetImage(
//                                     "assets/illustrations/default_image.png",
//                                   ) as ImageProvider,
//                             fit: BoxFit.cover)),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Obx(
//                   () => Text(
//                     item.value.content,
//                     style: kSubTitle1Style,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 SizedBox(
//                   height: 12,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       '${DateFormat('yy.MM.dd').format(item.value.date)}',
//                       style: kBody2Style.copyWith(
//                         color: mainblack.withOpacity(
//                           0.6,
//                         ),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Obx(() => InkWell(
//                             onTap: () {
//                               if (item.value.isLiked.value == 0) {
//                                 likeController.isliked(1);

//                                 item.value.likeCount += 1;
//                                 HomeController.to.tapLike(
//                                     item.value.id, item.value.likeCount.value);

//                                 item.value.isLiked.value = 1;
//                               } else {
//                                 likeController.isliked(0);

//                                 item.value.likeCount -= 1;
//                                 HomeController.to.tapunLike(
//                                     item.value.id, item.value.likeCount.value);

//                                 item.value.isLiked.value = 0;
//                               }
//                             },
//                             child: item.value.isLiked.value == 0
//                                 ? SvgPicture.asset(
//                                     "assets/icons/Favorite_Inactive.svg")
//                                 : SvgPicture.asset(
//                                     "assets/icons/Favorite_Active.svg"))),
//                         SizedBox(
//                           width: 4,
//                         ),
//                         Obx(
//                           () => GestureDetector(
//                             behavior: HitTestBehavior.translucent,
//                             onTap: () {
//                               Get.to(() => LikePeopleScreen(
//                                     postid: item.value.id,
//                                   ));
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 4),
//                               child: Text(
//                                 item.value.likeCount.value != 0
//                                     ? "${item.value.likeCount.value}   \u200B"
//                                     : ' \u200B',
//                                 style: kButtonStyle,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Obx(() => InkWell(
//                             onTap: () {
//                               if (item.value.isMarked.value == 0) {
//                                 HomeController.to.tapBookmark(item.value.id);
//                                 item.value.isMarked(1);
//                               } else {
//                                 HomeController.to.tapunBookmark(item.value.id);
//                                 item.value.isMarked(0);
//                               }
//                             },
//                             child: item.value.isMarked.value == 0
//                                 ? SvgPicture.asset(
//                                     "assets/icons/bookmark_inactive.svg")
//                                 : SvgPicture.asset(
//                                     "assets/icons/bookmark_active.svg")))
//                       ],
//                     )
//                   ],
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             Container(
//               height: 1,
//               color: Color(0xffe7e7e7),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
