import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/question_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/profile_screen.dart';
import 'package:loopus/screen/question_screen.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

class SearchQuestionWidget extends StatelessWidget {
  ProfileController profileController = Get.find();

  QuestionItem question;
  // String content;
  // int answercount;
  // var profileimage;
  // List<Tag> tag;
  // int id;
  // int user;
  // String department;
  // String real_name;
  // int istag;

  QuestionController questionController = Get.put(QuestionController());
  SearchQuestionWidget({required this.question
      // required this.content,
      // required this.id,
      // required this.istag,
      // required this.user,
      // required this.department,
      // required this.real_name,
      // required this.answercount,
      // required this.profileimage,
      // required this.tag,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          questionController.messageanswerlist.clear();
          await questionController.loadItem(question.id);
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
                  "${question.content}",
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
                    children: question.questionTag
                        .map((tag) => Row(children: [
                              Tagwidget(
                                tag: tag,
                                fontSize: 14,
                              ),
                              question.questionTag.indexOf(tag) !=
                                      question.questionTag.length - 1
                                  ? SizedBox(
                                      width: 8,
                                    )
                                  : Container()
                            ]))
                        .toList()),
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
                            await getProfile(question.user).then((response) {
                              var responseBody =
                                  json.decode(utf8.decode(response.bodyBytes));
                              profileController
                                  .user(User.fromJson(responseBody));

                              List projectmaplist = responseBody['project'];
                              profileController.projectlist(projectmaplist
                                  .map((project) => Project.fromJson(project))
                                  .map((project) => ProjectWidget(
                                        project: project.obs,
                                      ))
                                  .toList());
                            });
                            AppController.to.ismyprofile.value = false;
                            print(AppController.to.ismyprofile.value);
                            Get.to(() => ProfileScreen());
                          },
                          child: Row(
                            children: [
                              ClipOval(
                                child: question.profileimage == null
                                    ? ClipOval(
                                        child: Image.asset(
                                          "assets/illustrations/default_profile.png",
                                          height: 32,
                                          width: 32,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        height: 32,
                                        width: 32,
                                        imageUrl: question.profileimage!,
                                        placeholder: (context, url) =>
                                            const CircleAvatar(
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                              ),
                              Text(
                                "  ${question.realname}  · ",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${question.department}",
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
                          "${question.answercount}",
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
