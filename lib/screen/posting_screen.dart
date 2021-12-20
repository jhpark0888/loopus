import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';

class PostingScreen extends StatelessWidget {
  PostingScreen({Key? key}) : super(key: key);

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        controller: _controller,
        slivers: [
          SliverAppBar(
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
            flexibleSpace: _MyAppSpace(),
            expandedHeight: Get.width / 3 * 2,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Text(
                      "속의 별 멀듯이, 있습니다. 흙으로 그리고 가슴속에 피어나듯이 동경과 잔디가 프랑시스 보고, 버리었습니다. 하나의 릴케 그리고 하나에 딴은 이름자 위에 까닭이요, 봅니다. 애기 라이너 풀이 겨울이 까닭이요, 아침이 무덤 봅니다.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    Text(
                      "속의 별 멀듯이, 있습니다. 흙으로 그리고 가슴속에 피어나듯이 동경과 잔디가 프랑시스 보고, 버리었습니다. 하나의 릴케 그리고 하나에 딴은 이름자 위에 까닭이요, 봅니다. 애기 라이너 풀이 겨울이 까닭이요, 아침이 무덤 봅니다.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    Text(
                      "속의 별 멀듯이, 있습니다. 흙으로 그리고 가슴속에 피어나듯이 동경과 잔디가 프랑시스 보고, 버리었습니다. 하나의 릴케 그리고 하나에 딴은 이름자 위에 까닭이요, 봅니다. 애기 라이너 풀이 겨울이 까닭이요, 아침이 무덤 봅니다.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    Text(
                      "속의 별 멀듯이, 있습니다. 흙으로 그리고 가슴속에 피어나듯이 동경과 잔디가 프랑시스 보고, 버리었습니다. 하나의 릴케 그리고 하나에 딴은 이름자 위에 까닭이요, 봅니다. 애기 라이너 풀이 겨울이 까닭이요, 아침이 무덤 봅니다.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    Text(
                      "속의 별 멀듯이, 있습니다. 흙으로 그리고 가슴속에 피어나듯이 동경과 잔디가 프랑시스 보고, 버리었습니다. 하나의 릴케 그리고 하나에 딴은 이름자 위에 까닭이요, 봅니다. 애기 라이너 풀이 겨울이 까닭이요, 아침이 무덤 봅니다.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    Text(
                      "속의 별 멀듯이, 있습니다. 흙으로 그리고 가슴속에 피어나듯이 동경과 잔디가 프랑시스 보고, 버리었습니다. 하나의 릴케 그리고 하나에 딴은 이름자 위에 까닭이요, 봅니다. 애기 라이너 풀이 겨울이 까닭이요, 아침이 무덤 봅니다.",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _MyAppSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    print('빌드');
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
                    'LOOPUS 앱 개발 프로젝트askdlaskdlaasdasdd',
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: opacity1,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  getImage(),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        getExpendTitle(
                          'LOOPUS 앱 개발을 하면서 느낀 점 3가지가 있습니다.',
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
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      height: 32,
                                      width: 32,
                                      imageUrl:
                                          "https://i.stack.imgur.com/l60Hf.png",
                                      placeholder: (context, url) =>
                                          CircleAvatar(
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  const Text(
                                    "박도영 · ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: mainblack,
                                    ),
                                  ),
                                  const Text(
                                    "기계공학과",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: mainblack),
                                  ),
                                ],
                              ),
                              Text(
                                '21. 08. 21',
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

  Widget getImage() {
    return Container(
      width: Get.width,
      height: Get.height,
      child: Opacity(
        opacity: 0.25,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl:
              'https://thumb.pann.com/tc_480/http://fimg4.pann.com/new/download.jsp?FileID=45110348',
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
