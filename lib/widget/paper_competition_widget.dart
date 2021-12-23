import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class PapercompetitionWidget extends StatelessWidget {
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
            height: 200,
            decoration: BoxDecoration(
              color: mainlightgrey,
              border: Border.all(width: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  child: Container(
                    color: mainlightgrey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  width: 231,
                                  height: 120,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "1,243명이 조회했어요",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: mainblack.withOpacity(0.6)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          "KB 라스쿨 22년 2기 멘토 모집 (~22.1.2)",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4,
                                                horizontal: 16,
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff393e40),
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              height: 24,
                                              child: Center(
                                                child: const Text(
                                                  "봉사",
                                                  style: TextStyle(
                                                    color: mainWhite,
                                                    fontSize: 12,
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
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              height: 22,
                                              child: Center(
                                                child: const Text(
                                                  "KB라스쿨",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff999999),
                                                    fontWeight:
                                                        FontWeight.normal,
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
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              height: 22,
                                              child: Center(
                                                child: const Text(
                                                  "대외활동",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff999999),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                color: Colors.red,
                                width: 80,
                                height: 120,
                                child: CachedNetworkImage(
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  height: 32,
                                  width: 32,
                                  imageUrl:
                                      "https://res.cloudinary.com/linkareer/image/fetch/f_auto/https://s3.ap-northeast-2.amazonaws.com/media.linkareer.com/activity_manager/posters/2021-03-231147367242010_%EB%A9%98%ED%86%A0%EB%8B%A8_%EC%B6%94%EA%B0%80%EB%AA%A8%EC%A7%91_%ED%8F%AC%EC%8A%A4%ED%84%B0.jpg",
                                  placeholder: (context, url) => CircleAvatar(
                                      child: Container(
                                    color: mainWhite,
                                  )),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
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
                                      "KB국민은행",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: mainblack,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "마감까지 17일",
                                  style: TextStyle(
                                      color: mainblack.withOpacity(0.6)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
