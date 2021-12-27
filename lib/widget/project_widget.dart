// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/tag_widget.dart';

class ProjectWidget extends StatelessWidget {
  ProjectWidget({
    Key? key,
    required this.project,
  }) : super(key: key);

  BookmarkController bookmarkController = Get.put(BookmarkController());
  Project project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: GestureDetector(
        onTap: () async {
          await getproject(project.id).then((response) {
            var responseBody = json.decode(utf8.decode(response.bodyBytes));
            project = Project.fromJson(responseBody);
            Get.to(() => ProjectScreen(
                  project: project,
                ));
          });
        },
        child: Container(
          decoration: BoxDecoration(
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
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/illustrations/default_image.png",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                child: Container(
                  color: mainWhite,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        project.projectName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            '${project.startDate.substring(0, 4)}.${project.startDate.substring(5, 7)} ~',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: mainlightgrey,
                            ),
                            child: Center(
                              child: Text(
                                '진행중',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '포스팅',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '33',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(children: [
                            Obx(
                              () => InkWell(
                                  onTap: () {
                                    bookmarkController.bookmark.value == false
                                        ? bookmarkController.bookmark.value =
                                            true
                                        : bookmarkController.bookmark.value =
                                            false;
                                  },
                                  child: bookmarkController.bookmark.value ==
                                          false
                                      ? SvgPicture.asset(
                                          "assets/icons/Favorite_Inactive.svg")
                                      : SvgPicture.asset(
                                          "assets/icons/Favorite_Active.svg")),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${project.like_count}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ])
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
