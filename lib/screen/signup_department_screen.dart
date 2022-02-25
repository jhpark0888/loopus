import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_user_info_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';

import '../controller/ga_controller.dart';

class SignupDepartmentScreen extends StatelessWidget {
  final SignupController signupController = Get.find();
  final GAController _gaController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () async {
              if (signupController.selectdept.value != "") {
                //TODO: 학과 선택 시 활성화되어야 함
                Get.to(() => SignupUserInfoScreen());
                await _gaController.logScreenView('signup_3');
              }
            },
            child: Obx(
              () => Text(
                '다음',
                style: kSubTitle2Style.copyWith(
                    color: signupController.selectdept.value != ""
                        ? mainblue
                        : mainblack.withOpacity(0.38)),
              ),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
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
                      text: '어느 학과',
                      style: kSubTitle1Style.copyWith(
                        color: mainblue,
                      ),
                    ),
                    const TextSpan(
                      text: '를 전공하고 계신가요?',
                      style: kSubTitle1Style,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              //Todo: UX Writing
              const Text(
                '전공 학과를 바탕으로 홈 화면을 구성해드릴게요',
                style: kBody2Style,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 32,
              ),
              Obx(
                () => RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '나의 전공 학과 : ',
                        style: kSubTitle1Style.copyWith(
                            fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: signupController.selectdept.value != ''
                            ? '${signupController.selectdept.value}'
                            : '검색 탭에서 선택해주세요',
                        style: kSubTitle1Style.copyWith(
                          color: signupController.selectdept.value != ''
                              ? mainblue
                              : mainblack.withOpacity(0.38),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 32,
              ),
              CustomTextField(
                counterText: null,
                maxLength: null,
                textController: signupController.departmentcontroller,
                hintText: '학과 이름 검색',
                validator: null,
                obscureText: false,
                maxLines: 1,
              ),
              Obx(
                () => signupController.deptscreenstate.value ==
                        ScreenState.loading
                    ? Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            'assets/icons/loading.gif',
                            scale: 6,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '검색중...',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: mainblue.withOpacity(0.6),
                            ),
                          ),
                        ],
                      )
                    : signupController.deptscreenstate.value ==
                            ScreenState.disconnect
                        ? DisconnectReloadWidget(reload: () {
                            signupController
                                .deptscreenstate(ScreenState.loading);

                            getdeptlist();
                          })
                        : signupController.deptscreenstate.value ==
                                ScreenState.error
                            ? ErrorReloadWidget(reload: () {
                                signupController
                                    .deptscreenstate(ScreenState.loading);

                                getdeptlist();
                              })
                            : Obx(
                                () => Expanded(
                                  child: ListView(
                                    children: signupController.searchdeptlist
                                        .map((dept) => GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () {
                                                signupController
                                                    .selectdept(dept);
                                                signupController
                                                    .departmentcontroller
                                                    .text = dept;
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Divider(),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 16.0),
                                                    child: Text(
                                                      dept,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
