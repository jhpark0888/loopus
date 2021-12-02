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
          height: 120,
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 38,
                child: Text(
                  "$content",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ClipOval(
                      child: CachedNetworkImage(
                    height: 37,
                    width: 37,
                    // image
                    imageUrl: "https://i.stack.imgur.com/l60Hf.png",
                    placeholder: (context, url) => CircleAvatar(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    fit: BoxFit.fill,
                  )),
                  Text(
                    "   $name · ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "산업경영공학과",
                    style: TextStyle(fontSize: 14),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("1시간전")))
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          thickness: 8,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 50,
          padding: EdgeInsets.all(10),
          child: Obx(
            () => Text(
              "답변 ${QuestionController.to.messageanswerlist.length}개",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
