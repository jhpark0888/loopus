import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/signup_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/signup_emailcheck_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SignupUserInfoScreen extends StatelessWidget {
  // const SignupDepartmentScreen({Key? key}) : super(key: key);
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              children: [
                Text(
                  '계정을 만들어주세요',
                  style: kSubTitle1Style,
                ),
                SizedBox(
                  height: 32,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '학교 이메일 주소',
                    style: kButtonStyle,
                  ),
                ),
                TextFormField(
                    autocorrect: false,
                    minLines: 1,
                    maxLines: 2,
                    autofocus: true,
                    style: kSubTitle1Style,
                    cursorColor: mainblack,
                    cursorWidth: 1.5,
                    cursorRadius: Radius.circular(2),
                    controller: signupController.emailidcontroller,
                    decoration: InputDecoration(
                      hintText: 'loopus@inu.ac.kr',
                      hintStyle: kSubTitle1Style.copyWith(
                        color: mainblack.withOpacity(0.38),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: BorderSide(
                            color: mainblack.withOpacity(
                              0.6,
                            ),
                            width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainblack, width: 1),
                      ),
                    ),
                    validator: (value) =>
                        CheckValidate().validateEmail(value!)),
                SizedBox(
                  height: 32,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '이름',
                    style: kButtonStyle,
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  minLines: 1,
                  maxLines: 2,
                  autofocus: true,
                  style: kSubTitle1Style,
                  cursorColor: mainblack,
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(2),
                  controller: signupController.namecontroller,
                  decoration: InputDecoration(
                    hintText: '홍길동',
                    hintStyle: kSubTitle1Style.copyWith(
                      color: mainblack.withOpacity(0.38),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(
                          color: mainblack.withOpacity(
                            0.6,
                          ),
                          width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainblack, width: 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '비밀번호',
                    style: kButtonStyle,
                  ),
                ),
                TextFormField(
                    autocorrect: false,
                    minLines: 1,
                    maxLines: 2,
                    autofocus: true,
                    style: kSubTitle1Style,
                    cursorColor: mainblack,
                    cursorWidth: 1.5,
                    cursorRadius: Radius.circular(2),
                    controller: signupController.passwordcontroller,
                    decoration: InputDecoration(
                      hintText: '영문, 숫자, 특수문자 포함 8자리 이상',
                      hintStyle: kSubTitle1Style.copyWith(
                        color: mainblack.withOpacity(0.38),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: BorderSide(
                            color: mainblack.withOpacity(
                              0.6,
                            ),
                            width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainblack, width: 1),
                      ),
                    ),
                    validator: (value) =>
                        CheckValidate().validatePassword(value!)),
                SizedBox(
                  height: 32,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '비밀번호 확인',
                    style: kButtonStyle,
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  minLines: 1,
                  maxLines: 2,
                  autofocus: true,
                  style: kSubTitle1Style,
                  cursorColor: mainblack,
                  cursorWidth: 1.5,
                  cursorRadius: Radius.circular(2),
                  controller: signupController.passwordcheckcontroller,
                  decoration: InputDecoration(
                    hintStyle: kSubTitle1Style.copyWith(
                      color: mainblack.withOpacity(0.38),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(2),
                      borderSide: BorderSide(
                          color: mainblack.withOpacity(
                            0.6,
                          ),
                          width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainblack, width: 1),
                    ),
                  ),
                  validator: (value) {
                    if (signupController.passwordcontroller.text != value) {
                      return "비밀번호와 같지 않습니다";
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckValidate {
  String? validateEmail(String value) {
    if (value.isEmpty) {
      return '이메일을 입력하세요';
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern.toString());
      if (!regExp.hasMatch(value)) {
        return '이메일 형식을 다시 확인해주세요';
      } else {
        return null;
      }
    }
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return '비밀번호를 입력하세요';
    } else {
      Pattern pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = new RegExp(pattern.toString());
      if (!regExp.hasMatch(value)) {
        return '영문, 숫자, 특수문자 포함 8자 이상이어야해요';
      } else {
        return null;
      }
    }
  }
}
