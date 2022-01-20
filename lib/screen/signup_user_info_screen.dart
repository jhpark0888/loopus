import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/signup_emailcheck_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

import '../utils/check_form_validate.dart';

class SignupUserInfoScreen extends StatelessWidget {
  SignupController signupController = Get.find();
  final _formKey = GlobalKey<FormState>();
  RxBool isbutton = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                emailRequest();
                Get.to(() => SignupEmailcheckScreen());
              }
            },
            child: Text(
              '다음',
              style: kSubTitle2Style.copyWith(color: mainblue),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: SingleChildScrollView(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '계정을 만들어주세요',
                  textAlign: TextAlign.center,
                  style: kSubTitle1Style,
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  '학교 이메일 주소',
                  style: kButtonStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextField(
                  counterText: null,
                  maxLength: null,
                  textController: signupController.emailidcontroller,
                  hintText: 'loopus@inu.ac.kr',
                  validator: (value) => CheckValidate().validateEmail(value!),
                  obscureText: false,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  '이름',
                  style: kButtonStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextField(
                  counterText: null,
                  maxLength: null,
                  textController: signupController.namecontroller,
                  hintText: '김루프',
                  validator: null,
                  obscureText: false,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  '비밀번호',
                  style: kButtonStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextField(
                  counterText: null,
                  maxLength: null,
                  textController: signupController.passwordcontroller,
                  hintText: '영문, 숫자, 특수문자 포함 8자리 이상',
                  validator: (value) =>
                      CheckValidate().validatePassword(value!),
                  obscureText: true,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  '비밀번호 확인',
                  style: kButtonStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextField(
                  counterText: null,
                  maxLength: null,
                  textController: signupController.passwordcheckcontroller,
                  hintText: '',
                  validator: (value) {
                    if (signupController.passwordcontroller.text != value) {
                      return "입력하신 비밀번호와 일치하지 않아요";
                    }
                  },
                  obscureText: true,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
