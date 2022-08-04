// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';

// import 'package:loopus/api/post_api.dart';
// import 'package:loopus/constant.dart';
// import 'package:loopus/controller/bookmark_controller.dart';
// import 'package:loopus/controller/home_controller.dart';
// import 'package:loopus/controller/like_controller.dart';
// import 'package:loopus/controller/profile_controller.dart';
// import 'package:loopus/model/post_model.dart';
// import 'package:loopus/screen/posting_screen.dart';
// import 'package:loopus/screen/other_profile_screen.dart';

// class BookmarkWidget extends StatelessWidget {
//   final int index;
//   Post item;

//   BookmarkWidget({
//     required this.index,
//     required this.item,
//   });
//   ProfileController profileController = Get.find();
//   BookmarkController bookmarkController = Get.put(BookmarkController());
//   late final LikeController likeController = Get.put(
//       LikeController(
//           isLiked: item.isLiked,
//           id: item.id,
//           lastisliked: item.isLiked.value,
//           liketype: Liketype.post),
//       tag: 'posting${item.id}');

//   HomeController homeController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: tapPosting,
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 16,
//             ),
//             decoration: BoxDecoration(
//               color: mainWhite,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//                 bottomLeft: Radius.circular(8),
//                 bottomRight: Radius.circular(8),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 3,
//                   offset: Offset(0.0, 1.0),
//                   color: Colors.black.withOpacity(0.1),
//                 ),
//                 BoxShadow(
//                   blurRadius: 2,
//                   offset: Offset(0.0, 1.0),
//                   color: Colors.black.withOpacity(0.06),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Container(
//                   child: Text(item.content, style: kSubTitle4Style),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Text(
//                   item.project!.careerName,
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
//                             onTap: () async {
//                               // AppController.to.ismyprofile.value = false;
//                               // await tapProfile();

//                               Get.to(() => OtherProfileScreen(
//                                     userid: item.userid,
//                                     isuser: item.isuser,
//                                     realname: item.user.realName,
//                                   ));
//                             },
//                             child: Row(
//                               children: [
//                                 ClipOval(
//                                     child: item.user.profileImage == null
//                                         ? Image.asset(
//                                             "assets/illustrations/default_profile.png",
//                                             height: 32,
//                                             width: 32,
//                                           )
//                                         : CachedNetworkImage(
//                                             height: 32,
//                                             width: 32,
//                                             imageUrl:
//                                                 "${item.user.profileImage}",
//                                             placeholder: (context, url) =>
//                                                 kProfilePlaceHolder(),
//                                             fit: BoxFit.fill,
//                                           )),
//                                 SizedBox(
//                                   width: 8,
//                                 ),
//                                 Text(
//                                   "${item.user.realName} · ",
//                                   style: kButtonStyle,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Text(
//                             "${item.user.department}",
//                             style: kBody2Style,
//                           ),
//                         ],
//                       ),
//                       Obx(
//                         () => Row(
//                           children: [
//                             InkWell(
//                               onTap: tapLike,
//                               child: item.isLiked.value == 0
//                                   ? SvgPicture.asset(
//                                       "assets/icons/Favorite_Inactive.svg")
//                                   : SvgPicture.asset(
//                                       "assets/icons/Favorite_Active.svg"),
//                             ),
//                             SizedBox(
//                               width: 4,
//                             ),
//                             Text(
//                               "${item.likeCount.value}",
//                               style: kButtonStyle,
//                             ),
//                             SizedBox(
//                               width: 16,
//                             ),
//                             InkWell(
//                               onTap: tapBookmark,
//                               child: item.isMarked.value == 0 //0: 비활성 1: 활성
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
//         ],
//       ),
//     );
//   }

//   void tapBookmark() async {
//     int bookmarkid =
//         bookmarkController.bookmarkResult.value.postingitems[index].id;
//     if (item.isMarked.value == 0) {
//       item.isMarked.value = 1;
//       await bookmarkpost(item.id);
//     } else {
//       HomeController.to.tapunBookmark(bookmarkid);
//       bookmarkController.bookmarkResult.value.postingitems.removeAt(index);

//       if (bookmarkController.bookmarkResult.value.postingitems.isEmpty) {
//         bookmarkController.isBookmarkEmpty.value = true;
//       }
//       item.isMarked.value = 0;
//     }
//   }

//   void tapLike() {
//     int bookmarkid =
//         bookmarkController.bookmarkResult.value.postingitems[index].id;
//     if (item.isLiked.value == 0) {
//       likeController.isLiked(1);
//       item.likeCount.value += 1;

//       HomeController.to.tapLike(bookmarkid, item.likeCount.value);
//       item.isLiked.value = 1;
//     } else {
//       likeController.isLiked(0);
//       item.likeCount.value -= 1;

//       HomeController.to.tapunLike(bookmarkid, item.likeCount.value);
//       item.isLiked.value = 0;
//     }
//   }

//   Future<void> tapProfile() async {
//     Get.to(() => OtherProfileScreen(
//           userid: item.userid,
//           isuser: item.isuser,
//           realname: item.user.realName,
//         ));
//   }

//   void tapPosting() {
//     Get.to(
//         () => PostingScreen(
//               post: item,
//               postid: item.id,
//               // likecount: item.likeCount,
//               // isLiked: item.isLiked,
//             ),
//         opaque: false);
//   }
// }
