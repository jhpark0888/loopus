import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_complete_screen.dart';
import 'package:loopus/screen/signup_pw_screen.dart';
import 'package:loopus/screen/signup_tag_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/signup_text_widget.dart';
import '../controller/ga_controller.dart';

class SignupEmailcheckScreen extends StatelessWidget {
  final SignupController _signupController = Get.find();
  final GAController _gaController = Get.find();

  Map<Emailcertification, String> leftButtonText = {
    Emailcertification.normal: "이전",
    Emailcertification.waiting: "인증 취소하기",
    Emailcertification.success: "이전",
    Emailcertification.fail: "이전",
  };

  Map<Emailcertification, String> rightButtonText = {
    Emailcertification.normal: "인증하기",
    Emailcertification.waiting: "인증 대기중",
    Emailcertification.success: "다음",
    Emailcertification.fail: "다시 보내기",
  };

  // Timer? validChecktimer;

  Widget timerDisplay() {
    return Obx(
      () => Text(
        '0${_signupController.sec.value ~/ 60}:${NumberFormat('00', "ko").format(_signupController.sec.value % 60)}',
        style: kmainbold.copyWith(color: mainblack),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: mainWhite,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "인증이 어려우신가요?",
                      style: kcaption.copyWith(color: maingray),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => CustomExpandedButton(
                              onTap: () {
                                if (_signupController
                                        .signupcertification.value ==
                                    Emailcertification.waiting) {
                                  _signupController.timerClose();
                                } else {
                                  Get.back();
                                }
                              },
                              isBlue: false,
                              title: leftButtonText[
                                  _signupController.signupcertification.value],
                              isBig: true),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Obx(
                          () => CustomExpandedButton(
                              onTap: () async {
                                if (_signupController
                                            .signupcertification.value ==
                                        Emailcertification.normal ||
                                    _signupController
                                            .signupcertification.value ==
                                        Emailcertification.fail) {
                                  if (_signupController.emailidcontroller.text
                                          .trim() !=
                                      "") {
                                    await emailRequest().then((value) {
                                      if (value.isError == false) {
                                        _signupController.sec(180);
                                        _signupController.timerOn();
                                      } else {
                                        if (value.errorData!["statusCode"] ==
                                            400) {
                                          // Get.back();
                                          Get.closeCurrentSnackbar();
                                          showCustomDialog(
                                              "이미 가입된 회원입니다", 1000);
                                        } else {
                                          Get.closeCurrentSnackbar();
                                          errorSituation(value);
                                        }
                                        // signupController.timer!.cancel();
                                        _signupController.signupcertification(
                                            Emailcertification.fail);
                                      }
                                    });
                                  } else {
                                    showCustomDialog("이메일을 입력해주세요", 1000);
                                  }
                                } else if (_signupController
                                        .signupcertification.value ==
                                    Emailcertification.success) {
                                  Get.to(() => SignupPwScreen());
                                }
                              },
                              isBlue: true,
                              title: rightButtonText[
                                  _signupController.signupcertification.value],
                              isBig: true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SignUpTextWidget(
                  oneLinetext: "학교 인증을 위해",
                  twoLinetext: "대학 메일 주소를 입력해주세요",
                ),
                const SizedBox(
                  height: 62,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () => TextField(
                      controller: _signupController.emailidcontroller,
                      style: kmain,
                      keyboardType: TextInputType.emailAddress,
                      maxLines: 1,
                      cursorColor: mainblack,
                      textAlign: TextAlign.end,
                      //TODO: 학교 도메인 확인
                      decoration: InputDecoration(
                        hintText: "본인 대학 이메일 아이디",
                        hintStyle: kmain.copyWith(color: maingray),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(minHeight: 20, minWidth: 20),
                        suffixIcon: SizedBox(
                          width: 150,
                          child: Text(
                            "@${_signupController.selectUniv.value.email}",
                            style: kmain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "이후 루프어스 로그인 아이디로 사용돼요",
                  style: kmain.copyWith(color: maingray),
                ),
                const SizedBox(
                  height: 24,
                ),
                timerDisplay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
