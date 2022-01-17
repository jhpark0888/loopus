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

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({Key? key}) : super(key: key);
  ProfileController profileController = Get.put(ProfileController());
  ImageController imageController = Get.put(ImageController());
  RxBool isLoop = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            WillPopScope(
              onWillPop: () async {
                if (Platform.isAndroid &&
                    (AppController.to.currentIndex.value == 4)) {
                  AppController.to.currentIndex(0);
                  return false;
                }
                return true;
              },
              child: DefaultTabController(
                initialIndex: profileController.profileTabController.index,
                length: 2,
                child: Obx(
                  () => Scaffold(
                    appBar: AppBar(
                      elevation: 0,
                      centerTitle: false,
                      title: const Text(
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
                                      Obx(
                                        () => GestureDetector(
                                          onTap: () => ModalController.to
                                              .showModalIOS(context,
                                                  func1: changeProfileImage,
                                                  func2: () {},
                                                  value1: '라이브러리에서 선택',
                                                  value2: '기본 이미지로 변경',
                                                  isValue1Red: false,
                                                  isValue2Red: false,
                                                  isOne: false),
                                          child: ClipOval(
                                              child: (profileController
                                                          .isProfileLoading
                                                          .value ==
                                                      false)
                                                  ? (profileController
                                                              .myUserInfo
                                                              .value
                                                              .profileImage !=
                                                          null)
                                                      ? CachedNetworkImage(
                                                          height: 92,
                                                          width: 92,
                                                          imageUrl:
                                                              profileController
                                                                  .myUserInfo
                                                                  .value
                                                                  .profileImage!
                                                                  .replaceAll(
                                                                      'https',
                                                                      'http'),
                                                          placeholder:
                                                              (context, url) =>
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
                                                        )
                                                  : Image.asset(
                                                      "assets/illustrations/default_profile.png",
                                                      height: 92,
                                                      width: 92,
                                                    )),
                                        ),
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
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: mainWhite),
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
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Obx(
                                    () => Text(
                                      profileController
                                          .myUserInfo.value.realName,
                                      style: kSubTitle2Style,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Obx(
                                    () => Text(
                                      profileController
                                          .myUserInfo.value.department,
                                      style: kBody1Style,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Obx(
                                    () => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: profileController
                                            .myUserInfo.value.profileTag
                                            .map((tag) => Row(children: [
                                                  Tagwidget(
                                                    tag: tag,
                                                    fontSize: 14,
                                                  ),
                                                  profileController.myUserInfo
                                                              .value.profileTag
                                                              .indexOf(tag) !=
                                                          profileController
                                                                  .myUserInfo
                                                                  .value
                                                                  .profileTag
                                                                  .length -
                                                              1
                                                      ? const SizedBox(
                                                          width: 8,
                                                        )
                                                      : Container()
                                                ]))
                                            .toList()),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () =>
                                              Get.to(ProfileTagChangeScreen()),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: mainlightgrey,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0),
                                              child: Center(
                                                child: Text(
                                                  '관심 태그 변경하기',
                                                  style: kButtonStyle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: mainblue,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                              ),
                                              child: Center(
                                                  child: Text('내 프로필 공유하기',
                                                      style:
                                                          kButtonStyle.copyWith(
                                                              color:
                                                                  mainWhite))),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              height: 8,
                              color: const Color(0xffF2F3F5),
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
                                          Obx(
                                            () => Text(
                                              profileController
                                                  .myUserInfo.value.totalposting
                                                  .toString(),
                                              style: kSubTitle2Style,
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
                                      profileController
                                          .isLoopPeopleLoading(true);
                                      Get.to(() => LoopPeopleScreen(
                                            userid: profileController
                                                .myUserInfo.value.user,
                                            loopcount: profileController
                                                .myUserInfo.value.loopcount,
                                          ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            '루프',
                                            style: kBody1Style,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Obx(
                                            () => Text(
                                              profileController
                                                  .myUserInfo.value.loopcount
                                                  .toString(),
                                              style: kSubTitle2Style,
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
                          SliverOverlapAbsorber(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
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
                                    controller:
                                        profileController.profileTabController,
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
                                    unselectedLabelColor:
                                        mainblack.withOpacity(0.6),
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
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 24, 16, 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('활동', style: kSubTitle2Style),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => ProjectAddTitleScreen(
                                                  screenType: Screentype.add,
                                                ));
                                          },
                                          child: Text(
                                            '추가하기',
                                            style: kButtonStyle.copyWith(
                                                color: mainblue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(
                                    () => Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 0),
                                      child: (profileController
                                                  .isProfileLoading.value ==
                                              false)
                                          ? Column(
                                              children: profileController
                                                  .myProjectList,
                                            )
                                          : Column(
                                              children: [
                                                Image.asset(
                                                  'assets/icons/loading.gif',
                                                  scale: 6,
                                                ),
                                                const Text(
                                                  '활동 받아오는 중...',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: mainblue),
                                                ),
                                              ],
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
                                    child: DropdownButtonHideUnderline(
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
              ),
            ),
            if (imageController.isImagePickerLoading.value == true)
              Container(
                height: Get.height,
                width: Get.width,
                color: mainblack.withOpacity(0.3),
                child: Image.asset(
                  'assets/icons/loading.gif',
                  scale: 6,
                ),
              ),
          ],
        ));
  }

  void changeProfileImage() async {
    imageController.isImagePickerLoading.value = true;
    File? image = await imageController.getcropImage(ImageType.profile);
    print('image : $image');
    if (image != null) {
      User? user = await updateProfile(profileController.myUserInfo.value,
              image, null, ProfileUpdateType.image)
          .then((user) {
        imageController.isImagePickerLoading.value = false;
        if (user != null) {
          profileController.myUserInfo(user);
        }
      });
    }
  }
}
