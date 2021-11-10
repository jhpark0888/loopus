// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/project_add_name_screen.dart';
import 'package:loopus/screen/looppeople_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/question_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  ProfileController profileController = ProfileController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            '프로필',
            // style: TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => SettingScreen());
                },
                icon: const Icon(Icons.settings)),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                      child: ClipOval(
                          child: CachedNetworkImage(
                        height: 92,
                        width: 92,
                        imageUrl: "https://i.stack.imgur.com/l60Hf.png",
                        placeholder: (context, url) => const CircleAvatar(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        fit: BoxFit.fill,
                      )),
                    ),
                    const Text(
                      '박지환',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    const Text(
                      '산업경영공학과',
                      style: TextStyle(fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                            color: Colors.grey[300],
                            width: 83,
                            height: 20,
                            child: const Center(
                              child: Text(
                                '#관심태그1',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                            color: Colors.grey[300],
                            width: 83,
                            height: 20,
                            child: const Center(
                              child: Text(
                                '#관심태그2',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                            color: Colors.grey[300],
                            width: 83,
                            height: 20,
                            child: const Center(
                              child: Text(
                                '#관심태그3',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                            // color: Colors.grey[400],
                            width: 170,
                            height: 36,
                            child: const Center(
                              child: Text(
                                '루프 요청하기',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                            // color: Colors.grey[400],
                            width: 170,
                            height: 36,
                            child: const Center(
                              child: Text(
                                '메시지 보내기',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
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
              SliverToBoxAdapter(
                child: Divider(
                  thickness: 12,
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Column(
                        children: const [
                          Text(
                            '포스팅',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '36',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {},
                    //   child: Column(
                    //     children: const [
                    //       Text(
                    //         '답변',
                    //         style: TextStyle(fontSize: 14),
                    //       ),
                    //       Text(
                    //         '26',
                    //         style: TextStyle(fontSize: 16),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => LoopPeopleScreen());
                      },
                      child: Column(
                        children: const [
                          Text(
                            '루프',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '112',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Divider(
                  thickness: 1,
                ),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      child: Text(
                        "활동",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "질문과 답변",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ];
          },
          body: Container(
            child: TabBarView(children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '진행중인 활동',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                      child: Column(
                        children: [
                          ProjectWidget(),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 25,
                      endIndent: 25,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '활동',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => ProjectAddNameScreen());
                        },
                        child: DottedBorder(
                          strokeWidth: 3,
                          dashPattern: [3, 3],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(12),
                          padding: EdgeInsets.all(6),
                          child: ClipRRect(
                            child: Container(
                              height: 180,
                              width: 347,
                              child: Center(
                                  child: Text(
                                '+ 활동 추가하기',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                      child: Column(
                        children: [
                          ProjectWidget(),
                          ProjectWidget(),
                        ],
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
                        () => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DropdownButton(
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
      ),
    );
  }
}
