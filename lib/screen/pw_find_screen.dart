import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/api/login_api.dart';

import 'package:loopus/constant.dart';

import 'package:loopus/controller/login_controller.dart';

import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

import '../utils/check_form_validate.dart';

class PwFindScreen extends StatelessWidget {
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
                title: '비밀번호 찾기',
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
                            hintText: 'loopus@inu.ac.kr',
                            obscureText: false,
                            validator: (value) =>
                                (CheckValidate().validateEmail(value!)),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          InkWell(
                              onTap: () {},
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: mainblue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    "비밀번호 재설정 메일 보내기",
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
                                Get.back();
                              },
                              child: Center(
                                child: Text(
                                  "로그인 하기",
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
}