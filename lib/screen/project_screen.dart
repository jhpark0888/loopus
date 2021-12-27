// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/project_controller.dart';
import 'package:loopus/model/project_model.dart';
import 'package:loopus/screen/posting_add_name_screen.dart';
import 'package:loopus/screen/posting_add_content_screen.dart';
import 'package:loopus/screen/project_modify_screen.dart';
import 'package:loopus/screen/qurillread.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_posting_widget.dart';
import 'package:loopus/widget/tag_widget.dart';

class ProjectScreen extends StatelessWidget {
  ProjectScreen({Key? key, required this.project}) : super(key: key);

  ModalController modalController = Get.put(ModalController());

  ProjectController projectController = Get.put(ProjectController());
  Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/icons/Arrow.svg'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(ProjectModifyScreen());
            },
            icon: SvgPicture.asset('assets/icons/Edit.svg'),
          ),
          IconButton(
            onPressed: () {
              modalController.showModalIOS(
                context,
                func1: () {},
                func2: () {},
                value1: '이 활동 삭제하기',
                value2: '',
                isValue1Red: true,
                isValue2Red: false,
                isOne: true,
              );
            },
            icon: SvgPicture.asset('assets/icons/More.svg'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(
                16,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffe7e7e7),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    project.projectName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${project.startDate.substring(0, 4)}.${project.startDate.substring(5, 7)} ~',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Color(0xffefefef),
                            ),
                            child: Center(
                              child: Text(
                                '진행중',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: mainblack.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: SvgPicture.asset(
                              "assets/icons/Favorite_Inactive.svg",
                            ),
                            onTap: () {},
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '24',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 70,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: mainblack,
                              radius: 15,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  width: 28,
                                  height: 28,
                                  imageUrl:
                                      "https://i.stack.imgur.com/l60Hf.png",
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              child: CircleAvatar(
                                backgroundColor: mainblack,
                                radius: 15,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    width: 28,
                                    height: 28,
                                    imageUrl:
                                        "https://i.stack.imgur.com/l60Hf.png",
                                    placeholder: (context, url) =>
                                        const CircleAvatar(
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 40,
                              child: CircleAvatar(
                                backgroundColor: mainblack,
                                radius: 15,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    width: 28,
                                    height: 28,
                                    imageUrl:
                                        "https://i.stack.imgur.com/l60Hf.png",
                                    placeholder: (context, url) =>
                                        const CircleAvatar(
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '최승원',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '님, ',
                            ),
                            TextSpan(
                              text: '김형태',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '님 외 ',
                            ),
                            TextSpan(
                              text: '4명이',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' 참여했어요',
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 14,
                            color: mainblack,
                            fontFamily: 'Nanum',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '활동 소개',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    project.introduction,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    '활동 태그',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Tagwidget(content: '디자인'),
                      Tagwidget(content: '창업'),
                      Tagwidget(content: '기획'),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '활동 포스팅',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => PostingAddNameScreen(
                                project_id: project.id,
                              ));
                        },
                        child: Text(
                          '포스팅 작성하기',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: mainblue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Column(
                      children: project.post != null
                          ? project.post!
                              .map((post) => ProjectPostingWidget(
                                    post: post,
                                  ))
                              .toList()
                          : [Container()]
                      //     [
                      //   ProjectPostingWidget(
                      //     title: '안녕하세요',
                      //     preview: '안녕하세요 감사해요 반가워요 다시 만나요',
                      //   ),
                      //   ProjectPostingWidget(
                      //     title: '안녕하세요',
                      //     preview: '안녕하세요 감사해요 반가워요 다시 만나요',
                      //   ),
                      // ],
                      )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
