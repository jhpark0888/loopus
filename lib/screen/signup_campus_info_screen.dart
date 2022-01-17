import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_department_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/custom_textfield.dart';

class SignupCampusInfoScreen extends StatelessWidget {
  SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () {
              //TODO: 학교 선택 시 활성화되어야 함
              Get.to(() => SignupDepartmentScreen());
            },
            child: Text(
              '다음',
              style: kSubTitle2Style.copyWith(color: mainblue),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            32,
            24,
            32,
            40,
          ),
          child: Column(
            children: [
              const Text(
                '어느 대학에 재학 중이신가요?',
                style: kSubTitle1Style,
              ),
              const SizedBox(
                height: 32,
              ),
              CustomTextField(
                textController: signupController.campusnamecontroller,
                hintText: '학교 이름 검색',
                obscureText: false,
                validator: null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
