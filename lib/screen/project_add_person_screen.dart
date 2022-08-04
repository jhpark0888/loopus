// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/trash_bin/project_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';

import '../controller/modal_controller.dart';

class ProjectAddPersonScreen extends StatelessWidget {
  ProjectAddPersonScreen({
    Key? key,
    this.projectid,
    required this.screenType,
  }) : super(key: key);
  // ProjectAddPersonController projectaddpersoncontroller =
  // Get.put(ProjectAddPersonController());
  ProjectAddController projectaddcontroller = Get.find();
  Screentype screenType;
  int? projectid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          screenType == Screentype.add
              ? TextButton(
                  onPressed: () async {
                    loading();
                    await addproject().then((value) async {
                      Get.back();
                      final LocalDataController _localDataController =
                          Get.put(LocalDataController());
                      final GAController _gaController =
                          Get.put(GAController());
                      if (value.isError == false) {
                        await _gaController.logProjectCreated(true);

                        Project project = Project.fromJson(value.data);
                        project.is_user = 1;

                        ProfileController.to.myProjectList.insert(0, project);

                        SchedulerBinding.instance!.addPostFrameCallback((_) {
                          showCustomDialog('활동이 성공적으로 만들어졌어요!', 1000);
                        });

                        if (_localDataController.isAddFirstProject == true) {
                          final InAppReview inAppReview = InAppReview.instance;

                          if (await inAppReview.isAvailable()) {
                            inAppReview.requestReview();
                          }
                        }
                        _localDataController.firstProjectAdd();
                      } else {
                        await _gaController.logProjectCreated(false);
                      }
                    });
                  },
                  child:
                      //  Obx(
                      //   () =>
                      Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      // projectaddcontroller.selectedpersontaglist.isEmpty
                      //     ? '건너뛰기'
                      //     :
                      '만들기',
                      style: ktempFont.copyWith(
                        color: mainblue,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                )
              // )
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
                                    ProjectUpdateType.looper)
                                .then((value) {
                              Get.find<ProjectDetailController>(
                                      tag: projectid.toString())
                                  .isProjectUpdateLoading
                                  .value = false;
                            });
                          },
                          child: Obx(
                            () => Text(
                              '저장',
                              style: ktempFont.copyWith(
                                color: projectaddcontroller
                                        .selectedpersontaglist.isEmpty
                                    ? mainblack
                                    : mainblue,
                              ),
                            ),
                          ),
                        ),
                )
        ],
        title: '함께 활동한 사람',
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  32,
                  24,
                  32,
                  12,
                ),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '커리어를 ',
                            style: ktempFont,
                          ),
                          TextSpan(
                            text: '같이 진행한 학생',
                            style: ktempFont.copyWith(
                              color: mainblue,
                            ),
                          ),
                          TextSpan(
                            text: '이 있나요?',
                            style: ktempFont,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      '팔로잉 중인 학생만 추가할 수 있어요',
                      style: ktempFont,
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => projectaddcontroller.looppersonlist.value.length != 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 16, left: 16, top: 20),
                        child: Text(
                          '선택한 학생',
                          style: ktempFont,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 32,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: (index == 0) ? 16 : 0,
                                    right: (index == 0) ? 16 : 0),
                                child: Obx(() => Row(
                                    children: projectaddcontroller
                                        .selectedpersontaglist.value)),
                              );
                            }),
                      ),
                    ],
                  )
                : Container()),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('팔로잉 중인 학생', style: ktempFont),
                  SizedBox(
                    width: 4,
                  ),
                  Obx(
                    () => Text(
                        '${projectaddcontroller.looppersonlist.value.length}명',
                        style: ktempFont),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() => projectaddcontroller.looppersonscreenstate.value ==
                    ScreenState.loading
                ? Column(
                    children: [
                      Image.asset(
                        'assets/icons/loading.gif',
                        scale: 6,
                      ),
                      Text(
                        '팔로잉 리스트 받아오는 중...',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: mainblue,
                        ),
                      )
                    ],
                  )
                : projectaddcontroller.looppersonscreenstate.value ==
                        ScreenState.disconnect
                    ? DisconnectReloadWidget(reload: () {
                        getprojectfollowlist(
                            ProfileController.to.myUserInfo.value.userid,
                            followlist.following);
                      })
                    : projectaddcontroller.looppersonscreenstate.value ==
                            ScreenState.error
                        ? ErrorReloadWidget(reload: () {
                            getprojectfollowlist(
                                ProfileController.to.myUserInfo.value.userid,
                                followlist.following);
                          })
                        : Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16),
                            child: Column(
                              children: projectaddcontroller
                                          .looppersonlist.value.length !=
                                      0
                                  ? projectaddcontroller.looppersonlist
                                  : [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        '아직 팔로잉 중인 학생이 없어요',
                                        style: ktempFont.copyWith(
                                            color: mainblack.withOpacity(0.38)),
                                      )
                                    ],
                            ),
                          )),
          ],
        ),
      ),
    );
  }
}
