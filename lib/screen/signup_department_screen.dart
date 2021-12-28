import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/signup_controller.dart';
import 'package:loopus/screen/signup_user_info_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SignupDepartmentScreen extends StatelessWidget {
  // const SignupDepartmentScreen({Key? key}) : super(key: key);
  SignupController signupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          TextButton(
            onPressed: () {
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
            Text(
              '어느 학과를 전공하고 계신가요?',
              style: kSubTitle1Style,
            ),
            SizedBox(
              height: 32,
            ),
            TextField(
              autocorrect: false,
              minLines: 1,
              maxLines: 2,
              autofocus: true,
              style: kSubTitle1Style,
              cursorColor: mainblack,
              cursorWidth: 1.5,
              cursorRadius: Radius.circular(2),
              controller: signupController.departmentcontroller,
              decoration: InputDecoration(
                hintText: '이름으로 검색해보세요...',
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
          ],
        ),
      ),
    );
  }
}
