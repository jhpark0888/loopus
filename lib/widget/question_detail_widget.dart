import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/question_detail_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/project_widget.dart';

class QuestionDetailWidget extends StatelessWidget {
  QuestionItem question;

  QuestionDetailWidget({
    required this.question,
  });
  // const MessageQuestionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "${question.content}",
                style: kSubTitle1Style,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          // profileController.isProfileLoading(true);

                          // Get.to(() => OtherProfileScreen(
                          //       userid: 26,
                          //     ));
                        },
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => OtherProfileScreen(
                                  userid: question.user,
                                  isuser: question.isuser,
                                  realname: question.realname,
                                ));
                          },
                          child: Row(
                            children: [
                              ClipOval(
                                  child: question.profileimage == null
                                      ? Image.asset(
                                          "assets/illustrations/default_profile.png",
                                          height: 32,
                                          width: 32,
                                        )
                                      : CachedNetworkImage(
                                          height: 32,
                                          width: 32,
                                          imageUrl: question.profileimage!,
                                          placeholder: (context, url) =>
                                              CircleAvatar(
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          fit: BoxFit.cover,
                                        )),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "${question.realname} · ",
                                style: kBody2Style,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "${question.department}",
                        style: kBody2Style.copyWith(
                            color: mainblack.withOpacity(0.6)),
                      ),
                    ],
                  ),
                  Text(
                    DurationCaculator().messagedurationCaculate(
                        startDate: question.date!, endDate: DateTime.now()),
                    style: kButtonStyle.copyWith(
                        color: mainblack.withOpacity(0.6)),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
