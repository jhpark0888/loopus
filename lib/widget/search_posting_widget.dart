import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/widget/tag_widget.dart';

class SearchPostingWidget extends StatelessWidget {
  // PostItem item; required this.item,
  String postingtitle;
  String projecttitle;
  var profileimage;
  int id;
  int likecount;

  SearchPostingWidget(
      {required this.postingtitle,
      required this.id,
      required this.profileimage,
      required this.projecttitle,
      required this.likecount});
  BookmarkController bookmarkController = Get.put(BookmarkController());
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(PostingScreen());
        print("click posting");
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8, 16.0, 0),
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
                                  "${postingtitle}",
                                  style: kHeaderH2Style,
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Text(
                                  "${projecttitle}",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 32,
                                          width: 32,
                                          child: ClipOval(
                                              child: profileimage == null
                                                  ? Image.asset(
                                                      "assets/illustrations/default_profile.png")
                                                  : CachedNetworkImage(
                                                      height: 32,
                                                      width: 32,
                                                      imageUrl:
                                                          "${profileimage}",
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
                                        // Text(
                                        //   "${item.realname} · ",
                                        //   style: TextStyle(
                                        //     fontSize: 14,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: mainblack,
                                        //   ),
                                        // ),
                                        // Text(
                                        //   "${item.department}",
                                        //   style: TextStyle(
                                        //       fontSize: 14,
                                        //       fontWeight: FontWeight.normal,
                                        //       color: mainblack),
                                        // ),
                                      ],
                                    ),
                                    // Obx(
                                    //   () => Row(
                                    //     children: [
                                    //       InkWell(
                                    //         onTap: () {
                                    //           if (item.isLiked.value == 0) {
                                    //             item.isLiked.value = 1;
                                    //             item.likeCount.value += 1;
                                    //           } else {
                                    //             item.isLiked.value = 0;
                                    //             item.likeCount.value -= 1;
                                    //           }
                                    //           likepost(item.id);
                                    //         },
                                    //         child: item.isLiked.value == 0
                                    //             ? SvgPicture.asset(
                                    //                 "assets/icons/Favorite_Inactive.svg")
                                    //             : SvgPicture.asset(
                                    //                 "assets/icons/Favorite_Active.svg"),
                                    //       ),
                                    //       Text(
                                    //         "${item.likeCount.value}",
                                    //         style: TextStyle(
                                    //             fontWeight: FontWeight.bold),
                                    //       ),
                                    //       SizedBox(
                                    //         width: 10,
                                    //       ),
                                    //       InkWell(
                                    //         onTap: () {
                                    //           if (item.isMarked.value == 0) {
                                    //             item.isMarked.value = 1;
                                    //           } else {
                                    //             item.isMarked.value = 0;
                                    //           }
                                    //           bookmarkpost(item.id);
                                    //         },
                                    //         child: item.isMarked.value == 0
                                    //             ? SvgPicture.asset(
                                    //                 "assets/icons/Mark_Default.svg")
                                    //             : SvgPicture.asset(
                                    //                 "assets/icons/Mark_Saved.svg"),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
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
      ),
    );
  }
}
