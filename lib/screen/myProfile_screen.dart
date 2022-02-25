import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/tag_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/bookmark_screen.dart';
import 'package:loopus/screen/profile_tag_change_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/looppeople_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/selected_tag_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyProfileScreen extends StatelessWidget {
  MyProfileScreen({Key? key}) : super(key: key);
  final ProfileController profileController = Get.put(ProfileController());
  final ImageController imageController = Get.put(ImageController());
  final ScrollController _projectScrollController = ScrollController();
  final ScrollController _questionScrollController = ScrollController();
  final HoverController _hoverController = Get.put(HoverController());
  TagController tagController = Get.put(TagController(tagtype: Tagtype.profile),
      tag: Tagtype.profile.toString());

  RxBool isLoop = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            WillPopScope(
              onWillPop: () async {
                try {
                  if (Platform.isAndroid &&
                      (AppController.to.currentIndex.value == 4)) {
                    AppController.to.currentIndex(0);
                    return false;
                  }
                } catch (e) {
                  print(e);
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
                          'assets/icons/Mark_Default.svg',
                          width: 28,
                        )),
                    IconButton(
                      onPressed: () {
                        Get.to(() => SettingScreen());
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/Setting.svg',
                        width: 28,
                      ),
                    ),
                  ],
                ),
                body: Obx(
                  () => SmartRefresher(
                    controller: profileController.profilerefreshController,
                    enablePullDown:
                        (profileController.myprofilescreenstate.value ==
                                ScreenState.loading)
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
                        ],
                      ),
                      releaseIcon: Column(
                        children: [
                          Image.asset(
                            'assets/icons/loading.gif',
                            scale: 6,
                          ),
                        ],
                      ),
                      completeIcon: Column(
                        children: [
                          const Icon(
                            Icons.check_rounded,
                            color: mainblue,
                          ),
                        ],
                      ),
                      idleIcon: Column(
                        children: [
                          Image.asset(
                            'assets/icons/loading.png',
                            scale: 12,
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
                                              func2: changeDefaultImage,
                                              value1: '라이브러리에서 선택',
                                              value2: '기본 이미지로 변경',
                                              isValue1Red: false,
                                              isValue2Red: false,
                                              isOne: false),
                                      child: ClipOval(
                                          child: (profileController
                                                      .myprofilescreenstate
                                                      .value !=
                                                  ScreenState.loading)
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
                                                func2: changeDefaultImage,
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
                                    child: CustomExpandedButton(
                                        onTap: () {
                                          tagController.selectedtaglist.clear();
                                          tagController.tagsearch.text = "";
                                          for (var tag in profileController
                                              .myUserInfo.value.profileTag) {
                                            tagController.selectedtaglist
                                                .add(SelectedTagWidget(
                                              id: tag.tagId,
                                              text: tag.tag,
                                              selecttagtype:
                                                  SelectTagtype.interesting,
                                              tagtype: Tagtype.profile,
                                            ));
                                          }
                                          Get.to(
                                              () => ProfileTagChangeScreen());
                                        },
                                        isBlue: false,
                                        isBig: false,
                                        title: '관심 태그 변경하기',
                                        buttonTag: '관심 태그 변경하기'),
                                  ),
                                  // Expanded(
                                  //   child: GestureDetector(
                                  //     // onTapDown: (details) =>
                                  //     //     _hoverController.isHover(true),
                                  //     // onTapCancel: () =>
                                  //     //     _hoverController.isHover(false),
                                  //     // onTapUp: (details) =>
                                  //     //     _hoverController.isHover(false),
                                  //     onTap: () {
                                  //       tagController.selectedtaglist.clear();
                                  //       tagController.tagsearch.text = "";
                                  //       for (var tag in profileController
                                  //           .myUserInfo.value.profileTag) {
                                  //         tagController.selectedtaglist
                                  //             .add(SelectedTagWidget(
                                  //           id: tag.tagId,
                                  //           text: tag.tag,
                                  //           selecttagtype:
                                  //               SelectTagtype.interesting,
                                  //           tagtype: Tagtype.profile,
                                  //         ));
                                  //       }
                                  //       Get.to(() => ProfileTagChangeScreen());
                                  //     },
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //         color: mainlightgrey,
                                  //         borderRadius:
                                  //             BorderRadius.circular(4),
                                  //       ),
                                  //       child: Padding(
                                  //         padding: EdgeInsets.symmetric(
                                  //             vertical: 8.0),
                                  //         child: Center(
                                  //           child: Text(
                                  //             '관심 태그 변경하기',
                                  //             style: kButtonStyle,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   width: 8,
                                  // ),
                                  // Expanded(
                                  //   child: GestureDetector(
                                  //     onTap: () {
                                  //       KakaoShareManager()
                                  //           .isKakaotalkInstalled()
                                  //           .then((installed) {
                                  //         if (installed) {
                                  //           KakaoShareManager().shareMyCode();
                                  //         } else {
                                  //           // show alert
                                  //         }
                                  //       });
                                  //     },
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //         color: mainblue,
                                  //         borderRadius:
                                  //             BorderRadius.circular(4),
                                  //       ),
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.symmetric(
                                  //           vertical: 8.0,
                                  //         ),
                                  //         child: Center(
                                  //             child: Text('내 프로필 공유하기',
                                  //                 style: kButtonStyle.copyWith(
                                  //                     color: mainWhite))),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
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
                                behavior: HitTestBehavior.translucent,
                                onTapDown: (details) =>
                                    _hoverController.isHover(true),
                                onTapCancel: () =>
                                    _hoverController.isHover(false),
                                onTapUp: (details) =>
                                    _hoverController.isHover(false),
                                onTap: () {
                                  profileController.isLoopPeopleLoading(true);
                                  Get.to(() => LoopPeopleScreen(
                                        userid: profileController
                                            .myUserInfo.value.userid,
                                        loopcount: profileController
                                            .myUserInfo.value.loopcount.value,
                                      ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Obx(
                                        () => Text(
                                          '팔로워',
                                          style: kBody1Style.copyWith(
                                              color: _hoverController
                                                      .isHover.value
                                                  ? mainblack.withOpacity(0.6)
                                                  : mainblack),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Obx(
                                        () => Text(
                                          profileController
                                              .myUserInfo.value.loopcount
                                              .toString(),
                                          style: kSubTitle2Style.copyWith(
                                              color: _hoverController
                                                      .isHover.value
                                                  ? mainblack.withOpacity(0.6)
                                                  : mainblack),
                                          textAlign: TextAlign.center,
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
                                20,
                                16,
                                16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('활동', style: kSubTitle2Style),
                                  if (profileController
                                      .myProjectList.value.isNotEmpty)
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        Get.to(
                                          () => ProjectAddTitleScreen(
                                            screenType: Screentype.add,
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Text(
                                          '추가하기',
                                          style: kSubTitle2Style.copyWith(
                                              color: mainblue),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Obx(
                              () => Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  child: (profileController
                                              .myprofilescreenstate.value ==
                                          ScreenState.loading)
                                      ? Column(
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
                                        )
                                      : profileController
                                                  .myprofilescreenstate.value ==
                                              ScreenState.disconnect
                                          ? Container()
                                          : profileController
                                                      .myprofilescreenstate
                                                      .value ==
                                                  ScreenState.error
                                              ? Container()
                                              : Obx(
                                                  () =>
                                                      profileController
                                                              .myProjectList
                                                              .value
                                                              .isNotEmpty
                                                          ? Column(
                                                              children: profileController
                                                                  .myProjectList
                                                                  .map((project) => ProjectWidget(
                                                                      project:
                                                                          project
                                                                              .obs,
                                                                      type: ProjectWidgetType
                                                                          .profile))
                                                                  .toList(),
                                                            )
                                                          : Column(
                                                              children: [
                                                                Text(
                                                                  '첫번째 활동을 기록해보세요',
                                                                  style:
                                                                      kSubTitle1Style,
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  '수업, 과제, 스터디 등 학교 생활과 관련있는\n다양한 경험을 남겨보세요',
                                                                  style: kBody1Style
                                                                      .copyWith(
                                                                    color: mainblack
                                                                        .withOpacity(
                                                                            0.6),
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                  height: 12,
                                                                ),
                                                                CustomExpandedButton(
                                                                  onTap: () {
                                                                    Get.to(
                                                                      () =>
                                                                          ProjectAddTitleScreen(
                                                                        screenType:
                                                                            Screentype.add,
                                                                      ),
                                                                    );
                                                                  },
                                                                  isBlue: true,
                                                                  title:
                                                                      '첫번째 활동 추가하기',
                                                                  buttonTag:
                                                                      '첫번째 활동 추가하기',
                                                                  isBig: false,
                                                                )
                                                              ],
                                                            ),
                                                )),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ),
                ),
              ),
            ),
            if (imageController.isProfileImagePickerLoading.value == true)
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
    imageController.isProfileImagePickerLoading.value = true;
    File? image = await imageController.getcropImage(ImageType.profile);
    print('image : $image');
    if (image != null) {
      User? user = await updateProfile(profileController.myUserInfo.value,
              image, null, ProfileUpdateType.image)
          .then((user) {
        imageController.isProfileImagePickerLoading.value = false;
        if (user != null) {
          profileController.myUserInfo(user);
        }
      });
    }
  }

  void changeDefaultImage() async {
    User? user = await updateProfile(profileController.myUserInfo.value, null,
            null, ProfileUpdateType.image)
        .then((user) {
      imageController.isProfileImagePickerLoading.value = false;
      if (user != null) {
        profileController.myUserInfo(user);
      }
    });
  }
}
