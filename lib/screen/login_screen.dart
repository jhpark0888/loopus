import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';
import 'package:loopus/app.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/login_controller.dart';
import 'package:loopus/main.dart';
import 'package:loopus/screen/signup_campus_info_screen.dart';
import 'package:loopus/screen/signup_user_info_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final LogInController _loginController = Get.put(LogInController());
  static final FlutterSecureStorage? storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '로그인',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이메일 주소',
                    style: kSubTitle2Style,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      autocorrect: false,
                      minLines: 1,
                      maxLines: 1,
                      autofocus: true,
                      style: kSubTitle3Style,
                      cursorColor: mainblack,
                      cursorWidth: 1.2,
                      cursorRadius: Radius.circular(2),
                      controller: _loginController.idcontroller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 8),
                        isDense: true,
                        hintText: 'loopus@inu.ac.kr',
                        hintStyle: kSubTitle3Style.copyWith(
                          color: mainblack.withOpacity(0.38),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: BorderSide(color: mainblack, width: 1.2),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: BorderSide(color: mainblack, width: 1.2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainblack, width: 1.2),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainpink, width: 1.2),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: mainpink, width: 1.2),
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
                      '비밀번호',
                      style: kSubTitle2Style,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    minLines: 1,
                    autofocus: true,
                    style: kSubTitle3Style,
                    cursorColor: mainblack,
                    cursorWidth: 1.5,
                    cursorRadius: Radius.circular(2),
                    controller: _loginController.passwordcontroller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8),
                      isDense: true,
                      hintText: '영문, 숫자, 특수문자 포함 8자리 이상',
                      hintStyle: kSubTitle3Style.copyWith(
                        color: mainblack.withOpacity(0.38),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: BorderSide(color: mainblack, width: 1.2),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                        borderSide: BorderSide(color: mainblack, width: 1.2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainblack, width: 1.2),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainpink, width: 1.2),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: mainpink, width: 1.2),
                      ),
                    ),
                    validator: (value) =>
                        CheckValidate().validatePassword(value!),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          loginRequest();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: mainblue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            "로그인하기",
                            style: kButtonStyle.copyWith(color: mainWhite),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 24,
                  ),
                  InkWell(
                      onTap: () {
                        // Get.to(() => )
                      },
                      child: Center(
                        child: Text(
                          "비밀번호 찾기",
                          style: kButtonStyle.copyWith(
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
    );
  }
}

// class CheckValidate {
//   String? validateEmail(String value) {
//     if (value.isEmpty) {
//       return '이메일을 입력하세요.';
//     } else {
//       Pattern pattern =
//           r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//       RegExp regExp = new RegExp(pattern.toString());
//       if (!regExp.hasMatch(value)) {
//         return '잘못된 이메일 형식입니다.';
//       } else {
//         return null;
//       }
//     }
//   }

//   String? validatePassword(String value) {
//     if (value.isEmpty) {
//       return '비밀번호를 입력하세요.';
//     } else {
//       Pattern pattern =
//           r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
//       RegExp regExp = new RegExp(pattern.toString());
//       if (!regExp.hasMatch(value)) {
//         return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
//       } else {
//         return null;
//       }
//     }
//   }
// }
