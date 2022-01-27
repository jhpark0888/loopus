import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/project_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';
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
  TagController tagController = Get.put(TagController(tagtype: Tagtype.project),
      tag: Tagtype.project.toString());
  int? projectid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          screenType == Screentype.add
              ? TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Get.to(() => ProjectAddIntroScreen(
                            screenType: Screentype.add,
                          ));
                    }
                  },
                  child: Obx(
                    () => Text(
                      '다음',
                      style: kSubTitle2Style.copyWith(
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
                                  ProjectUpdateType.project_name);
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
                            }
                          },
                          child: Obx(
                            () => Text(
                              '저장',
                              style: kSubTitle2Style.copyWith(
                                color: projectaddcontroller.ontitlebutton.value
                                    ? mainblue
                                    : mainblack.withOpacity(0.38),
                              ),
                            ),
                          ),
                        ))
        ],
        title: '활동명',
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            32,
            24,
            32,
            40,
          ),
          child: Column(
            children: [
              const Text(
                '활동명이 무엇인가요?',
                style: kSubTitle1Style,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                '어떤 활동인지 잘 드러나는 이름을 입력해주세요',
                style: kBody2Style,
              ),
              const SizedBox(
                height: 32,
              ),
              CustomTextField(
                  counterText: null,
                  maxLength: 32,
                  textController: projectaddcontroller.projectnamecontroller,
                  hintText: 'OO 스터디, OO 공모전, OO 프로젝트...',
                  validator: (value) => CheckValidate().validateName(value!),
                  obscureText: false,
                  maxLines: 2),
            ],
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

