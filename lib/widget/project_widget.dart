// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/posting_add_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/trash_bin/project_screen.dart';
import 'package:intl/intl.dart';

class ProjectWidget extends StatelessWidget {
  ProjectWidget({
    Key? key,
    required this.project,
  }) : super(key: key);

  // late ProjectDetailController controller = Get.put(
  //     ProjectDetailController(project.value.id),
  //     tag: project.value.id.toString());
  final HoverController _hoverController = HoverController();
  Rx<Project> project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      child: GestureDetector(
        onTapDown: (details) => _hoverController.isHoverState(),
        onTapCancel: () => _hoverController.isNonHoverState(),
        onTapUp: (details) => _hoverController.isNonHoverState(),
        onTap: () async {
          print(project.value.post_count);
          Get.to(() => PostingAddScreen(
                project_id: project.value.id,
                route: PostaddRoute.bottom,
              ));
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
                    () => Text(
                      project.value.careerName,
                      style: kmainbold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Obx(
                        () => RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '포스트 ',
                              style: kmain.copyWith(color: maingray)),
                          TextSpan(
                            text: '${project.value.post_count!.value}개',
                            style: kmain,
                          )
                        ])),
                      ),
                      Spacer(),
                      Obx(
                        () => Text(
                          '${lastPostCalculateDate(project.value.updateDate!)} 마지막 포스트',
                          style: kmain,
                        ),
                        //  ~ ${project.value.endDate != null ? DateFormat("yy.MM.dd").format(project.value.endDate!) : ''
                        // }
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  careerAnalysisWidget(
                    fieldList[project.value.fieldId]!,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget careerAnalysisWidget(String title) {
    return Row(
      children: [
        RichText(
            text: TextSpan(children: [
          TextSpan(text: title, style: kmain.copyWith(color: mainblue)),
          const TextSpan(text: ' 분야', style: kmain)
        ])),
        Spacer(),
        Row(
          children: [
            project.value.isPublic
                ? SvgPicture.asset('assets/icons/group_career.svg',
                    color: mainblack)
                : SvgPicture.asset('assets/icons/single_career.svg',
                    color: mainblack),
            const SizedBox(
              width: 8,
            ),
            Text(
              project.value.isPublic ? "그룹 커리어" : "개인 커리어",
              style: kmain.copyWith(color: mainblack),
            ),

            // const Spacer(),
            // Row(
            //   children: [
            //     career.isPublic
            //         ? SvgPicture.asset('assets/icons/group.svg')
            //         : SvgPicture.asset('assets/icons/personal_career.svg'),
            //     const SizedBox(
            //       width: 7,
            //     ),
            //     Text(
            //       career.isPublic ? "그룹 커리어" : "개인 커리어",
            //       style: kmainbold.copyWith(
            //           color: career.thumbnail == "" ? mainblack : mainWhite),
            //     ),
            //   ],
            // )
          ],
        )
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
