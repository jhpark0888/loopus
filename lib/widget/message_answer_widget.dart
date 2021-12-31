import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/widget/alertdialog1_widget.dart';
import 'package:loopus/widget/alertdialog2_widget.dart';

class MessageAnswerWidget extends StatelessWidget {
  String content;
  String name;
  String image;

  MessageAnswerWidget({
    required this.content,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(height: 4),
                  ClipOval(
                      child: CachedNetworkImage(
                    height: 32,
                    width: 32,
                    imageUrl: "https://i.stack.imgur.com/l60Hf.png",
                    placeholder: (context, url) => CircleAvatar(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    fit: BoxFit.cover,
                  )),
                ],
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$name",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '소속 학과',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: mainblack.withOpacity(0.6),
                                  ),
                                ),
                                Text(
                                  " · 게시 시간",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: mainblack.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            ModalController.to.showModalIOS(context,
                                func1: () {},
                                func2: () {},
                                value1: '답글 삭제하기',
                                value2: 'value2',
                                isValue1Red: true,
                                isValue2Red: true,
                                isOne: true);
                          },
                          child: SvgPicture.asset("assets/icons/More.svg"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "$content",
                      style: kBody1Style,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
