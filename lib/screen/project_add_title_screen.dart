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

import '../check_form_validate.dart';

class ProjectAddTitleScreen extends StatelessWidget {
  ProjectAddTitleScreen({
    Key? key,
    required this.screenType,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  Screentype screenType;
  ProjectAddController projectaddcontroller = Get.put(ProjectAddController());
  TagController tagController = Get.put(TagController());

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
              : Obx(() => ProjectDetailController.to.isProjectLoading.value
                  ? Image.asset(
                      'assets/icons/loading.gif',
                      scale: 9,
                    )
                  : TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ProjectDetailController.to.isProjectLoading.value =
                              true;
                          await updateproject(
                              ProjectDetailController.to.project.value.id,
                              ProjectUpdateType.project_name);
                          await getproject(
                                  ProjectDetailController.to.project.value.id)
                              .then((value) {
                            ProjectDetailController.to.project(value);
                            ProjectDetailController.to.isProjectLoading.value =
                                false;
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
              Text(
                '활동명이 무엇인가요?',
                style: kSubTitle1Style,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                '어떤 활동인지 잘 드러나는 이름을 입력해주세요',
                style: kBody2Style,
              ),
              SizedBox(
                height: 32,
              ),
              TextFormField(
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 32,
                  autocorrect: false,
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(2),
                  style: TextStyle(
                    color: mainblack,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                  cursorColor: mainblack,
                  controller: projectaddcontroller.projectnamecontroller,
                  decoration: InputDecoration(
                    hintText: 'OO 스터디, OO 공모전, OO 프로젝트...',
                    hintStyle: TextStyle(
                      color: mainblack.withOpacity(0.38),
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(color: mainblack, width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(color: mainblack, width: 1),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(color: mainpink, width: 1),
                    ),
                  ),
                  validator: (value) => CheckValidate().validateName(value!))
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

