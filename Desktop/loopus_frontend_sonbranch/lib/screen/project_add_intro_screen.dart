// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';

class ProjectAddIntroScreen extends StatelessWidget {
  ProjectAddIntroScreen({Key? key}) : super(key: key);

  ProjectMakeController projectmakecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            color: Color(0xffe7e7e7),
            height: 1,
          ),
          preferredSize: Size.fromHeight(4.0),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/icons/Arrow.svg'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => ProjectAddPeriodScreen());
            },
            child: Text(
              '다음',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: mainblue,
              ),
            ),
          ),
        ],
        title: const Text(
          '활동 소개',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
              '어떤 활동인지 간략하게 소개해주세요',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, height: 1.5),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              '지금 적지 않아도 나중에 수정할 수 있어요',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            TextField(
              minLines: 1,
              maxLines: 4,
              maxLength: 200,
              autocorrect: false,
              cursorWidth: 1.5,
              cursorRadius: Radius.circular(2),
              style: TextStyle(
                color: mainblack,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
              cursorColor: mainblack,
              controller: projectmakecontroller.projectnamecontroller,
              decoration: InputDecoration(
                hintText: '무엇을 주제로 진행한 프로젝트이며, 이러한 역할을 맡았습니다.',
                hintStyle: TextStyle(
                  color: mainblack.withOpacity(0.38),
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: BorderSide(color: mainblack, width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: BorderSide(color: mainblack, width: 1),
                ),
                errorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(2),
                  borderSide: BorderSide(color: mainpink, width: 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
