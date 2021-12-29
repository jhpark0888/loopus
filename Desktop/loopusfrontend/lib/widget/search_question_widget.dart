import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/screen/question_screen.dart';
import 'package:loopus/widget/tag_widget.dart';

class SearchQuestionWidget extends StatelessWidget {
  String content;
  int answercount;
  var tag;
  int id;
  QuestionController questionController = Get.put(QuestionController());
  SearchQuestionWidget(
      {required this.content,
      required this.id,
      required this.answercount,
      required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          questionController.messageanswerlist.clear();
          await questionController.loadItem(id);
          await questionController.addanswer();
          Get.to(() => QuestionScreen());
          print("click posting");
        },
        child: Container(
          decoration: BoxDecoration(
            color: mainWhite,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "${content}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                tag.length == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: const Text("Tag 없음"),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(tag.length, (index) {
                              return Tagwidget(
                                content: tag[index]["tag"],
                              );
                            }),
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
                        Text(
                          "  손승태  · ",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "산업경영공학과",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/Comment.svg"),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "${answercount}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
