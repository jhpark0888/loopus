// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/login_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/pwchange_screen.dart';
import 'package:loopus/screen/start_screen.dart';
import 'package:loopus/screen/withdrawal_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       // Get.to(() => ActivityAddPeriodScreen());
          //     },
          //     child: Text(
          //       '다음',
          //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ],
          title: '계정 정보',
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text('나의 학교',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: Text('인천대학교 송도 캠퍼스',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: Text('학과/학번',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: Text('학과/학번',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {
                Get.to(() => PwChangeScreen());
              },
              title: Text('비밀번호 변경',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: Text('변경하기',
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ),
            ListTile(
              onTap: () {
                FlutterSecureStorage().delete(key: 'token');
                FlutterSecureStorage().delete(key: 'id');
                Get.offAll(() => StartScreen());
              },
              title: Text('로그아웃',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {
                Get.to(() => WithdrawalScreen());
              },
              title: Text('회원탈퇴',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ));
  }
}
