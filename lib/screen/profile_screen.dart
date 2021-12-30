// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/get_image_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/looppeople_screen.dart';
import 'package:loopus/screen/project_modify_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/question_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  ProfileController profileController = Get.put(ProfileController());
  RxBool isLoop = false.obs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: profileController.user.value.isuser == 1
            ? (AppController.to.ismyprofile.value == true)
                ? AppBar(
                    elevation: 0,
                    centerTitle: false,
                    title: Text(
                      '프로필',
                      style: kHeaderH1Style,
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
                  )
                : AppBarWidget(
                    title: '${profileController.user.value.realName}의 프로필')
            : AppBarWidget(
                title: '${profileController.user.value.realName}의 프로필'),
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
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          Obx(
                            () => ClipOval(
                                child:
                                    profileController.user.value.profileImage !=
                                            null
                                        ? CachedNetworkImage(
                                            height: 92,
                                            width: 92,
                                            imageUrl: profileController
                                                .user.value.profileImage!,
                                            placeholder: (context, url) =>
                                                const CircleAvatar(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            "assets/illustrations/default_profile.png",
                                            height: 92,
                                            width: 92,
                                          )),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                  onTap: () async {
                                    File? image = await getcropImage("profile");
                                    if (image != null) {
                                      await updateProfile(
                                          profileController.user.value, image);
                                    }
                                  },
                                  child:
                                      profileController.user.value.isuser == 1
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: mainWhite),
                                              child: SvgPicture.asset(
                                                "assets/icons/Image.svg",
                                                width: 24,
                                                height: 24,
                                              ),
                                            )
                                          : Container()),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Obx(
                        () => Text(
                          profileController.user.value.realName,
                          style: kSubTitle2Style,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '산업경영공학과',
                        style: kBody1Style,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: profileController.user.value.profileTag
                              .map((tag) => Row(children: [
                                    Tagwidget(
                                      content: tag.tag,
                                      fontSize: 14,
                                    ),
                                    profileController.user.value.profileTag
                                                .indexOf(tag) !=
                                            profileController.user.value
                                                    .profileTag.length -
                                                1
                                        ? SizedBox(
                                            width: 8,
                                          )
                                        : Container()
                                  ]))
                              .toList()),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child:
                                        profileController.user.value.isuser == 1
                                            ? const Center(
                                                child: Text(
                                                '관심 태그 변경하기',
                                                style: kButtonStyle,
                                              ))
                                            : const Center(
                                                child: Text(
                                                '메세지 보내기',
                                                style: kButtonStyle,
                                              ))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (profileController.user.value.isuser == 1) {}
                              },
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
                                  child:
                                      profileController.user.value.isuser == 1
                                          ? Center(
                                              child: Text('내 프로필 공유하기',
                                                  style: kButtonStyle.copyWith(
                                                      color: mainWhite)),
                                            )
                                          : Center(
                                              child: Text('루프 맺기',
                                                  style: kButtonStyle.copyWith(
                                                      color: mainWhite)),
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
                                style: kBody1Style,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                '36',
                                style: kSubTitle2Style,
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
                                style: kBody1Style,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                '112',
                                style: kSubTitle2Style,
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
              SliverAppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 43,
                elevation: 0,
                pinned: true,
                flexibleSpace: Theme(
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
                        ),
                      ),
                      Tab(
                        height: 40,
                        child: Text(
                          "질문과 답변",
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
                          Text('활동', style: kSubTitle2Style),
                          GestureDetector(
                              onTap: () {
                                Get.to(() => ProjectAddTitleScreen());
                              },
                              child: profileController.user.value.isuser == 1
                                  ? Text(
                                      '추가하기',
                                      style: kButtonStyle.copyWith(
                                          color: mainblue),
                                    )
                                  : Container())
                        ]),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      child: Column(
                        children: profileController.projectlist.value,
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
                      child: profileController.user.value.isuser == 1
                          ? Obx(
                              () => DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    onChanged: (value) {},
                                    onTap: () {},
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    elevation: 1,
                                    underline: Container(),
                                    icon: Icon(
                                      Icons.expand_more_rounded,
                                      color: mainblack,
                                    ),
                                    value: profileController.selectqanda.value,
                                    items: profileController.dropdown_qanda
                                        .map((value) => DropdownMenuItem(
                                            value: profileController
                                                .dropdown_qanda
                                                .indexOf("$value"),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 4,
                                              ),
                                              child: Text(
                                                "$value",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )))
                                        .toList(),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "답변한 질문",
                                    style: kSubTitle2Style,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      print("hihi");
                                    },
                                    child: Text(
                                      "질문 남기기",
                                      style: kSubTitle2Style.copyWith(
                                          color: mainblue),
                                    ),
                                  ),
                                ],
                              ),
                            )),
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
