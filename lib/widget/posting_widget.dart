import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/debouncer.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/utils/error_control.dart';
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
  int likenum = 0;
  late int lastIsMaked;
  int marknum = 0;

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
              swiperType:
                  item.images.isNotEmpty ? SwiperType.image : SwiperType.link,
              aspectRatio: item.images.isNotEmpty
                  ? getAspectRatioinUrl(item.images[0])
                  : null,
            ),
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
                    if (item.tags.isNotEmpty)
                      Column(children: [
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
                      ]),
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
                                InkWell(
                                    onTap: () {
                                      tapPosting(autoFocus: true);
                                    },
                                    child: SvgPicture.asset(
                                        "assets/icons/Comment.svg")),
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
                                  Get.to(
                                    () => LikePeopleScreen(
                                      id: item.id,
                                      likeType: LikeType.post,
                                    ),
                                  );
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
                                      Expanded(
                                        child: Text(
                                          item.comments.first.content,
                                          style: k16Normal,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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

  void tapPosting({bool? autoFocus}) {
    Get.to(
        () => PostingScreen(
              post: item,
              postid: item.id,
              autofocus: autoFocus,
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
    if (marknum == 0) {
      lastIsMaked = item.isMarked.value;
    }
    if (item.isMarked.value == 0) {
      item.isMarked(1);
    } else {
      item.isMarked(0);
    }
    marknum += 1;

    _debouncer.run(() {
      if (lastIsMaked != item.isMarked.value) {
        bookmarkpost(item.id).then((value) {
          if (value.isError == false) {
            lastIsMaked = item.isMarked.value;
            marknum = 0;

            if (item.isMarked.value == 1) {
              HomeController.to.tapBookmark(item.id);
              showCustomDialog("북마크에 추가되었습니다", 1000);
            } else {
              HomeController.to.tapunBookmark(item.id);
            }
          } else {
            errorSituation(value);
            item.isMarked(lastIsMaked);
          }
        });
      }
    });
  }

  void tapLike() {
    if (likenum == 0) {
      lastIsLiked = item.isLiked.value;
    }
    if (item.isLiked.value == 0) {
      item.isLiked(1);
      item.likeCount += 1;

      HomeController.to.tapLike(item.id, item.likeCount.value);
      // ProfileController.to
      //     .tapLike(item.project!.id, item.id, item.likeCount.value);
    } else {
      item.isLiked(0);
      item.likeCount -= 1;

      HomeController.to.tapunLike(item.id, item.likeCount.value);
      // ProfileController.to
      //     .tapunLike(item.project!.id, item.id, item.likeCount.value);
    }
    likenum += 1;

    _debouncer.run(() {
      if (lastIsLiked != item.isLiked.value) {
        likepost(item.id, LikeType.post);
        lastIsLiked = item.isLiked.value;
        likenum = 0;
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
