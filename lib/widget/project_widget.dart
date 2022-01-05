// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/bookmark_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/tag_widget.dart';

class ProjectWidget extends StatelessWidget {
  ProjectWidget({
    Key? key,
    required this.project,
  }) : super(key: key);

  Project project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: GestureDetector(
        onTap: () async {
          project = await getproject(project.id);
          Get.to(() => ProjectScreen(
                project: project,
              ));
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
                        image: project.thumbnail != null
                            ? NetworkImage(
                                project.thumbnail!,
                              ) as ImageProvider
                            : AssetImage(
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
                        style: kHeaderH2Style,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Text(
                            '${project.startDate!.substring(0, 4)}.${project.startDate!.substring(5, 7)}  ~',
                            style: kSubTitle2Style,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          project.endDate != null
                              ? Text(
                                  '${project.endDate!.substring(0, 4)}.${project.endDate!.substring(5, 7)}',
                                  style: kSubTitle2Style,
                                )
                              : Container(),
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
                                project.endDate != null ? '9개월' : '진행중',
                                style: kBody1Style,
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
                                '${project.post_count ?? 0}',
                                style: kButtonStyle,
                              ),
                            ],
                          ),
                          Row(children: [
                            SvgPicture.asset(
                                "assets/icons/Favorite_Active.svg"),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${project.like_count ?? 0}",
                              style: kButtonStyle,
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
