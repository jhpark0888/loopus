import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/posting_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

import '../utils/duration_calculate.dart';

class SearchTagProjectWidget extends StatelessWidget {
  ProfileController profileController = Get.find();

  Project project;

  SearchTagProjectWidget({
    required this.project,
  });
  BookmarkController bookmarkController = Get.put(BookmarkController());
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapProject,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        padding: const EdgeInsets.fromLTRB(
          16,
          20,
          16,
          16,
        ),
        decoration: kCardStyle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "${project.projectName}",
              style: kHeaderH1Style,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                project.endDate == null
                    ? Text(
                        "${DateFormat("yy.MM.dd").format(project.startDate!)} ~ ",
                        style: kButtonStyle.copyWith(
                          color: mainblack.withOpacity(0.6),
                        ),
                      )
                    : Text(
                        "${DateFormat("yy.MM.dd").format(project.startDate!)} ~ ${DateFormat("yy.MM.dd").format(project.endDate!)}",
                        style: kButtonStyle.copyWith(
                          color: mainblack.withOpacity(0.6),
                        ),
                      ),
                SizedBox(
                  width: (project.endDate == null) ? 4 : 8,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: (project.endDate == null)
                        ? const Color(0xffefefef)
                        : const Color(0xff888B8C),
                  ),
                  child: Center(
                    child: Text(
                      (project.endDate == null)
                          ? '진행중'
                          : DurationCaculator().durationCaculate(
                              startDate: project.startDate!,
                              endDate: project.endDate!,
                            ),
                      style: kCaptionStyle.copyWith(
                          fontWeight: (project.endDate == null)
                              ? FontWeight.normal
                              : FontWeight.bold,
                          color: (project.endDate == null)
                              ? mainblack.withOpacity(0.6)
                              : mainWhite),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: tapProfile,
                        child: Row(
                          children: [
                            ClipOval(
                                child: project.profileimage == null
                                    ? Image.asset(
                                        "assets/illustrations/default_profile.png",
                                        height: 32,
                                        width: 32,
                                      )
                                    : CachedNetworkImage(
                                        height: 32,
                                        width: 32,
                                        imageUrl: project.profileimage!,
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                          backgroundColor: Color(0xffe7e7e7),
                                          child: Container(),
                                        ),
                                        fit: BoxFit.cover,
                                      )),
                            SizedBox(
                              width: 8,
                            ),
                            Text("${project.realname} · ", style: kButtonStyle),
                          ],
                        ),
                      ),
                      Text(
                        "${project.department}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/Paper_Inactive.svg"),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${project.post_count}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      SvgPicture.asset("assets/icons/Favorite_Active.svg"),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${project.like_count}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void tapProfile() {
    // AppController.to.ismyprofile.value = false;
    Get.to(() => OtherProfileScreen(
          userid: project.userid!,
          isuser: project.is_user!,
          realname: project.realname!,
        ));
  }

  void tapProject() {
    Get.to(
        () => ProjectScreen(
              projectid: project.id,
              isuser: 1,
            ),
        arguments: {"projectid": project.id, "isuser": 1});
  }
}
