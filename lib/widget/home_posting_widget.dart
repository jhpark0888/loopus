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
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:http/http.dart' as http;

class HomePostingWidget extends StatelessWidget {
  // final int index;
  Post item;

  HomePostingWidget({required this.item, Key? key}) : super(key: key);

  BookmarkController bookmarkController = Get.put(BookmarkController());
  ProfileController profileController = Get.put(ProfileController());
  HoverController _hoverController = Get.put(HoverController());
  PostingDetailController postingDetailController =
      Get.put(PostingDetailController());

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTapDown: (details) => _hoverController.isHoverState(),
      // onTapCancel: () => _hoverController.isNonHoverState(),
      // onTapUp: (details) => _hoverController.isNonHoverState(),
      onTap: () {
        // http.Response? response = await getposting(item.id);
        // var responseBody = json.decode(utf8.decode(response!.bodyBytes));
        // Post post = Post.fromJson(responseBody['posting_info']);
        postingDetailController.isPostingContentLoading.value = true;
        getposting(item.id).then((value) {
          postingDetailController.item = value;
          postingDetailController.isPostingContentLoading.value = false;
        });
        Get.to(
          () => PostingScreen(),
          arguments: {
            'isuser': item.isuser,
            'id': item.id,
            'realName': item.realname,
            'profileImage': item.profileimage,
            'title': item.title,
            'content': item.contents,
            'postDate': item.date,
            'department': item.department,
            'thumbNail': item.thumbnail,
          },
          // transition: Transition.fade,
          // duration: kAnimationDuration,
          // curve: kAnimationCurve,
        );
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
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
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: item.thumbnail == null
                      ? Image.asset(
                          "assets/illustrations/default_image.png",
                          height: Get.width / 2 * 1,
                          width: Get.width,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          fadeOutDuration: Duration(milliseconds: 500),
                          height: Get.width / 2 * 1,
                          width: Get.width,
                          imageUrl: item.thumbnail,
                          placeholder: (context, url) => Container(
                            color: mainWhite,
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: Container(
                        color: mainWhite,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Material(
                                type: MaterialType.transparency,
                                child: Text(
                                  "${item.title}",
                                  style: kHeaderH2Style,
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                "${item.project!.projectName}",
                                style: TextStyle(
                                  color: mainblack.withOpacity(0.6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: item.project!.projectTag
                                    .map((tag) => Row(children: [
                                          Tagwidget(
                                            tag: tag,
                                            fontSize: 12,
                                          ),
                                          item.project!.projectTag
                                                      .indexOf(tag) !=
                                                  item.project!.projectTag
                                                          .length -
                                                      1
                                              ? SizedBox(
                                                  width: 4,
                                                )
                                              : Container()
                                        ]))
                                    .toList(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          // AppController.to.ismyprofile.value =false;
                                          profileController
                                              .isProfileLoading(true);

                                          Get.to(() => OtherProfileScreen(
                                                userid: item.userid,
                                              ));
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 32,
                                              width: 32,
                                              child: ClipOval(
                                                child: item.profileimage == null
                                                    ? Image.asset(
                                                        "assets/illustrations/default_profile.png")
                                                    : CachedNetworkImage(
                                                        height: 32,
                                                        width: 32,
                                                        imageUrl:
                                                            "${item.profileimage}",
                                                        placeholder:
                                                            (context, url) =>
                                                                CircleAvatar(
                                                          child: Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Material(
                                              type: MaterialType.transparency,
                                              child: Text(
                                                "${item.realname} · ",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: mainblack,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Material(
                                        type: MaterialType.transparency,
                                        child: Text("${item.department}",
                                            style: kBody2Style),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (item.isLiked.value == 0) {
                                              homeController.tapLike(item.id);
                                            } else {
                                              homeController.tapunLike(item.id);
                                            }
                                          },
                                          child: item.isLiked.value == 0
                                              ? SvgPicture.asset(
                                                  "assets/icons/Favorite_Inactive.svg")
                                              : SvgPicture.asset(
                                                  "assets/icons/Favorite_Active.svg"),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "${item.likeCount.value}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (item.isMarked.value == 0) {
                                              homeController
                                                  .tapBookmark(item.id);
                                              ModalController.to
                                                  .showCustomDialog(
                                                      '북마크 탭에 저장했어요', 1000);
                                            } else {
                                              homeController
                                                  .tapunBookmark(item.id);
                                              ModalController.to
                                                  .showCustomDialog(
                                                      '북마크 탭에서 삭제했어요', 1000);
                                            }
                                          },
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
