// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class ProjectAddTagScreen extends StatelessWidget {
  QuestionController questionController = Get.put(QuestionController());

  String title;
  String content1;
  String content2;
  String textbtn;

  ProjectAddTagScreen(
      {required this.title,
      required this.content1,
      required this.content2,
      required this.textbtn});
  ProjectMakeController projectmakecontroller = Get.find();

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
        actions: [
          TextButton(
            onPressed: () {
              if (textbtn == "다음") {
                Get.to(() => ProjectAddPersonScreen());
              } else {
                QuestionApi.to
                    .questionmake(questionController.contentcontroller.text);
                questionController.contentcontroller.clear();
                Get.offAllNamed("/");
              }
            },
            child: Text(
              '$textbtn',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        title: Text(
          "$title",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          '활동을 대표하는 키워드가 무엇인가요?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          '누구나 쉽게 찾을 수 있는 태그를 입력해주세요',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '선택한 태그',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Obx(
                      () => Text(
                        '${projectmakecontroller.selectedtaglist.length} / 3',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    children: projectmakecontroller.selectedtaglist,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextField(
                  controller: projectmakecontroller.tagsearch,
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  // autofocus: true,
                  // focusNode: searchController.detailsearchFocusnode,
                  textAlign: TextAlign.start,
                  // selectionHeightStyle: BoxHeightStyle.tight,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12)),
                    // focusColor: Colors.black,
                    // border: OutlineInputBorder(borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.all(10),
                    isDense: true,
                    hintText: "예) 봉사, 기계공학과, 서포터즈",
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Obx(
                () => Expanded(
                  child: ListView(
                    children: projectmakecontroller.searchtaglist,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
