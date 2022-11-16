import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/signup_complete_screen.dart';
import 'package:loopus/screen/signup_fail_screen.dart';
import 'package:loopus/screen/signup_tutorial_screen.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/certfynum_textfield_widget.dart';
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
    Emailcertification.normal: "다시 보내기",
    Emailcertification.waiting: "인증 대기중",
    Emailcertification.success: "다시 시도",
    Emailcertification.fail: "다시 보내기",
  };

  void _timerClose({bool dialogOn = false}) {
    _signupController.timer.timerClose(closeFunction: () {
      _signupController.signupcertification(Emailcertification.fail);
    });
  }

  RxBool isCertiftNumdiffer = false.obs;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_signupController.signupcertification.value ==
            Emailcertification.waiting) {
          _timerClose();
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: AppColors.mainWhite,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() => _signupController.signupcertification.value ==
                          Emailcertification.waiting
                      ? _signupController.timer.timerDisplay(context)
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
                                _timerClose();
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
                                            _signupController.getEmail(),
                                            _signupController
                                                .signupcertification,
                                            isCreate: !_signupController
                                                .isReCertification)
                                        .then((value) {
                                      if (value.isError == false) {
                                        Get.back();
                                        _signupController.certfyNumController
                                            .clear();
                                        _signupController.timer.timerOn(180);
                                      } else {
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
                                        _timerClose();
                                      }
                                    });
                                  } else {
                                    showCustomDialog("이메일을 입력해주세요", 1000);
                                  }
                                } else if (_signupController
                                        .signupcertification.value ==
                                    Emailcertification.success) {
                                  _certftNumSuccess(reTry: true);
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SignUpTextWidget(
                    oneLinetext: "",
                    highlightText: "입력하신 주소로 메일을 보냈어요",
                    twoLinetext: "인증번호를 입력해주세요",
                  ),
                  Text(
                    "${_signupController.emailidcontroller.text}@${_signupController.selectUniv.value.email}",
                    style: MyTextTheme.mainbold(context),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "위 웹메일 주소에서 인증번호를 확인해주세요",
                    style: MyTextTheme.main(context),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: CertfyTextFieldWidget(
                            controller: _signupController.certfyNumController,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Obx(
                          () => CustomExpandedButton(
                              onTap: () async {
                                if (_signupController.isCertftNumCheck.value) {
                                  loading();
                                  await certfyNumRequest(
                                          _signupController.getEmail(),
                                          _signupController
                                              .certfyNumController.text)
                                      .then((value) async {
                                    if (value.isError == false) {
                                      isCertiftNumdiffer(false);
                                      _signupController.timer.timerClose();
                                      _signupController.signupcertification
                                          .value = Emailcertification.success;

                                      _certftNumSuccess();
                                    } else {
                                      Get.back();
                                      if (value.errorData!["statusCode"] ==
                                          401) {
                                        isCertiftNumdiffer(true);
                                      } else {
                                        isCertiftNumdiffer(false);
                                        errorSituation(value);
                                      }
                                    }
                                  });
                                }
                              },
                              isBlue: _signupController.isCertftNumCheck.value,
                              title: "인증하기",
                              isBig: false),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => isCertiftNumdiffer.value
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "인증번호가 다릅니다. 다시 확인해주세요",
                                style: MyTextTheme.main(context)
                                    .copyWith(color: AppColors.rankred),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                      onTap: () {
                        showSignUpEmailHint();
                      },
                      child: Text(
                        "인천대학교 메일이 오지 않는 경우 해결 방법",
                        style: MyTextTheme.main(context)
                            .copyWith(color: AppColors.mainblue),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _certftNumSuccess({bool reTry = false}) async {
    if (_signupController.isReCertification == false) {
      //회원가입
      await signupRequest().then((value) async {
        final GAController _gaController = GAController();

        if (value.isError == false) {
          await _gaController.logSignup();
          await _gaController.setUserProperties(value.data['user_id'],
              _signupController.selectDept.value.deptname);
          await _gaController.logScreenView('signup_6');
          Get.back();
          Get.offAll(() => TutorialScreen(
                emailId: _signupController.emailidcontroller.text +
                    "@" +
                    _signupController.selectUniv.value.email,
                password: _signupController.passwordcontroller.text,
              ));
        } else {
          await _gaController.logScreenView('signup_6');
          // errorSituation(value);
          Get.back();
          if (reTry) {
            errorSituation(value);
          } else {
            showPopUpDialog("인증 완료", "다음 버튼을 눌러주세요");
          }
        }
      });
    } else {
      updateProfile(
              updateType: ProfileUpdateType.profile,
              email: _signupController.getEmail(),
              name: _signupController.namecontroller.text.trim(),
              deptId: _signupController.selectDept.value.id,
              univId: _signupController.selectUniv.value.id,
              admission: _signupController.admissioncontroller.text)
          .then((value) {
        if (value.isError == false) {
          Get.back();
          Get.offAll(() => SignupCompleteScreen(
                emailId: _signupController.emailidcontroller.text +
                    "@" +
                    _signupController.selectUniv.value.email,
                password: _signupController.reCertPw!,
              ));
        } else {
          Get.back();
          if (reTry) {
            errorSituation(value);
          } else {
            showPopUpDialog("인증 완료", "다음 버튼을 눌러주세요");
          }
        }
      });
    }
  }
}
