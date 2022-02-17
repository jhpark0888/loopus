import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/projectpeople_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/posting_add_name_screen.dart';
import 'package:loopus/screen/posting_add_content_screen.dart';
import 'package:loopus/screen/project_modify_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_posting_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:intl/intl.dart';

import '../widget/custom_expanded_button.dart';

class ProjectScreen extends StatelessWidget {
  ProjectScreen({
    required this.projectid,
    required this.isuser,
    Key? key,
  }) : super(key: key);

  ModalController modalController = Get.put(ModalController());

  late ProjectDetailController controller =
      Get.put(ProjectDetailController(projectid), tag: projectid.toString());

  int projectid;
  int isuser;
  RxInt likecount = 0.obs;

  Widget looppersonlist() {
    double? width;
    List<Widget> personlist = [];
    if (controller.project.value.looper.length == 1) {
      personlist.add(ProjectLooperImage(
          user: controller.project.value.looper.first, index: 0));
      width = 30;
    } else if (controller.project.value.looper.length == 2) {
      for (int i = 0; i < controller.project.value.looper.length; i++) {
        personlist.add(ProjectLooperImage(
            user: controller.project.value.looper[i], index: i));
      }
      width = 50;
    } else if (controller.project.value.looper.length >= 3) {
      for (int i = 0; i < 3; i++) {
        personlist.add(ProjectLooperImage(
            user: controller.project.value.looper[i], index: i));
      }
      width = 70;
    }
    return Container(
      width: width,
      child: Stack(
        children: personlist,
      ),
    );
  }

  Widget looppersonname() {
    List<InlineSpan>? textspanlist = [];
    if (controller.project.value.looper.length == 1) {
      textspanlist.add(
        TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Get.to(() => OtherProfileScreen(
                  userid: controller.project.value.looper.first.userid,
                  isuser: 0,
                  realname: controller.project.value.looper.first.realName));
            },
          text: controller.project.value.looper.first.realName,
          style: kButtonStyle,
        ),
      );
      textspanlist.add(
        TextSpan(
          text: '님이',
        ),
      );
    } else if (controller.project.value.looper.length == 2) {
      for (int i = 0; i < controller.project.value.looper.length; i++) {
        textspanlist.add(
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(() => OtherProfileScreen(
                    userid: controller.project.value.looper[i].userid,
                    isuser: 0,
                    realname: controller.project.value.looper[i].realName));
              },
            text: controller.project.value.looper[i].realName,
            style: kButtonStyle,
          ),
        );
        textspanlist.add(
          TextSpan(
            text: '님',
          ),
        );
        if (i == 0) {
          textspanlist.add(
            TextSpan(
              text: ', ',
            ),
          );
        }
      }
      textspanlist.add(
        TextSpan(
          text: '이',
        ),
      );
    } else if (controller.project.value.looper.length >= 3) {
      for (int i = 0; i < 2; i++) {
        textspanlist.add(
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(() => OtherProfileScreen(
                    userid: controller.project.value.looper[i].userid,
                    isuser: 0,
                    realname: controller.project.value.looper[i].realName));
              },
            text: controller.project.value.looper[i].realName,
            style: kButtonStyle,
          ),
        );
        textspanlist.add(
          TextSpan(
            text: '님',
          ),
        );
        if (i == 0) {
          textspanlist.add(
            TextSpan(
              text: ', ',
            ),
          );
        }
      }
      textspanlist.add(
        TextSpan(
          text: ' 외 ',
        ),
      );
      textspanlist.add(TextSpan(
        text: '${controller.project.value.looper.length - 2}명이',
        style: kButtonStyle,
      ));
    }
    textspanlist.add(
      TextSpan(
        text: ' 참여했어요',
      ),
    );

    return RichText(
      text: TextSpan(
        children: textspanlist,
        style: kBody2Style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.loadProject();
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
              (isuser == 1)
                  ? IconButton(
                      onPressed: () {
                        Get.to(
                          () => ProjectModifyScreen(
                            projectid: controller.project.value.id,
                          ),
                        );
                      },
                      icon: SvgPicture.asset('assets/icons/Edit.svg'),
                    )
                  : Container(),
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
                                    '<${controller.project.value.projectName}> 활동을 삭제하시겠어요?',
                                content:
                                    '작성한 ${controller.project.value.post.length}개의 포스팅도 삭제됩니다',
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
                                    '<${controller.project.value.projectName}> 활동을 신고하시겠어요?',
                                content: '관리자가 검토 후 조치하도록 하겠습니다',
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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
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
                                  style: kHeaderH2Style,
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
                                            style: kSubTitle2Style),
                                        SizedBox(
                                          width: (controller
                                                      .project.value.endDate ==
                                                  null)
                                              ? 4
                                              : 8,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
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
                                                    ? FontWeight.w400
                                                    : FontWeight.w500,
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
                                              '${controller.project.value.like_count!.value}',
                                              style: kButtonStyle),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (controller.project.value.looper.isNotEmpty)
                                const SizedBox(
                                  height: 20,
                                ),
                              controller.project.value.looper.isEmpty
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () {
                                        Get.to(() => ProjectPeopleScreen(
                                              projectid: controller.projectid,
                                            ));
                                      },
                                      child: Row(
                                        children: [
                                          looppersonlist(),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          looppersonname(),
                                        ],
                                      ),
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
                              const Text('활동 소개', style: kSubTitle2Style),
                              const SizedBox(
                                height: 8,
                              ),
                              Obx(
                                () => controller.project.value.introduction !=
                                        ''
                                    ? Text(
                                        controller.project.value.introduction ??
                                            '',
                                        style: kBody1Style,
                                      )
                                    : Text(
                                        '-',
                                        style: kBody1Style.copyWith(
                                          color: mainblack.withOpacity(0.6),
                                        ),
                                      ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              const Text(
                                '활동 태그',
                                style: kSubTitle2Style,
                              ),
                              const SizedBox(
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
                                                ? const SizedBox(
                                                    width: 8,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '활동 포스팅',
                                    style: kSubTitle2Style,
                                  ),
                                  controller.project.value.is_user == 1
                                      ? controller.project.value.post.isNotEmpty
                                          ? GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: addPosting,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: Text(
                                                  '포스팅 작성하기',
                                                  style:
                                                      kSubTitle2Style.copyWith(
                                                          color: mainblue),
                                                ),
                                              ),
                                            )
                                          : SizedBox.shrink()
                                      : SizedBox.shrink(),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Obx(
                                () => Column(
                                  children: controller
                                          .project.value.post.isNotEmpty
                                      ? controller.postinglist
                                      : (controller.project.value.is_user == 1)
                                          ? [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text('첫번째 포스팅을 작성해주세요',
                                                  style: kSubTitle1Style),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                '활동을 통해 경험한 순간들을 남겨 보세요',
                                                style: kBody1Style.copyWith(
                                                  color: mainblack
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              CustomExpandedButton(
                                                onTap: addPosting,
                                                isBlue: true,
                                                title: '첫번째 포스팅 작성하기',
                                                buttonTag: '첫번째 포스팅 작성하기',
                                                isBig: false,
                                              )
                                            ]
                                          : [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  '아직 작성한 포스팅이 없어요',
                                                  style:
                                                      kSubTitle3Style.copyWith(
                                                    color: mainblack
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              )
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

  void addPosting() {
    Get.to(() => PostingAddNameScreen(
          project_id: controller.project.value.id,
          route: PostaddRoute.project,
        ));
  }
}

class ProjectLooperImage extends StatelessWidget {
  ProjectLooperImage({Key? key, required this.user, required this.index})
      : super(key: key);

  User user;
  int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: index == 0 ? null : index * 20,
      child: CircleAvatar(
        backgroundColor: mainblack,
        radius: 15,
        child: ClipOval(
            child: user.profileImage != null
                ? CachedNetworkImage(
                    width: 28,
                    height: 28,
                    imageUrl: user.profileImage!,
                    placeholder: (context, url) => kProfilePlaceHolder(),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/illustrations/default_profile.png",
                    height: 28,
                    width: 28,
                  )),
      ),
    );
  }
}
