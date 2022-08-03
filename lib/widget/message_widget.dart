import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/before_message_detail_controller.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/screen/other_profile_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/user_image_widget.dart';

class MessageWidget extends StatelessWidget {
  MessageWidget(
      {Key? key,
      required this.message,
      required this.isLast,
      required this.isFirst,
      required this.partner,
      required this.myId})
      : super(key: key);
  // late MessageDetailController controller =
  //     Get.find(tag: user.userid.toString());
  RxBool isFirst;
  RxBool isLast;
  Chat message;
  User partner;
  int myId;
  // var image;
  // String content;
  // int isSender;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){print('islast $isFirst');
            print('isFirst $isLast');},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 7,
        ),
        child: message.sender == myId.toString()
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  changeDay(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(() => (message.sendsuccess != null)
                          ? message.sendsuccess!.value
                              ? Container()
                              : const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Opacity(
                                    opacity: 0.6,
                                    child: Icon(
                                      Icons.reply_rounded,
                                      color: mainblue,
                                      size: 20,
                                    ),
                                  ),
                                )
                          : const SizedBox.shrink()),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 0, 8.0, 0.0),
                        child: Text(
                          messagedurationCaculate(startDate: message.date, endDate: DateTime.now()),
                          style: kCaptionStyle.copyWith(
                            color: mainblack,
                          ),
                        ),
                      ),
                      hasTextOverflow(message.content, kBody2Style)
                          ? Container(
                              constraints:
                                  BoxConstraints(maxWidth: Get.width * (3 / 5)),
                              decoration: BoxDecoration(
                                  color: mainblue,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 7, 14, 7),
                                  child: Text(
                                    message.content,
                                    style: kSubTitle3Style.copyWith(
                                        height: 1.5, color: mainWhite),
                                    textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: true,
                                      applyHeightToLastDescent: true,
                                      leadingDistribution: TextLeadingDistribution.even
                                    ),
                                  )),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: mainblue,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 7, 14, 7),
                                  child: Text(
                                    message.content,
                                    style: kSubTitle3Style.copyWith(
                                      height: 1.5,
                                      color: mainWhite,
                                    ),
                                    textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: true,
                                      applyHeightToLastDescent: true,
                                      leadingDistribution: TextLeadingDistribution.even
                                    ),
                                  )),
                            ),
                    ],
                  ),
                  Obx(() => isFirst.value
                      ? Column(children: [
                          const SizedBox(height: 7),
                          message.isRead!.value
                              ? const Text(
                                  '읽음',
                                  textAlign: TextAlign.end,
                                  style: kCaptionStyle,
                                )
                              : const SizedBox.shrink()
                        ])
                      : const SizedBox.shrink())
                ],
              )
            : Column(
                children: [
                  changeDay(),
                  Row(
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
                          child: UserImageWidget(
                              imageUrl: partner.profileImage ?? '',
                              width: 36,
                              height: 36)),
                      const SizedBox(
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
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              14, 7, 14, 7),
                                          child: Text(
                                            message.content,
                                            style: kBody2Style,
                                            textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: true,
                                      applyHeightToLastDescent: true,
                                      leadingDistribution: TextLeadingDistribution.even
                                    ),
                                          )),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: cardGray,
                                          ),
                                          color: cardGray,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              14, 7, 14, 7),
                                          child: Text(
                                            message.content,
                                            style: kBody2Style,
                                            softWrap: true,
                                            textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: true,
                                      applyHeightToLastDescent: true,
                                      leadingDistribution: TextLeadingDistribution.even
                                    ),
                                          )),
                                    ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 18.0, 12.0, 0.0),
                                child: Text(
                                  messagedurationCaculate(startDate: message.date, endDate: DateTime.now()),
                                  style: kCaptionStyle.copyWith(color: mainblack),
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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

  Widget changeDay() {
    if (isLast.value) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(20, 7, 20, 14),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Divider(thickness: 0.5, color: maingray, height: 0.5),
                ),
                const SizedBox(width: 14),
                Text(
                  '${message.date.year}.${message.date.month}.${message.date.day}',
                  style: k16Normal.copyWith(color: maingray),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Divider(thickness: 0.5, color: maingray, height: 0.5),
                ),
              ]));
    } else {
      return const SizedBox.shrink();
    }
  }
}
