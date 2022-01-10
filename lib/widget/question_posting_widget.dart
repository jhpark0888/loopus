import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/question_screen.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

class QuestionPostingWidget extends StatelessWidget {
  QuestionController questionController = Get.put(QuestionController());
  ProfileController profileController = Get.find();
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
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  await getProfile(item.user).then((response) {
                                    var responseBody = json.decode(
                                        utf8.decode(response.bodyBytes));
                                    profileController.myUserInfo(
                                        User.fromJson(responseBody));

                                    List projectmaplist =
                                        responseBody['project'];
                                    profileController.projectlist(projectmaplist
                                        .map((project) =>
                                            Project.fromJson(project))
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
                                        child: item.profileimage == null
                                            ? Image.asset(
                                                "assets/illustrations/default_profile.png",
                                                height: 32,
                                                width: 32,
                                              )
                                            : CachedNetworkImage(
                                                height: 32,
                                                width: 32,
                                                imageUrl:
                                                    item.profileimage ?? "",
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                ),
                                                fit: BoxFit.cover,
                                              )),
                                    Text(
                                      "  ${item.realname}  · ",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
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
