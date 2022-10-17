import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/overflow_text_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class CareerBoardPostWidget extends StatelessWidget {
  CareerBoardPostWidget({Key? key, required this.post}) : super(key: key);

  Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
            () => PostingScreen(
                  post: post,
                  postid: post.id,
                ),
            opaque: false,
            preventDuplicates: false,
            transition: Transition.noTransition);
      },
      child: Container(
        height: 430,
        width: 280,
        decoration: BoxDecoration(
            color: lightcardgray, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: tapProfile,
                        child: Row(
                          children: [
                            UserImageWidget(
                              imageUrl: post.user.profileImage,
                              width: 36,
                              height: 36,
                              userType: post.user.userType,
                            ),
                            const SizedBox(width: 8),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: '${post.user.name} · ',
                                  style: kmainbold),
                              TextSpan(text: post.user.department, style: kmain)
                            ])),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: (post.isMarked.value == 0)
                            ? SvgPicture.asset(
                                "assets/icons/bookmark_inactive.svg",
                                color: mainblack,
                              )
                            : SvgPicture.asset(
                                "assets/icons/bookmark_active.svg"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(post.project!.careerName,
                      style: kmain.copyWith(color: maingray)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (post.images.isNotEmpty || post.links.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                        width: 280,
                        height: 195,
                        child: post.images.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: post.images.first, fit: BoxFit.fill)
                            : LinkSmallWidget(url: post.links.first)),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Obx(
                        () => ExpandableText(
                          textSpan: TextSpan(
                              text: post.content.value, style: kmainheight),
                          moreSpan: TextSpan(
                              text: "...더보기",
                              style: kmainheight.copyWith(color: maingray)),
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Obx(
                    () => Text(post.content.value, style: kmainheight),
                  ),
                ),
              ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Text('좋아요 ', style: kmain.copyWith(color: maingray)),
                  Text('${post.likeCount}개', style: kmain),
                  const SizedBox(width: 7),
                  Text('댓글 ', style: kmain.copyWith(color: maingray)),
                  Text(
                    '${(post.comments.length + 1).toString()}개',
                    style: kmain,
                  ),
                  const Spacer(),
                  Text('교내추천', style: kmain.copyWith(color: maingray))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void tapProfile() {
    Get.to(
        () => OtherProfileScreen(
            user: post.user,
            userid: post.user.userId,
            realname: post.user.name),
        preventDuplicates: false);
  }
}
