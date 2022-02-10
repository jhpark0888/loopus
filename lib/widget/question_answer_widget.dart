import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/question_detail_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/project_widget.dart';

class QuestionAnswerWidget extends StatelessWidget {
  ProfileController profileController = Get.find();
  Answer answer;

  QuestionAnswerWidget({
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => OtherProfileScreen(
                            userid: answer.userid,
                            isuser: answer.isuser,
                            realname: answer.user.realName,
                          ));
                    },
                    child: ClipOval(
                        child: answer.user.profileImage == ""
                            ? Image.asset(
                                "assets/illustrations/default_profile.png",
                                height: 32,
                                width: 32,
                              )
                            : CachedNetworkImage(
                                height: 32,
                                width: 32,
                                imageUrl: answer.user.profileImage!,
                                placeholder: (context, url) => CircleAvatar(
                                  backgroundColor: Color(0xffe7e7e7),
                                  child: Container(),
                                ),
                                fit: BoxFit.cover,
                              )),
                  ),
                ],
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () async {
                                  // profileController.isProfileLoading(true);

                                  Get.to(() => OtherProfileScreen(
                                        userid: answer.userid,
                                        isuser: answer.isuser,
                                        realname: answer.user.realName,
                                      ));
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "${answer.user.realName}",
                                      style: kButtonStyle,
                                    ),
                                    Text(
                                      " · ${DurationCaculator().messagedurationCaculate(startDate: answer.date, endDate: DateTime.now())}",
                                      style: kBody2Style.copyWith(
                                          color: mainblack.withOpacity(0.6)),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        InkWell(
                          onTap: answer.isuser == 1
                              ? () {
                                  ModalController.to.showModalIOS(context,
                                      func1: () {
                                    ModalController.to.showButtonDialog(
                                        leftText: '취소',
                                        rightText: '삭제',
                                        title: '정말 답변을 삭제하시겠어요?',
                                        content: '삭제한 답변은 복구할 수 없어요',
                                        leftFunction: () => Get.back(),
                                        rightFunction: () async {
                                          await deleteanswer(
                                                  answer.questionid, answer.id)
                                              .then((value) {
                                            QuestionDetailController
                                                .to.question.value.answer
                                                .removeWhere((element) =>
                                                    element.id == answer.id);
                                            QuestionDetailController
                                                .to.answerlist
                                                .removeWhere((element) =>
                                                    element.answer.id ==
                                                    answer.id);
                                          });
                                          getbacks(2);
                                        });
                                  },
                                      func2: () {},
                                      value1: '답글 삭제하기',
                                      value2: 'value2',
                                      isValue1Red: true,
                                      isValue2Red: true,
                                      isOne: true);
                                }
                              : () {
                                  ModalController.to.showModalIOS(context,
                                      func1: () {},
                                      func2: () {},
                                      value1: '답글 신고하기',
                                      value2: 'value2',
                                      isValue1Red: true,
                                      isValue2Red: true,
                                      isOne: true);
                                },
                          child: SvgPicture.asset("assets/icons/More.svg"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${answer.content}",
                      style: kBody1Style,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
