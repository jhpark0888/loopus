import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/screen/question_screen.dart';
import 'package:loopus/widget/tag_widget.dart';

class MyQuestionPostingWidget extends StatelessWidget {
  QuestionController questionController = Get.put(QuestionController());
  final QuestionItem item;
  final int index;

  MyQuestionPostingWidget(
      {required Key key, required this.item, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return item.realname == ""
        ? Container()
        : Container(
            height: 120,
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
                await questionController.loadItem(item.id);
                await questionController.addanswer();
                Get.to(() => QuestionScreen());
                print("click posting");
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "${item.content}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
                              "  ${item.realname}님이 남긴 질문",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: mainblack),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/icons/Comment.svg"),
                                Text(
                                  " ${item.answercount}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
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
