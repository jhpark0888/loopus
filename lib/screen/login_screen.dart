import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/login_api.dart';
import 'package:loopus/app.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/login_controller.dart';
import 'package:loopus/screen/loading_screen.dart';
import 'package:loopus/screen/pw_find_screen.dart';

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
                        style: kSubTitle2Style,
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
                        style: kSubTitle2Style,
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
                        buttonTag: '로그인하기',
                        onTap: () {
                          login(context);
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
        ),
      ],
    );
  }

  void login(context) async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      loading();
      // Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
      await loginRequest(
        _loginController.idcontroller.text,
        _loginController.passwordcontroller.text,
      ).then((value) {
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
          Get.offAll(() => App());
        }
      });
    }
  }
}
