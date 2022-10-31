import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/login_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/app.dart';

import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/certification_controller.dart';
import 'package:loopus/controller/home_controller.dart';

import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/pwchange_controller.dart';
import 'package:loopus/controller/search_controller.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/pw_find_screen.dart';
import 'package:loopus/screen/signup_user_info_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/utils/error_control.dart';

import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';

enum CertificateType { userInfoChange, withDrawal, pwChange }

class CertificationScreen extends StatelessWidget {
  CertificationScreen({Key? key, required this.certificateType})
      : super(key: key);

  final CertificationController _controller =
      Get.put(CertificationController());
  final PwChangeController _pwChangeController = Get.put(PwChangeController());

  late PwType pwType;
  final _formKey = GlobalKey<FormState>();
  CertificateType certificateType;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
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
                              if (_controller.nextButtonOn.value) {
                                _certificate(
                                  context,
                                  emailId: _controller.idcontroller.text,
                                  password: _controller.passwordcontroller.text,
                                );
                              }
                            },
                            isBlue: _controller.nextButtonOn.value,
                            title: "다음",
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
                    oneLinetext: "본인 확인을 위해", twoLinetext: "계정 정보를 입력해주세요"),
                LabelTextFieldWidget(
                  label: "본인 대학 이메일",
                  hintText: "인증한 본인 대학 이메일 주소",
                  // validator: (value) =>
                  //     CheckValidate().validateEmail(value!),
                  textController: _controller.idcontroller,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 24,
                ),
                LabelTextFieldWidget(
                    label: "비밀번호",
                    hintText: "루프어스 비밀번호",
                    obscureText: true,
                    // validator: (value) =>
                    //     CheckValidate().validatePassword(value!),
                    textController: _controller.passwordcontroller),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _certificate(context,
      {required String emailId, required String password}) async {
    FocusScope.of(context).unfocus();
    loading();
    // Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
    await loginRequest(emailId, password).then((value) async {
      if (value.isError == false) {
        Get.back();
        if (certificateType == CertificateType.userInfoChange) {
          Get.to(() => SignupUserInfoScreen(
                isReCertification: true,
              ));
        } else {
          TextEditingController textController = TextEditingController();
          showTextFieldDialog2(
            title: "탈퇴 사유를 입력해주세요",
            completeText: '탈퇴하기',
            hintText:
                "루프어스를 탈퇴하는 이유를 알려주세요. 보다 나은 서비스로 보답하겠습니다.\n이후 모든 계정 데이터는 삭제됩니다.",
            leftFunction: () {
              dialogBack();
            },
            rightFunction: () {
              withDrawal(textController.text);
            },
            textEditingController: textController,
          );
        }
      } else {
        Get.back();
        if (value.errorData!["statusCode"] == 401) {
          showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
        } else {
          errorSituation(value);
        }
      }
    });
  }

  void withDrawal(String reason) async {
    loading();
    await deleteuser(_controller.passwordcontroller.text, reason)
        .then((value) async {
      if (value.isError == false) {
        Get.back();
        await logOut();
      } else {
        Get.back();
        if (value.errorData!["statusCode"] == 401) {
          showCustomDialog("비밀번호를 다시 입력해주세요", 1000);
        } else if (value.errorData!["statusCode"] == 403) {
          showCustomDialog("공유 커리어를 정리 후 탈퇴를 다시 진행해주세요", 1000);
        } else {
          errorSituation(value);
        }
      }
    });
  }

  // void pwChange(context,
  //     {required String emailId, required String password}) async {
  //   FocusScope.of(context).unfocus();
  //   loading();
  //   // Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
  //   await loginRequest(emailId, password).then((value) async {
  //     if (_pwChangeController.pwChangeButtonOn.value) {
  //       if (_formKey.currentState!.validate()) {
  //         loading();
  //         pwType == PwType.pwchange
  //             ? putpwchange().then((value) {
  //                 if (value.isError == false) {
  //                   getbacks(2);
  //                   showCustomDialog('비밀번호 변경이 완료되었습니다', 1400);
  //                 } else {
  //                   Get.back();

  //                   if (value.errorData!["statusCode"] == 401) {
  //                     showCustomDialog('현재 비밀번호가 틀렸습니다.', 1400);
  //                   } else {
  //                     errorSituation(value);
  //                   }
  //                 }
  //               })
  //             : putpwfindchange().then((value) {
  //                 if (value.isError == false) {
  //                   getbacks(3);
  //                   showCustomDialog('비밀번호 변경이 완료되었습니다', 1400);
  //                 } else {
  //                   Get.back();
  //                   if (value.errorData!["statusCode"] == 401) {
  //                     showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
  //                   } else {
  //                     errorSituation(value);
  //                   }
  //                 }
  //               });
  //       }
  //     }
  //   });
  // }
}
