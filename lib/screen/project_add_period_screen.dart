// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_add_tag_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ProjectAddPeriodScreen extends StatelessWidget {
  ProjectAddPeriodScreen({
    Key? key,
    this.projectid,
    required this.screenType,
  }) : super(key: key);

  final ProjectAddController projectaddcontroller = Get.find();
  final ModalController _modalController = Get.put(ModalController());
  final Screentype screenType;
  int? projectid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          screenType == Screentype.add
              ? Obx(
                  () => TextButton(
                    onPressed:
                        (projectaddcontroller.isDateValidated.value == true)
                            ? () {
                                Get.to(() => ProjectAddTagScreen(
                                    screenType: Screentype.add));
                              }
                            : () {},
                    child: Text(
                      '다음',
                      style: kSubTitle2Style.copyWith(
                        color: projectaddcontroller.isDateValidated.value
                            ? mainblue
                            : mainblack.withOpacity(0.38),
                      ),
                    ),
                  ),
                )
              : Obx(
                  () => Get.find<ProjectDetailController>(
                              tag: projectid.toString())
                          .isProjectUpdateLoading
                          .value
                      ? Image.asset(
                          'assets/icons/loading.gif',
                          scale: 9,
                        )
                      : TextButton(
                          onPressed: () async {
                            if (projectaddcontroller.isDateValidated.value ==
                                true) {
                              Get.find<ProjectDetailController>(
                                      tag: projectid.toString())
                                  .isProjectUpdateLoading
                                  .value = true;
                              await updateproject(
                                  Get.find<ProjectDetailController>(
                                          tag: projectid.toString())
                                      .project
                                      .value
                                      .id,
                                  ProjectUpdateType.date);
                              await getproject(
                                      Get.find<ProjectDetailController>(
                                              tag: projectid.toString())
                                          .project
                                          .value
                                          .id)
                                  .then((value) {
                                Get.find<ProjectDetailController>(
                                        tag: projectid.toString())
                                    .project(value);
                                Get.find<ProjectDetailController>(
                                        tag: projectid.toString())
                                    .isProjectUpdateLoading
                                    .value = false;
                              });
                              Get.back();
                              ModalController.to
                                  .showCustomDialog('변경이 완료되었어요', 1000);
                            }
                          },
                          child: Text(
                            '저장',
                            style: kSubTitle2Style.copyWith(
                              color:
                                  (projectaddcontroller.isDateValidated.value ==
                                          true)
                                      ? mainblue
                                      : mainblack.withOpacity(0.38),
                            ),
                          ),
                        ),
                )
        ],
        title: '활동 기간',
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          32,
          24,
          32,
          40,
        ),
        child: Center(
          child: Obx(
            () => Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '언제부터 언제까지 ',
                        style: kSubTitle1Style.copyWith(
                          color: mainblue,
                        ),
                      ),
                      TextSpan(
                        text: '진행하셨나요?',
                        style: kSubTitle1Style,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  '아직 종료되지 않은 활동이어도 괜찮아요',
                  style: kBody2Style,
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '시작한 날짜',
                      style: kSubTitle3Style,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    TextButton(
                      onPressed: () {
                        _modalController.showDatePicker(
                            context, SelectDateType.start);
                      },
                      child: Obx(
                        () => Text(
                          (projectaddcontroller.selectedStartDateTime.value ==
                                  '')
                              ? '선택'
                              : '${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(projectaddcontroller.selectedStartDateTime.value))}',
                          style: kSubTitle2Style.copyWith(color: mainblue),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '종료한 날짜',
                        style:
                            (projectaddcontroller.isEndedProject.value == true)
                                ? kSubTitle3Style
                                : kSubTitle3Style.copyWith(
                                    color: mainblack.withOpacity(0.38),
                                  ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      TextButton(
                        onPressed:
                            (projectaddcontroller.isEndedProject.value == true)
                                ? () {
                                    _modalController.showDatePicker(
                                        context, SelectDateType.end);
                                  }
                                : () {},
                        child: Text(
                          (projectaddcontroller.isEndedProject.value == true)
                              ? (projectaddcontroller
                                          .selectedEndDateTime.value ==
                                      '')
                                  ? '선택'
                                  : '${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(projectaddcontroller.selectedEndDateTime.value))}'
                              : '진행 중',
                          style: kSubTitle2Style.copyWith(
                            color: (projectaddcontroller.isEndedProject.value ==
                                    true)
                                ? mainblue
                                : mainblack.withOpacity(0.38),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            projectaddcontroller.changeEndState();
                            projectaddcontroller.isDateChange.value = true;
                          },
                          icon: (projectaddcontroller.isEndedProject.value ==
                                  true)
                              ? SvgPicture.asset(
                                  'assets/icons/check_box_inactive.svg')
                              : SvgPicture.asset(
                                  'assets/icons/check_box_active.svg'),
                        ),
                        Text(
                          '아직 종료되지 않았어요',
                          style: kBody2Style,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                if (projectaddcontroller.startDateIsBiggerThanEndDate.value ==
                    true)
                  Text(
                    '시작한 날짜는 종료한 날짜보다 클 수 없어요',
                    style: kButtonStyle.copyWith(color: mainpink),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
