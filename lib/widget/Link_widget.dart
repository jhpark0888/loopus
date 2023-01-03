import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/posting_add_controller.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/utils/custom_linkpreview.dart';
import 'package:loopus/widget/loading_widget.dart';

// class LinkWidget extends StatefulWidget {
//   LinkWidget({Key? key, required this.url, required this.widgetType})
//       : super(key: key);
//   WebInfo? info;
//   String url;
//   // add, post
//   String widgetType;
//   @override
//   State<LinkWidget> createState() => _LinkWidgetState();
// }

// class _LinkWidgetState extends State<LinkWidget>
//     with AutomaticKeepAliveClientMixin<LinkWidget> {
//   /// Description of the page.
//   late String description;

//   /// Domain name of the link.
//   late String domain;

//   /// Favicon of the page.
//   late String icon;

//   /// Image URL, if present any in the link.
//   late String image;

//   /// Title of the page.
//   late String title;

//   /// Link preview type of the rule used for scrapping the link.
//   /// Returns [LinkPreviewType.error] if the scrapping is failed.
//   late LinkPreviewType type;

//   /// Video URL, if present any in the link.
//   late String video;

//   bool loading = true;

//   @override
//   void initState() {
//     geturlinfo();
//     super.initState();
//   }

//   Future geturlinfo() async {
//     // final String finalUrl;
//     // if(widget.url.contains('https')){
//     //   finalUrl = widget.url;
//     // }else if(widget.url.contains('http')){
//     //   finalUrl = widget.url.replaceAll('http', 'https');
//     // }
//     // else{
//     //   finalUrl = 'https://' + widget.url;
//     // }

//     final WebInfo info = await CustomLinkPreview.scrapeFromURL(widget.url);
//     description = info.description;
//     domain = info.domain;
//     icon = info.icon;
//     image = info.image;
//     title = info.title;
//     type = info.type;
//     video = info.video;
//     if (mounted) {
//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return ScrapCard(child: const LoadingWidget(), isimgae: false);
//     } else {
//       if (domain.endsWith('jpg') || domain.endsWith('png')) {
//         return ScrapCard(
//           isimgae: true,
//           domain: domain,
//         );
//       } else {
//         return GestureDetector(
//           onTap: () {
//             Get.to(() => WebViewScreen(url: widget.url));
//           },
//           child: Stack(
//             children: [
//               ScrapCard(
//                 child: Column(
//                   children: [
//                     CachedNetworkImage(
//                       imageUrl: image != ''
//                           ? image
//                           : 'https://cdn.pixabay.com/photo/2022/04/22/14/14/leaves-7149850__340.jpg',
//                       height: 200,
//                       width: Get.width,
//                       fit: BoxFit.cover,
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 22, horizontal: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             domain,
//                             style: k16Normal,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                           const SizedBox(
//                             height: 14,
//                           ),
//                           Text(
//                             description,
//                             style: k16Normal,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 isimgae: false,
//               ),
//               if (widget.widgetType == 'add')
//                 Positioned(
//                     top: 15,
//                     right: 15,
//                     child: GestureDetector(
//                         onTap: () {
//                           Get.find<PostingAddController>()
//                               .scrapList
//                               .removeWhere(
//                                   (element) => element.url == widget.url);
//                           if (Get.find<PostingAddController>()
//                               .scrapList
//                               .isEmpty) {
//                             Get.find<PostingAddController>().isAddLink(false);
//                           }
//                         },
//                         child: SvgPicture.asset(
//                           'assets/icons/link_delete_button.svg',
//                         ))),
//             ],
//           ),
//         );
//       }
//     }
//   }
// }

class LinkWidget extends StatelessWidget {
  LinkWidget({Key? key, required this.url, required this.widgetType})
      : super(key: key);

  String url;
  String widgetType;
  late final LinkController linkController = LinkController(url: url)
    ..infoLoad();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => linkController.loading.value
          ? ScrapCard(child: const LoadingWidget(), isimgae: false)
          : linkController.info.value.domain.endsWith('jpg') ||
                  linkController.info.value.domain.endsWith('png')
              ? ScrapCard(
                  isimgae: true,
                  domain: linkController.info.value.domain,
                )
              : GestureDetector(
                  onTap: () {
                    Get.to(() => WebViewScreen(url: url));
                  },
                  child: Stack(
                    children: [
                      ScrapCard(
                        child: Column(
                          children: [
                            if (url.contains("inu.ac.kr"))
                              Image.asset(
                                "assets/illustrations/inu_symbol_image.png",
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            else if (linkController.info.value.image != "")
                              CachedNetworkImage(
                                imageUrl: linkController.info.value.image,
                                height: 200,
                                width: Get.width,
                                fit: BoxFit.cover,
                                errorWidget: (context, string, widget) {
                                  return Image.asset(
                                    "assets/illustrations/link_noimage.png",
                                    height: 200,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            else
                              Image.asset(
                                "assets/illustrations/link_noimage.png",
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    linkController.info.value.domain,
                                    style: MyTextTheme.main(context)
                                        .copyWith(color: AppColors.maingray),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    linkController.info.value.title,
                                    style: MyTextTheme.mainbold(context),
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
                      if (widgetType == 'add')
                        Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                                onTap: () {
                                  Get.find<PostingAddController>()
                                      .scrapList
                                      .removeWhere(
                                          (element) => element.url == url);
                                  if (Get.find<PostingAddController>()
                                      .scrapList
                                      .isEmpty) {
                                    Get.find<PostingAddController>()
                                        .isAddLink(false);
                                  }
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/link_delete_button.svg',
                                ))),
                    ],
                  ),
                ),
    );
  }
}

class LinkSmallWidget extends StatelessWidget {
  LinkSmallWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  String url;
  double width = 280;
  double height = 190;
  late final LinkController linkController = LinkController(url: url)
    ..infoLoad();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => linkController.loading.value
          ? ScrapCard(
              child: const LoadingWidget(),
              isimgae: false,
              width: width,
              height: height,
            )
          : linkController.info.value.domain.endsWith('jpg') ||
                  linkController.info.value.domain.endsWith('png')
              ? ScrapCard(
                  isimgae: true,
                  domain: linkController.info.value.domain,
                  width: width,
                  height: height,
                )
              : GestureDetector(
                  onTap: () {
                    Get.to(() => WebViewScreen(url: url));
                  },
                  child: ScrapCard(
                    width: width,
                    height: height,
                    child: Column(
                      children: [
                        if (url.contains("inu.ac.kr"))
                          Image.asset(
                            "assets/illustrations/inu_symbol_image.png",
                            height: 120,
                            width: width,
                            fit: BoxFit.cover,
                          )
                        else if (linkController.info.value.image != "")
                          CachedNetworkImage(
                            imageUrl: linkController.info.value.image,
                            height: 120,
                            width: width,
                            fit: BoxFit.cover,
                            errorWidget: (context, string, widget) {
                              return Image.asset(
                                "assets/illustrations/link_noimage.png",
                                height: 120,
                                width: width,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        else
                          Image.asset(
                            "assets/illustrations/link_noimage.png",
                            height: 120,
                            width: width,
                            fit: BoxFit.cover,
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                linkController.info.value.domain,
                                style: MyTextTheme.main(context)
                                    .copyWith(color: AppColors.maingray),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                linkController.info.value.title,
                                style: MyTextTheme.mainbold(context),
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
                ),
    );
  }
}

class LinkController {
  LinkController({required this.url});
  Rx<WebInfo> info = WebInfo(
          description: "",
          domain: "",
          icon: "",
          image: "",
          title: "",
          type: LinkPreviewType.error,
          video: "")
      .obs;
  String url;
  RxBool loading = true.obs;

  void infoLoad() async {
    await CustomLinkPreview.scrapeFromURL(url).then((value) {
      info.value = value;
      loading(false);
    });
  }
}

class ScrapCard extends StatelessWidget {
  ScrapCard(
      {Key? key,
      this.child,
      required this.isimgae,
      this.domain,
      this.width,
      this.height})
      : super(key: key);

  Widget? child;
  bool isimgae;
  String? domain;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 270,
        width: width ?? Get.width,
        decoration: BoxDecoration(
          color: AppColors.cardGray,
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

class KeepAliveWidget extends StatefulWidget {
  KeepAliveWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }
}
