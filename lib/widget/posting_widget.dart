import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/divide_widget.dart';
import 'package:loopus/widget/overflow_text_widget.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/swiper_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/widget/user_image_widget.dart';

enum PostingWidgetType { normal, search, profile }

class PostingWidget extends StatelessWidget {
  // final int index;
  Post item;
  PostingWidgetType type;
  PostingWidget({required this.item, Key? key, required this.type})
      : super(key: key);

  PageController pageController = PageController();

  final Debouncer _debouncer = Debouncer();

  late int lastIsLiked;
  int num = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => tapPosting(),
      // behavior: HitTestBehavior.translucent,
      splashColor: kSplashColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (type != PostingWidgetType.profile)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => tapProfile(),
                      child: Row(
                        children: [
                          UserImageWidget(
                            imageUrl: item.user.profileImage ?? '',
                            width: 35,
                            height: 35,
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.user.realName, style: k16semiBold),
                                Text(item.user.department,
                                    style: kSubTitle3Style)
                              ])
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: tapProjectname,
                        child: Text(
                          item.project!.careerName,
                          style: k16semiBold.copyWith(color: maingray),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
          ]),
          if (item.images.isNotEmpty || item.links.isNotEmpty)
            SwiperWidget(
                items: item.images.isNotEmpty ? item.images : item.links,
                swiperType: item.images.isNotEmpty
                    ? SwiperType.image
                    : SwiperType.link),
          // Column(
          //   children: [
          //     // Swiper(
          //     //   outer: true,
          //     //   loop: false,
          //     //   itemCount: item.images.isNotEmpty
          //     //       ? item.images.length
          //     //       : item.links.length,
          //     //   itemBuilder: (BuildContext context, int index) {
          //     //     if (item.images.isNotEmpty) {
          //     //       return CachedNetworkImage(
          //     //           imageUrl: item.images[index], fit: BoxFit.fill);
          //     //       // Image.network(item.images[index],
          //     //       //     fit: BoxFit.fill);
          //     //     } else {
          //     //       return KeepAlivePage(
          //     //         child: LinkWidget(
          //     //             url: item.links[index], widgetType: 'post'),
          //     //       );
          //     //     }
          //     //   },
          //     //   pagination: SwiperPagination(
          //     //       margin: const EdgeInsets.all(14),
          //     //       alignment: Alignment.bottomCenter,
          //     //       builder: DotSwiperPaginationBuilder(
          //     //           color: Color(0xFF5A5A5A).withOpacity(0.5),
          //     //           activeColor: mainblue,
          //     //           size: 7,
          //     //           activeSize: 7)),
          //     // ),
          //     // ),
          //     Container(
          //         decoration: const BoxDecoration(
          //             color: mainblack,
          //             border: Border.symmetric(
          //                 horizontal: BorderSide(color: mainblack))),
          //         constraints: BoxConstraints(
          //             maxWidth: Get.width,
          //             maxHeight: item.images.isNotEmpty ? Get.width : 300),
          //         child: PageView.builder(
          //           controller: pageController,
          //           itemBuilder: (BuildContext context, int index) {
          //             if (item.images.isNotEmpty) {
          //               return CachedNetworkImage(
          //                 imageUrl: item.images[index],
          //                 fit: BoxFit.contain,
          //               );
          //               // Image.network(item.images[index],
          //               //     fit: BoxFit.fill);
          //             } else {
          //               return KeepAlivePage(
          //                 child: LinkWidget(
          //                     url: item.links[index], widgetType: 'post'),
          //               );
          //             }
          //           },
          //           itemCount: item.images.isNotEmpty
          //               ? item.images.length
          //               : item.links.length,
          //         )
          //         // )
          //         // Swiper(
          //         //   outer: true,
          //         //   loop: false,
          //         //   itemCount: item.images.isNotEmpty
          //         //       ? item.images.length
          //         //       : item.links.length,
          //         //   itemBuilder: (BuildContext context, int index) {
          //         //     if (item.images.isNotEmpty) {
          //         //       return CachedNetworkImage(
          //         //           imageUrl: item.images[index], fit: BoxFit.fill);
          //         //       // Image.network(item.images[index],
          //         //       //     fit: BoxFit.fill);
          //         //     } else {
          //         //       return KeepAlivePage(
          //         //         child: LinkWidget(
          //         //             url: item.links[index], widgetType: 'post'),
          //         //       );
          //         //     }
          //         //   },
          //         //   pagination: SwiperPagination(
          //         //       margin: const EdgeInsets.all(14),
          //         //       alignment: Alignment.bottomCenter,
          //         //       builder: DotSwiperPaginationBuilder(
          //         //           color: Color(0xFF5A5A5A).withOpacity(0.5),
          //         //           activeColor: mainblue,
          //         //           size: 7,
          //         //           activeSize: 7)),
          //         // ),
          //         ),
          //     const SizedBox(
          //       height: 14,
          //     ),
          //     if (item.images.length > 1 || item.links.length > 1)
          //       Column(
          //         children: [
          //           PageIndicator(
          //             size: 7,
          //             activeSize: 7,
          //             space: 7,
          //             color: maingray,
          //             activeColor: mainblue,
          //             count: item.images.isNotEmpty
          //                 ? item.images.length
          //                 : item.links.length,
          //             controller: pageController,
          //             layout: PageIndicatorLayout.SLIDE,
          //           ),
          //           const SizedBox(
          //             height: 14,
          //           ),
          //         ],
          //       ),
          //   ],
          // ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => ExpandableText(
                          textSpan: TextSpan(
                              text: item.content.value,
                              style: kSubTitle3Style.copyWith(height: 1.5)),
                          moreSpan: TextSpan(
                              text: ' ...더보기',
                              style: kSubTitle3Style.copyWith(
                                  height: 1.5, color: maingray)),
                          maxLines: 3),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Obx(
                      () => Wrap(
                          spacing: 7,
                          runSpacing: 7,
                          children: item.tags
                              .map((tag) => Tagwidget(
                                    tag: tag,
                                  ))
                              .toList()),
                    ),
                    const SizedBox(height: 14),
                    if (type != PostingWidgetType.search)
                      Column(
                        children: [
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
                                // Obx(
                                //   () => SizedBox(
                                //     width: item.likeCount.value != 0 ? 0 : 8,
                                //   ),
                                // ),
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
                                  () => Text(
                                    '좋아요 ${item.likeCount.value}개',
                                    style: kSubTitle3Style,
                                  ),
                                )),
                            const Spacer(),
                            Text(calculateDate(item.date),
                                style: kSubTitle3Style),
                          ]),
                          const SizedBox(height: 14),
                          if (item.comments.isNotEmpty)
                            Column(
                              children: [
                                Obx(
                                  () => Row(
                                    children: [
                                      Text(
                                        item.comments.first.user.realName,
                                        style: k16semiBold,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        item.comments.first.content,
                                        style: k16Normal,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                              ],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              // if (view != 'detail') const DivideWidget()
            ],
          ),
        ],
      ),
    );
  }

  void tapPosting() {
    Get.to(
        () => PostingScreen(
              post: item,
              postid: item.id,
              // likecount: item.likeCount,
              // isLiked: item.isLiked,
            ),
        opaque: false);
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
    if (num == 0) {
      lastIsLiked = item.isLiked.value;
    }
    if (item.isLiked.value == 0) {
      item.isLiked(1);
      item.likeCount += 1;

      HomeController.to.tapLike(item.id, item.likeCount.value);
      ProfileController.to
          .tapLike(item.project!.id, item.id, item.likeCount.value);
    } else {
      item.isLiked(0);
      item.likeCount -= 1;

      HomeController.to.tapunLike(item.id, item.likeCount.value);
      ProfileController.to
          .tapunLike(item.project!.id, item.id, item.likeCount.value);
    }
    num += 1;

    _debouncer.run(() {
      if (lastIsLiked != item.isLiked.value) {
        likepost(item.id, 'post');
        lastIsLiked = item.isLiked.value;
        num = 0;
      }
    });
  }

  void tapProfile() {
    Get.to(
        () => OtherProfileScreen(
            user: item.user,
            userid: item.user.userid,
            realname: item.user.realName),
        preventDuplicates: false);
  }
}
