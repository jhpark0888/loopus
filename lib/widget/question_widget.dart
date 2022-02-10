import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/question_detail_controller.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/question_detail_screen.dart';
import 'package:loopus/widget/tag_widget.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionItem item;

  QuestionWidget({required this.item});
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: 'question${item.id}');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTapDown: (details) => _hoverController.isHoverState(),
        onTapCancel: () => _hoverController.isNonHoverState(),
        onTapUp: (details) => _hoverController.isNonHoverState(),
        onTap: tapQuestion,
        child: Obx(
          () => AnimatedScale(
            scale: _hoverController.scale.value,
            duration: Duration(milliseconds: 100),
            curve: kAnimationCurve,
            child: Container(
              decoration: kCardStyle,
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
                            InkWell(
                              onTap: tapProfile,
                              child: Row(
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
                                              imageUrl:
                                                  item.user.profileImage ?? "",
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                backgroundColor:
                                                    Color(0xffe7e7e7),
                                                child: Container(),
                                              ),
                                              fit: BoxFit.cover,
                                            )),
                                  Text(
                                    "  ${item.user.realName}  · ",
                                    style: kButtonStyle,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${item.user.department}",
                              style: kBody2Style,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset("assets/icons/Comment.svg"),
                            const SizedBox(
                              width: 4,
                            ),
                            (item.answercount == 0)
                                ? Text(
                                    '답변하기',
                                    style: kButtonStyle.copyWith(height: 0.7),
                                  )
                                : Text(
                                    item.answercount.toString(),
                                    style: kButtonStyle.copyWith(height: 1.1),
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
        ),
      ),
    );
  }

  void tapQuestion() async {
    // questionController.messageanswerlist.clear();
    // await questionController.loadItem(item.id);
    // await questionController.addanswer();
    Get.to(() => QuestionDetailScreen(
          questionid: item.id,
          isuser: item.isuser,
          realname: item.user.realName,
        ));
  }

  void tapProfile() {
    Get.to(() => OtherProfileScreen(
          userid: item.userid,
          isuser: item.isuser,
          realname: item.user.realName,
        ));
  }
}
