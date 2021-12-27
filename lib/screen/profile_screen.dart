// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/get_image_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/looppeople_screen.dart';
import 'package:loopus/screen/project_modify_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/question_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          title: const Text(
            '프로필',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => SettingScreen());
              },
              icon: SvgPicture.asset(
                'assets/icons/Setting.svg',
              ),
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipOval(
                              child: CachedNetworkImage(
                            height: 92,
                            width: 92,
                            imageUrl:
                                profileController.user.value.profileImage ??
                                    "https://i.stack.imgur.com/l60Hf.png",
                            placeholder: (context, url) => const CircleAvatar(
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            fit: BoxFit.cover,
                          )),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () async {
                                  await getcropImage("profile");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: mainWhite),
                                  child: SvgPicture.asset(
                                    "assets/icons/Image.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        profileController.user.value.realName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '산업경영공학과',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Tagwidget(content: '관심태그1'),
                          Tagwidget(content: '관심태그2'),
                          Tagwidget(content: '관심태그3'),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: mainlightgrey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: const Center(
                                    child: Text(
                                      '관심 태그 변경하기',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: mainblack,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: mainblue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                // color: Colors.grey[400],

                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '내 프로필 공유하기',
                                      style: TextStyle(
                                          color: mainWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 8,
                  color: Color(0xffF2F3F5),
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          child: Column(
                            children: const [
                              Text(
                                '포스팅',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                '36',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => LoopPeopleScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            children: const [
                              Text(
                                '루프',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                '112',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => LoopPeopleScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            children: const [
                              Text(
                                '오퍼',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                '-',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 1,
                  color: Color(0xfff2f3f5),
                ),
              ),
              SliverToBoxAdapter(
                child: Theme(
                  data: ThemeData().copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: TabBar(
                    labelStyle: TextStyle(
                      color: mainblack,
                      fontSize: 14,
                      fontFamily: 'Nanum',
                      fontWeight: FontWeight.bold,
                    ),
                    labelColor: mainblack,
                    unselectedLabelStyle: TextStyle(
                      color: Colors.yellow,
                      fontSize: 14,
                      fontFamily: 'Nanum',
                      fontWeight: FontWeight.normal,
                    ),
                    unselectedLabelColor: mainblack.withOpacity(0.6),
                    indicator: UnderlineIndicator(
                      strokeCap: StrokeCap.round,
                      borderSide: BorderSide(width: 2),
                    ),
                    indicatorColor: mainblack,
                    tabs: [
                      Tab(
                        height: 40,
                        child: Text(
                          "활동",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Tab(
                        height: 40,
                        child: Text(
                          "질문과 답변",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '활동',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.to(() => ProjectAddTitleScreen());
                              },
                              child: Text(
                                '추가하기',
                                style: TextStyle(
                                  color: mainblue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ]),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      child: Column(
                        children: profileController.projectlist,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => DropdownButton(
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black),
                          icon: Icon(Icons.expand_more),
                          value: profileController.selectqanda.value,
                          onChanged: (int? value) {
                            profileController.selectqanda(value);
                          },
                          underline: Container(),
                          items: profileController.dropdown_qanda
                              .map((value) => DropdownMenuItem(
                                  value: profileController.dropdown_qanda
                                      .indexOf("$value"),
                                  child: Text("$value")))
                              .toList()),
                    ),
                  ),
                  QuestionWidget(),
                  QuestionWidget(),
                  QuestionWidget(),
                  QuestionWidget(),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
