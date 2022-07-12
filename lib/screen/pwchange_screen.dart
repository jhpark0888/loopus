// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/pwchange_controller.dart';
import 'package:loopus/utils/check_form_validate.dart';
import 'package:loopus/utils/error_control.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class PwChangeScreen extends StatelessWidget {
  PwChangeScreen({Key? key, required this.pwType}) : super(key: key);
  PwChangeController pwChangeController = Get.put(PwChangeController());

  final _formKey = GlobalKey<FormState>();
  PwType pwType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '비밀번호 변경',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                pwType == PwType.pwchange
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '현재 비밀번호',
                            style: kSubTitle2Style,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          CustomTextField(
                            counterText: null,
                            maxLength: null,
                            textController:
                                pwChangeController.originpwcontroller,
                            hintText: '',
                            validator: (value) =>
                                CheckValidate().validatePassword(value!),
                            obscureText: true,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      )
                    : Container(),
                Text(
                  '새로운 비밀번호',
                  style: kSubTitle2Style,
                ),
                SizedBox(
                  height: 12,
                ),
                CustomTextField(
                  counterText: null,
                  maxLength: null,
                  textController: pwChangeController.newpwcontroller,
                  hintText: '8자리 이상',
                  validator: (value) =>
                      CheckValidate().validatePassword(value!),
                  obscureText: true,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  '새로운 비밀번호 확인',
                  style: kSubTitle2Style,
                ),
                SizedBox(
                  height: 12,
                ),
                CustomTextField(
                  counterText: null,
                  maxLength: null,
                  textController: pwChangeController.newpwcheckcontroller,
                  hintText: '',
                  validator: (value) {
                    if (pwChangeController.newpwcontroller.text != value) {
                      return "입력하신 비밀번호와 일치하지 않아요";
                    }
                  },
                  obscureText: true,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 32,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      pwType == PwType.pwchange
                          ? putpwchange().then((value) {
                              if (value.isError == false) {
                                Get.back();
                                showCustomDialog('비밀번호 변경이 완료되었습니다', 1400);
                              } else {
                                if (value.errorData!["statusCode"] == 401) {
                                  showCustomDialog('현재 비밀번호가 틀렸습니다.', 1400);
                                } else {
                                  errorSituation(value);
                                }
                              }
                            })
                          : putpwfindchange().then((value) {
                              if (value.isError == false) {
                                getbacks(2);
                                showCustomDialog('비밀번호 변경이 완료되었습니다', 1400);
                              } else {
                                if (value.errorData!["statusCode"] == 401) {
                                  showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
                                } else {
                                  errorSituation(value);
                                }
                              }
                            });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: mainblue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        '변경하기',
                        style: kButtonStyle.copyWith(color: mainWhite),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
