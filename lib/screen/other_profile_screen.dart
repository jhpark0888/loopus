import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/image_controller.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/other_profile_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/screen/profile_tag_change_screen.dart';
import 'package:loopus/screen/project_add_title_screen.dart';
import 'package:loopus/screen/looppeople_screen.dart';
import 'package:loopus/screen/setting_screen.dart';
import 'package:loopus/utils/kakao_share_manager.dart';
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
  late OtherProfileController controller =
      Get.put(OtherProfileController(userid), tag: userid.toString());

  late MessageDetailController messagecontroller = Get.put(
      MessageDetailController(
        controller.otherUser.value,
      ),
      tag: controller.otherUser.value.userid.toString());

  final ImageController imageController = Get.put(ImageController());
  int userid;
  int isuser;
  String realname;

  RefreshController otherprofilerefreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    controller.profileenablepullup.value = true;
    controller.loadotherProfile(userid);
    otherprofilerefreshController.refreshCompleted();
  }

  void onLoading() async {
    otherprofilerefreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
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
        () => controller.isProfileLoading.value
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
                  enablePullDown: (controller.isProfileLoading.value == true)
                      ? false
                      : true,
                  enablePullUp: !controller.profileenablepullup.value,
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
                                    onTap:
                                        controller.otherUser.value.isuser == 1
                                            ? () => ModalController.to
                                                .showModalIOS(context,
                                                    func1: changeProfileImage,
                                                    func2: () {},
                                                    value1: '라이브러리에서 선택',
                                                    value2: '기본 이미지로 변경',
                                                    isValue1Red: false,
                                                    isValue2Red: false,
                                                    isOne: false)
                                            : () {},
                                    child: ClipOval(
                                        child:
                                            (controller.isProfileLoading.value)
                                                ? Image.asset(
                                                    "assets/illustrations/default_profile.png",
                                                    height: 92,
                                                    width: 92,
                                                  )
                                                : controller.otherUser.value
                                                            .profileImage !=
                                                        null
                                                    ? CachedNetworkImage(
                                                        height: 92,
                                                        width: 92,
                                                        imageUrl: controller
                                                            .otherUser
                                                            .value
                                                            .profileImage!,
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
                                        child: controller
                                                    .otherUser.value.isuser ==
                                                1
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
                                controller.otherUser.value.realName,
                                style: kSubTitle2Style,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Obx(
                              () => Text(
                                controller.otherUser.value.department,
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
                                      controller.otherUser.value.profileTag
                                          .map((tag) => Row(children: [
                                                Tagwidget(
                                                  tag: tag,
                                                  fontSize: 14,
                                                ),
                                                controller.otherUser.value
                                                            .profileTag
                                                            .indexOf(tag) !=
                                                        controller
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
                                    onTap: controller.otherUser.value.isuser ==
                                            1
                                        ? () {
                                            Get.to(
                                                () => ProfileTagChangeScreen());
                                          }
                                        : () {
                                            messagecontroller
                                                .messageroomrefresh();
                                            Get.to(() => MessageDetailScreen(
                                                  user: controller
                                                      .otherUser.value,
                                                ));
                                          },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: mainlightgrey,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: controller
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
                                if (controller.otherUser.value.isuser != 1)
                                  SizedBox(
                                    width: 8,
                                  ),
                                if (controller.otherUser.value.isuser != 1)
                                  Expanded(
                                    child: Obx(
                                      () => GestureDetector(
                                        onTap: () {
                                          if (controller
                                                  .otherUser.value.isuser ==
                                              1) {
                                            // KakaoShareManager()
                                            //     .isKakaotalkInstalled()
                                            //     .then((installed) {
                                            //   if (installed) {
                                            //     KakaoShareManager().shareMyCode();
                                            //   } else {
                                            //     // show alert
                                            //   }
                                            // });
                                          } else {
                                            if (controller.otherUser.value
                                                    .looped.value ==
                                                FollowState.normal) {
                                              postfollowRequest(controller
                                                      .otherUser.value.userid)
                                                  .then((value) {
                                                controller.otherUser.value
                                                    .looped(
                                                        FollowState.following);
                                              });
                                            } else if (controller.otherUser
                                                    .value.looped.value ==
                                                FollowState.follower) {
                                              postfollowRequest(controller
                                                      .otherUser.value.userid)
                                                  .then((value) {
                                                controller.otherUser.value
                                                    .looped(
                                                        FollowState.wefollow);
                                              });

                                              // ProfileController.to.myUserInfo
                                              //         .value.loopcount -
                                              //     1;

                                            } else if (controller.otherUser
                                                    .value.looped.value ==
                                                FollowState.following) {
                                              deletefollow(controller
                                                      .otherUser.value.userid)
                                                  .then((value) {
                                                controller.otherUser.value
                                                    .looped(FollowState.normal);
                                              });
                                            } else if (controller.otherUser
                                                    .value.looped.value ==
                                                FollowState.wefollow) {
                                              deletefollow(controller
                                                      .otherUser.value.userid)
                                                  .then((value) {
                                                controller.otherUser.value
                                                    .looped(
                                                        FollowState.follower);
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: mainblue,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          // color: Colors.grey[400],

                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            child: Center(
                                              child: Text(
                                                  controller.otherUser.value
                                                              .looped.value ==
                                                          FollowState.normal
                                                      ? '팔로우'
                                                      : controller
                                                                  .otherUser
                                                                  .value
                                                                  .looped
                                                                  .value ==
                                                              FollowState
                                                                  .follower
                                                          ? '맞팔로우'
                                                          : controller
                                                                      .otherUser
                                                                      .value
                                                                      .looped
                                                                      .value ==
                                                                  FollowState
                                                                      .following
                                                              ? '팔로우 해제'
                                                              : '팔로우 해제',
                                                  style: kButtonStyle.copyWith(
                                                      color: mainWhite)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                                      controller.otherUser.value.totalposting
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
                                controller.isLoopPeopleLoading(true);
                                Get.to(() => LoopPeopleScreen(
                                      userid: controller.otherUser.value.userid,
                                      loopcount: controller
                                          .otherUser.value.loopcount.value,
                                    ));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '팔로워',
                                      style: kBody1Style,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      controller.otherUser.value.loopcount
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
                                        child: controller
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
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: (controller.isProfileLoading.value ==
                                        false)
                                    ? Obx(
                                        () => (controller.otherProjectList.value
                                                .isNotEmpty)
                                            ? Column(
                                                children: controller
                                                    .otherProjectList.value,
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0),
                                                child: Text(
                                                  '아직 만들어진 활동이 없어요',
                                                  style:
                                                      kSubTitle3Style.copyWith(
                                                    color: mainblack
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              ),
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
      User? user = await updateProfile(
          controller.otherUser.value, image, null, ProfileUpdateType.image);
      if (user != null) {
        controller.otherUser(user);
      }
    }
  }
}
