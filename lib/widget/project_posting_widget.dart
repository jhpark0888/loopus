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

  Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () {
          Get.to(() => PostingScreen(post: post));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 343,
                height: 171.5,
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
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
              child: Text(
                post.title,
                style: kSubTitle1Style,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
              child: Text(
                post.content_summary ?? '',
                style: kBody2Style,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${post.date.year}.${post.date.month}.${post.date.day}',
                    style: kButtonStyle,
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
                      Text(post.like_count.toString(), style: kButtonStyle),
                      SizedBox(
                        width: 10,
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
