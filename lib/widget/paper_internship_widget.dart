import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class PaperinternshipWidget extends StatelessWidget {
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
            height: 180,
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
                                        "743명이 조회했어요",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: mainblack.withOpacity(0.6)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 25.0),
                                        child: Text(
                                          "당근마켓",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          "중고거래 PM 인턴",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              ClipOval(
                                child: CachedNetworkImage(
                                  fadeOutDuration: Duration(milliseconds: 500),
                                  height: 80,
                                  width: 80,
                                  imageUrl:
                                      "https://upload.wikimedia.org/wikipedia/commons/a/ae/DaangnMarket_logo.png",
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
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
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
                                              "기획",
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
                                              "전략",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff999999),
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  "마감까지 14일",
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
