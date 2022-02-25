// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/screen/posting_add_name_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:intl/intl.dart';

enum ProjectWidgetType { profile, addposting }

class ProjectWidget extends StatelessWidget {
  ProjectWidget({Key? key, required this.project, required this.type})
      : super(key: key);

  ProjectWidgetType type;
  // late ProjectDetailController controller = Get.put(
  //     ProjectDetailController(project.value.id),
  //     tag: project.value.id.toString());
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: 'project${project.value.id}');
  Rx<Project> project;

  @override
  Widget build(BuildContext context) {
    // controller.project = project;
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: GestureDetector(
        onTapDown: (details) => _hoverController.isHoverState(),
        onTapCancel: () => _hoverController.isNonHoverState(),
        onTapUp: (details) => _hoverController.isNonHoverState(),
        onTap: () async {
          if (type == ProjectWidgetType.profile) {
            Get.to(() => ProjectScreen(
                  projectid: project.value.id,
                  isuser: project.value.is_user,
                ));
          } else {
            Get.to(() => PostingAddNameScreen(
                  project_id: project.value.id,
                  route: PostaddRoute.bottom,
                ));
          }
        },
        child: Obx(
          () => AnimatedScale(
            scale: _hoverController.scale.value,
            duration: Duration(milliseconds: 100),
            curve: kAnimationCurve,
            child: Container(
              decoration: kCardStyle,
              child: Column(
                children: [
                  type == ProjectWidgetType.profile
                      ? ClipRRect(
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
                        )
                      : Container(),
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
                              style: kHeaderH2Style.copyWith(fontSize: 18),
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
                              Obx(
                                () => SizedBox(
                                  width:
                                      (project.value.endDate == null) ? 4 : 8,
                                ),
                              ),
                              Obx(() => Container(
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
                                              : DurationCaculator()
                                                  .durationCaculate(
                                                  startDate:
                                                      project.value.startDate!,
                                                  endDate:
                                                      project.value.endDate!,
                                                ),
                                          style: kBody2Style.copyWith(
                                              fontWeight:
                                                  (project.value.endDate ==
                                                          null)
                                                      ? FontWeight.w400
                                                      : FontWeight.w500,
                                              color: (project.value.endDate ==
                                                      null)
                                                  ? mainblack.withOpacity(0.6)
                                                  : mainWhite),
                                        ),
                                      ),
                                    ),
                                  )),
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
                                      '${project.value.post_count!.value}',
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
                                    "${project.value.like_count!.value}",
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
        ),
      ),
    );
  }
}
