// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/project_detail_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/persontile_widget.dart';

class ProjectPeopleScreen extends StatelessWidget {
  ProjectPeopleScreen({Key? key, required this.projectid}) : super(key: key);

  int projectid;
  late ProjectDetailController controller =
      Get.find<ProjectDetailController>(tag: projectid.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "함께 활동한 사람",
        bottomBorder: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 40),
          child: Column(
              children: controller.project.value.members
                  .map((user) => PersonTileWidget(user: user))
                  .toList()),
        ),
      ),
    );
  }
}
