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
import 'package:loopus/screen/pwchange_screen.dart';
import 'package:loopus/utils/error_control.dart';

import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_textfield.dart';

import '../utils/check_form_validate.dart';

class PwFindScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final PwChangeController _pwChangeController = Get.put(PwChangeController());
  final LogInController _loginController = Get.put(LogInController());
  static FlutterSecureStorage? storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          title: '비밀번호 재설정',
          actions: [
            TextButton(
              onPressed: () {
                if (_pwChangeController.pwcertification.value ==
                    Emailcertification.success) {
                  Get.to(() => PwChangeScreen(
                        pwType: PwType.pwfind,
                      ));
                }
              },
              child: Obx(
                () => Text(
                  '다음',
                  style: ktempFont.copyWith(
                      color: _pwChangeController.pwcertification.value ==
                              Emailcertification.success
                          ? mainblue
                          : mainblack.withOpacity(0.38)),
                ),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                32,
                24,
                32,
                40,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '이메일 주소',
                      style: ktempFont,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextField(
                      counterText: null,
                      maxLength: null,
                      textController: _loginController.idcontroller,
                      hintText: '',
                      obscureText: false,
                      validator: (value) =>
                          (CheckValidate().validateEmail(value!)),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Obx(
                      () => CustomExpandedButton(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (_pwChangeController.pwcertification.value ==
                                      Emailcertification.fail ||
                                  _pwChangeController.pwcertification.value ==
                                      Emailcertification.normal) {
                                postpwfindemailcheck(
                                        _loginController.idcontroller.text,
                                        _pwChangeController.pwcertification)
                                    .then((value) {
                                  if (value.isError == false) {
                                    _pwChangeController.timer.timerOn(180);

                                    // _modalController.showCustomDialog('입력하신 이메일로 새로운 비밀번호를 알려드렸어요', 1400);
                                  } else {
                                    _pwChangeController.pwcertification(
                                        Emailcertification.fail);
                                    if (value.errorData!["statusCode"] == 401) {
                                      Get.closeCurrentSnackbar();

                                      showCustomDialog(
                                          '아직 가입 되지 않은 이메일입니다', 1400);
                                    } else {
                                      Get.closeCurrentSnackbar();
                                      errorSituation(value);
                                    }
                                    _pwChangeController.timer
                                        .timerClose(dialogOn: false);
                                  }
                                });
                              }
                            } else {
                              showCustomDialog('이메일 형식을 다시 확인해주세요', 1400);
                            }
                          },
                          isBlue: _pwChangeController.pwcertification.value ==
                                      Emailcertification.fail ||
                                  _pwChangeController.pwcertification.value ==
                                      Emailcertification.normal
                              ? true
                              : false,
                          isBig: true,
                          title: "비밀번호 재설정 메일 보내기"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Center(
                          child: Text(
                            "로그인 화면으로",
                            style: ktempFont.copyWith(
                              color: mainblack.withOpacity(0.6),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
