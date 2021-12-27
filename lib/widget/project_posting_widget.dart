import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/screen/posting_screen.dart';

class ProjectPostingWidget extends StatelessWidget {
  ProjectPostingWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  // BookmarkController bookmarkController = Get.put(BookmarkController());
  Post post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => PostingScreen(post: post));
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 16,
        ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: Get.width,
                  height: Get.width / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: post.thumbnail != null
                              ? NetworkImage(post.thumbnail!)
                              : const AssetImage(
                                  "assets/illustrations/default_image.png",
                                ) as ImageProvider,
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  post.title,
                  style: kSubTitle1Style,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  post.content_summary ?? '',
                  style: kBody1Style,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${post.date.year}.${post.date.month}.${post.date.day}',
                      style: kBody2Style.copyWith(
                        color: mainblack.withOpacity(
                          0.6,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Obx(() => InkWell(
                            onTap: () {
                              post.isliked.value == false
                                  ? post.isliked.value = true
                                  : post.isliked.value = false;
                            },
                            child: post.isliked.value == false
                                ? SvgPicture.asset(
                                    "assets/icons/Favorite_Inactive.svg")
                                : SvgPicture.asset(
                                    "assets/icons/Favorite_Active.svg"))),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          post.like_count.toString(),
                          style: kButtonStyle,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Obx(() => InkWell(
                            onTap: () {
                              post.ismarked.value == false
                                  ? post.ismarked.value = true
                                  : post.ismarked.value = false;
                            },
                            child: post.ismarked.value == false
                                ? SvgPicture.asset(
                                    "assets/icons/Mark_Default.svg")
                                : SvgPicture.asset(
                                    "assets/icons/Mark_Saved.svg")))
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 1,
              color: Color(0xffefefef),
            ),
          ],
        ),
      ),
    );
  }
}
