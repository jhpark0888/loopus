// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/inquiry_screen.dart';
import 'package:loopus/screen/privacypolicy_screen.dart';
import 'package:loopus/screen/termsofservice_screen.dart';
import 'package:loopus/screen/userinfo_screen.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Get.back();
            },
          ),
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
          title: const Text(
            '설정',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            ListTile(
              onTap: () {
                Get.to(() => UserInfoScreen());
              },
              title: Text('계정 정보',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {},
              title: Text('알림 설정',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => TermsOfServiceScreen());
              },
              title: Text('서비스 이용 약관',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => PrivacyPolicyScreen());
              },
              title: Text('개인정보 처리방침',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => InquiryScreen());
              },
              title: Text('문의하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            )
          ],
        ));
  }
}
