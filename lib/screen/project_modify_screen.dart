// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';
import 'package:loopus/screen/project_add_name_screen.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/inquiry_screen.dart';
import 'package:loopus/screen/privacypolicy_screen.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/screen/project_add_tag_screen.dart';
import 'package:loopus/screen/termsofservice_screen.dart';
import 'package:loopus/screen/userinfo_screen.dart';

class ProjectModifyScreen extends StatelessWidget {
  ProjectModifyScreen({Key? key}) : super(key: key);

  ProjectMakeController projectmakecontroller =
      Get.put(ProjectMakeController());

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
            '활동 추가',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            ListTile(
              onTap: () {
                Get.to(() => ProjectAddNameScreen());
              },
              title: Text('활동명',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle:
                  Text(projectmakecontroller.projectnamecontroller.value.text,
                      style: TextStyle(
                        fontSize: 16,
                      )),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => ProjectAddPeriodScreen());
              },
              title: Text('활동 기간',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle: Text(
                  '${projectmakecontroller.startyearcontroller.value.text}.${projectmakecontroller.startmonthcontroller.value.text} ~ ${projectmakecontroller.finishyearcontroller.value.text}.${projectmakecontroller.finishmonthcontroller.value.text}',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => ProjectAddIntroScreen());
              },
              title: Text('활동 정보',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle:
                  Text(projectmakecontroller.projectnamecontroller.value.text,
                      style: TextStyle(
                        fontSize: 16,
                      )),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => ProjectAddTagScreen());
              },
              title: Text('활동 태그',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle:
                  Text(projectmakecontroller.projectnamecontroller.value.text,
                      style: TextStyle(
                        fontSize: 16,
                      )),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => ProjectAddPersonScreen());
              },
              title: Text('함께 활동한 사람',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              subtitle:
                  Text(projectmakecontroller.projectnamecontroller.value.text,
                      style: TextStyle(
                        fontSize: 16,
                      )),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
          ],
        ));
  }
}
