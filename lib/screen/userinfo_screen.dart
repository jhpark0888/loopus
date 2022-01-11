// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/login_controller.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/pwchange_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/screen/withdrawal_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class UserInfoScreen extends StatelessWidget {
  final LogInController _logInController = Get.put(LogInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Scaffold(
            appBar: AppBarWidget(
              title: '계정 정보',
            ),
            body: ListView(
              children: [
                ListTile(
                  title: Text(
                    '나의 학교',
                    style: kSubTitle2Style,
                  ),
                  trailing: Text(
                    '인천대학교 송도캠퍼스',
                    style: kSubTitle3Style,
                  ),
                ),
                ListTile(
                  title: Text(
                    '전공 학과',
                    style: kSubTitle2Style,
                  ),
                  trailing: Text(
                    '학과',
                    style: kSubTitle3Style,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => PwChangeScreen());
                  },
                  title: Text(
                    '비밀번호 변경',
                    style: kSubTitle2Style,
                  ),
                  trailing: Text(
                    '변경하기',
                    style: kSubTitle2Style.copyWith(color: mainblue),
                  ),
                ),
                ListTile(
                  onTap: () {
                    _logInController.isLogout.value = true;
                    logOut().then((value) {
                      _logInController.isLogout.value = false;
                      Get.offAll(() => StartScreen());
                    });
                  },
                  title: Text(
                    '로그아웃',
                    style: kSubTitle2Style,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => WithdrawalScreen());
                  },
                  title: Text(
                    '회원탈퇴',
                    style: kSubTitle2Style.copyWith(color: mainpink),
                  ),
                )
              ],
            ),
          ),
          if (_logInController.isLogout.value == true)
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
      ),
    );
  }

  Future<void> logOut() async {
    await FlutterSecureStorage().delete(key: 'token');
    await FlutterSecureStorage().delete(key: 'id');
  }
}
