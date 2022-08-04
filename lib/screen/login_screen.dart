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

import '../utils/check_form_validate.dart';

class LogInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final LogInController _loginController = Get.put(LogInController());
  static FlutterSecureStorage? storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '학교 이메일 주소',
                        style: kmain,
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
                            (CheckValidate().validateEmail(value!.trim())),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      const Text(
                        '비밀번호',
                        style: kmain,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        counterText: null,
                        maxLength: null,
                        textController: _loginController.passwordcontroller,
                        hintText: '',
                        obscureText: true,
                        validator: (value) =>
                            CheckValidate().validatePassword(value!),
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      CustomExpandedButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {}
                          login(
                            context,
                            emailId: _loginController.idcontroller.text,
                            password: _loginController.passwordcontroller.text,
                          );
                        },
                        isBlue: true,
                        isBig: true,
                        title: '로그인하기',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextButton(
                          onPressed: () {
                            Get.to(() => PwFindScreen());
                          },
                          child: Center(
                            child: Text(
                              "비밀번호를 잊으셨나요?",
                              style: kmain.copyWith(
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
      ],
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
    Get.back();
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
      if (value.errorData!["statusCode"] == 401) {
        showCustomDialog('입력한 정보를 다시 확인해주세요', 1400);
      } else {
        errorSituation(value);
      }
    }
  });
}
