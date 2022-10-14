import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:link_preview_generator/link_preview_generator.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/screen/webview_screen.dart';
import 'package:loopus/widget/Link_widget.dart';

class ProfileUrlWidget extends StatelessWidget {
  ProfileUrlWidget({
    Key? key,
    required this.url,
  }) : super(key: key);

  String url;
  late final LinkController linkController = LinkController(url: url)
    ..infoLoad();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      child: GestureDetector(
        onTap: () {
          Get.to(() => WebViewScreen(url: url));
        },
        child: ClipOval(
          child: Obx(() => linkController.loading.value == false &&
                  linkController.info.value.icon != ""
              ? CachedNetworkImage(
                  imageUrl: linkController.info.value.icon,
                )
              : Container(
                  color: maingray,
                )),
        ),
      ),
    );
  }
}
