import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/duration_calculate.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget({required this.message, required this.user});
  MessageController messageController = Get.find();

  Message message;
  User user;
  // var image;
  // String content;
  // int isSender;

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
              child: user.profileImage == null
                  ? Image.asset(
                      "assets/illustrations/default_profile.png",
                      height: 32,
                      width: 32,
                    )
                  : CachedNetworkImage(
                      height: 32,
                      width: 32,
                      imageUrl: user.profileImage!,
                      placeholder: (context, url) => CircleAvatar(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      fit: BoxFit.cover,
                    )),
          SizedBox(
            width: 10,
          ),
          messageController.hasTextOverflow(message.message, kBody2Style)
              ? Container(
                  width: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: mainblack.withOpacity(0.6)),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${message.message}",
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
                        "${message.message}",
                        style: kBody2Style,
                      )),
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 18.0, 8.0, 12.0),
            child: Text(
              "${DurationCaculator().durationCaculate(startDate: message.date, endDate: DateTime.now())} 전",
              style: kCaptionStyle.copyWith(color: mainblack.withOpacity(0.6)),
            ),
          )
        ],
      ),
    );
  }
}
