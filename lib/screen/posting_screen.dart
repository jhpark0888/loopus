import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/like_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/screen/likepeople_screen.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/screen/posting_modify_screen.dart';
import 'package:loopus/screen/project_screen.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';

class PostingScreen extends StatelessWidget {
  PostingScreen({
    Key? key,
    required this.userid,
    required this.isuser,
    required this.postid,
    required this.title,
    required this.realName,
    required this.department,
    required this.postDate,
    required this.profileImage,
    required this.thumbNail,
    required this.likecount,
    required this.isLiked,
    required this.isMarked,
  }) : super(key: key);
  late PostingDetailController controller =
      Get.put(PostingDetailController(postid), tag: postid.toString());
  late final LikeController likeController = Get.put(
      LikeController(isliked: isLiked, id: postid, lastisliked: isLiked.value),
      tag: postid.toString());

  final ModalController modalController = Get.put(ModalController());
  final ScrollController _controller = ScrollController();
  // final TransitionAnimationController _transitionAnimationController =
  // Get.put(TransitionAnimationController());

  int userid;
  int isuser;
  int postid;
  String title;
  String realName;
  dynamic profileImage;
  DateTime postDate;
  String department;
  dynamic thumbNail;
  RxInt likecount;
  RxInt isLiked;
  RxInt isMarked;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(children: [
        Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: kBottomNavigationBarHeight,
              decoration: const BoxDecoration(
                color: mainWhite,
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Color(0xffe7e7e7),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => InkWell(
                      onTap: () {
                        if (isLiked.value == 0) {
                          likeController.isliked(1);
                          likecount += 1;

                          HomeController.to.tapLike(postid, likecount.value);
                          isLiked(1);
                        } else {
                          likeController.isliked(0);
                          likecount -= 1;
                          HomeController.to.tapunLike(postid, likecount.value);

                          isLiked(0);
                        }
                      },
                      child: isLiked.value == 0
                          ? SvgPicture.asset(
                              "assets/icons/Favorite_Inactive.svg")
                          : SvgPicture.asset(
                              "assets/icons/Favorite_Active.svg"))),
                  const SizedBox(
                    width: 4,
                  ),
                  Obx(
                    () => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Get.to(() => LikePeopleScreen(
                              postid: postid,
                            ));
                      },
                      child: Text(
                        likecount != 0 ? "${likecount}     \u200B" : ' \u200B',
                        style: kButtonStyle,
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      width: likecount != 0 ? 4 : 8,
                    ),
                  ),
                  Obx(() => InkWell(
                      onTap: () {
                        if (isMarked.value == 0) {
                          HomeController.to.tapBookmark(postid);
                          isMarked(1);
                        } else {
                          HomeController.to.tapunBookmark(postid);
                          isMarked(0);
                        }
                      },
                      child: isMarked.value == 0
                          ? SvgPicture.asset("assets/icons/Mark_Default.svg")
                          : SvgPicture.asset("assets/icons/Mark_Saved.svg")))
                ],
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () {},
            // },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              slivers: [
                SliverAppBar(
                  stretch: true,
                  bottom: PreferredSize(
                      child: Container(
                        color: const Color(0xffe7e7e7),
                        height: 1,
                      ),
                      preferredSize: const Size.fromHeight(4.0)),
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () => Get.back(),
                    icon: SvgPicture.asset('assets/icons/Arrow.svg'),
                  ),
                  actions: [
                    isuser == 1
                        ? IconButton(
                            onPressed: () {
                              Get.to(
                                () => PostingModifyScreen(
                                  postid: controller.postid,
                                ),
                              );
                            },
                            icon: SvgPicture.asset('assets/icons/Edit.svg'),
                          )
                        : Container(),
                    IconButton(
                      onPressed: isuser == 1
                          ? () {
                              modalController.showModalIOS(
                                context,
                                func1: () {
                                  modalController.showButtonDialog(
                                      leftText: '취소',
                                      rightText: '삭제',
                                      title:
                                          '<${controller.post.value.title}> 포스팅을 삭제하시겠어요?',
                                      content: '삭제한 포스팅은 복구할 수 없어요',
                                      leftFunction: () => Get.back(),
                                      rightFunction: () async {
                                        controller.isPostDeleteLoading(true);
                                        getbacks(2);
                                        await deleteposting(
                                                controller.post.value.id,
                                                controller
                                                    .post.value.project!.id)
                                            .then((value) {
                                          controller.isPostDeleteLoading(false);
                                        });
                                      });
                                },
                                func2: () {},
                                value1: '이 포스팅 삭제하기',
                                value2: '',
                                isValue1Red: true,
                                isValue2Red: false,
                                isOne: true,
                              );
                            }
                          : () {
                              modalController.showModalIOS(
                                context,
                                func1: () {
                                  modalController.showButtonDialog(
                                      leftText: '취소',
                                      rightText: '신고',
                                      title:
                                          '정말 <${controller.post.value.title}> 포스팅을 신고하시겠어요?',
                                      content: '관리자가 검토 절차를 거칩니다',
                                      leftFunction: () => Get.back(),
                                      rightFunction: () {
                                        postingreport(controller.post.value.id);
                                      });
                                },
                                func2: () {},
                                value1: '이 포스팅 신고하기',
                                value2: '',
                                isValue1Red: true,
                                isValue2Red: false,
                                isOne: true,
                              );
                            },
                      icon: SvgPicture.asset(
                        'assets/icons/More.svg',
                      ),
                    ),
                  ],
                  pinned: true,
                  flexibleSpace: Obx(
                    () => controller.post.value.id == 0
                        ? _MyAppSpace(
                            id: postid,
                            title: title,
                            realname: realName,
                            profileImage: profileImage,
                            postDate: postDate,
                            department: department,
                            thumbnail: thumbNail,
                            isuser: isuser,
                            userid: userid,
                          )
                        : _MyAppSpace(
                            id: controller.post.value.id,
                            title: controller.post.value.title,
                            realname: realName,
                            profileImage: profileImage,
                            postDate: controller.post.value.date,
                            department: department,
                            thumbnail: controller.post.value.thumbnail,
                            isuser: isuser,
                            userid: userid,
                          ),
                  ),
                  expandedHeight: Get.width / 3 * 2,
                ),
                SliverToBoxAdapter(
                  child: Obx(() => (controller.postscreenstate.value ==
                          ScreenState.loading)
                      ? Image.asset(
                          'assets/icons/loading.gif',
                          scale: 9,
                        )
                      : controller.postscreenstate.value ==
                              ScreenState.disconnect
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 24,
                                ),
                                DisconnectReloadWidget(reload: () {
                                  getposting(controller.postid);
                                }),
                              ],
                            )
                          : controller.postscreenstate.value ==
                                  ScreenState.error
                              ? ErrorReloadWidget(reload: () {
                                  getposting(controller.postid);
                                })
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                      Obx(
                                        () => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 24,
                                            ),
                                            child: Column(
                                              children: controller
                                                  .postcontentlist.value,
                                            )),
                                      ),
                                      TextButton(
                                        onPressed: tapOtherPosting,
                                        child: Text(
                                          '이 활동의 다른 포스팅 읽기',
                                          style: kButtonStyle.copyWith(
                                              color: mainblue),
                                        ),
                                      ),
                                      Container(
                                        height: 8,
                                        color: Color(0xffF2F3F5),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(16, 20, 16, 8),
                                        child: Text(
                                          '관련 포스팅',
                                          style: kSubTitle2Style,
                                        ),
                                      ),
                                      Column(
                                        children: controller
                                                .recommendposts.isNotEmpty
                                            ? controller.recommendposts
                                            : [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  '관련된 포스팅이 없어요',
                                                  style:
                                                      kSubTitle3Style.copyWith(
                                                    color: mainblack
                                                        .withOpacity(0.38),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                              ],
                                      ),
                                    ])),
                ),
              ],
            ),
          ),
        ),
        if (controller.isPostDeleteLoading.value == true)
          Container(
            height: Get.height,
            width: Get.width,
            color: mainblack.withOpacity(0.3),
            child: Image.asset(
              'assets/icons/loading.gif',
              scale: 6,
            ),
          ),
      ]),
    );
  }

  void tapOtherPosting() {
    Get.to(() => ProjectScreen(
        projectid: controller.post.value.project!.id,
        isuser: controller.post.value.isuser));
  }
}

class _MyAppSpace extends StatelessWidget {
  _MyAppSpace({
    Key? key,
    required this.id,
    required this.title,
    required this.realname,
    required this.profileImage,
    required this.postDate,
    required this.department,
    required this.thumbnail,
    required this.isuser,
    required this.userid,
  }) : super(key: key);

  String title;
  String realname;
  var profileImage;
  DateTime postDate;
  String department;
  var thumbnail;
  int id;
  int isuser;
  int userid;

  @override
  Widget build(
    BuildContext context,
  ) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return LayoutBuilder(
      builder: (context, c) {
        var top = c.biggest.height;

        final settings = context
            .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
        final deltaExtent = settings!.maxExtent - settings.minExtent;
        final t =
            (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
                .clamp(0.0, 1.0) as double;
        final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
        const fadeEnd = 1.0;
        final opacity1 = 1.0 - Interval(0.0, 0.75).transform(t);
        final opacity2 = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
        return Stack(
          children: [
            SafeArea(
              child: Center(
                child: Opacity(
                  opacity: 1 - opacity2,
                  child: getCollapseTitle(
                    title,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: opacity1,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  getImage(thumbnail, 'thumbnail$id'),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        getExpendTitle(title, 'title$id'),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => OtherProfileScreen(
                                        userid: userid,
                                        isuser: isuser,
                                        realname: realname,
                                      ));
                                },
                                child: Row(
                                  children: [
                                    (profileImage != null)
                                        ? ClipOval(
                                            child: CachedNetworkImage(
                                              height: 32,
                                              width: 32,
                                              imageUrl: profileImage,
                                              placeholder: (context, url) =>
                                                  kProfilePlaceHolder(),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ClipOval(
                                            child: Image.asset(
                                              "assets/illustrations/default_profile.png",
                                              height: 32,
                                              width: 32,
                                            ),
                                          ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Material(
                                      type: MaterialType.transparency,
                                      child: Text(
                                        "$realname · ",
                                        style: kButtonStyle,
                                      ),
                                    ),
                                    Hero(
                                      tag: 'department$id',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          department,
                                          style: kBody2Style,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${postDate.year}.${postDate.month}.${postDate.day}',
                                style: kBody2Style.copyWith(
                                  color: mainblack.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getImage(String? image, String heroThumbnailTag) {
    return Hero(
      tag: heroThumbnailTag,
      child: Container(
        width: Get.width,
        height: Get.height,
        child: Opacity(
          opacity: image != null ? 0.25 : 1,
          child: (image != null)
              ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: image,
                )
              : Image.asset(
                  "assets/illustrations/default_image.png",
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget getExpendTitle(String text, String heroTitleTag) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Hero(
        tag: heroTitleTag,
        child: Material(
          type: MaterialType.transparency,
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: kHeaderH2Style,
          ),
        ),
      ),
    );
  }

  Widget getCollapseTitle(String text) {
    return Container(
      padding: EdgeInsets.only(right: isuser == 1 ? 100 : 60, left: 60),
      child: Text(text,
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: kBody2Style),
    );
  }
}
