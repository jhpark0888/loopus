import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

class SearchPostingWidget extends StatelessWidget {
  Post post;

  SearchPostingWidget({
    required this.post,
  });
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => PostingScreen(
              userid: post.userid,
              isuser: post.isuser,
              postid: post.id,
              title: post.title,
              realName: post.realname,
              department: post.department,
              postDate: post.date,
              profileImage: post.profileimage,
              thumbNail: post.thumbnail,
              likecount: post.likeCount,
              isLiked: post.isLiked,
              isMarked: post.isMarked),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: mainWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              offset: Offset(0.0, 1.0),
              color: Colors.black.withOpacity(0.1),
            ),
            BoxShadow(
              blurRadius: 2,
              offset: Offset(0.0, 1.0),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Text(
                "${post.title}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "${post.project!.projectName}",
              style: TextStyle(
                fontSize: 14,
                color: mainblack.withOpacity(0.6),
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          // profileController.isProfileLoading(true);

                          // Get.to(() => OtherProfileScreen(
                          //       userid: user_id,
                          //       isuser: ,
                          //     ));
                        },
                        child: Row(
                          children: [
                            ClipOval(
                                child: post.profileimage == null
                                    ? Image.asset(
                                        "assets/illustrations/default_profile.png",
                                        height: 32,
                                        width: 32,
                                      )
                                    : CachedNetworkImage(
                                        height: 32,
                                        width: 32,
                                        imageUrl: "${post.profileimage}",
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                        fit: BoxFit.fill,
                                      )),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "${post.realname} · ",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${post.department}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Obx(
                    () => Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (post.isLiked.value == 0) {
                              post.likeCount.value += 1;
                              HomeController.to
                                  .tapLike(post.id, post.likeCount.value);
                              post.isLiked.value = 1;
                            } else {
                              post.likeCount.value -= 1;
                              HomeController.to
                                  .tapunLike(post.id, post.likeCount.value);
                              post.isLiked.value = 0;
                            }
                          },
                          child: post.isLiked.value == 0
                              ? SvgPicture.asset(
                                  "assets/icons/Favorite_Inactive.svg")
                              : SvgPicture.asset(
                                  "assets/icons/Favorite_Active.svg"),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${post.likeCount.value}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            if (post.isMarked.value == 0) {
                              HomeController.to.tapBookmark(post.id);
                              post.isMarked.value = 1;
                            } else {
                              HomeController.to.tapunBookmark(post.id);
                              post.isMarked.value = 0;
                            }
                          },
                          child: post.isMarked.value == 0
                              ? SvgPicture.asset(
                                  "assets/icons/Mark_Default.svg",
                                  color: mainblack,
                                )
                              : SvgPicture.asset("assets/icons/Mark_Saved.svg"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
