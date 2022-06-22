import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:loopus/constant.dart';
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

class _NewsWidgetState extends State<NewsWidget> {
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

  Future geturlinfo() async {
    final WebInfo info = await LinkPreview.scrapeFromURL(widget.url);
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
        print(loading);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const LoadingWidget();
    } else {
      return SizedBox(
        width: 252,
        child: Column(
          children: [
            image != ''
                ? CachedNetworkImage(
                    imageUrl: image,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 150,
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
      );
    }
  }
}
