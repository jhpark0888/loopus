import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/widget/alertdialog1_widget.dart';
import 'package:loopus/widget/alertdialog2_widget.dart';

class MessageAnswerWidget extends StatelessWidget {
  String content;
  String name;
  String image;

  MessageAnswerWidget(
      {required this.content, required this.image, required this.name});
  // const MessageQuestionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            children: [
              Row(
                children: [
                  ClipOval(
                      child: CachedNetworkImage(
                    height: 37,
                    width: 37,
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
                    "1시간 전",
                    style: TextStyle(fontSize: 14),
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () {
                          Get.dialog(Alertdialog1Widget(
                            color_1: Colors.red,
                            text_1: "이 질문 삭제하기",
                          ));
                        },
                        child: SvgPicture.asset("assets/icons/More.svg")),
                  ))
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Container(
                    width: Get.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 47),
                      child: Text("$content"),
                    ),
                  ),
                ],
              )
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Container(
          //       // padding: EdgeInsets.fromLTRB(80, 0, 15, 0),
          //       height: 60,
          //       width: Get.width * 0.77,
          //       decoration: BoxDecoration(
          //           color: Colors.grey[200],
          //           borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(8),
          //               topRight: Radius.zero,
          //               bottomLeft: Radius.circular(8),
          //               bottomRight: Radius.circular(8))),
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Text(
          //           "${content}",
          //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //     ),
          //     Column(
          //       children: [
          //         ClipOval(
          //             child: CachedNetworkImage(
          //           height: 37,
          //           width: 37,
          //           imageUrl: "https://i.stack.imgur.com/l60Hf.png",
          //           placeholder: (context, url) => CircleAvatar(
          //             child: Center(child: CircularProgressIndicator()),
          //           ),
          //           fit: BoxFit.fill,
          //         )),
          //         SizedBox(
          //           height: 3,
          //         ),
          //
          //       ],
          //     ),
          //   ],
          // ),
        ),
      ],
    );
  }
}
