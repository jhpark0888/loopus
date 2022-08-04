// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/post_add_test.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/trash_bin/project_screen.dart';
import 'package:intl/intl.dart';

enum ProjectWidgetType { profile, addposting }

class ProjectWidget extends StatelessWidget {
  ProjectWidget({Key? key, required this.project, required this.type})
      : super(key: key);

  ProjectWidgetType type;
  // late ProjectDetailController controller = Get.put(
  //     ProjectDetailController(project.value.id),
  //     tag: project.value.id.toString());
  final HoverController _hoverController = HoverController();
  Rx<Project> project;

  @override
  Widget build(BuildContext context) {
    // controller.project = project;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: GestureDetector(
        onTapDown: (details) => _hoverController.isHoverState(),
        onTapCancel: () => _hoverController.isNonHoverState(),
        onTapUp: (details) => _hoverController.isNonHoverState(),
        onTap: () async {
          if (type == ProjectWidgetType.profile) {
            // Get.to(() => ProjectScreen(
            //       projectid: project.value.id,
            //       isuser: project.value.is_user,
            //     ));
          } else {
            print(project.value.post_count);
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
              color: mainWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          project.value.careerName,
                          style: kmainbold,
                        ),
                        Spacer(),
                        Obx(
                          () => Text(
                            '${DateFormat("yyyy.MM").format(project.value.startDate!)}',
                            style: kmain,
                          ),
                          //  ~ ${project.value.endDate != null ? DateFormat("yy.MM.dd").format(project.value.endDate!) : ''
                          // }
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      Text('포스트',
                          style: kmain.copyWith(
                              color: maingray)),
                      SizedBox(
                        width: 4,
                      ),
                      Obx(
                        () => Text(
                          '${project.value.post_count!.value}개',
                          style: kmain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  careerAnalysisWidget(
                      fieldList[project.value.fieldIds.first]!, 21, 2, 23, 1)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget careerAnalysisWidget(String title, int countrywide,
      int countryVariance, int campus, int campusVariance) {
    return Row(
      children: [
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: title, style: kmain.copyWith(color: mainblue)),
          const TextSpan(text: '분야', style: kmain)
        ])),
        Spacer(),
        const SizedBox(width: 37),
        Text('전국 $countrywide%', style: kmain),
        rate(countryVariance),
        const SizedBox(width: 11),
        Text('교내 $campus%', style: kmain),
        rate(campusVariance)
      ],
    );
  }

  Widget rate(int variance) {
    return Row(children: [
      const SizedBox(width: 4),
      arrowDirection(variance),
      const SizedBox(width: 4),
      if (variance != 0)
        Text('${variance.abs()}%', style: kcaption
            // .copyWith(color: variance >= 1 ? rankred : mainblue)
            ),
    ]);
  }

  Widget arrowDirection(int variance) {
    if (variance == 0) {
      return const SizedBox.shrink();
    } else if (variance >= 1) {
      return SvgPicture.asset('assets/icons/rate_upper_arrow.svg');
    } else {
      return SvgPicture.asset('assets/icons/rate_down_arrow.svg');
    }
  }
}
