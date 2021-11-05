// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/activitymake_controller.dart';
import 'package:loopus/screen/activity_add_period_screen.dart';

class ActivityAddIntroScreen extends StatelessWidget {
  ActivityAddIntroScreen({Key? key}) : super(key: key);

  ActivityMakeController activitymakecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => ActivityAddPeriodScreen());
            },
            child: Text(
              '다음',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        title: const Text(
          '활동 추가',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  '어떤 활동인지 간략하게 소개해주세요!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  '지금 적지 않아도 나중에 추가할 수 있어요',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                cursorColor: Colors.black,
                maxLines: 2,
                controller: activitymakecontroller.introcontroller,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    hintText: 'OO를 주제로 진행한 프로젝트이며, OO 역할을 맡았습니다.'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
