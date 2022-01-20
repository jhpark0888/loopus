import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/posting_add_name_screen.dart';
import 'package:loopus/screen/posting_add_content_screen.dart';
import 'package:loopus/screen/project_modify_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_posting_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:intl/intl.dart';

class ProjectScreen extends GetWidget<ProjectDetailController> {
  ProjectScreen({
    required this.isuser,
    required this.projectid,
    Key? key,
  }) : super(key: key);

  ModalController modalController = Get.put(ModalController());

  // ProjectDetailController controller = Get.find();
  int isuser;
  int projectid;
  RxInt likecount = 0.obs;
  // Rx<Project> project = Project(
  //         id: 0,
  //         userid: 0,
  //         projectName: '',
  //         post: [],
  //         projectTag: [],
  //         looper: [],
  //         is_user: 0)
  //     .obs;
  // RxList<ProjectPostingWidget> postinglist = <ProjectPostingWidget>[].obs;
  Project? exproject;

  @override
  Widget build(BuildContext context) {
    controller.isProjectLoading(true);
    getproject(projectid).then((value) {
      controller.project(value);
      controller.postinglist(List.from(controller.project.value.post
          .map((post) => ProjectPostingWidget(
                item: post,
                isuser: controller.project.value.is_user ?? 0,
                realname: controller.project.value.realname ?? '',
                department: controller.project.value.department ?? '',
                profileimage: controller.project.value.profileimage ?? '',
              ))
          .toList()
          .reversed));
      controller.isProjectLoading.value = false;
    });
    return Obx(
      () => Stack(children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back(result: controller.project.value);
              },
              icon: SvgPicture.asset('assets/icons/Arrow.svg'),
            ),
            actions: [
              Obx(
                () => (controller.project.value.is_user == 1)
                    ? IconButton(
                        onPressed: () async {
                          exproject = await Get.to(() => ProjectModifyScreen(
                                project: controller.project,
                              ));
                          if (exproject != null) {
                            controller.project(exproject);
                          }
                        },
                        icon: SvgPicture.asset('assets/icons/Edit.svg'),
                      )
                    : Container(),
              ),
              IconButton(
                onPressed: () {
                  controller.project.value.is_user == 1
                      ? modalController.showModalIOS(
                          context,
                          func1: () {
                            modalController.showButtonDialog(
                                leftText: '취소',
                                rightText: '삭제',
                                title:
                                    '정말 <${controller.project.value.projectName}> 활동을 삭제하시겠어요?',
                                content:
                                    '지금까지 작성한 ${controller.project.value.post.length}개의 포스팅도 삭제됩니다',
                                leftFunction: () => Get.back(),
                                rightFunction: () async {
                                  Get.back();
                                  Get.back();
                                  controller.isProjectDeleteLoading(true);
                                  await deleteproject(
                                      controller.project.value.id);
                                  controller.isProjectDeleteLoading(false);
                                  Get.back();
                                });
                          },
                          func2: () {},
                          value1: '이 활동 삭제하기',
                          value2: '',
                          isValue1Red: true,
                          isValue2Red: false,
                          isOne: true,
                        )
                      : modalController.showModalIOS(
                          context,
                          func1: () {
                            modalController.showButtonDialog(
                                leftText: '취소',
                                rightText: '신고',
                                title:
                                    '정말 <${controller.project.value.projectName}> 활동을 신고하시겠어요?',
                                content:
                                    '지금까지 작성한 ${controller.project.value.post.length}개의 포스팅도 삭제됩니다',
                                leftFunction: () => Get.back(),
                                rightFunction: () {});
                          },
                          func2: () {},
                          value1: '이 활동 신고하기',
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
            () => controller.isProjectLoading.value
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
                                  controller.project.value.projectName,
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
                                          '${DateFormat("yy.MM.dd").format(controller.project.value.startDate ?? DateTime(2022))} ~ ${controller.project.value.endDate != null ? DateFormat("yy.MM.dd").format(controller.project.value.endDate ?? DateTime(2022)) : ''}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: (controller
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
                                            color: (controller.project.value
                                                        .endDate ==
                                                    null)
                                                ? Color(0xffefefef)
                                                : Color(0xff888B8C),
                                          ),
                                          child: Center(
                                            child: Text(
                                              controller.project.value
                                                          .endDate ==
                                                      null
                                                  ? '진행중'
                                                  : DurationCaculator()
                                                      .durationCaculate(
                                                          startDate: controller
                                                              .project
                                                              .value
                                                              .startDate!,
                                                          endDate: controller
                                                              .project
                                                              .value
                                                              .endDate!),
                                              style: TextStyle(
                                                fontWeight: (controller.project
                                                            .value.endDate ==
                                                        null)
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                                fontSize: 14,
                                                color: (controller.project.value
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
                                            '${controller.likesum(likecount, controller.project.value.post.map((post) => post.likeCount.value).toList())}',
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
                                                  CircleAvatar(
                                                backgroundColor:
                                                    Color(0xffe7e7e7),
                                                child: Container(),
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
                                                    CircleAvatar(
                                                  backgroundColor:
                                                      Color(0xffe7e7e7),
                                                  child: Container(),
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
                                                    CircleAvatar(
                                                  backgroundColor:
                                                      Color(0xffe7e7e7),
                                                  child: Container(),
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
                                          text: '박지환',
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
                                  controller.project.value.introduction ?? '',
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
                                  children: controller.project.value.projectTag
                                      .map(
                                        (tag) => Row(
                                          children: [
                                            Tagwidget(
                                              tag: tag,
                                              fontSize: 14,
                                            ),
                                            controller.project.value.projectTag
                                                        .indexOf(tag) !=
                                                    controller.project.value
                                                            .projectTag.length -
                                                        1
                                                ? SizedBox(
                                                    width: 8,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '활동 포스팅',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  controller.project.value.is_user == 1
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.to(() => PostingAddNameScreen(
                                                  project_id: controller
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
                                  children:
                                      controller.project.value.post.isNotEmpty
                                          ? controller.postinglist
                                          : [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                '첫 포스팅을 작성해주세요',
                                                style: kSubTitle2Style.copyWith(
                                                  color: mainblack,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '포스팅을 통해 경험한 순간들을 남겨 보세요',
                                                style: kButtonStyle.copyWith(
                                                  color: mainblue,
                                                ),
                                              ),
                                            ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        if (controller.isProjectDeleteLoading.value)
          Container(
            height: Get.height,
            width: Get.width,
            color: mainblack.withOpacity(0.3),
            child: Image.asset(
              'assets/icons/loading.gif',
              scale: 6,
            ),
          ),
      ]),
    );
  }
}
