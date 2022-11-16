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
      required this.isDayChange,
      required this.isFirst,
      required this.partner,
      required this.myId})
      : super(key: key);
  // late MessageDetailController controller =
  //     Get.find(tag: user.userid.toString());
  RxBool isFirst;
  RxBool isDayChange;
  Chat message;
  User partner;
  int myId;
  // var image;
  // String content;
  // int isSender;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('isFirst $isFirst');
        print('isLast $isDayChange');
        print('isread ${message.isRead}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: message.sender == myId.toString()
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  changeDay(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(() => (message.sendsuccess != null)
                          ? message.sendsuccess!.value == 'true'
                              ? Container()
                              : const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Opacity(
                                    opacity: 0.6,
                                    child: Icon(
                                      Icons.reply_rounded,
                                      color: AppColors.mainblue,
                                      size: 20,
                                    ),
                                  ),
                                )
                          : const SizedBox.shrink()),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 0, 8.0, 0.0),
                        child: Text(
                          messageDurationCalculate(message.date),
                          style: MyTextTheme.mainheight(context).copyWith(
                            color: AppColors.maingray,
                          ),
                        ),
                      ),
                      hasTextOverflow(
                              message.content, MyTextTheme.mainheight(context))
                          ? Container(
                              constraints:
                                  BoxConstraints(maxWidth: Get.width * (3 / 5)),
                              decoration: BoxDecoration(
                                  color: AppColors.mainblue,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: Text(
                                    message.content,
                                    style: MyTextTheme.mainheight(context)
                                        .copyWith(color: AppColors.mainWhite),
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                            applyHeightToFirstAscent: true,
                                            applyHeightToLastDescent: true,
                                            leadingDistribution:
                                                TextLeadingDistribution.even),
                                  )),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: AppColors.mainblue,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: Text(
                                    message.content,
                                    style: MyTextTheme.mainheight(context)
                                        .copyWith(
                                      color: AppColors.mainWhite,
                                    ),
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                            applyHeightToFirstAscent: true,
                                            applyHeightToLastDescent: true,
                                            leadingDistribution:
                                                TextLeadingDistribution.even),
                                  )),
                            ),
                    ],
                  ),
                  Obx(() => isFirst.value
                      ? Column(children: [
                          const SizedBox(height: 8),
                          message.isRead!.value
                              ? Text(
                                  '읽음',
                                  textAlign: TextAlign.end,
                                  style: MyTextTheme.mainheight(context),
                                )
                              : const SizedBox.shrink()
                        ])
                      : const SizedBox.shrink())
                ],
              )
            : Column(
                children: [
                  changeDay(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.to(() => OtherProfileScreen(
                                  userid: partner.userId,
                                  realname: partner.name,
                                ));
                          },
                          child: UserImageWidget(
                            imageUrl: partner.profileImage,
                            width: 36,
                            height: 36,
                            userType: partner.userType,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            partner.name,
                            style: MyTextTheme.mainbold(context),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              hasTextOverflow(message.content,
                                      MyTextTheme.mainheight(context))
                                  ? Container(
                                      constraints: BoxConstraints(
                                          maxWidth: Get.width * (3 / 5)),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.cardGray,
                                          ),
                                          color: AppColors.cardGray,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          child: Text(
                                            message.content,
                                            style:
                                                MyTextTheme.mainheight(context),
                                            textHeightBehavior:
                                                const TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        true,
                                                    applyHeightToLastDescent:
                                                        true,
                                                    leadingDistribution:
                                                        TextLeadingDistribution
                                                            .even),
                                          )),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.cardGray,
                                          ),
                                          color: AppColors.cardGray,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          child: Text(
                                            message.content,
                                            style:
                                                MyTextTheme.mainheight(context),
                                            softWrap: true,
                                            textHeightBehavior:
                                                const TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        true,
                                                    applyHeightToLastDescent:
                                                        true,
                                                    leadingDistribution:
                                                        TextLeadingDistribution
                                                            .even),
                                          )),
                                    ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 18.0, 12.0, 0.0),
                                child: Text(
                                  messageDurationCalculate(message.date),
                                  style: MyTextTheme.mainheight(context)
                                      .copyWith(color: AppColors.maingray),
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

  Widget changeDay(BuildContext context) {
    if (isDayChange.value) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0, 7, 0, 14),
          child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Divider(
                      thickness: 0.5, color: AppColors.maingray, height: 0.5),
                ),
                const SizedBox(width: 14),
                Text(
                  '${message.date.year}.${message.date.month}.${message.date.day}',
                  style: MyTextTheme.main(context)
                      .copyWith(color: AppColors.maingray),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Divider(
                      thickness: 0.5, color: AppColors.maingray, height: 0.5),
                ),
              ]));
    } else {
      return const SizedBox.shrink();
    }
  }
}
