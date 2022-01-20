import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/widget/appbar_widget.dart';

class ProjectAddThumbnailScreen extends StatelessWidget {
  ProjectAddThumbnailScreen({
    Key? key,
    required this.screenType,
  }) : super(key: key);

  final ProjectAddController projectAddController =
      Get.put(ProjectAddController());
  final TagController tagController = Get.put(TagController());
  final ImageController imageController = Get.put(ImageController());

  final Screentype screenType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
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
                              projectAddController.isProjectUploading(false);
                            });
                          },
                          child: Text(
                            '저장',
                            style: kSubTitle2Style.copyWith(color: mainblue),
                          ),
                        ),
                )
              : Obx(
                  () => ProjectDetailController.to.isProjectLoading.value
                      ? Image.asset(
                          'assets/icons/loading.gif',
                          scale: 9,
                        )
                      : TextButton(
                          onPressed: () async {
                            ProjectDetailController.to.isProjectLoading.value =
                                true;
                            await updateproject(
                                ProjectDetailController.to.project.value.id,
                                ProjectUpdateType.thumbnail);
                            await getproject(
                                    ProjectDetailController.to.project.value.id)
                                .then((value) {
                              ProjectDetailController.to.project(value);
                              ProjectDetailController
                                  .to.isProjectLoading.value = false;
                            });
                            Get.back();
                          },
                          child: Text(
                            '저장',
                            style: kSubTitle2Style.copyWith(color: mainblue),
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
            Text(
              '대표 사진을 설정해주세요',
              style: kSubTitle1Style,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '나중에 수정할 수 있어요',
              style: kBody2Style,
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                imageController.isProfileImagePickerLoading.value = true;
                await imageController
                    .getcropImage(ImageType.thumbnail)
                    .then((value) {
                  projectAddController.projectthumbnail(value);
                  imageController.isProfileImagePickerLoading.value = false;
                });
              },
              child: Container(
                width: 141,
                height: 32,
                decoration: BoxDecoration(
                  color: mainblue,
                  borderRadius: BorderRadius.circular(4),
                ),
                // color: Colors.grey[400],

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Center(
                    child: Text('대표 사진 변경하기',
                        style: kButtonStyle.copyWith(color: mainWhite)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '내 프로필에 이렇게 보여요',
                style: kSubTitle2Style,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
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
                                image: projectAddController
                                            .projectthumbnail.value!.path !=
                                        ''
                                    ? FileImage(
                                        projectAddController
                                            .projectthumbnail.value!,
                                      )
                                    : projectAddController
                                                .projecturlthumbnail !=
                                            null
                                        ? NetworkImage(projectAddController
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
                              projectAddController.projectnamecontroller.text,
                              style: kHeaderH2Style,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${DateFormat("yy.MM.dd").format(DateTime.parse(projectAddController.selectedStartDateTime.value))}  ~',
                                  style: kSubTitle2Style,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                projectAddController.isEndedProject.value ==
                                        true
                                    ? Text(
                                        DateFormat("yy.MM.dd").format(
                                            DateTime.parse(projectAddController
                                                .selectedEndDateTime.value)),
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
                                      projectAddController
                                                  .isEndedProject.value ==
                                              true
                                          ? '9개월'
                                          : '진행중',
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
                                      '33',
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
                                    "33",
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
      ),
    );
  }
}
