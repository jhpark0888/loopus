import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/post_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/controller/transition_animation_controller.dart';
import 'package:loopus/widget/post_content_widget.dart';

class PostingScreen extends StatelessWidget {
  final PostingDetailController _postingDetailController =
      Get.put(PostingDetailController());

  final ModalController modalController = Get.put(ModalController());
  final ScrollController _controller = ScrollController();
  // final TransitionAnimationController _transitionAnimationController =
  // Get.put(TransitionAnimationController());

  @override
  Widget build(BuildContext context) {
    int isuser = Get.arguments['isuser'];
    int id = Get.arguments['id'];
    String title = Get.arguments['title'];
    String realName = Get.arguments['realName'];
    dynamic profileImage = Get.arguments['profileImage'];
    DateTime postDate = Get.arguments['postDate'];
    String department = Get.arguments['department'];
    dynamic thumbNail = Get.arguments['thumbnail'];
    print(profileImage);
    print(thumbNail);
    return Obx(
      () => Stack(children: [
        Scaffold(
          body: GestureDetector(
            onTap: () {},
            // },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              slivers: [
                SliverAppBar(
                  stretch: false,
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
                    IconButton(
                      onPressed: isuser == 1
                          ? () {
                              modalController.showModalIOS(
                                context,
                                func1: () {
                                  modalController.showButtonDialog(
                                      leftText: '',
                                      rightText: '',
                                      title:
                                          '정말 <${_postingDetailController.item?.title}> 포스팅을 삭제하시겠어요?',
                                      content: '삭제한 포스팅은 복구할 수 없어요',
                                      leftFunction: () => Get.back(),
                                      rightFunction: () async {
                                        _postingDetailController
                                            .isPostDeleteLoading(true);
                                        Get.back();
                                        Get.back();
                                        await deleteposting(
                                            _postingDetailController.item!.id);
                                        _postingDetailController
                                            .isPostDeleteLoading(false);
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
                                      leftText: '',
                                      rightText: '',
                                      title:
                                          '정말 <${_postingDetailController.item?.title}> 포스팅을 신고하시겠어요?',
                                      content: '신고 횟수가 누적되면 포스팅은 삭제됩니다',
                                      leftFunction: () => Get.back(),
                                      rightFunction: () {});
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
                  flexibleSpace: _MyAppSpace(
                    id: id,
                    title: title,
                    realName: realName,
                    profileImage: profileImage,
                    postDate: postDate,
                    department: department,
                    thumbnail: thumbNail,
                  ),
                  expandedHeight: Get.width / 3 * 2,
                ),
                Obx(
                  () => SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                        ),
                        child: (_postingDetailController
                                    .isPostingContentLoading.value ==
                                false)
                            ? Column(
                                children: _postingDetailController
                                    .item!.contents!
                                    .map((content) =>
                                        PostContentWidget(content: content))
                                    .toList(),
                              )
                            : Image.asset(
                                'assets/icons/loading.gif',
                                scale: 9,
                              ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_postingDetailController.isPostDeleteLoading.value == true)
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
}

class _MyAppSpace extends StatelessWidget {
  _MyAppSpace({
    Key? key,
    required this.id,
    required this.title,
    required this.realName,
    required this.profileImage,
    required this.postDate,
    required this.department,
    required this.thumbnail,
  }) : super(key: key);

  String title;
  String realName;
  var profileImage;
  DateTime postDate;
  String department;
  var thumbnail;
  int id;

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
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  (profileImage != null)
                                      ? Hero(
                                          tag: 'profileImage$id',
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              height: 32,
                                              width: 32,
                                              imageUrl: profileImage,
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
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
                                  Hero(
                                    tag: 'realname$id',
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: Text(
                                        "$realName · ",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: mainblack,
                                        ),
                                      ),
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
                              Text(
                                '${postDate.year}.${postDate.month}.${postDate.day}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: mainblack.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
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
            style: TextStyle(
              height: 1.5,
              color: mainblack,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget getCollapseTitle(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: Text(
        text,
        textAlign: TextAlign.center,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: mainblack,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
