import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';

class MessageWidget extends StatelessWidget {
  MessageController messageController = Get.find();
  var image;
  String content;
  int isSender;
  MessageWidget(
      {required this.image, required this.content, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
              child: image == null
                  ? Image.asset(
                      "assets/illustrations/default_profile.png",
                      height: 32,
                      width: 32,
                    )
                  : CachedNetworkImage(
                      height: 32,
                      width: 32,
                      imageUrl: image,
                      placeholder: (context, url) => CircleAvatar(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      fit: BoxFit.cover,
                    )),
          SizedBox(
            width: 10,
          ),
          messageController.hasTextOverflow(content, kBody2Style)
              ? Container(
                  width: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: mainblack.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$content",
                        style: kBody2Style,
                      )),
                )
              : Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: mainblack.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$content",
                        style: kBody2Style,
                      )),
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 18.0, 8.0, 12.0),
            child: Text(
              "1분전",
              style: kCaptionStyle.copyWith(color: mainblack.withOpacity(0.6)),
            ),
          )
        ],
      ),
    );
  }
}
