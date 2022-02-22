import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/blue_button.dart';

class ProjectAddThumbnailScreen extends StatelessWidget {
  ProjectAddThumbnailScreen({
    Key? key,
    this.projectid,
    required this.screenType,
  }) : super(key: key);

  final ProjectAddController projectAddController =
      Get.put(ProjectAddController());
  final ImageController imageController = Get.put(ImageController());

  final Screentype screenType;
  int? projectid;

  @override
  Widget build(BuildContext context) {
    print(projectAddController.isEndedProject);
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppBarWidget(
              bottomBorder: false,
              actions: [
                screenType == Screentype.add
                    ? Obx(
                        () => projectAddController.isProjectUploading.value
                            ? Image.asset(
                                'assets/icons/loading.gif',
                                scale: 9,
                              )
                            : TextButton(
                                onPressed: () async {
                                  projectAddController.isProjectUploading(true);
                                  await addproject().then((value) {
                                    projectAddController
                                        .isProjectUploading(false);
                                  });
                                },
                                child: Text(
                                  '완료',
                                  style:
                                      kSubTitle2Style.copyWith(color: mainblue),
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
                                          ProjectUpdateType.thumbnail)
                                      .then((value) {
                                    Get.find<ProjectDetailController>(
                                            tag: projectid.toString())
                                        .isProjectUpdateLoading
                                        .value = false;
                                  });
                                },
                                child: Text(
                                  '저장',
                                  style:
                                      kSubTitle2Style.copyWith(color: mainblue),
                                ),
                              ),
                      )
              ],
              title: '대표 사진',
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(
                32,
                24,
                32,
                40,
              ),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '활동의 ',
                          style: kSubTitle1Style,
                        ),
                        TextSpan(
                          text: '대표 사진',
                          style: kSubTitle1Style.copyWith(
                            color: mainblue,
                          ),
                        ),
                        TextSpan(
                          text: '을 설정해주세요',
                          style: kSubTitle1Style,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    '나중에 변경할 수 있어요',
                    style: kBody2Style,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlueTextButton(
                      onTap: () async {
                        imageController.isThumbnailImagePickerLoading.value =
                            true;
                        await imageController
                            .getcropImage(ImageType.thumbnail)
                            .then((value) {
                          projectAddController.projectthumbnail(value);
                          imageController.isThumbnailImagePickerLoading.value =
                              false;
                        });
                      },
                      text: '대표 사진 변경하기',
                      hoverTag: '활동 대표 사진 변경하기'),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '내 프로필에 이렇게 보여요',
                        style: kSubTitle2Style,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child: Container(
                          decoration: kCardStyle,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 2 / 1,
                                  child: Obx(
                                    () => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: projectAddController
                                                      .projectthumbnail
                                                      .value!
                                                      .path !=
                                                  ''
                                              ? FileImage(
                                                  projectAddController
                                                      .projectthumbnail.value!,
                                                )
                                              : projectAddController
                                                          .projecturlthumbnail !=
                                                      null
                                                  ? NetworkImage(
                                                      projectAddController
                                                          .projecturlthumbnail!)
                                                  : const AssetImage(
                                                      "assets/illustrations/default_image.png",
                                                    ) as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        projectAddController
                                            .projectnamecontroller.text,
                                        style: kHeaderH2Style,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        children: [
                                          Obx(
                                            () => (projectAddController
                                                        .isEndedProject.value ==
                                                    true)
                                                ? Text(
                                                    '${DateFormat("yy.MM.dd").format(DateTime.parse(projectAddController.selectedStartDateTime.value))} ~ ${DateFormat("yy.MM.dd").format(DateTime.parse(projectAddController.selectedEndDateTime.value))}',
                                                    style: kSubTitle2Style,
                                                  )
                                                : Text(
                                                    '${DateFormat("yy.MM.dd").format(DateTime.parse(projectAddController.selectedStartDateTime.value))} ~ ',
                                                    style: kSubTitle2Style,
                                                  ),
                                          ),
                                          SizedBox(
                                            width: (projectAddController
                                                        .isEndedProject.value ==
                                                    false)
                                                ? 4
                                                : 8,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: (projectAddController
                                                          .isEndedProject
                                                          .value ==
                                                      false)
                                                  ? Color(0xffefefef)
                                                  : Color(0xff888B8C),
                                            ),
                                            child: Center(
                                              child: Obx(
                                                () => Text(
                                                  (projectAddController
                                                              .isEndedProject
                                                              .value ==
                                                          false)
                                                      ? '진행중'
                                                      : DurationCaculator()
                                                          .durationCaculate(
                                                          startDate: DateTime.parse(
                                                              projectAddController
                                                                  .selectedStartDateTime
                                                                  .value),
                                                          endDate:
                                                              DateTime.parse(
                                                            projectAddController
                                                                .selectedEndDateTime
                                                                .value,
                                                          ),
                                                        ),
                                                  style: kBody2Style.copyWith(
                                                      fontWeight:
                                                          (projectAddController
                                                                      .isEndedProject
                                                                      .value ==
                                                                  false)
                                                              ? FontWeight.w400
                                                              : FontWeight.w500,
                                                      color: (projectAddController
                                                                  .isEndedProject
                                                                  .value ==
                                                              false)
                                                          ? mainblack
                                                              .withOpacity(0.6)
                                                          : mainWhite),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: const [
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
                                                '999+',
                                                style: kButtonStyle,
                                              ),
                                            ],
                                          ),
                                          Row(children: [
                                            SvgPicture.asset(
                                                "assets/icons/Favorite_Active.svg"),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            const Text(
                                              "999+",
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
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (imageController.isThumbnailImagePickerLoading.value == true)
            Container(
              height: Get.height,
              width: Get.width,
              color: mainblack.withOpacity(0.3),
              child: Image.asset(
                'assets/icons/loading.gif',
                scale: 6,
              ),
            ),
        ],
      ),
    );
  }
}
