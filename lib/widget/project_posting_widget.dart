import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProjectPostingWidget extends StatelessWidget {
  ProjectPostingWidget({
    Key? key,
    required this.isuser,
    required this.item,
    required this.realname,
    required this.profileimage,
    required this.department,
  }) : super(key: key);

  PostingDetailController postingDetailController =
      Get.put(PostingDetailController());

  Post item;
  int isuser;
  String realname;
  var profileimage;
  String department;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        postingDetailController.isPostingContentLoading.value = true;
        print(item.isLiked);
        Get.to(
          () => PostingScreen(
              userid: item.userid,
              isuser: isuser,
              id: item.id,
              title: item.title,
              realName: realname,
              department: department,
              postDate: item.date,
              profileImage: profileimage,
              thumbNail: item.thumbnail,
              likecount: item.likeCount,
              isLiked: item.isLiked,
              isMarked: item.isMarked),
        );
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
                          image: item.thumbnail != null
                              ? NetworkImage(item.thumbnail)
                              : const AssetImage(
                                  "assets/illustrations/default_image.png",
                                ) as ImageProvider,
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  item.title,
                  style: kSubTitle1Style,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  item.content_summary ?? '',
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
                      '${DateFormat('yy.MM.dd').format(item.date)}',
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
                              if (item.isLiked.value == 0) {
                                item.likeCount += 1;
                                HomeController.to
                                    .tapLike(item.id, item.likeCount.value);

                                item.isLiked.value = 1;
                              } else {
                                item.likeCount -= 1;
                                HomeController.to
                                    .tapunLike(item.id, item.likeCount.value);

                                item.isLiked.value = 0;
                              }
                            },
                            child: item.isLiked.value == 0
                                ? SvgPicture.asset(
                                    "assets/icons/Favorite_Inactive.svg")
                                : SvgPicture.asset(
                                    "assets/icons/Favorite_Active.svg"))),
                        SizedBox(
                          width: 4,
                        ),
                        Obx(
                          () => Text(
                            item.likeCount.toString(),
                            style: kButtonStyle,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Obx(() => InkWell(
                            onTap: () {
                              if (item.isMarked.value == 0) {
                                HomeController.to.tapBookmark(item.id);
                                item.isMarked(1);
                              } else {
                                HomeController.to.tapunBookmark(item.id);
                                item.isMarked(0);
                              }
                            },
                            child: item.isMarked.value == 0
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
              color: Color(0xffe7e7e7),
            ),
          ],
        ),
      ),
    );
  }
}
