// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/controller/projectmake_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/screen/posting_add_content_screen.dart';
import 'package:loopus/screen/project_add_intro_screen.dart';

class PostingAddNameScreen extends StatelessWidget {
  PostingAddNameScreen({Key? key}) : super(key: key);

  PostingAddController postingcontroller = Get.put(PostingAddController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/Close.svg"),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => PostingAddContentScreen());
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
          '포스팅 제목',
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
                  '포스팅 제목을 작성해주세요',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  '나중에 얼마든지 수정할 수 있어요',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                cursorColor: Colors.black,
                controller: postingcontroller.titlecontroller,
                decoration: InputDecoration(
                  hintText: '포스팅 제목...',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
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
