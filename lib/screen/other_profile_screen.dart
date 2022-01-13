import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/profile_tag_change_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/looppeople_screen.dart';
import 'package:loopus/screen/project_modify_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/question_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:underline_indicator/underline_indicator.dart';

class OtherProfileScreen extends StatelessWidget {
  OtherProfileScreen({Key? key}) : super(key: key);
  final ProfileController profileController = Get.put(ProfileController());
  final ImageController imageController = Get.put(ImageController());
  RxBool isLoop = false.obs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: profileController.profileTabController.index,
      length: 2,
      child: Obx(
        () => Scaffold(
          appBar: profileController.otherUser.value.isuser == 1
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
                      bottomBorder: false,
                      title:
                          '${profileController.otherUser.value.realName}님의 프로필')
              : AppBarWidget(
                  bottomBorder: false,
                  title: '${profileController.otherUser.value.realName}님의 프로필'),
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
                            Obx(
                              () =>
                                  // GestureDetector(
                                  //   onTap: () => ModalController.to.showModalIOS(
                                  //       context,
                                  //       func1: changeProfileImage,
                                  //       func2: () {},
                                  //       value1: '라이브러리에서 선택',
                                  //       value2: '기본 이미지로 변경',
                                  //       isValue1Red: false,
                                  //       isValue2Red: false,
                                  //       isOne: false),
                                  //   child:
                                  ClipOval(
                                      child: (profileController
                                              .isProfileLoading.value)
                                          ? Image.asset(
                                              "assets/illustrations/default_profile.png",
                                              height: 92,
                                              width: 92,
                                            )
                                          : profileController.otherUser.value
                                                      .profileImage !=
                                                  null
                                              ? CachedNetworkImage(
                                                  height: 92,
                                                  width: 92,
                                                  imageUrl: profileController
                                                      .otherUser
                                                      .value
                                                      .profileImage!,
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                    "assets/illustrations/default_profile.png",
                                                    height: 92,
                                                    width: 92,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  "assets/illustrations/default_profile.png",
                                                  height: 92,
                                                  width: 92,
                                                )),
                              // ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                    onTap: () => ModalController.to
                                        .showModalIOS(context,
                                            func1: changeProfileImage,
                                            func2: () {},
                                            value1: '라이브러리에서 선택',
                                            value2: '기본 이미지로 변경',
                                            isValue1Red: false,
                                            isValue2Red: false,
                                            isOne: false),
                                    child: profileController
                                                .otherUser.value.isuser ==
                                            1
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
                            profileController.otherUser.value.realName,
                            style: kSubTitle2Style,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Obx(
                          () => Text(
                            profileController.otherUser.value.department,
                            style: kBody1Style,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Obx(
                          () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  profileController.otherUser.value.profileTag
                                      .map((tag) => Row(children: [
                                            Tagwidget(
                                              tag: tag,
                                              fontSize: 14,
                                            ),
                                            profileController.otherUser.value
                                                        .profileTag
                                                        .indexOf(tag) !=
                                                    profileController
                                                            .otherUser
                                                            .value
                                                            .profileTag
                                                            .length -
                                                        1
                                                ? SizedBox(
                                                    width: 8,
                                                  )
                                                : Container()
                                          ]))
                                      .toList()),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: profileController
                                            .otherUser.value.isuser ==
                                        1
                                    ? () {
                                        Get.to(() => ProfileTagChangeScreen());
                                      }
                                    : () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: mainlightgrey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: profileController
                                                  .otherUser.value.isuser ==
                                              1
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
                                  if (profileController
                                          .otherUser.value.isuser ==
                                      1) {}
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
                                    child: profileController
                                                .otherUser.value.isuser ==
                                            1
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
                          height: 16,
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
                              vertical: 12.0,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '포스팅',
                                  style: kBody1Style,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  profileController.otherUser.value.totalposting
                                      .toString(),
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
                            profileController.isLoopPeopleLoading(true);
                            Get.to(() => LoopPeopleScreen(
                                  userid:
                                      profileController.otherUser.value.user,
                                  loopcount: profileController
                                      .otherUser.value.loopcount,
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              children: [
                                Text(
                                  '루프',
                                  style: kBody1Style,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  profileController.otherUser.value.loopcount
                                      .toString(),
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
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
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
                          controller: profileController.profileTabController,
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
                  ),
                ),
              ];
            },
            body: TabBarView(
                controller: profileController.profileTabController,
                children: [
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
                                      Get.to(() => ProjectAddTitleScreen(
                                            screenType: Screentype.add,
                                          ));
                                    },
                                    child: profileController
                                                .otherUser.value.isuser ==
                                            1
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
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: (profileController.isProfileLoading.value ==
                                    false)
                                ? Column(
                                    children: profileController
                                        .otherProjectList.value,
                                  )
                                : Padding(
                                    padding: EdgeInsets.zero,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/loading.gif',
                                          scale: 6,
                                        ),
                                        Text(
                                          '활동 받아오는 중...',
                                          style: TextStyle(
                                              fontSize: 10, color: mainblue),
                                        ),
                                      ],
                                    ),
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
                            child: profileController.otherUser.value.isuser == 1
                                ? Obx(
                                    () => DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton(
                                          onChanged: (int? value) {
                                            profileController
                                                .selectqanda(value);
                                          },
                                          onTap: () {},
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          elevation: 1,
                                          underline: Container(),
                                          icon: Icon(
                                            Icons.expand_more_rounded,
                                            color: mainblack,
                                          ),
                                          value: profileController
                                              .selectqanda.value,
                                          items: profileController.dropdownQanda
                                              .map((value) => DropdownMenuItem(
                                                  value: profileController
                                                      .dropdownQanda
                                                      .indexOf("$value"),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      right: 4,
                                                    ),
                                                    child: Text(
                                                      "$value",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
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
      ),
    );
  }

  void changeProfileImage() async {
    File? image = await imageController.getcropImage(ImageType.profile);
    if (image != null) {
      User? user = await updateProfile(profileController.myUserInfo.value,
          image, null, ProfileUpdateType.image);
      if (user != null) {
        profileController.myUserInfo(user);
      }
    }
  }
}
