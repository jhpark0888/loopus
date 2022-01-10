import 'dart:convert';
import 'package:http/http.dart' as http;

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
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/widget/project_widget.dart';

class BookmarkWidget extends StatelessWidget {
  final int index;
  Post post;

  BookmarkWidget({
    required this.index,
    required this.post,
  });
  ProfileController profileController = Get.find();
  BookmarkController bookmarkController = Get.put(BookmarkController());
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapPosting,
      child: Column(
        children: [
          Container(
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
                  "${post.projectname}",
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
                              AppController.to.ismyprofile.value = false;
                              await tapProfile();

                              Get.to(() => OtherProfileScreen());
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
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
                              onTap: tapLike,
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
                              onTap: tapBookmark,
                              child: post.isMarked.value == 0 //0: 비활성 1: 활성
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void tapBookmark() async {
    if (post.isMarked.value == 0) {
      post.isMarked.value = 1;
    } else {
      bookmarkController.bookmarkResult.value.postingitems.removeAt(index);

      ModalController.to.showCustomDialog("북마크 탭에서 삭제했어요.", 1000);
      if (bookmarkController.bookmarkResult.value.postingitems.isEmpty) {
        bookmarkController.isBookmarkEmpty.value = true;
      }
      post.isMarked.value = 0;
    }
    await bookmarkpost(post.id);
  }

  void tapLike() {
    if (post.isLiked.value == 0) {
      post.isLiked.value = 1;
      post.likeCount.value += 1;
    } else {
      post.isLiked.value = 0;
      post.likeCount.value -= 1;
    }
    likepost(post.id);
  }

  Future<void> tapProfile() async {
    await getProfile(post.userId).then((response) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      profileController.myUserInfo(User.fromJson(responseBody));

      List projectmaplist = responseBody['project'];
      profileController.projectlist(projectmaplist
          .map((project) => Project.fromJson(project))
          .map((project) => ProjectWidget(
                project: project.obs,
              ))
          .toList());
    });
  }

  Future<void> tapPosting() async {
    http.Response? response = await getposting(post.id);
    var responseBody = json.decode(utf8.decode(response!.bodyBytes));
    Get.to(() => PostingScreen(
          user: User(
              type: 0,
              user: responseBody['user_id'],
              realName: responseBody['real_name'],
              profileImage: responseBody['profile_image'],
              profileTag: [],
              department: '',
              isuser: -1),
          post: Post.fromJson(
            responseBody['posting_info'],
          ),
        ));
  }
}
