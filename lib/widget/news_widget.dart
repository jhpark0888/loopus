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
import 'package:loopus/widget/Link_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class NewsWidget extends StatelessWidget {
  NewsWidget({Key? key, required this.url}) : super(key: key);
  String url;

  late final NewsController _newsController = NewsController(url: url)
    ..geturlinfo();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _newsController.loading.value
          ? const SizedBox(width: 252, child: LoadingWidget())
          : InkWell(
              onTap: () {
                Get.to(() => WebViewScreen(url: url));
              },
              splashColor: kSplashColor,
              child: SizedBox(
                width: 252,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _newsController.image != ''
                        ? CachedNetworkImage(
                            imageUrl: _newsController.image,
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
                    Expanded(
                      child: Text(
                        _newsController.title,
                        style: kmain.copyWith(height: 1.5),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_newsController.authorName != "")
                      Column(
                        children: [
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: _newsController.authorImage,
                                  fit: BoxFit.cover,
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                _newsController.authorName,
                                style: kmain,
                              )
                            ],
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
    );
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
            height: 240,
            child: Obx(
              () => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Obx(() =>
                      KeepAliveWidget(child: NewsWidget(url: newslist[index])));
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

class NewsController {
  NewsController({required this.url});
  late String description;
  late String favicon;
  late String icon;
  late String image;
  late String title;
  late String authorImage;
  late String authorName;
  String url;
  RxBool loading = true.obs;

  Future geturlinfo() async {
    final Map<String, String>? info = await NewsFetchPreview().fetch(url);
    description = info != null ? info["description"] ?? "" : "";
    icon = info != null ? info["appleIcon"] ?? "" : "";
    image = info != null ? info["image"] ?? "" : "";
    title = info != null ? info["title"] ?? "" : "";
    favicon = info != null ? info["favIcon"] ?? "" : "";
    authorImage = info != null ? info["authorImage"] ?? "" : "";
    authorName = info != null ? info["authorName"] ?? "" : "";
    loading(false);
  }
}
