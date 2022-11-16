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
              color: AppColors.mainWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () => Text(
                      project.value.careerName,
                      style: MyTextTheme.mainbold(context),
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
                              style: MyTextTheme.main(context)
                                  .copyWith(color: AppColors.maingray)),
                          TextSpan(
                            text: '${project.value.post_count!.value}개',
                            style: MyTextTheme.main(context),
                          )
                        ])),
                      ),
                      Spacer(),
                      Obx(
                        () => project.value.updateDate != null
                            ? Text(
                                '${lastPostCalculateDate(project.value.updateDate!)} 마지막 포스트',
                                style: MyTextTheme.main(context),
                              )
                            : Container(
                                color: AppColors.mainblack,
                                height: 2,
                                width: 6,
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
                    context,
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

  Widget careerAnalysisWidget(BuildContext context, String title) {
    return Row(
      children: [
        RichText(
            text: TextSpan(children: [
          TextSpan(
              text: title,
              style: MyTextTheme.main(context)
                  .copyWith(color: AppColors.mainblue)),
          TextSpan(text: ' 분야', style: MyTextTheme.main(context))
        ])),
        Spacer(),
        Row(
          children: [
            project.value.isPublic
                ? SvgPicture.asset('assets/icons/group_career.svg',
                    color: AppColors.mainblack)
                : SvgPicture.asset('assets/icons/single_career.svg',
                    color: AppColors.mainblack),
            const SizedBox(
              width: 8,
            ),
            Text(
              project.value.isPublic ? "그룹 커리어" : "개인 커리어",
              style: MyTextTheme.main(context)
                  .copyWith(color: AppColors.mainblack),
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
            //       style: MyTextTheme.mainbold(context).copyWith(
            //           color: career.thumbnail == "" ? AppColors.mainblack : AppColors.mainWhite),
            //     ),
            //   ],
            // )
          ],
        )
      ],
    );
  }

  Widget rate(BuildContext context, int variance) {
    return Row(children: [
      const SizedBox(width: 4),
      arrowDirection(variance),
      const SizedBox(width: 4),
      if (variance != 0)
        Text('${variance.abs()}%', style: MyTextTheme.caption(context)
            // .copyWith(color: variance >= 1 ? AppColors.rankred : AppColors.mainblue)
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
