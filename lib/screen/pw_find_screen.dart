import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/login_api.dart';
import 'package:loopus/api/signup_api.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/login_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/pwchange_controller.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/pwchange_screen.dart';
import 'package:loopus/utils/error_control.dart';

import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/certfynum_textfield_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';

import '../utils/check_form_validate.dart';

class PwFindScreen extends StatelessWidget {
  final PwChangeController _pwChangeController = Get.put(PwChangeController());
  final LogInController _loginController = Get.put(LogInController());
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  Map<Emailcertification, String> rightButtonText = {
    Emailcertification.normal: "메일 보내기",
    Emailcertification.waiting: "인증 대기중",
    Emailcertification.success: "다음",
    Emailcertification.fail: "다시 보내기",
  };

  RxBool isCertiftNumdiffer = false.obs;

  void _timerClose() {
    _pwChangeController.timer.timerClose(closeFunction: () {
      _pwChangeController.pwcertification(Emailcertification.fail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pwChangeController.pwcertification.value ==
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
                  Obx(() => _pwChangeController.pwcertification.value ==
                          Emailcertification.waiting
                      ? _pwChangeController.timer.timerDisplay(context)
                      : Container()),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomExpandedButton(
                            onTap: () {
                              if (_pwChangeController.pwcertification.value ==
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
                                if (_loginController.pwFindButtonOn.value) {
                                  if (_pwChangeController
                                              .pwcertification.value ==
                                          Emailcertification.fail ||
                                      _pwChangeController
                                              .pwcertification.value ==
                                          Emailcertification.normal) {
                                    await postpwfindemailcheck(
                                            _loginController.idcontroller.text,
                                            _pwChangeController.pwcertification)
                                        .then((value) {
                                      if (value.isError == false) {
                                        showBottomSnackbar(
                                            "${_loginController.idcontroller.text}로\n인증 메일을 보냈어요\n메일을 확인하고 인증을 완료해주세요");
                                        _pwChangeController.timer.timerOn(180);
                                      } else {
                                        _pwChangeController.pwcertification(
                                            Emailcertification.fail);
                                        if (value.errorData!["statusCode"] ==
                                            401) {
                                          Get.closeCurrentSnackbar();

                                          showCustomDialog(
                                              '아직 가입 되지 않은 이메일입니다', 1400);
                                        } else {
                                          Get.closeCurrentSnackbar();
                                          errorSituation(value);
                                        }
                                        _timerClose();
                                      }
                                    });
                                  } else if (_pwChangeController
                                          .pwcertification.value ==
                                      Emailcertification.success) {
                                    Get.to(() =>
                                        PwChangeScreen(pwType: PwType.pwfind));
                                  }
                                }
                              },
                              isBlue: _loginController.pwFindButtonOn.value
                                  ? _pwChangeController.pwcertification.value ==
                                          Emailcertification.waiting
                                      ? false
                                      : true
                                  : false,
                              title: rightButtonText[
                                  _pwChangeController.pwcertification.value],
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
                    oneLinetext: "비밀번호 변경을 위해",
                    twoLinetext: "이메일로 본인임을 인증해주세요",
                  ),
                  LabelTextFieldWidget(
                    label: "대학 웹메일 주소",
                    hintText: "본인 대학 이메일 아이디",
                    textController: _loginController.idcontroller,
                    keyboardType: TextInputType.emailAddress,
                    // validator: (value) =>
                    //     CheckValidate().validateEmail(value!),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CertfyTextFieldWidget(
                            controller: _pwChangeController.certfyNumController,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Obx(
                          () => CustomExpandedButton(
                              onTap: () async {
                                loading();
                                await certfyNumRequest(
                                        _loginController.idcontroller.text,
                                        _pwChangeController
                                            .certfyNumController.text)
                                    .then((value) async {
                                  if (value.isError == false) {
                                    Get.back();
                                    isCertiftNumdiffer(false);
                                    _pwChangeController.timer.timerClose();
                                    PwChangeController.to.pwcertification(
                                        Emailcertification.success);
                                    Get.to(() =>
                                        PwChangeScreen(pwType: PwType.pwfind));
                                  } else {
                                    Get.back();
                                    if (value.errorData!["statusCode"] == 401) {
                                      isCertiftNumdiffer(true);
                                    } else {
                                      isCertiftNumdiffer(false);
                                      errorSituation(value);
                                    }
                                  }
                                });
                              },
                              isBlue:
                                  _pwChangeController.isCertftNumCheck.value,
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
