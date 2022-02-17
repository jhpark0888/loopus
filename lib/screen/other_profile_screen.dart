import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/loop_api.dart';
import 'package:loopus/controller/follow_controller.dart';
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
import 'package:loopus/widget/custom_expanded_button.dart';
import 'package:loopus/widget/project_widget.dart';
import 'package:loopus/widget/tag_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../controller/hover_controller.dart';

class OtherProfileScreen extends StatelessWidget {
  OtherProfileScreen(
      {Key? key,
      required this.userid,
      required this.isuser,
      required this.realname})
      : super(key: key);
  late OtherProfileController controller =
      Get.put(OtherProfileController(userid), tag: userid.toString());

  late final FollowController followController = Get.put(
      FollowController(
          islooped: controller.otherUser.value.looped.value ==
                  FollowState.normal
              ? 0.obs
              : controller.otherUser.value.looped.value == FollowState.follower
                  ? 0.obs
                  : controller.otherUser.value.looped.value ==
                          FollowState.following
                      ? 1.obs
                      : 1.obs,
          id: userid,
          lastislooped: controller.otherUser.value.looped.value ==
                  FollowState.normal
              ? 0
              : controller.otherUser.value.looped.value == FollowState.follower
                  ? 0
                  : controller.otherUser.value.looped.value ==
                          FollowState.following
                      ? 1
                      : 1),
      tag: userid.toString());

  final ImageController imageController = Get.put(ImageController());
  final HoverController _hoverController = Get.put(HoverController());

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
              title: '${realname}님의 프로필',
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
                      '프로필 받아오는 중...',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
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
                                                        placeholder: (context,
                                                                url) =>
                                                            kProfilePlaceHolder(),
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
                                  child: CustomExpandedButton(
                                    onTap: controller.otherUser.value.isuser ==
                                            1
                                        ? () {
                                            Get.to(
                                                () => ProfileTagChangeScreen());
                                          }
                                        : () {
                                            MessageDetailController
                                                messagecontroller = Get.put(
                                                    MessageDetailController(
                                                        userid: userid,
                                                        user: controller
                                                            .otherUser),
                                                    tag: controller
                                                        .otherUser.value.userid
                                                        .toString());
                                            messagecontroller
                                                .firstmessagesload();
                                            Get.to(() => MessageDetailScreen(
                                                  realname: controller
                                                      .otherUser.value.realName,
                                                  userid: controller
                                                      .otherUser.value.userid,
                                                  user: controller
                                                      .otherUser.value,
                                                ));
                                          },
                                    isBlue: false,
                                    isBig: false,
                                    buttonTag: '메시지 보내기',
                                    title:
                                        controller.otherUser.value.isuser == 1
                                            ? '관심 태그 변경하기'
                                            : '메시지 보내기',
                                  ),
                                ),
                                if (controller.otherUser.value.isuser != 1)
                                  const SizedBox(
                                    width: 8,
                                  ),
                                if (controller.otherUser.value.isuser != 1)
                                  Expanded(
                                    child: CustomExpandedButton(
                                      onTap: followMotion,
                                      isBlue: controller.otherUser.value.looped
                                                      .value ==
                                                  FollowState.follower ||
                                              controller.otherUser.value.looped
                                                      .value ==
                                                  FollowState.normal
                                          ? true
                                          : false,
                                      isBig: false,
                                      buttonTag: '팔로우',
                                      title: controller.otherUser.value.looped
                                                  .value ==
                                              FollowState.normal
                                          ? '팔로우하기'
                                          : controller.otherUser.value.looped
                                                      .value ==
                                                  FollowState.follower
                                              ? '나도 팔로우하기'
                                              : controller.otherUser.value
                                                          .looped.value ==
                                                      FollowState.following
                                                  ? '팔로잉 중'
                                                  : '팔로잉 중',
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
                              behavior: HitTestBehavior.translucent,
                              onTapDown: (details) =>
                                  _hoverController.isHover(true),
                              onTapCancel: () =>
                                  _hoverController.isHover(false),
                              onTapUp: (details) =>
                                  _hoverController.isHover(false),
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
                                    Obx(
                                      () => Text(
                                        '팔로워',
                                        style: kBody1Style.copyWith(
                                            color:
                                                _hoverController.isHover.value
                                                    ? mainblack.withOpacity(0.6)
                                                    : mainblack),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Obx(
                                      () => Text(
                                        controller.otherUser.value.loopcount
                                            .toString(),
                                        style: kSubTitle2Style.copyWith(
                                            color:
                                                _hoverController.isHover.value
                                                    ? mainblack.withOpacity(0.6)
                                                    : mainblack),
                                      ),
                                    ),
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
                                      child:
                                          controller.otherUser.value.isuser == 1
                                              ? (controller.otherProjectList
                                                      .value.isNotEmpty)
                                                  ? Text(
                                                      '추가하기',
                                                      style: kSubTitle2Style
                                                          .copyWith(
                                                              color: mainblue),
                                                    )
                                                  : SizedBox.shrink()
                                              : SizedBox.shrink(),
                                    )
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
                                            : controller.otherUser.value
                                                        .isuser ==
                                                    1
                                                ? Column(
                                                    children: [
                                                      Text(
                                                        '첫번째 활동을 기록해보세요',
                                                        style: kSubTitle1Style,
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        '수업, 과제, 스터디 등 학교 생활과 관련있는\n다양한 경험을 남겨보세요',
                                                        style: kBody1Style
                                                            .copyWith(
                                                          color: mainblack
                                                              .withOpacity(0.6),
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 12,
                                                      ),
                                                      CustomExpandedButton(
                                                        onTap: () {
                                                          Get.to(() =>
                                                              ProjectAddTitleScreen(
                                                                screenType:
                                                                    Screentype
                                                                        .add,
                                                              ));
                                                        },
                                                        isBlue: true,
                                                        title: '첫번째 활동 추가하기',
                                                        buttonTag:
                                                            '첫번째 활동 추가하기',
                                                        isBig: false,
                                                      )
                                                    ],
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 12.0),
                                                    child: Text(
                                                      '아직 만들어진 활동이 없어요',
                                                      style: kSubTitle3Style
                                                          .copyWith(
                                                        color: mainblack
                                                            .withOpacity(0.38),
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
                                                  fontWeight: FontWeight.w500,
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

  void followMotion() {
    if (controller.otherUser.value.isuser == 1) {
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
      if (controller.otherUser.value.looped.value == FollowState.normal) {
        followController.islooped(1);
        controller.otherUser.value.looped(FollowState.following);
      } else if (controller.otherUser.value.looped.value ==
          FollowState.follower) {
        followController.islooped(1);

        controller.otherUser.value.looped(FollowState.wefollow);

        // ProfileController.to.myUserInfo
        //         .value.loopcount -
        //     1;

      } else if (controller.otherUser.value.looped.value ==
          FollowState.following) {
        followController.islooped(0);

        controller.otherUser.value.looped(FollowState.normal);
      } else if (controller.otherUser.value.looped.value ==
          FollowState.wefollow) {
        followController.islooped(0);

        controller.otherUser.value.looped(FollowState.follower);
      }
    }
  }
}
