import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/post_detail_controller.dart';
import 'package:loopus/model/post_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/post_content_widget.dart';

class PostingScreen extends StatelessWidget {
  PostingDetailController _postingDetailController =
      Get.put(PostingDetailController());

  ScrollController _controller = ScrollController();
  // Post post;
  // User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        controller: _controller,
        slivers: [
          SliverAppBar(
            stretch: true,
            bottom: PreferredSize(
                child: Container(
                  color: Color(0xffe7e7e7),
                  height: 1,
                ),
                preferredSize: Size.fromHeight(4.0)),
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset('assets/icons/Arrow.svg'),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/More.svg',
                ),
              ),
            ],
            pinned: true,
            flexibleSpace: _MyAppSpace(
              title: Get.arguments['title'],
              realName: Get.arguments['realName'],
              profileImage: Get.arguments['profileImage'],
              postDate: Get.arguments['postDate'],
              department: Get.arguments['department'],
              thumbNail: Get.arguments['thumbNail'],
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
                  child:
                      (_postingDetailController.isPostingContentLoading.value ==
                              false)
                          ? Column(
                              children: _postingDetailController.item!.contents!
                                  .map((content) =>
                                      PostContentWidget(content: content))
                                  .toList(),
                            )
                          : Column(children: [
                              Image.asset(
                                'assets/icons/loading.gif',
                                scale: 9,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                '내용을 받는 중이에요...',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: mainblue,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ]),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyAppSpace extends StatelessWidget {
  _MyAppSpace({
    Key? key,
    // required this.post,
    // required this.user,
    required this.title,
    required this.realName,
    required this.profileImage,
    required this.postDate,
    required this.department,
    required this.thumbNail,
  }) : super(key: key);

  // Post post;
  // User user;
  String title;
  String realName;
  var profileImage;
  DateTime postDate;
  String department;
  var thumbNail;

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
                  getImage(thumbNail),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        getExpendTitle(
                          title,
                        ),
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
                                      ? ClipOval(
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
                                  Text(
                                    "$realName · ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: mainblack,
                                    ),
                                  ),
                                  Text(
                                    department,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: mainblack),
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

  Widget getImage(String? image) {
    return Container(
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
    );
  }

  Widget getExpendTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
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
