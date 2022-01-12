import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/duration_calculate.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/posting_add_name_screen.dart';
import 'package:loopus/screen/posting_add_content_screen.dart';
import 'package:loopus/screen/project_modify_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_posting_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:intl/intl.dart';

class ProjectScreen extends StatelessWidget {
  ProjectScreen({
    Key? key,
  }) : super(key: key);

  ModalController modalController = Get.put(ModalController());

  ProjectDetailController projectdetailController = Get.find();
  Project? exproject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back(result: projectdetailController.project.value);
            },
            icon: SvgPicture.asset('assets/icons/Arrow.svg'),
          ),
          actions: [
            Obx(
              () => projectdetailController.project.value.is_user == true
                  ? IconButton(
                      onPressed: () async {
                        exproject = await Get.to(() => ProjectModifyScreen());
                        if (exproject != null) {
                          projectdetailController.project(exproject);
                        }
                      },
                      icon: SvgPicture.asset('assets/icons/Edit.svg'),
                    )
                  : Container(),
            ),
            IconButton(
              onPressed: () {
                modalController.showModalIOS(
                  context,
                  func1: () {},
                  func2: () {},
                  value1: '이 활동 삭제하기',
                  value2: '',
                  isValue1Red: true,
                  isValue2Red: false,
                  isOne: true,
                );
              },
              icon: SvgPicture.asset('assets/icons/More.svg'),
            ),
          ],
        ),
        body: Obx(
          () => projectdetailController.isProjectLoading.value
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/loading.gif',
                          scale: 9,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '내용을 받는 중이에요...',
                          style: TextStyle(
                            fontSize: 10,
                            color: mainblue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(
                          16,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffe7e7e7),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Obx(
                              () => Text(
                                projectdetailController
                                    .project.value.projectName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${DateFormat("yy.MM.dd").format(projectdetailController.project.value.startDate!)} ~ ${projectdetailController.project.value.endDate != null ? DateFormat("yy.MM.dd").format(projectdetailController.project.value.endDate!) : ''}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: (projectdetailController
                                                    .project.value.endDate ==
                                                null)
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
                                          color: (projectdetailController
                                                      .project.value.endDate ==
                                                  null)
                                              ? Color(0xffefefef)
                                              : Color(0xff888B8C),
                                        ),
                                        child: Center(
                                          child: Text(
                                            projectdetailController.project
                                                        .value.endDate ==
                                                    null
                                                ? '진행중'
                                                : DurationCaculator()
                                                    .durationCaculate(
                                                        startDate:
                                                            projectdetailController
                                                                .project
                                                                .value
                                                                .startDate!,
                                                        endDate:
                                                            projectdetailController
                                                                .project
                                                                .value
                                                                .endDate!),
                                            style: TextStyle(
                                              fontWeight:
                                                  (projectdetailController
                                                              .project
                                                              .value
                                                              .endDate ==
                                                          null)
                                                      ? FontWeight.normal
                                                      : FontWeight.bold,
                                              fontSize: 14,
                                              color: (projectdetailController
                                                          .project
                                                          .value
                                                          .endDate ==
                                                      null)
                                                  ? mainblack.withOpacity(0.6)
                                                  : mainWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //좋아요 한 사람 리스트
                                      print(DurationCaculator()
                                          .durationCaculate(
                                              startDate:
                                                  projectdetailController
                                                      .project.value.startDate!,
                                              endDate: projectdetailController
                                                  .project.value.endDate!));
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/Favorite_Active.svg",
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '${projectdetailController.project.value.like_count}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 70,
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: mainblack,
                                        radius: 15,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            width: 28,
                                            height: 28,
                                            imageUrl:
                                                "https://i.stack.imgur.com/l60Hf.png",
                                            placeholder: (context, url) =>
                                                const CircleAvatar(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 20,
                                        child: CircleAvatar(
                                          backgroundColor: mainblack,
                                          radius: 15,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              width: 28,
                                              height: 28,
                                              imageUrl:
                                                  "https://i.stack.imgur.com/l60Hf.png",
                                              placeholder: (context, url) =>
                                                  const CircleAvatar(
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 40,
                                        child: CircleAvatar(
                                          backgroundColor: mainblack,
                                          radius: 15,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              width: 28,
                                              height: 28,
                                              imageUrl:
                                                  "https://i.stack.imgur.com/l60Hf.png",
                                              placeholder: (context, url) =>
                                                  const CircleAvatar(
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '최승원',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: '님, ',
                                      ),
                                      TextSpan(
                                        text: '김형태',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: '님 외 ',
                                      ),
                                      TextSpan(
                                        text: '4명이',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: ' 참여했어요',
                                      ),
                                    ],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: mainblack,
                                      fontFamily: 'Nanum',
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '활동 소개',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Obx(
                              () => Text(
                                projectdetailController
                                    .project.value.introduction!,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              '활동 태그',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Obx(
                              () => Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: projectdetailController
                                      .project.value.projectTag
                                      .map((tag) => Row(children: [
                                            Tagwidget(
                                              tag: tag,
                                              fontSize: 14,
                                            ),
                                            projectdetailController.project
                                                        .value.projectTag
                                                        .indexOf(tag) !=
                                                    projectdetailController
                                                            .project
                                                            .value
                                                            .projectTag
                                                            .length -
                                                        1
                                                ? SizedBox(
                                                    width: 8,
                                                  )
                                                : Container()
                                          ]))
                                      .toList()),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '활동 포스팅',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                projectdetailController.project.value.is_user ==
                                        true
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(() => PostingAddNameScreen(
                                                project_id:
                                                    projectdetailController
                                                        .project.value.id,
                                              ));
                                        },
                                        child: Text(
                                          '포스팅 작성하기',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: mainblue,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Obx(
                              () => Column(
                                  children: projectdetailController
                                              .project.value.post !=
                                          null
                                      ? List.from(projectdetailController
                                          .project.value.post
                                          .map((post) => ProjectPostingWidget(
                                                item: post,
                                                realName:
                                                    projectdetailController
                                                            .project
                                                            .value
                                                            .realname ??
                                                        '',
                                                department:
                                                    projectdetailController
                                                            .project
                                                            .value
                                                            .department ??
                                                        '',
                                                profileImage:
                                                    projectdetailController
                                                            .project
                                                            .value
                                                            .profileimage ??
                                                        '',
                                              ))
                                          .toList()
                                          .reversed)
                                      : [Container()]
                                  //     [
                                  ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
