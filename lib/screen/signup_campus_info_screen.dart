import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/ga_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/model/univ_model.dart';
import 'package:loopus/screen/signup_department_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';

class SignupCampusInfoScreen extends StatelessWidget {
  final SignupController signupController = Get.put(SignupController());
  final GAController _gaController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () async {
              if (signupController.selectUniv.value.id != 0) {
                //TODO: 학교 선택 시 활성화되어야 함

                Get.to(() => SignupDepartmentScreen());
              }
            },
            child: Obx(
              () => Text(
                '다음',
                style: kSubTitle2Style.copyWith(
                    color: signupController.selectUniv.value.id != 0
                        ? mainblue
                        : maingray),
              ),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 24,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '어느 대학',
                      style: kSubTitle1Style.copyWith(
                        color: mainblue,
                      ),
                    ),
                    const TextSpan(
                      text: '에 재학 중이신가요?',
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
                '재학 중인 학교의 학생들과 정보를 교류할 수 있어요',
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
                        text: '나의 학교 : ',
                        style: kSubTitle1Style.copyWith(
                            fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: signupController.selectUniv.value.id != 0
                            ? signupController.selectUniv.value.univname
                            : '검색 탭에서 선택해주세요',
                        style: kSubTitle1Style.copyWith(
                          color: signupController.selectUniv.value.id != 0
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
                textController: signupController.campusnamecontroller,
                hintText: '학교 이름 검색',
                obscureText: false,
                validator: null,
                textInputAction: TextInputAction.search,
                onfieldSubmitted: (text) {
                  if (text.trim().isNotEmpty) {
                    signupController.searchUnivLoad(text.trim());
                  }
                },
                maxLines: 1,
              ),
              const SizedBox(
                height: 14,
              ),
              Obx(
                () => signupController.univscreenstate.value ==
                        ScreenState.loading
                    ? const Center(child: LoadingWidget())
                    : signupController.univscreenstate.value ==
                            ScreenState.disconnect
                        ? DisconnectReloadWidget(reload: () {
                            if (signupController.campusnamecontroller.text
                                .trim()
                                .isNotEmpty) {
                              signupController.searchUnivLoad(signupController
                                  .campusnamecontroller.text
                                  .trim());
                            }
                          })
                        : signupController.univscreenstate.value ==
                                ScreenState.error
                            ? ErrorReloadWidget(reload: () {
                                if (signupController.campusnamecontroller.text
                                    .trim()
                                    .isNotEmpty) {
                                  signupController.searchUnivLoad(
                                      signupController.campusnamecontroller.text
                                          .trim());
                                }
                              })
                            : Obx(
                                () => Expanded(
                                  child: ScrollNoneffectWidget(
                                    child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            signupController.selectUniv(
                                                signupController
                                                    .searchUnivList[index]);
                                            signupController.deptInit();
                                            signupController
                                                    .campusnamecontroller.text =
                                                signupController
                                                    .searchUnivList[index]
                                                    .univname;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: Text(
                                              signupController
                                                  .searchUnivList[index]
                                                  .univname,
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const Divider(),
                                      itemCount: signupController
                                          .searchUnivList.length,
                                    ),
                                  ),
                                ),
                              ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
