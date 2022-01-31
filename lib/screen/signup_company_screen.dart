import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/signup_campus_info_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class SignupCompanyScreen extends StatelessWidget {
  const SignupCompanyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        actions: [
          TextButton(
            onPressed: () {
              //TODO: 학교 선택 시 활성화되어야 함
              // Get.to(() => SignupCampusInfoScreen());
            },
            child: Text(
              '다음',
              style: kSubTitle2Style.copyWith(color: mainblue),
            ),
          ),
        ],
        title: '회원 가입',
      ),
      body: Center(child: Text('기업 회원 가입')),
    );
  }
}
