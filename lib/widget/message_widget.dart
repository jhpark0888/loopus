import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/user_image_widget.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget({Key? key,required this.message, required this.isLast, required this.partner, required this.myId}):super(key: key);
  // late MessageDetailController controller =
  //     Get.find(tag: user.userid.toString());
  RxBool isLast;
  Chat message;
  User partner;
  int myId;
  // var image;
  // String content;
  // int isSender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      child: message.sender == myId
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Obx(() => (message.issending.value)
                    //     ? Container(
                    //         padding:
                    //             const EdgeInsets.fromLTRB(12.0, 12.0, 8.0, 12.0),
                    //         width: 20,
                    //         height: 20,
                    //         child: Opacity(
                    //           opacity: 0.6,
                    //           child: Icon(
                    //             Icons.reply_rounded,
                    //             color: mainblack,
                    //             size: 20,
                    //           ),
                    //         ),
                    //       )
                    //     : Container()),
                    // SizedBox(
                    //   width: 2,
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 18.0, 8.0, 0.0),
                      child: Text(
                        "${messagedurationCaculate(startDate: message.date, endDate: DateTime.now())}",
                        style: kCaptionStyle.copyWith(
                          color: mainblack,
                        ),
                      ),
                    ),
                    hasTextOverflow(message.content, kBody2Style)
                        ? Container(
                            constraints:
                                BoxConstraints(maxWidth: Get.width * (2 / 3)),
                            decoration: BoxDecoration(
                                color: mainblue,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  message.content,
                                  style: kSubTitle3Style.copyWith(
                                      height: 1.5, color: mainWhite),
                                )),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: mainblue,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  message.content,
                                  style: kSubTitle3Style.copyWith(
                                      height: 1.5, color: mainWhite),
                                )),
                          ),
                  ],
                ),
                Obx( () => isLast.value ? 
                Column(children: [
                  const SizedBox(height: 14),
                  message.isRead!.value
                          ? const Text('읽음', textAlign: TextAlign.end, style: kCaptionStyle,)
                          : const SizedBox.shrink()
                ]) : const SizedBox.shrink())
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => OtherProfileScreen(
                          userid: partner.userid,
                          realname: partner.realName,
                        ));
                  },
                  child: UserImageWidget(imageUrl: partner.profileImage ?? '', width: 36, height: 36)
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      partner.realName,
                      style: k16semiBold,
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        hasTextOverflow(message.content, kBody2Style)
                            ? Container(
                                constraints: BoxConstraints(
                                    maxWidth: Get.width * (3 / 5)),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: cardGray,
                                    ),
                                    color: cardGray,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      message.content,
                                      style: kBody2Style,
                                    )),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: cardGray,
                                    ),
                                    color: cardGray,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      message.content,
                                      style: kBody2Style,
                                      softWrap: true,
                                    )),
                              ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 18.0, 12.0, 0.0),
                          child: Text(
                            messagedurationCaculate(
                                startDate: message.date,
                                endDate: DateTime.now()),
                            style: kCaptionStyle.copyWith(color: mainblack),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  bool hasTextOverflow(String text, TextStyle style,
      {double minWidth = 0, double maxWidth = 10, int maxLines = 1}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: minWidth, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }
}
