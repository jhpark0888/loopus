// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/pwchange_controller.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';

class PwChangeScreen extends StatelessWidget {
  PwChangeScreen({Key? key, required this.pwType}) : super(key: key);
  final PwChangeController _pwChangeController = Get.put(PwChangeController());

  PwType pwType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                Obx(() => _pwChangeController.pwcertification.value ==
                        Emailcertification.waiting
                    ? _pwChangeController.timer.timerDisplay()
                    : Container()),
                const SizedBox(
                  height: 24,
                ),
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
                            onTap: () {
                              if (_pwChangeController.pwChangeButtonOn.value) {
                                loading();
                                pwType == PwType.pwchange
                                    ? putpwchange().then((value) {
                                        if (value.isError == false) {
                                          getbacks(2);
                                          showCustomDialog(
                                              '비밀번호 변경이 완료되었습니다', 1400);
                                        } else {
                                          Get.back();

                                          if (value.errorData!["statusCode"] ==
                                              401) {
                                            showCustomDialog(
                                                '현재 비밀번호가 틀렸습니다.', 1400);
                                          } else {
                                            errorSituation(value);
                                          }
                                        }
                                      })
                                    : putpwfindchange().then((value) {
                                        if (value.isError == false) {
                                          getbacks(3);
                                          showCustomDialog(
                                              '비밀번호 변경이 완료되었습니다', 1400);
                                        } else {
                                          Get.back();
                                          if (value.errorData!["statusCode"] ==
                                              401) {
                                            showCustomDialog(
                                                '입력한 정보를 다시 확인해주세요', 1400);
                                          } else {
                                            errorSituation(value);
                                          }
                                        }
                                      });
                              }
                            },
                            isBlue: _pwChangeController.pwChangeButtonOn.value,
                            title: "변경하기",
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
                  oneLinetext: "비밀번호는 최소",
                  twoLinetext: "6글자 이상이어야 합니다",
                ),
                pwType == PwType.pwchange
                    ? LabelTextFieldWidget(
                        label: "현재 비밀번호",
                        hintText: "최소 6글자",
                        textController: _pwChangeController.originpwcontroller,
                        // validator: (value) =>
                        //     CheckValidate().validatePassword(value!),
                        obscureText: true,
                      )
                    : Container(),
                LabelTextFieldWidget(
                  label: "새로운 비밀번호",
                  hintText: "최소 6글자",
                  textController: _pwChangeController.newpwcontroller,
                  // validator: (value) =>
                  //     CheckValidate().validatePassword(value!),
                  obscureText: true,
                ),
                LabelTextFieldWidget(
                  label: "새로운 비밀번호 확인",
                  hintText: "",
                  textController: _pwChangeController.newpwcheckcontroller,
                  // validator: (value) {
                  //   if (_pwChangeController.newpwcontroller.text != value) {
                  //     return "입력하신 비밀번호와 일치하지 않아요";
                  //   }
                  // },
                  obscureText: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
