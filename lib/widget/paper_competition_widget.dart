import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/widget/tag_widget.dart';

class PapercompetitionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(PostingScreen());
        print("click posting");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: mainWhite,
                border: Border.all(width: 1, color: Color(0xffe7e7e7)),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
                                    Container(
                                      width: Get.width * 0.605,
                                      child: Text(
                                        "1,243명이 조회했어요",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: mainblack.withOpacity(0.6),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      width: Get.width * 0.605,
                                      child: Text(
                                        "KB 라스쿨 22년 2기 멘토 모집(~22. 01. 02)",
                                        style: kSubTitle1Style,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        Tagwidget(content: '공모전', fontSize: 12),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Tagwidget(content: '공모전', fontSize: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              CachedNetworkImage(
                                fadeOutDuration: Duration(milliseconds: 500),
                                height: Get.width * 0.213 / 2 * 3,
                                width: Get.width * 0.213,
                                imageUrl:
                                    "https://res.cloudinary.com/linkareer/image/fetch/f_auto/https://s3.ap-northeast-2.amazonaws.com/media.linkareer.com/activity_manager/posters/2021-03-231147367242010_%EB%A9%98%ED%86%A0%EB%8B%A8_%EC%B6%94%EA%B0%80%EB%AA%A8%EC%A7%91_%ED%8F%AC%EC%8A%A4%ED%84%B0.jpg",
                                placeholder: (context, url) => CircleAvatar(
                                    child: Container(
                                  color: mainWhite,
                                )),
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  Text(
                                    "KB국민은행",
                                    style: kButtonStyle,
                                  ),
                                ],
                              ),
                              Text(
                                "마감까지 17일",
                                style: kCaptionStyle.copyWith(
                                  color: mainblack.withOpacity(
                                    0.6,
                                  ),
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
