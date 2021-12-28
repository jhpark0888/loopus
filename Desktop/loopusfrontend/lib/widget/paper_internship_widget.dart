import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/tag_widget.dart';

class PaperinternshipWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(PostingScreen());
        print("click posting");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: mainWhite,
                border: Border.all(
                  width: 1,
                  color: Color(0xffe7e7e7),
                ),
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
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: mainWhite,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "743명이 조회했어요",
                                      style: kCaptionStyle.copyWith(
                                        color: mainblack.withOpacity(0.6),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      width: Get.width * 0.573,
                                      child: Text(
                                        "당근마켓",
                                        style: kSubTitle1Style,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      width: Get.width * 0.573,
                                      child: Text(
                                        "중고거래 PM 인턴",
                                        style: kSubTitle4Style,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: Color(0xffe7e7e7),
                                      width: 1,
                                    )),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    fadeOutDuration:
                                        Duration(milliseconds: 500),
                                    height: Get.width * 0.213,
                                    width: Get.width * 0.213,
                                    imageUrl:
                                        "https://upload.wikimedia.org/wikipedia/commons/a/ae/DaangnMarket_logo.png",
                                    placeholder: (context, url) => CircleAvatar(
                                        child: Container(
                                      color: mainWhite,
                                    )),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Tagwidget(content: '기획'),
                                  Tagwidget(content: '전략'),
                                ],
                              ),
                              Text(
                                "마감까지 14일",
                                style: kCaptionStyle.copyWith(
                                  color: mainblack.withOpacity(0.6),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
