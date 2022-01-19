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
import 'package:loopus/screen/bookmark_screen.dart';
import 'package:loopus/screen/profile_tag_change_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/looppeople_screen.dart';
import 'package:loopus/screen/project_modify_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:underline_indicator/underline_indicator.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({Key? key}) : super(key: key);
  final ProfileController profileController = Get.put(ProfileController());
  final ImageController imageController = Get.put(ImageController());
  final ScrollController _projectScrollController = ScrollController();
  final ScrollController _questionScrollController = ScrollController();

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
              child: Scaffold(
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
                          Get.to(() => BookmarkScreen());
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/Bookmark_Inactive.svg',
                        )),
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
                body: Obx(
                  () => SmartRefresher(
                    controller: profileController.profilerefreshController,
                    enablePullDown:
                        (profileController.isProfileLoading.value == true)
                            ? false
                            : true,
                    enablePullUp: !profileController.profileenablepullup.value,
                    header: ClassicHeader(
                      spacing: 0.0,
                      height: 60,
                      completeDuration: Duration(milliseconds: 600),
                      textStyle: TextStyle(color: mainblack),
                      refreshingText: '',
                      releaseText: "",
                      completeText: "",
                      idleText: "",
                      refreshingIcon: Column(
                        children: [
                          Image.asset(
                            'assets/icons/loading.gif',
                            scale: 6,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '프로필 새로고침 중...',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: mainblue.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      releaseIcon: Column(
                        children: [
                          Image.asset(
                            'assets/icons/loading.gif',
                            scale: 6,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '프로필 새로고침 중...',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: mainblue.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      completeIcon: Column(
                        children: [
                          const Icon(
                            Icons.check_rounded,
                            color: mainblue,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '완료!',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: mainblue.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      idleIcon: Column(
                        children: [
                          Image.asset(
                            'assets/icons/loading.png',
                            scale: 12,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '당겨주세요',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: mainblue.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    footer: ClassicFooter(
                      completeDuration: Duration.zero,
                      loadingText: "",
                      canLoadingText: "",
                      idleText: "",
                      idleIcon: Container(),
                      noMoreIcon: Container(
                        child: Text('as'),
                      ),
                      loadingIcon: Image.asset(
                        'assets/icons/loading.gif',
                        scale: 6,
                      ),
                      canLoadingIcon: Image.asset(
                        'assets/icons/loading.gif',
                        scale: 6,
                      ),
                    ),
                    onRefresh: profileController.onRefresh,
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Padding(
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
                                                      .isProfileLoading.value ==
                                                  false)
                                              ? (profileController.myUserInfo
                                                          .value.profileImage !=
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
                                                              CircleAvatar(
                                                        backgroundColor:
                                                            const Color(
                                                                0xffe7e7e7),
                                                        child: Container(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          CircleAvatar(
                                                        backgroundColor:
                                                            const Color(
                                                                0xffe7e7e7),
                                                        child: Container(),
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
                                          decoration: const BoxDecoration(
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
                                  profileController.myUserInfo.value.realName,
                                  style: kSubTitle2Style,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Obx(
                                () => Text(
                                  profileController.myUserInfo.value.department,
                                  style: kBody1Style,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Obx(
                                () => Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: profileController
                                        .myUserInfo.value.profileTag
                                        .map((tag) => Row(children: [
                                              Tagwidget(
                                                tag: tag,
                                                fontSize: 14,
                                              ),
                                              profileController.myUserInfo.value
                                                          .profileTag
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
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Center(
                                              child: Text('내 프로필 공유하기',
                                                  style: kButtonStyle.copyWith(
                                                      color: mainWhite))),
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
                        Container(
                          height: 8,
                          color: const Color(0xffF2F3F5),
                        ),
                        Row(
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
                                  profileController.isLoopPeopleLoading(true);
                                  Get.to(() => LoopPeopleScreen(
                                        userid: profileController
                                            .myUserInfo.value.userid,
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
                        Container(
                          height: 1,
                          color: Color(0xfff2f3f5),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                24,
                                16,
                                20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('활동', style: kSubTitle2Style),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => ProjectAddTitleScreen(
                                          screenType: Screentype.add,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '추가하기',
                                      style: kSubTitle2Style.copyWith(
                                          color: mainblue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child:
                                    (profileController.isProfileLoading.value ==
                                            false)
                                        ? Column(
                                            children:
                                                profileController.myProjectList,
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
                      ],
                    )),
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
