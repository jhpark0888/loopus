import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/question_controller.dart';

class MessageQuestionWidget extends StatelessWidget {
  String content;
  String name;
  String image;

  MessageQuestionWidget(
      {required this.content, required this.image, required this.name});
  // const MessageQuestionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "$content",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ClipOval(
                          child: CachedNetworkImage(
                        height: 32,
                        width: 32,
                        // image
                        imageUrl: "https://i.stack.imgur.com/l60Hf.png",
                        placeholder: (context, url) => CircleAvatar(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        fit: BoxFit.cover,
                      )),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "$name · ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "소속 학과",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    "게시 시간",
                    style: TextStyle(
                      color: mainblack.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          color: Color(0xffe7e7e7),
          height: 1,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            right: 16,
            left: 16,
            top: 20,
            bottom: 12,
          ),
          child: Obx(
            () => Text(
              "답변 ${QuestionController.to.messageanswerlist.length}개",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
