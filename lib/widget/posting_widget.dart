// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:loopus/constant.dart';

// import 'package:loopus/controller/home_controller.dart';
// import 'package:loopus/controller/hover_controller.dart';
// import 'package:loopus/controller/like_controller.dart';
// import 'package:loopus/controller/profile_controller.dart';

// import 'package:loopus/model/post_model.dart';
// import 'package:loopus/screen/likepeople_screen.dart';

// import 'package:loopus/screen/posting_screen.dart';
// import 'package:loopus/screen/other_profile_screen.dart';
// import 'package:loopus/screen/project_screen.dart';

// import 'package:loopus/widget/tag_widget.dart';

// class PostingWidget extends StatelessWidget {
//   // final int index;
//   Post item;

//   PostingWidget({required this.item, Key? key}) : super(key: key);

//   final ProfileController profileController = Get.find();
//   late final LikeController likeController = Get.put(
//       LikeController(
//           isliked: item.isLiked, id: item.id, lastisliked: item.isLiked.value),
//       tag: item.id.toString());
//   late final HoverController _hoverController =
//       Get.put(HoverController(), tag: 'posting${item.id}');
//   // final PostingDetailController postingDetailController =
//   //     Get.put(PostingDetailController());

//   final HomeController homeController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (details) => _hoverController.isHoverState(),
//       onTapCancel: () => _hoverController.isNonHoverState(),
//       onTapUp: (details) => _hoverController.isNonHoverState(),
//       onTap: tapPosting,
//       child: Column(
//         children: [
//           Obx(
//             () => AnimatedScale(
//               scale: _hoverController.scale.value,
//               duration: Duration(milliseconds: 100),
//               curve: kAnimationCurve,
//               child: Container(
//                 decoration: kCardStyle,
//                 child: Column(
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(8),
//                         topRight: Radius.circular(8),
//                       ),
//                       child: (item.images[0] == null)
//                           ? Image.asset(
//                               "assets/illustrations/default_image.png",
//                               height: Get.width / 2 * 1,
//                               width: Get.width,
//                               fit: BoxFit.cover,
//                             )
//                           : CachedNetworkImage(
//                               height: Get.width / 2 * 1,
//                               width: Get.width,
//                               imageUrl: item.images[0],
//                               placeholder: (context, url) => Container(
//                                 color: const Color(0xffe7e7e7),
//                               ),
//                               fit: BoxFit.cover,
//                             ),
//                     ),
//                     Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(8),
//                             bottomRight: Radius.circular(8),
//                           ),
//                           child: Container(
//                             color: mainWhite,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 16,
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item.content,
//                                     style:
//                                         kHeaderH2Style.copyWith(fontSize: 18),
//                                   ),
//                                   SizedBox(
//                                     height: 16,
//                                   ),
//                                   GestureDetector(
//                                     onTap: tapProjectname,
//                                     child: Text(
//                                       item.project!.careerName,
//                                       style: kSubTitle2Style.copyWith(
//                                         color: mainblack.withOpacity(0.6),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 20,
//                                   ),
//                                   // postingTag(),
//                                   const SizedBox(
//                                     height: 16,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           InkWell(
//                                             onTap: tapProfile,
//                                             child: Row(
//                                               children: [
//                                                 Container(
//                                                   height: 32,
//                                                   width: 32,
//                                                   child: ClipOval(
//                                                     child: item.user
//                                                                 .profileImage ==
//                                                             null
//                                                         ? Image.asset(
//                                                             "assets/illustrations/default_profile.png")
//                                                         : CachedNetworkImage(
//                                                             height: 32,
//                                                             width: 32,
//                                                             imageUrl:
//                                                                 "${item.user.profileImage}",
//                                                             placeholder: (context,
//                                                                     url) =>
//                                                                 kProfilePlaceHolder(),
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 8,
//                                                 ),
//                                                 Text("${item.user.realName} · ",
//                                                     style: kButtonStyle),
//                                               ],
//                                             ),
//                                           ),
//                                           Text("${item.user.department}",
//                                               style: kBody2Style),
//                                         ],
//                                       ),
//                                       Obx(
//                                         () => Row(
//                                           children: [
//                                             InkWell(
//                                               onTap: tapLike,
//                                               child: item.isLiked.value == 0
//                                                   ? SvgPicture.asset(
//                                                       "assets/icons/Favorite_Inactive.svg")
//                                                   : SvgPicture.asset(
//                                                       "assets/icons/Favorite_Active.svg"),
//                                             ),
//                                             const SizedBox(
//                                               width: 4,
//                                             ),
//                                             GestureDetector(
//                                               behavior:
//                                                   HitTestBehavior.translucent,
//                                               onTap: () {
//                                                 Get.to(() => LikePeopleScreen(
//                                                       postid: item.id,
//                                                     ));
//                                               },
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                   vertical: 4,
//                                                 ),
//                                                 child: Text(
//                                                   item.likeCount.value != 0
//                                                       ? "${item.likeCount.value}     \u200B"
//                                                       : ' \u200B',
//                                                   style: kButtonStyle,
//                                                 ),
//                                               ),
//                                             ),
//                                             Obx(
//                                               () => SizedBox(
//                                                 width: item.likeCount.value != 0
//                                                     ? 0
//                                                     : 8,
//                                               ),
//                                             ),
//                                             InkWell(
//                                               onTap: tapBookmark,
//                                               child: (item.isMarked.value == 0)
//                                                   ? SvgPicture.asset(
//                                                       "assets/icons/Mark_Default.svg",
//                                                       color: mainblack,
//                                                     )
//                                                   : SvgPicture.asset(
//                                                       "assets/icons/Mark_Saved.svg"),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget postingTag() {
//   //   return Row(
//   //     mainAxisAlignment: MainAxisAlignment.start,
//   //     children: item.project!.projectTag
//   //         .map((tag) => Row(children: [
//   //               Tagwidget(
//   //                 tag: tag,
//   //                 fontSize: 12,
//   //               ),
//   //               item.project!.projectTag.indexOf(tag) !=
//   //                       item.project!.projectTag.length - 1
//   //                   ? const SizedBox(
//   //                       width: 4,
//   //                     )
//   //                   : Container()
//   //             ]))
//   //         .toList(),
//   //   );
//   // }

//   void tapPosting() {
//     Get.to(
//         () => PostingScreen(
//             userid: item.userid,
//             isuser: item.isuser,
//             postid: item.id,
//             title: item.content,
//             realName: item.user.realName,
//             department: item.user.department,
//             postDate: item.date,
//             profileImage: item.user.profileImage,
//             thumbNail: item.images[0],
//             likecount: item.likeCount,
//             isLiked: item.isLiked,
//             isMarked: item.isMarked),
//         preventDuplicates: false);
//   }

//   void tapProjectname() {
//     Get.to(() => ProjectScreen(
//           projectid: item.project!.id,
//           isuser: item.isuser,
//         ));
//   }

//   void tapBookmark() {
//     if (item.isMarked.value == 0) {
//       homeController.tapBookmark(item.id);
//     } else {
//       homeController.tapunBookmark(item.id);
//     }
//   }

//   void tapLike() {
// //     debounce(
// //   item.li,
// //   (_) {
// //     print('$_가 마지막으로 변경된 이후, 1초간 변경이 없습니다.');
// //   },
// //   time: Duration(seconds: 1),
// // );
//     if (item.isLiked.value == 0) {
//       likeController.isliked(1);
//       item.likeCount += 1;
//       homeController.tapLike(item.id, item.likeCount.value);
//     } else {
//       likeController.isliked(0);
//       item.likeCount -= 1;
//       homeController.tapunLike(item.id, item.likeCount.value);
//     }
//   }

//   void tapProfile() {
//     Get.to(() => OtherProfileScreen(
//           userid: item.userid,
//           isuser: item.isuser,
//           realname: item.user.realName,
//         ));
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/widget/overflow_text_widget.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/tag_widget.dart';

import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/profile_controller.dart';


class PostingWidget extends StatelessWidget {
  // final int index;
  Post item;
  String? view;
  PostingWidget({required this.item, Key? key, this.view}) : super(key: key);

  final ProfileController profileController = Get.find();
  late final LikeController likeController = Get.put(
      LikeController(
          isliked: item.isLiked, id: item.id, lastisliked: item.isLiked.value),
      tag: item.id.toString());
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: 'posting${item.id}');
  // final PostingDetailController postingDetailController =
  //     Get.put(PostingDetailController());

  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if(view != 'profile')
                    Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          child: ClipOval(
                              child:
                                   item.user.profileImage == null
                                  ?
                                  Image.asset(
                            "assets/illustrations/default_profile.png",
                            fit: BoxFit.cover,
                          )
                              : CachedNetworkImage(
                                  height: 35,
                                  width: 35,
                                  imageUrl: "${item.user.profileImage}",
                                  placeholder: (context, url) =>
                                      kProfilePlaceHolder(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.user.realName, style: k16semiBold),
                              Text(item.user.department, style: kSubTitle3Style)
                            ])
                      ],
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: tapProjectname,
                      child: Text(
                        item.project!.careerName,
                        style:
                            kSubTitle3Style.copyWith(color: Color(0xFF5A5A5A)),
                      ),
                    ),
                  ])),
          const SizedBox(height: 14),
          (item.images[0] == null)
              ?Image.asset(
                              "assets/illustrations/default_image.png",
                              height: Get.width / 2 * 1,
                              width: Get.width,
                              fit: BoxFit.cover,
                            ):
          Container(
              width: Get.width,
              height: 300,
              child: Swiper(
                outer: true,
                itemCount: item.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(item.images[index], fit: BoxFit.fill);
                },
                pagination: SwiperPagination(margin: EdgeInsets.all(14),alignment: Alignment.bottomCenter, builder: DotSwiperPaginationBuilder(
                  color: Color(0xFF5A5A5A).withOpacity(0.5), activeColor: mainblue, size: 7, activeSize: 7
                )),
              )),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpandableText(
                        textSpan: TextSpan(
                            text: item.content,
                            style: kSubTitle3Style.copyWith(height: 1.5)),
                        moreSpan: TextSpan(
                            text: ' ...더보기',
                            style: kSubTitle3Style.copyWith(
                                height: 1.5, color: Color(0xFF5A5A5A))),
                        maxLines: 2),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                        children: item.tags
                            .map((e) => Row(children: [
                                  Tagwidget(tag: e, fontSize: 16),
                                  const SizedBox(width: 7)
                                ]))
                            .toList()),
                    const SizedBox(height: 14),
                    Obx(
                      () => Row(
                        children: [
                          InkWell(
                            onTap: tapLike,
                            child: item.isLiked.value == 0
                                ? SvgPicture.asset(
                                    "assets/icons/Favorite_Inactive.svg")
                                : SvgPicture.asset(
                                    "assets/icons/Favorite_Active.svg"),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          // GestureDetector(
                          //   behavior: HitTestBehavior.translucent,
                          //   onTap: () {
                          //     // Get.to(() => LikePeopleScreen(
                          //     //       postid: item.id,
                          //     //     ));
                          //   },
                          //   child:
                          //    Padding(
                          //     padding: const EdgeInsets.symmetric(
                          //       vertical: 4,
                          //     ),
                          //     child: Text(
                          //       item.likeCount.value != 0
                          //           ? "${item.likeCount.value}     \u200B"
                          //           : ' \u200B',
                          //       style: kButtonStyle,
                          //     ),
                          //   ),
                          // ),
                          Obx(
                            () => SizedBox(
                              width: item.likeCount.value != 0 ? 0 : 8,
                            ),
                          ),
                          SvgPicture.asset("assets/icons/Comment.svg"),
                          const Spacer(),

                          InkWell(
                            onTap: tapBookmark,
                            child: (item.isMarked.value == 0)
                                ? SvgPicture.asset(
                                    "assets/icons/Mark_Default.svg",
                                    color: mainblack,
                                  )
                                : SvgPicture.asset(
                                    "assets/icons/Mark_Saved.svg"),
                          ),
                        ],
                      ),
                    ),
                    // postingTag(),
                    const SizedBox(
                      height: 13,
                    ),
                    Row(children: [
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.to(() => LikePeopleScreen(
                                      postid: item.id,
                                    ));
                          },
                          child: Obx(
                            () =>Text(
                              '좋아요 ${item.likeCount}개',
                              style: kSubTitle3Style,
                            ),
                          )),
                      const Spacer(),
                      Text(calculateDate(item.date), style: kSubTitle3Style),
                    ]),
                    const SizedBox(height: 13),
                    Row(
                      children: const [
                        Text(
                          '이름',
                          style: k16semiBold,
                        ),
                        SizedBox(width: 7),
                        Text(
                          '댓글 내용',
                          style: kSubTitle3Style,
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    Divider(thickness: 0.5, color: Color(0xFF5A5A5A).withOpacity(0.2),)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget postingTag() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: item.project!.projectTag
  //         .map((tag) => Row(children: [
  //               Tagwidget(
  //                 tag: tag,
  //                 fontSize: 12,
  //               ),
  //               item.project!.projectTag.indexOf(tag) !=
  //                       item.project!.projectTag.length - 1
  //                   ? const SizedBox(
  //                       width: 4,
  //                     )
  //                   : Container()
  //             ]))
  //         .toList(),
  //   );
  // }

  void tapPosting() {
    // Get.to(
    //     () => PostingScreen(
    //         userid: item.userid,
    //         isuser: item.isuser,
    //         postid: item.id,
    //         title: item.content,
    //         realName: item.user.realName,
    //         department: item.user.department,
    //         postDate: item.date,
    //         profileImage: item.user.profileImage,
    //         thumbNail: item.images[0],
    //         likecount: item.likeCount,
    //         isLiked: item.isLiked,
    //         isMarked: item.isMarked),
    //     preventDuplicates: false);
  }

  void tapProjectname() {
    // Get.to(() => ProjectScreen(
    //       projectid: item.project!.id,
    //       isuser: item.isuser,
    //     ));
  }

  void tapBookmark() {
    // if (item.isMarked.value == 0) {
    //   homeController.tapBookmark(item.id);
    // } else {
    //   homeController.tapunBookmark(item.id);
    // }
  }

  void tapLike() {
//     debounce(
//   item.li,
//   (_) {
//     print('$_가 마지막으로 변경된 이후, 1초간 변경이 없습니다.');
//   },
//   time: Duration(seconds: 1),
// );
    // if (item.isLiked.value == 0) {
    //   likeController.isliked(1);
    //   item.likeCount += 1;
    //   homeController.tapLike(item.id, item.likeCount.value);
    // } else {
    //   likeController.isliked(0);
    //   item.likeCount -= 1;
    //   homeController.tapunLike(item.id, item.likeCount.value);
    // }
  }

  void tapProfile() {
    // Get.to(() => OtherProfileScreen(
    //       userid: item.userid,
    //       isuser: item.isuser,
    //       realname: item.user.realName,
    //     ));
  }

  Widget overflowText(String text) {
    int maxLength = 50;
    if (text.length < maxLength) {
      return Text(text);
    } else {
      return RichText(
          text: TextSpan(children: [
        TextSpan(
            text: text.substring(0, 49),
            style: kSubTitle3Style.copyWith(height: 1.5)),
        TextSpan(
            text: '... 더보기',
            style:
                kSubTitle3Style.copyWith(height: 1.5, color: Color(0xFF5A5A5A)))
      ]));
    }
  }

  String calculateDate(DateTime date) {
  if (DateTime.now().difference(date).inMilliseconds < 1000) {
    return '방금 전';
  } 
  else if (DateTime.now().difference(date).inMinutes < 60) {
    return '${DateTime.now().difference(date).inMinutes}분 전';
  } else if(DateTime.now().difference(date).inHours <= 24){
    return '${DateTime.now().difference(date).inHours}시간 전';
  }
   else if (DateTime.now().difference(date).inDays <= 31) {
    return '${DateTime.now().difference(date).inDays}일 전';
  } else if (DateTime.now().difference(date).inDays <= 365) {
    return '일 년 이내';
  }
  return '일 년 전';
}
}
