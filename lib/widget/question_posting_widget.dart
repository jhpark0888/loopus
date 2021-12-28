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
  final QuestionItem item;
  final int index;

  QuestionPostingWidget(
      {required Key key, required this.item, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return item.realname == ""
        ? Container()
        : Container(
            margin: EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () async {
                questionController.messageanswerlist.clear();
                await questionController.loadItem(item.id);
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
                        "${item.content}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      item.questionTag.length == 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: const Text("Tag 없는거 없애줘~"),
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
                                  children: List.generate(
                                      item.questionTag.length, (index) {
                                    return Tagwidget(
                                      content: item.questionTag[index].tag,
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
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                                fit: BoxFit.cover,
                              )),
                              Text(
                                "  ${item.realname}  · ",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${item.department}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              print("답변하기");
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset("assets/icons/Comment.svg"),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "답변하기",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
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
