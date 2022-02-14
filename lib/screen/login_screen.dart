import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/login_controller.dart';
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
                            counterText: null,
                            maxLength: null,
                            textController: _loginController.idcontroller,
                            hintText: '',
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

  void login(context) async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      _loginController.isLogin.value = true;
      await loginRequest()
          .then((value) => _loginController.isLogin.value = false);
    }
  }
}
