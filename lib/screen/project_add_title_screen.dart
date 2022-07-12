import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/local_data_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/trash_bin/project_add_intro_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

import '../utils/check_form_validate.dart';

class ProjectAddTitleScreen extends StatelessWidget {
  ProjectAddTitleScreen({
    Key? key,
    this.projectid,
    required this.screenType,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final Screentype screenType;
  final ProjectAddController projectaddcontroller =
      Get.put(ProjectAddController());
  TagController tagController = Get.put(TagController(tagtype: Tagtype.Posting),
      tag: Tagtype.Posting.toString());
  int? projectid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          actions: [
            screenType == Screentype.add
                ? TextButton(
                    onPressed: () async {
                      // if (_formKey.currentState!.validate()) {
                      //   Get.to(() => ProjectAddPeriodScreen(
                      //         screenType: Screentype.add,
                      //       ));
                      // }
                      projectaddcontroller.selectedStartDateTime.value =
                          DateTime.parse(DateTime.now().toString()).toString();
                      projectaddcontroller.isEndedProject(false);
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

                          ProfileController.to.myProjectList.add(project);
                          ProfileController.to.careerPagenums.add(1);
                          Get.back();

                          SchedulerBinding.instance!.addPostFrameCallback((_) {
                            showCustomDialog('활동이 성공적으로 만들어졌어요!', 1000);
                          });

                          if (_localDataController.isAddFirstProject == true) {
                            final InAppReview inAppReview =
                                InAppReview.instance;

                            if (await inAppReview.isAvailable()) {
                              inAppReview.requestReview();
                            }
                          }
                          _localDataController.firstProjectAdd();
                        } else {
                          await _gaController.logProjectCreated(false);
                          errorSituation(value);
                        }
                      });
                    },
                    child: Obx(
                      () => Text(
                        '확인',
                        style: kNavigationTitle.copyWith(
                          color: projectaddcontroller.ontitlebutton.value
                              ? mainblue
                              : mainblack.withOpacity(0.38),
                        ),
                      ),
                    ),
                  )
                : Obx(() =>
                    Get.find<ProjectDetailController>(tag: projectid.toString())
                            .isProjectUpdateLoading
                            .value
                        ? Image.asset(
                            'assets/icons/loading.gif',
                            scale: 9,
                          )
                        : TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
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
                                        ProjectUpdateType.project_name)
                                    .then((value) {
                                  Get.find<ProjectDetailController>(
                                          tag: projectid.toString())
                                      .isProjectUpdateLoading
                                      .value = false;
                                });
                              }
                            },
                            child: Obx(
                              () => Text(
                                '저장',
                                style: kNavigationTitle.copyWith(
                                  color:
                                      projectaddcontroller.ontitlebutton.value
                                          ? mainblue
                                          : mainblack.withOpacity(0.38),
                                ),
                              ),
                            ),
                          ))
          ],
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/icons/Close.svg'),
          ),
          title: '커리어 추가',
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 14,
                ),
                Text(
                  "본인의 새로운 경험을 추가해보세요",
                  style: kmain.copyWith(color: maingray),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "커리어 이름",
                    style: kmain,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                CustomTextField(
                    counterText: null,
                    maxLength: 32,
                    textController: projectaddcontroller.projectnamecontroller,
                    hintText: '커리어 이름을 입력하세요',
                    validator: (value) => CheckValidate().validateName(value!),
                    obscureText: false,
                    maxLines: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




  // String? validatePassword(String value) {
  //   if (value.isEmpty) {
  //     return '비밀번호를 입력하세요.';
  //   } else {
  //     Pattern pattern =
  //         r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
  //     RegExp regExp = new RegExp(pattern.toString());
  //     if (!regExp.hasMatch(value)) {
  //       return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
  //     } else {
  //       return null;
  //     }
  //   }
  // }

