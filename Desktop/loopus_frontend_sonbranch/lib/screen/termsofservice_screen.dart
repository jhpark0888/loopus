// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

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
          '서비스 이용 약관',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          '적어주신 내용은 서비스 개선에 큰 도움이 됩니다!',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
