import 'package:cached_network_image/cached_network_image.dart';
// import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/project_api.dart';
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
// import 'package:loopus/trash_bin/overflow_text_widget.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/tag_model.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/overflow_text_widget.dart';
import 'package:loopus/widget/swiper_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/widget/user_image_widget.dart';

enum PostingWidgetType { normal, search, profile, detail }

class PostingWidget extends StatelessWidget {
  // final int index;
  Post item;
  PostingWidgetType type;
  PostingWidget(
      {required this.item, Key? key, required this.type, this.isDark = false})
      : super(key: key);

  PageController pageController = PageController();

  final Debouncer _debouncer = Debouncer();

  late int lastIsLiked;
  int likenum = 0;
  late int lastIsMaked;
  int marknum = 0;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: type != PostingWidgetType.detail ? () => tapPosting() : null,
      // behavior: HitTestBehavior.translucent,
      splashColor: type != PostingWidgetType.detail ? kSplashColor : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (type != PostingWidgetType.profile)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => tapProfile(),
                      child: Row(
                        children: [
                          UserImageWidget(
                            imageUrl: item.user.profileImage,
                            width: 35,
                            height: 35,
                            userType: item.user.userType,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.user.name, style: kmainbold),
                                const SizedBox(height: 8),
                                Text(
                                    '${item.user.univName} | ${item.user.department}',
                                    style: kmain)
                              ])
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: tapProjectname,
                        child: Text(
                          item.project!.careerName,
                          style: kmain.copyWith(color: maingray),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.content.value.isNotEmpty)
                      Obx(
                        () => Column(
                          children: [
                            type == PostingWidgetType.detail
                                ? Text(item.content.value, style: kmainheight)
                                : ExpandableText(
                                    textSpan: TextSpan(
                                        text: item.content.value,
                                        style: kmainheight.copyWith(
                                            color: isDark ? mainWhite : null)),
                                    moreSpan: TextSpan(
                                        text: ' ...더보기',
                                        style: kmainheight.copyWith(
                                            color: maingray)),
                                    maxLines: 3),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    if (item.tags.isNotEmpty)
                      Column(children: [
                        Obx(
                          () => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: item.tags
                                  .map((tag) => Tagwidget(
                                        tag: tag,
                                        isDark: isDark,
                                      ))
                                  .toList()),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
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
                                          "assets/icons/unlike.svg",
                                          color: isDark ? mainWhite : null,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/like.svg"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                // Obx(
                                //   () => SizedBox(
                                //     width: item.likeCount.value != 0 ? 0 : 8,
                                //   ),
                                // ),
                                InkWell(
                                    onTap: type != PostingWidgetType.detail
                                        ? () => tapPosting(autoFocus: true)
                                        : null,
                                    child: SvgPicture.asset(
                                        "assets/icons/comment.svg",
                                        color: isDark ? mainWhite : null)),
                                const Spacer(),
                                InkWell(
                                  onTap: tapBookmark,
                                  child: (item.isMarked.value == 0)
                                      ? SvgPicture.asset(
                                          "assets/icons/bookmark_inactive.svg",
                                          color: isDark ? mainWhite : null,
                                        )
                                      : SvgPicture.asset(
                                          "assets/icons/bookmark_active.svg"),
                                ),
                              ],
                            ),
                          ),
                          // postingTag(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(children: [
                            GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Get.to(
                                    () => LikePeopleScreen(
                                      id: item.id,
                                      likeType: contentType.post,
                                    ),
                                  );
                                },
                                child: Obx(
                                  () => Text(
                                    '좋아요 ${item.likeCount.value}개',
                                    style: kmain.copyWith(
                                        color: isDark ? mainWhite : null),
                                  ),
                                )),
                            const Spacer(),
                            Text(calculateDate(item.date),
                                style: kmain.copyWith(
                                    color: isDark ? mainWhite : null)),
                          ]),
                          SizedBox(
                              height:
                                  type != PostingWidgetType.detail ? 10 : 16),
                          if (item.comments.isNotEmpty &&
                              type != PostingWidgetType.detail)
                            Column(
                              children: [
                                Obx(
                                  () => Row(
                                    children: [
                                      Text(
                                        item.comments.first.user.name,
                                        style: kmainbold.copyWith(
                                            color: isDark ? mainWhite : null),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          item.comments.first.content,
                                          style: kmain.copyWith(
                                              color: isDark ? mainWhite : null),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
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

  void tapPosting({bool autoFocus = false}) {
    Get.to(
        () => PostingScreen(
              post: item,
              postid: item.id,
              autofocus: autoFocus,
            ),
        opaque: false,
        preventDuplicates: false,
        transition: Transition.noTransition);
  }

  void tapProjectname() async {
    await getproject(item.project!.id, item.userid).then(
      (value) {
        if (value.isError == false) {
          goCareerScreen(value.data, item.user.name);
        }
      },
    );
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
        likepost(item.id, contentType.post);
        lastIsLiked = item.isLiked.value;
        likenum = 0;
      }
    });
  }

  void tapProfile() {
    Get.to(
        () => OtherProfileScreen(
            user: item.user,
            userid: item.user.userId,
            realname: item.user.name),
        preventDuplicates: false);
  }
}
