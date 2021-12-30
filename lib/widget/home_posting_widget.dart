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
import 'package:loopus/screen/profile_screen.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:http/http.dart' as http;

class HomePostingWidget extends StatelessWidget {
  // PostItem item; required this.item,
  final int index;
  Post item;

  HomePostingWidget({required Key key, required this.item, required this.index})
      : super(key: key);
  BookmarkController bookmarkController = Get.put(BookmarkController());
  ProfileController profileController = Get.put(ProfileController());
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        http.Response? response = await getposting(item.id);
        var responseBody = json.decode(utf8.decode(response!.bodyBytes));
        Post post = Post.fromJson(responseBody['posting_info']);
        User user = User(
            type: 0,
            user: responseBody['user_id'],
            realName: responseBody['real_name'],
            profileImage: responseBody['profile_image'],
            profileTag: [],
            department: '',
            isuser: -1);

        Get.to(() => PostingScreen(post: post, user: user));
        print("click posting");
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
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
                      borderRadius: BorderRadius.only(
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
                              Text(
                                "${item.title}",
                                style: kHeaderH2Style,
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
                              SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: item.project!.projectTag
                                    .map((tag) => Row(children: [
                                          Tagwidget(
                                            content: tag.tag,
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
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await getProfile(item.userId)
                                              .then((response) {
                                            var responseBody = json.decode(utf8
                                                .decode(response.bodyBytes));
                                            profileController.user(
                                                User.fromJson(responseBody));

                                            List projectmaplist =
                                                responseBody['project'];
                                            profileController.projectlist(
                                                projectmaplist
                                                    .map((project) =>
                                                        Project.fromJson(
                                                            project))
                                                    .map((project) =>
                                                        ProjectWidget(
                                                          project: project,
                                                        ))
                                                    .toList());
                                          });
                                          AppController.to.ismyprofile.value =
                                              false;
                                          print(AppController
                                              .to.ismyprofile.value);
                                          Get.to(() => ProfileScreen());
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 32,
                                              width: 32,
                                              child: ClipOval(
                                                  child: item.profileimage ==
                                                          null
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
                                                        )),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "${item.realname} · ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: mainblack,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${item.department}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: mainblack),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (item.isLiked.value == 0) {
                                              item.isLiked.value = 1;
                                              item.likeCount.value += 1;
                                            } else {
                                              item.isLiked.value = 0;
                                              item.likeCount.value -= 1;
                                            }
                                            likepost(item.id);
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
                                          onTap: () {
                                            if (item.isMarked.value == 0) {
                                              item.isMarked.value = 1;
                                            } else {
                                              item.isMarked.value = 0;
                                            }
                                            bookmarkpost(item.id);
                                          },
                                          child: item.isMarked.value == 0
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
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
