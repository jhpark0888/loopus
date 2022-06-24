import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/widget/loading_widget.dart';

class ScrapWidget extends StatefulWidget {
  ScrapWidget({Key? key, required this.url,required this.length, required this.widgetType})
      : super(key: key);
  WebInfo? info;
  String url;
  int length;
  // add, post
  String widgetType;
  @override
  State<ScrapWidget> createState() => _ScrapWidgetState();
}

class _ScrapWidgetState extends State<ScrapWidget> {
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
    return loading
        ? ScrapCard(child: const LoadingWidget(), isimgae: false)
        : domain.endsWith('jpg') || domain.endsWith('png')
            ? ScrapCard(
                isimgae: true,
                domain: domain,
              )
            : Stack(
                children: [
                  ScrapCard(
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: image != ''
                              ? image
                              : 'https://cdn.pixabay.com/photo/2022/04/22/14/14/leaves-7149850__340.jpg',
                          height: 200,
                          width: Get.width,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 22, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                domain,
                                style: k16Normal,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Text(
                                description,
                                style: k16Normal,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    isimgae: false,
                  ),
                  if (widget.widgetType == 'add')
                    Positioned(
                        top: 15,
                        right: 15,
                        child: GestureDetector(
                            onTap: (){
                              Get.find<PostingAddController>().scrapList.removeWhere((element) => element.key == widget.key);
                            },
                            child: SvgPicture.asset(
                              'assets/icons/link_delete_button.svg',
                            ))),
                ],
              );
  }
}

class ScrapCard extends StatelessWidget {
  ScrapCard({Key? key, this.child, required this.isimgae, this.domain})
      : super(key: key);

  Widget? child;
  bool isimgae;
  String? domain;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: Get.width,
        decoration: BoxDecoration(
          color: cardGray,
          image: isimgae
              ? DecorationImage(
                  image: NetworkImage(domain!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: child);
  }
}
