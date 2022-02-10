import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/question_detail_controller.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/screen/question_detail_screen.dart';
import 'package:loopus/widget/tag_widget.dart';

class MyQuestionPostingWidget extends StatelessWidget {
  final QuestionItem item;
  final int index;

  MyQuestionPostingWidget(
      {required Key key, required this.item, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kCardStyle,
      child: InkWell(
        onTap: () async {
          // await questionController.loadItem(item.id);
          // await questionController.addanswer();
          Get.to(() => QuestionDetailScreen(
                questionid: item.id,
                isuser: item.isuser,
                realname: item.user.realName,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${item.content}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: kSubTitle1Style,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: item.questionTag
                    .map((tag) => Row(children: [
                          Tagwidget(
                            tag: tag,
                            fontSize: 12,
                          ),
                          item.questionTag.indexOf(tag) !=
                                  item.questionTag.length - 1
                              ? SizedBox(
                                  width: 4,
                                )
                              : Container()
                        ]))
                    .toList(),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipOval(
                          child: item.user.profileImage == null
                              ? Image.asset(
                                  "assets/illustrations/default_profile.png",
                                  height: 32,
                                  width: 32,
                                )
                              : CachedNetworkImage(
                                  height: 32,
                                  width: 32,
                                  imageUrl: item.user.profileImage ?? "",
                                  placeholder: (context, url) => CircleAvatar(
                                    backgroundColor: const Color(0xffe7e7e7),
                                    child: Container(),
                                  ),
                                  fit: BoxFit.cover,
                                )),
                      SizedBox(
                        width: 8,
                      ),
                      Text("${item.user.realName}", style: kButtonStyle),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset("assets/icons/Comment.svg"),
                      Text(
                        " ${item.answercount}",
                        style: kButtonStyle,
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
