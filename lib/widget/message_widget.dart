import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget({required this.message, required this.user});
  late MessageDetailController controller =
      Get.find(tag: user.userid.toString());

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
      child: message.issender == 1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => (message.issending.value)
                    ? Container(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 12.0, 8.0, 12.0),
                        width: 20,
                        height: 20,
                        child: Opacity(
                          opacity: 0.6,
                          child: Icon(
                            Icons.reply_rounded,
                            color: mainblack,
                            size: 20,
                          ),
                        ),
                      )
                    : Container()),
                SizedBox(
                  width: 2,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 18.0, 8.0, 0.0),
                  child: Text(
                    "${DurationCaculator().messagedurationCaculate(startDate: message.date, endDate: DateTime.now())} 전",
                    style: kCaptionStyle.copyWith(
                        color: mainblack.withOpacity(0.6)),
                  ),
                ),
                controller.hasTextOverflow(message.message, kBody2Style)
                    ? Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: mainblack.withOpacity(0.6)),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${message.message}",
                                style: kBody2Style,
                              )),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: mainblack.withOpacity(0.6)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${message.message}",
                              style: kBody2Style,
                            )),
                      ),
              ],
            )
          : Row(
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
                              backgroundColor: Color(0xffe7e7e7),
                              child: Container(),
                            ),
                            fit: BoxFit.cover,
                          )),
                SizedBox(
                  width: 10,
                ),
                controller.hasTextOverflow(message.message, kBody2Style)
                    ? Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: mainblack.withOpacity(0.6)),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${message.message}",
                                style: kBody2Style,
                              )),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: mainblack.withOpacity(0.6)),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${message.message}",
                              style: kBody2Style,
                            )),
                      ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 18.0, 12.0, 0.0),
                  child: Text(
                    "${DurationCaculator().messagedurationCaculate(startDate: message.date, endDate: DateTime.now())} 전",
                    style: kCaptionStyle.copyWith(
                        color: mainblack.withOpacity(0.6)),
                  ),
                )
              ],
            ),
    );
  }
}
