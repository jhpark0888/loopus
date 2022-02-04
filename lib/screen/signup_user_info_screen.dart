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
        bottomBorder: false,
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
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '계정',
                        style: kSubTitle1Style.copyWith(
                          color: mainblue,
                        ),
                      ),
                      const TextSpan(
                        text: '을 만들어주세요',
                        style: kSubTitle1Style,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                //Todo: UX Writing
                const Text(
                  '공정한 이용을 위해 학교 이메일 주소를 받고 있어요',
                  style: kBody2Style,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 32,
                ),
                //TODO: 학교 별 다른 UX Writing
                const Text(
                  '인천대학교 이메일 주소',
                  style: kButtonStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        counterText: null,
                        maxLength: null,
                        textController: signupController.emailidcontroller,
                        //TODO: 선택한 학교에 따라 hintText의 Domain 주소 변경
                        hintText: 'loopus',
                        validator: (value) =>
                            CheckValidate().validateSpecificWords(value!),
                        obscureText: false,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    //TODO: 학교 별 다른 UX Writing
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('@inu.ac.kr'),
                    ),
                  ],
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
                  hintText: '8자리 이상',
                  validator: (value) =>
                      CheckValidate().validatePassword(value!),
                  obscureText: true,
                  maxLines: 1,
                ),
                // const SizedBox(
                //   height: 32,
                // ),
                // const Text(
                //   '비밀번호 확인',
                //   style: kButtonStyle,
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // CustomTextField(
                //   counterText: null,
                //   maxLength: null,
                //   textController: signupController.passwordcheckcontroller,
                //   hintText: '',
                //   validator: (value) {
                //     if (signupController.passwordcontroller.text != value) {
                //       return "입력하신 비밀번호와 일치하지 않아요";
                //     }
                //   },
                //   obscureText: true,
                //   maxLines: 1,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
