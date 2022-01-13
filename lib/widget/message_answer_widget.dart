import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/widget/alertdialog1_widget.dart';
import 'package:loopus/widget/alertdialog2_widget.dart';
import 'package:loopus/widget/project_widget.dart';

class MessageAnswerWidget extends StatelessWidget {
  ProfileController profileController = Get.find();
  String content;
  String name;
  String image;
  int user;

  MessageAnswerWidget({
    required this.content,
    required this.image,
    required this.name,
    required this.user,
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
                              placeholder: (context, url) => CircleAvatar(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                              fit: BoxFit.cover,
                            )),
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
                                await getProfile(user).then((user) async {
                                  profileController.myUserInfo(user);
                                  profileController.isProfileLoading.value =
                                      false;
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
                              child: Text(
                                "$name",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '소속 학과',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: mainblack.withOpacity(0.6),
                                  ),
                                ),
                                Text(
                                  " · 게시 시간",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: mainblack.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            ModalController.to.showModalIOS(context,
                                func1: () {},
                                func2: () {},
                                value1: '답글 삭제하기',
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
                      "$content",
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
