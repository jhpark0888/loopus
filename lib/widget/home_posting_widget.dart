import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/screen/posting_screen.dart';

class HomePostingWidget extends StatelessWidget {
  BookmarkController bookmarkController = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(PostingScreen());
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
                  child: CachedNetworkImage(
                    fadeOutDuration: Duration(milliseconds: 500),
                    height: Get.width / 2 * 1,
                    width: Get.width,
                    imageUrl:
                        "https://thumb.pann.com/tc_480/http://fimg4.pann.com/new/download.jsp?FileID=45110348",
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
                                "SK 서포터즈 활동을 하면서 느꼈던 것들이 있는데 그것은 바로...",
                                style: kHeaderH2Style,
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                "SK 서포터즈 활동",
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
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Color(0xff393e40),
                                        borderRadius: BorderRadius.circular(4)),
                                    height: 24,
                                    child: Center(
                                      child: const Text(
                                        "SK 서포터즈",
                                        style: TextStyle(
                                          color: mainWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Color(0xffefefef),
                                        borderRadius: BorderRadius.circular(4)),
                                    height: 24,
                                    child: Center(
                                      child: const Text(
                                        "기계공학과",
                                        style: TextStyle(
                                          color: Color(0xff999999),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Color(0xffefefef),
                                        borderRadius: BorderRadius.circular(4)),
                                    height: 24,
                                    child: Center(
                                      child: const Text(
                                        "공모전",
                                        style: TextStyle(
                                          color: Color(0xff999999),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
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
                                      ClipOval(
                                        child: CachedNetworkImage(
                                          fadeOutDuration:
                                              Duration(milliseconds: 500),
                                          height: 32,
                                          width: 32,
                                          imageUrl:
                                              "https://i.stack.imgur.com/l60Hf.png",
                                          placeholder: (context, url) =>
                                              CircleAvatar(
                                                  child: Container(
                                            color: mainWhite,
                                          )),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      const Text(
                                        "박도영 · ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: mainblack,
                                        ),
                                      ),
                                      const Text(
                                        "기계공학과",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: mainblack),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => InkWell(
                                      onTap: () {
                                        bookmarkController.bookmark.value ==
                                                false
                                            ? bookmarkController
                                                .bookmark.value = true
                                            : bookmarkController
                                                .bookmark.value = false;
                                      },
                                      child: bookmarkController
                                                  .bookmark.value ==
                                              false
                                          ? SvgPicture.asset(
                                              "assets/icons/Mark_Default.svg")
                                          : SvgPicture.asset(
                                              "assets/icons/Mark_Saved.svg"),
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
