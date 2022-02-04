import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_user_info_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class SignupDepartmentScreen extends StatelessWidget {
  SignupController signupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () {
              //TODO: 학과 선택 시 활성화되어야 함
              Get.to(() => SignupUserInfoScreen());
            },
            child: Text(
              '다음',
              style: kSubTitle2Style.copyWith(color: mainblue),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          32,
          24,
          32,
          40,
        ),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '어느 학과',
                    style: kSubTitle1Style.copyWith(
                      color: mainblue,
                    ),
                  ),
                  const TextSpan(
                    text: '를 전공하고 계신가요?',
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
              '전공 학과를 바탕으로 홈 화면을 구성해드릴게요',
              style: kBody2Style,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            CustomTextField(
              counterText: null,
              maxLength: null,
              textController: signupController.departmentcontroller,
              hintText: '학과 이름 검색',
              validator: null,
              obscureText: false,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
