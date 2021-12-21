// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/question_api.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/controller/question_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/project_add_period_screen.dart';
import 'package:loopus/screen/project_add_person_screen.dart';
import 'package:loopus/screen/search_typing_screen.dart';
import 'package:loopus/widget/selected_tag_widget.dart';

class QuestionAddTagScreen extends StatelessWidget {
  QuestionController questionController = Get.put(QuestionController());
  TagController tagController = Get.put(TagController());

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
          Obx(
            () => IgnorePointer(
              ignoring:
                  tagController.selectedtaglist.length == 0 ? true : false,
              child: TextButton(
                onPressed: () {
                  questionmake(questionController.contentcontroller.text);
                  questionController.contentcontroller.clear();
                  Get.offAllNamed("/");
                },
                child: tagController.selectedtaglist.length == 0
                    ? Text(
                        '올리기',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      )
                    : Text(
                        '올리기',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ),
        ],
        title: Text(
          "질문 태그",
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
                          '질문 태그를 선택해주세요!',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          '해당 태그에 관심있는 학생에게 질문을 보여드려요.',
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
                        '${tagController.selectedtaglist.length} / 3',
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
                    children: tagController.selectedtaglist,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextField(
                  controller: tagController.tagsearch,
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
                    children: tagController.searchtaglist,
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
