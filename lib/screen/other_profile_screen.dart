import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/profile_tag_change_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/looppeople_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:underline_indicator/underline_indicator.dart';

class OtherProfileScreen extends StatelessWidget {
  OtherProfileScreen(
      {Key? key,
      required this.userid,
      required this.isuser,
      required this.realname})
      : super(key: key);
  final ProfileController profileController = Get.put(ProfileController());
  final ImageController imageController = Get.put(ImageController());
  int userid;
  int isuser;
  String realname;
  Rx<User> otherUser = User(
    userid: 0,
    type: 0,
    realName: '',
    totalposting: 0,
    loopcount: 0,
    profileTag: [],
    department: '',
    isuser: 0,
    looped: 0,
  ).obs;
  RxList<ProjectWidget> otherProjectList = <ProjectWidget>[].obs;
  // RxBool isLoop = false.obs;

  RefreshController otherprofilerefreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    profileController.profileenablepullup.value = true;
    getProfile(userid).then((user) {
      otherUser(user);
    });
    getProjectlist(userid).then((projectlist) {
      otherProjectList(projectlist
          .map((project) => ProjectWidget(
                project: project.obs,
              ))
          .toList());
      profileController.isProfileLoading(false);
    });
    otherprofilerefreshController.refreshCompleted();
  }

  // void onLoading() async {
  //   await Future.delayed(Duration(milliseconds: 10));
  //   otherprofilerefreshController.loadComplete();
  // }

  @override
  Widget build(BuildContext context) {
    getProfile(userid).then((user) {
      otherUser(user);
    });
    getProjectlist(userid).then((projectlist) {
      otherProjectList(projectlist
          .map((project) => ProjectWidget(
                project: project.obs,
              ))
          .toList());
      profileController.isProfileLoading(false);
    });
    return Scaffold(
      appBar: isuser == 1
          ? AppBarWidget(
              title: '프로필',
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
              bottomBorder: false,
            )
          : AppBarWidget(bottomBorder: false, title: '${realname}님의 프로필'),
      body: Obx(
        () => ProfileController.to.isProfileLoading.value
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/loading.gif',
                      scale: 6,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '프로필 받는 중...',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: mainblue.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              )
            : Obx(
                () => SmartRefresher(
                  controller: otherprofilerefreshController,
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
                  onRefresh: onRefresh,
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
                                    onTap: otherUser.value.isuser == 1
                                        ? () => ModalController.to.showModalIOS(
                                            context,
                                            func1: changeProfileImage,
                                            func2: () {},
                                            value1: '라이브러리에서 선택',
                                            value2: '기본 이미지로 변경',
                                            isValue1Red: false,
                                            isValue2Red: false,
                                            isOne: false)
                                        : () {},
                                    child: ClipOval(
                                        child: (profileController
                                                .isProfileLoading.value)
                                            ? Image.asset(
                                                "assets/illustrations/default_profile.png",
                                                height: 92,
                                                width: 92,
                                              )
                                            : otherUser.value.profileImage !=
                                                    null
                                                ? CachedNetworkImage(
                                                    height: 92,
                                                    width: 92,
                                                    imageUrl: otherUser
                                                        .value.profileImage!,
                                                    placeholder:
                                                        (context, url) =>
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
                                        child: otherUser.value.isuser == 1
                                            ? Container(
                                                decoration: const BoxDecoration(
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
                                otherUser.value.realName,
                                style: kSubTitle2Style,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Obx(
                              () => Text(
                                otherUser.value.department,
                                style: kBody1Style,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Obx(
                              () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: otherUser.value.profileTag
                                      .map((tag) => Row(children: [
                                            Tagwidget(
                                              tag: tag,
                                              fontSize: 14,
                                            ),
                                            otherUser.value.profileTag
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
                                    onTap: otherUser.value.isuser == 1
                                        ? () {
                                            Get.to(
                                                () => ProfileTagChangeScreen());
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
                                          child: otherUser.value.isuser == 1
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
                                      if (otherUser.value.isuser == 1) {
                                      } else {
                                        otherUser.value.looped == 1
                                            ? postloopRelease(
                                                otherUser.value.userid)
                                            : postloopRequest(
                                                otherUser.value.userid);
                                      }
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
                                        child: otherUser.value.isuser == 1
                                            ? Center(
                                                child: Text('내 프로필 공유하기',
                                                    style:
                                                        kButtonStyle.copyWith(
                                                            color: mainWhite)),
                                              )
                                            : Center(
                                                child: Text(
                                                    otherUser.value.looped == 0
                                                        ? '루프 맺기'
                                                        : otherUser.value
                                                                    .looped ==
                                                                1
                                                            ? '루프 해제'
                                                            : '루프 요청중',
                                                    style:
                                                        kButtonStyle.copyWith(
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
                      Container(
                        height: 8,
                        color: Color(0xffF2F3F5),
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
                                    Text(
                                      otherUser.value.totalposting.toString(),
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
                                      userid: otherUser.value.userid,
                                      loopcount: otherUser.value.loopcount,
                                    ));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
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
                                      otherUser.value.loopcount.toString(),
                                      style: kSubTitle2Style,
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
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 24, 16, 20),
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
                                        child: otherUser.value.isuser == 1
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child:
                                    (profileController.isProfileLoading.value ==
                                            false)
                                        ? Column(
                                            children: otherProjectList,
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
                                                      fontSize: 10,
                                                      color: mainblue),
                                                ),
                                              ],
                                            ),
                                          ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
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
