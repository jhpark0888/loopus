import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/utils/custom_linkpreview.dart';
import 'package:loopus/widget/loading_widget.dart';

class NewsWidget extends StatefulWidget {
  NewsWidget({
    Key? key,
    required this.url,
  }) : super(key: key);
  WebInfo? info;
  String url;

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget>
    with AutomaticKeepAliveClientMixin<NewsWidget> {
  /// Description of the page.
  late String description;

  /// Domain name of the link.
  late String domain;

  /// Favicon of the page.
  late String icon;

  /// Image URL, if present any in the link.
  late String image;

  /// Title of the page.
  late String title;

  /// Link preview type of the rule used for scrapping the link.
  /// Returns [LinkPreviewType.error] if the scrapping is failed.
  late LinkPreviewType type;

  /// Video URL, if present any in the link.
  late String video;

  bool loading = true;

  @override
  void initState() {
    geturlinfo();
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future geturlinfo() async {
    final WebInfo info = await CustomLinkPreview.scrapeFromURL(widget.url);
    description = info.description;
    domain = info.domain;
    icon = info.icon;
    image = info.image;
    title = info.title;
    type = info.type;
    video = info.video;
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(width: 252, child: LoadingWidget());
    } else {
      // if (type != LinkPreviewType.error) {
      return InkWell(
        onTap: () {
          Get.to(() => WebViewScreen(url: widget.url));
        },
        splashColor: kSplashColor,
        child: SizedBox(
          width: 252,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              image != ''
                  ? CachedNetworkImage(
                      imageUrl: image,
                      height: 150,
                      width: 252,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      width: 252,
                      color: cardGray,
                    ),
              const SizedBox(
                height: 14,
              ),
              Text(
                title,
                style: k16Normal.copyWith(height: 1.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
      // } else {
      //   return SizedBox(
      //     width: 252,
      //     child: Center(
      //         child: Text(
      //       '존재하지 않는 URL입니다',
      //       style: k16Normal.copyWith(height: 1.5),
      //     )),
      //   );
      // }
    }
  }
}

class NewsListWidget extends StatelessWidget {
  NewsListWidget({Key? key, required this.newslist}) : super(key: key);

  RxList<String> newslist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '이건 꼭 봐야해! 관심 분야 최근 이슈',
              style: kmainbold,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          SizedBox(
            height: 220,
            child: Obx(
              () => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return NewsWidget(url: newslist[index]);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 14,
                  );
                },
                itemCount: newslist.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
