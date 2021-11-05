// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/activitymake_controller.dart';
import 'package:loopus/screen/activity_add_period_screen.dart';

class ActivityAddTagScreen extends StatelessWidget {
  ActivityAddTagScreen({Key? key}) : super(key: key);

  ActivityMakeController activitymakecontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // Get.to(() => ActivityAddPeriodScreen());
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
                  '활동을 대표하는 키워드가 무엇인가요?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '선택한 태그',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '2 / 3',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  children: [],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: TextField(
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
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
