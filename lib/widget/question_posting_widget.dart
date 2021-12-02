import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/screen/question_screen.dart';
import 'package:loopus/widget/tag_widget.dart';

class QuestionPostingWidget extends StatelessWidget {
  QuestionController questionController = Get.put(QuestionController());
  final Question item;
  final int index;

  QuestionPostingWidget(
      {required Key key, required this.item, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return item.realname == ""
        ? Container()
        : Container(
            height: 160,
            width: Get.width * 0.9,
            margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  offset: Offset(0.0, 1),
                  color: mainblack.withOpacity(0.06)),
              BoxShadow(
                  blurRadius: 3,
                  offset: Offset(0.0, 1),
                  color: mainblack.withOpacity(0.1)),
            ], color: mainlightgrey, borderRadius: BorderRadius.circular(5)),
            child: InkWell(
              onTap: () async {
                questionController.messageanswerlist.clear();
                await questionController.loadItem(item.id);
                await questionController.addanswer();
                Get.to(() => QuestionScreen());
                print("click posting");
              },
              child: Column(
                children: [
                  Container(
                    height: 75,
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "${item.content}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  item.questionTag.length == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: mainWhite,
                                  borderRadius: BorderRadius.circular(4)),
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              height: 24,
                              child: const Text("Tag 없는거 없애줘~"),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(item.questionTag.length,
                                  (index) {
                                return Tagwidget(
                                  content: item.questionTag[index].tag,
                                );
                              }),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                    height: 45,
                    child: Row(
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
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                              fit: BoxFit.fill,
                            )),
                            Text(
                              "  ${item.realname}  · ",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "산업경영공학과",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: InkWell(
                              onTap: () {
                                print("답변하기");
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/icons/Comment.svg"),
                                  Text(
                                    " 답변하기",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
