import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/signup_text_widget.dart';
import '../controller/ga_controller.dart';

class SignupEmailcheckScreen extends StatelessWidget {
  final SignupController _signupController = Get.find();
  final GAController _gaController = Get.find();

  // Map<Emailcertification, String> leftButtonText = {
  //   Emailcertification.normal: "이전",
  //   Emailcertification.waiting: "인증 취소하기",
  //   Emailcertification.success: "이전",
  //   Emailcertification.fail: "이전",
  // };

  Map<Emailcertification, String> rightButtonText = {
    Emailcertification.normal: "인증하기",
    Emailcertification.waiting: "인증 대기중",
    Emailcertification.success: "다음",
    Emailcertification.fail: "다시 보내기",
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_signupController.signupcertification.value ==
            Emailcertification.waiting) {
          _signupController.timer.timerClose(dialogOn: false);
        }
        return true;
      },
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
                  Obx(() => _signupController.signupcertification.value ==
                          Emailcertification.waiting
                      ? _signupController.timer.timerDisplay()
                      : Container()),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomExpandedButton(
                            onTap: () {
                              if (_signupController.signupcertification.value ==
                                  Emailcertification.waiting) {
                                _signupController.timer
                                    .timerClose(dialogOn: false);
                              }
                              Get.back();
                            },
                            isBlue: false,
                            title: "취소하기",
                            isBig: true),
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
                                    loading();
                                    await emailRequest(
                                            _signupController
                                                    .emailidcontroller.text +
                                                "@" +
                                                _signupController
                                                    .selectUniv.value.email,
                                            _signupController
                                                .signupcertification)
                                        .then((value) {
                                      if (value.isError == false) {
                                        Get.back();
                                        _signupController.timer.timerOn(180);
                                      } else {
                                        FirebaseMessaging.instance
                                            .unsubscribeFromTopic(value.data);
                                        Get.back();
                                        if (value.errorData!["statusCode"] ==
                                            400) {
                                          Get.closeCurrentSnackbar();
                                          showCustomDialog(
                                              "이미 가입된 회원입니다", 1000);
                                        } else {
                                          Get.closeCurrentSnackbar();
                                          errorSituation(value);
                                        }
                                        _signupController.timer
                                            .timerClose(dialogOn: false);
                                      }
                                    });
                                  } else {
                                    showCustomDialog("이메일을 입력해주세요", 1000);
                                  }
                                } else if (_signupController
                                        .signupcertification.value ==
                                    Emailcertification.success) {}
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _signupController.isReCertification == false
                      ? SignUpTextWidget(
                          oneLinetext: "학교 인증을 위해",
                          twoLinetext: "",
                          twohighlightText: "입력한 주소로 메일을 보냈어요",
                        )
                      : SignUpTextWidget(
                          oneLinetext: "재인증을 위해",
                          twoLinetext: "",
                          twohighlightText: "입력한 주소로 메일을 보냈어요",
                        ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "${_signupController.emailidcontroller.text}@${_signupController.selectUniv.value.email}",
                    style: kmainbold,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "위 이메일 주소에서 메일을 확인해주세요",
                    style: kmain,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    _signupController.isReCertification == false
                        ? "메일 속 링크를 클릭하면 가입이 완료돼요"
                        : "메일 속 링크를 클릭하면 재인증이 완료되며,",
                    style: kmain,
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  if (_signupController.isReCertification == false)
                    Text(
                      "재인증 된 대학 메일로 로그인이 가능해요",
                      style: kmain.copyWith(color: mainblue),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
