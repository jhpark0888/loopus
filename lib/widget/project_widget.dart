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
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/duration_calculate.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:intl/intl.dart';

class ProjectWidget extends StatelessWidget {
  ProjectWidget({
    Key? key,
    required this.project,
  }) : super(key: key);

  ProjectDetailController projectDetailController =
      Get.put(ProjectDetailController());
  Rx<Project> project;
  Project? exproject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: GestureDetector(
        onTap: () async {
          projectDetailController.isProjectLoading.value = true;
          getproject(project.value.id).then((value) {
            projectDetailController.project(value);
            projectDetailController.isProjectLoading.value = false;
          });
          exproject = await Get.to(() => ProjectScreen());
          if (exproject != null) {
            project(exproject);
          }
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
                  child: Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: project.value.thumbnail != null
                              ? NetworkImage(
                                  project.value.thumbnail!,
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
                      Obx(
                        () => Text(
                          project.value.projectName,
                          style: kHeaderH2Style,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Text(
                              '${DateFormat("yy.MM.dd").format(project.value.startDate!)} ~ ${project.value.endDate != null ? DateFormat("yy.MM.dd").format(project.value.endDate!) : ''}',
                              style: kSubTitle2Style,
                            ),
                          ),
                          SizedBox(
                            width: (project.value.endDate == null) ? 4 : 8,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: (project.value.endDate == null)
                                  ? Color(0xffefefef)
                                  : Color(0xff888B8C),
                            ),
                            child: Center(
                              child: Obx(
                                () => Text(
                                  (project.value.endDate == null)
                                      ? '진행중'
                                      : DurationCaculator().durationCaculate(
                                          startDate: project.value.startDate!,
                                          endDate: project.value.endDate!,
                                        ),
                                  style: kBody2Style.copyWith(
                                      fontWeight:
                                          (project.value.endDate == null)
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                      color: (project.value.endDate == null)
                                          ? mainblack.withOpacity(0.6)
                                          : mainWhite),
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
                              Obx(
                                () => Text(
                                  '${project.value.post_count}',
                                  style: kButtonStyle,
                                ),
                              ),
                            ],
                          ),
                          Row(children: [
                            SvgPicture.asset(
                                "assets/icons/Favorite_Active.svg"),
                            SizedBox(
                              width: 4,
                            ),
                            Obx(
                              () => Text(
                                "${project.value.like_count}",
                                style: kButtonStyle,
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
