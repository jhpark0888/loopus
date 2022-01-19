import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/question_detail_screen.dart';
import 'package:loopus/widget/tag_widget.dart';

class QuestionWidget extends StatelessWidget {
  final QuestionController questionController = Get.put(QuestionController());
  final ProfileController profileController = Get.find();
  final QuestionItem item;

  QuestionWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: tapQuestion,
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
                                  child: item.profileimage == null
                                      ? Image.asset(
                                          "assets/illustrations/default_profile.png",
                                          height: 32,
                                          width: 32,
                                        )
                                      : CachedNetworkImage(
                                          height: 32,
                                          width: 32,
                                          imageUrl: item.profileimage ?? "",
                                          placeholder: (context, url) =>
                                              CircleAvatar(
                                            backgroundColor: Color(0xffe7e7e7),
                                            child: Container(),
                                          ),
                                          fit: BoxFit.cover,
                                        )),
                              Text(
                                "  ${item.realname}  · ",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${item.department}",
                          style: TextStyle(fontSize: 14),
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
    );
  }

  void tapQuestion() async {
    questionController.messageanswerlist.clear();
    await questionController.loadItem(item.id);
    await questionController.addanswer();
    Get.to(() => QuestionDetailScreen());
  }

  void tapProfile() {
    profileController.isProfileLoading(true);

    Get.to(() => OtherProfileScreen(
          userid: item.user,
          isuser: item.is_user,
          realname: item.realname,
        ));
  }
}
