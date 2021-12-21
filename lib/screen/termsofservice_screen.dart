// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/project_add_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

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
        title: '서비스 이용 약관',
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
