import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/login_api.dart';
import 'package:loopus/app.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/login_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/pw_find_screen.dart';
import 'package:loopus/utils/error_control.dart';

import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/custom_textfield.dart';
import 'package:loopus/widget/label_textfield_widget.dart';
import 'package:loopus/widget/signup_text_widget.dart';

import '../utils/check_form_validate.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final LogInController _loginController = Get.put(LogInController());
  static FlutterSecureStorage? storage = const FlutterSecureStorage();

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
                              if (_loginController.loginButtonOn.value) {
                                login(
                                  context,
                                  emailId: _loginController.idcontroller.text,
                                  password: _loginController
                                      .passwordcontroller.text,
                                );
                              }
                            },
                            isBlue: _loginController.loginButtonOn.value,
                            title: "로그인",
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
                    oneLinetext: "대학 메일 주소 및", twoLinetext: "비밀번호를 입력해주세요"),
                LabelTextFieldWidget(
                    label: "본인 대학 이메일",
                    hintText: "인증한 본인 대학 이메일 주소",
                    // validator: (value) =>
                    //     CheckValidate().validateEmail(value!),
                    textController: _loginController.idcontroller),
                LabelTextFieldWidget(
                    label: "비밀번호",
                    hintText: "루프어스에 가입할 때 입력한 비밀번호",
                    obscureText: true,
                    // validator: (value) =>
                    //     CheckValidate().validatePassword(value!),
                    textController: _loginController.passwordcontroller),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                    onTap: () {
                      Get.to(() => PwFindScreen());
                    },
                    child: Center(
                      child: Text(
                        "비밀번호를 잊으셨나요?",
                        style: kmain.copyWith(
                          color: maingray,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void login(context, {required String emailId, required String password}) async {
  FocusScope.of(context).unfocus();
  loading();
  // Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
  await loginRequest(
    emailId,
    password,
  ).then((value) async {
    if (value.isError == false) {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      http.Response response = value.data;
      String token = jsonDecode(response.body)['token'];
      String userid = jsonDecode(response.body)['user_id'];
      //! GA
      // await _gaController.logLogin();

      storage.write(key: 'token', value: token);
      storage.write(key: 'id', value: userid);
      await FirebaseMessaging.instance.subscribeToTopic(userid);
      Get.offAll(() => App());
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
