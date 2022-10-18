import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/signup_emailcheck_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';

// ignore: must_be_immutable
class SignupEmailPwScreen extends StatelessWidget {
  SignupEmailPwScreen({Key? key}) : super(key: key);

  final SignupController _signupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          color: mainWhite,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomExpandedButton(
                      onTap: () {
                        Get.back();
                      },
                      isBlue: false,
                      title: "이전",
                      isBig: true),
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Obx(
                    () => CustomExpandedButton(
                        onTap: () async {
                          loading();
                          if (_signupController.isEmailPassWordCheck.value) {
                            await emailRequest(
                                    _signupController.emailidcontroller.text +
                                        "@" +
                                        _signupController
                                            .selectUniv.value.email,
                                    _signupController.signupcertification)
                                .then((value) {
                              if (value.isError == false) {
                                Get.back();
                                Get.to(() => SignupEmailcheckScreen());
                                _signupController.timer.timerOn(180);
                              } else {
                                Get.back();
                                if (value.errorData!["statusCode"] == 400) {
                                  Get.closeCurrentSnackbar();
                                  showCustomDialog("이미 가입된 회원입니다", 1000);
                                } else {
                                  Get.closeCurrentSnackbar();
                                  errorSituation(value);
                                }
                                _signupController.timer.timerClose(
                                    closeFunction: () {
                                  _signupController.signupcertification(
                                      Emailcertification.fail);
                                  _signupController.timer.certificateClose(
                                      const FlutterSecureStorage());
                                });
                              }
                            });
                          } else {
                            Get.back();
                            showCustomDialog("입력 정보를 확인해주세요", 1000);
                          }
                        },
                        isBlue: _signupController.isEmailPassWordCheck.value,
                        title: "인증하기",
                        isBig: true),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _signupController.isReCertification == false
                    ? SignUpTextWidget(
                        oneLinetext: "가입 정보를 입력해주세요",
                        twoLinetext: "이후 대학 인증이 진행돼요")
                    : SignUpTextWidget(
                        highlightText: "재인증을 위해",
                        oneLinetext: "",
                        twoLinetext: "대학 웹메일 주소를 입력하세요"),
                LabelTextFieldWidget(
                  label: "대학 웹메일 주소",
                  hintText: "본인 대학 이메일 아이디",
                  textController: _signupController.emailidcontroller,
                  suffix: Text(
                    "@${_signupController.selectUniv.value.email}",
                    style: kmain,
                  ),
                ),
                if (_signupController.isReCertification == false)
                  Column(
                    children: [
                      LabelTextFieldWidget(
                        label: "비밀번호",
                        hintText: "최소 6글자",
                        textController: _signupController.passwordcontroller,
                        obscureText: true,
                      ),
                      LabelTextFieldWidget(
                        label: "비밀번호 확인",
                        hintText: "입력한 비밀번호를 다시 입력해주세요",
                        textController:
                            _signupController.passwordcheckcontroller,
                        obscureText: true,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  _signupController.isReCertification == false
                      ? "대학 인증을 위해 정확한 대학 메일을 입력해주세요"
                      : "대학이 변경된 경우, 변경된 대학 주소를 입력해주세요",
                  style: kmain.copyWith(color: maingray),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
