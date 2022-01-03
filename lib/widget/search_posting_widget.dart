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

class SearchPostingWidget extends StatelessWidget {
  ProfileController profileController = Get.find();
  // PostItem item; required this.item,
  String postingtitle;
  String projecttitle;
  String department;
  String name;
  var profileimage;
  int id;
  RxInt is_liked;
  RxInt is_marked;
  RxInt like_count;
  int user_id;

  SearchPostingWidget({
    required this.postingtitle,
    required this.id,
    required this.user_id,
    required this.like_count,
    required this.is_marked,
    required this.is_liked,
    required this.profileimage,
    required this.name,
    required this.department,
    required this.projecttitle,
  });
  BookmarkController bookmarkController = Get.put(BookmarkController());
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("click posting");
      },
      child: Container(
        width: Get.width * 0.94,
        margin: EdgeInsets.symmetric(vertical: 8),
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
                "${postingtitle}",
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
              "${projecttitle}",
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
                          await getProfile(user_id).then((response) {
                            var responseBody =
                                json.decode(utf8.decode(response.bodyBytes));
                            profileController.user(User.fromJson(responseBody));

                            List projectmaplist = responseBody['project'];
                            profileController.projectlist(projectmaplist
                                .map((project) => Project.fromJson(project))
                                .map((project) => ProjectWidget(
                                      project: project,
                                    ))
                                .toList());
                          });
                          AppController.to.ismyprofile.value = false;
                          print(AppController.to.ismyprofile.value);
                          Get.to(() => ProfileScreen());
                        },
                        child: Row(
                          children: [
                            ClipOval(
                                child: profileimage == null
                                    ? Image.asset(
                                        "assets/illustrations/default_profile.png",
                                        height: 32,
                                        width: 32,
                                      )
                                    : CachedNetworkImage(
                                        height: 32,
                                        width: 32,
                                        imageUrl: "${profileimage}",
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
                              "${name} · ",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "$department",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Obx(
                    () => Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (is_liked.value == 0) {
                              is_liked.value = 1;
                              like_count.value += 1;
                            } else {
                              is_liked.value = 0;
                              like_count.value -= 1;
                            }
                            likepost(id);
                          },
                          child: is_liked.value == 0
                              ? SvgPicture.asset(
                                  "assets/icons/Favorite_Inactive.svg")
                              : SvgPicture.asset(
                                  "assets/icons/Favorite_Active.svg"),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${like_count.value}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () {
                            if (is_marked.value == 0) {
                              is_marked.value = 1;
                            } else {
                              is_marked.value = 0;
                            }
                            bookmarkpost(id);
                          },
                          child: is_marked.value == 0
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
    // GestureDetector(
    //   onTap: () {
    //     // Get.to(PostingScreen(post: Post(),));
    //     print("click posting");
    //   },
    //   child: Padding(
    //     padding: const EdgeInsets.fromLTRB(16.0, 8, 16.0, 0),
    //     child: Column(
    //       children: [
    //         Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(8),
    //               topRight: Radius.circular(8),
    //               bottomLeft: Radius.circular(8),
    //               bottomRight: Radius.circular(8),
    //             ),
    //             boxShadow: [
    //               BoxShadow(
    //                 blurRadius: 3,
    //                 offset: Offset(0.0, 1.0),
    //                 color: Colors.black.withOpacity(0.1),
    //               ),
    //               BoxShadow(
    //                 blurRadius: 2,
    //                 offset: Offset(0.0, 1.0),
    //                 color: Colors.black.withOpacity(0.06),
    //               ),
    //             ],
    //           ),
    //           child: Column(
    //             children: [
    //               Column(
    //                 children: [
    //                   ClipRRect(
    //                     borderRadius: BorderRadius.only(
    //                       bottomLeft: Radius.circular(8),
    //                       bottomRight: Radius.circular(8),
    //                     ),
    //                     child: Container(
    //                       color: mainWhite,
    //                       child: Padding(
    //                         padding: const EdgeInsets.symmetric(
    //                           horizontal: 12,
    //                           vertical: 16,
    //                         ),
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.stretch,
    //                           children: [
    //                             Text(
    //                               "${postingtitle}",
    //                               style: kHeaderH2Style,
    //                             ),
    //                             SizedBox(
    //                               height: 24,
    //                             ),
    //                             Text(
    //                               "${projecttitle}",
    //                               style: TextStyle(
    //                                 color: mainblack.withOpacity(0.6),
    //                                 fontSize: 14,
    //                                 fontWeight: FontWeight.bold,
    //                               ),
    //                             ),
    //                             SizedBox(
    //                               height: 24,
    //                             ),
    //                             Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 Row(
    //                                   children: [
    //                                     Container(
    //                                       height: 32,
    //                                       width: 32,
    //                                       child: ClipOval(
    //                                           child: profileimage == null
    //                                               ? Image.asset(
    //                                                   "assets/illustrations/default_profile.png")
    //                                               : CachedNetworkImage(
    //                                                   height: 32,
    //                                                   width: 32,
    //                                                   imageUrl:
    //                                                       "${profileimage}",
    //                                                   placeholder:
    //                                                       (context, url) =>
    //                                                           CircleAvatar(
    //                                                     child: Center(
    //                                                         child:
    //                                                             CircularProgressIndicator()),
    //                                                   ),
    //                                                   fit: BoxFit.fill,
    //                                                 )),
    //                                     ),
    //                                     SizedBox(
    //                                       width: 8,
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ],
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(
    //           height: 16,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
