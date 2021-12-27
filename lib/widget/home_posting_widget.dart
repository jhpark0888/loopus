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

class HomePostingWidget extends StatelessWidget {
  // PostItem item; required this.item,
  final int index;
  Post item;

  HomePostingWidget({required Key key, required this.item, required this.index})
      : super(key: key);
  BookmarkController bookmarkController = Get.put(BookmarkController());
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(PostingScreen());
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
                                "${item.project.projectName}",
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
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(
                                        item.project.projectTag.length,
                                        (index) {
                                      return Tagwidget(
                                        content:
                                            item.project.projectTag[index].tag,
                                      );
                                    }),
                                  ),
                                ],
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
                                        Text(
                                          "${item.likeCount.value}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
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
                                                  "assets/icons/Mark_Default.svg")
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
