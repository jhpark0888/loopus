import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/widget/project_widget.dart';

class MessageQuestionWidget extends StatelessWidget {
  ProfileController profileController = Get.find();
  int user;
  String content;
  String name;
  String image;

  MessageQuestionWidget(
      {required this.content,
      required this.image,
      required this.name,
      required this.user});
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
                "$content",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              SizedBox(
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
                          await getProfile(user).then((user) async {
                            profileController.myUserInfo(user);
                            profileController.isProfileLoading.value = false;
                          });
                          await getProjectlist(user).then((projectlist) {
                            profileController.myProjectList(projectlist
                                .map((project) => ProjectWidget(
                                      project: project.obs,
                                    ))
                                .toList());
                          });

                          AppController.to.ismyprofile.value = false;
                          print(AppController.to.ismyprofile.value);
                          Get.to(() => OtherProfileScreen());
                        },
                        child: Row(
                          children: [
                            ClipOval(
                                child: image == ""
                                    ? Image.asset(
                                        "assets/illustrations/default_profile.png",
                                        height: 32,
                                        width: 32,
                                      )
                                    : CachedNetworkImage(
                                        height: 32,
                                        width: 32,
                                        imageUrl: image,
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
                              "$name · ",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "소속 학과",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    "게시 시간",
                    style: TextStyle(
                      color: mainblack.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          color: Color(0xffe7e7e7),
          height: 1,
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
            right: 16,
            left: 16,
            top: 20,
            bottom: 12,
          ),
          child: Obx(
            () => Text(
              "답변 ${QuestionController.to.messageanswerlist.length}개",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
