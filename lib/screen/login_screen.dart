import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/login_controller.dart';

import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

import '../check_form_validate.dart';

class LogInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final LogInController _loginController = Get.put(LogInController());
  static FlutterSecureStorage? storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
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
                            '이메일 주소',
                            style: kSubTitle2Style,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomTextField(
                            textController: _loginController.idcontroller,
                            hintText: 'loopus@inu.ac.kr',
                            obscureText: false,
                            validator: (value) =>
                                (CheckValidate().validateEmail(value!)),
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
                            textController: _loginController.passwordcontroller,
                            hintText: '영문, 숫자, 특수문자 포함 8자리 이상',
                            obscureText: true,
                            validator: (value) =>
                                CheckValidate().validatePassword(value!),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          InkWell(
                              onTap: login,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: mainblue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    "로그인하기",
                                    style:
                                        kButtonStyle.copyWith(color: mainWhite),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          TextButton(
                              onPressed: () {
                                //TODO: 비밀번호 찾기
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
            ),
            if (_loginController.isLogin.value == true)
              Container(
                height: Get.height,
                width: Get.width,
                color: mainblack.withOpacity(0.3),
                child: Image.asset(
                  'assets/icons/loading.gif',
                  scale: 6,
                ),
              ),
          ],
        ));
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      _loginController.isLogin.value = true;
      await loginRequest()
          .then((value) => _loginController.isLogin.value = false);
    }
  }
}
