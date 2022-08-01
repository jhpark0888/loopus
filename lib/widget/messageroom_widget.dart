import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/screen/before_message_detail_screen.dart';
import 'package:loopus/widget/overflow_text_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class MessageRoomWidget extends StatelessWidget {
  MessageRoomWidget(
      {Key? key,
      required this.chatRoom,
      required this.user})
      : super(key: key);

  Rx<ChatRoom> chatRoom;
  Rx<User> user;

  @override
  Widget build(BuildContext context) {
    return
        GestureDetector(
      onTap: () async {
        await getPartnerToken(user.value.userid).then((value) {
          chatRoom.value.notread.value = 0;
          if (MessageController.to.chattingRoomList
              .where((messageroomwidget) =>
                  messageroomwidget.chatRoom.value.notread.value != 0)
              .isNotEmpty) {
            HomeController.to.isNewMsg(true);
          } else {
            HomeController.to.isNewMsg(false);
          }
          if (value.isError == false) {
            Get.to(() => MessageDetatilScreen(
                  partner: user.value,
                  partnerToken: value.data,
                  myProfile: HomeController.to.myProfile.value,
                  enterRoute: EnterRoute.messageScreen,
                ));
          }
        });
        SQLController.to.updateNotReadCount(chatRoom.value.roomId, 0);

        HomeController.to.enterMessageRoom.value = user.value.userid;
      },
      child: Container(
        width: Get.width,
        color: mainWhite,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            UserImageWidget(
                imageUrl: user.value.profileImage ?? '', width: 36, height: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(user.value.realName, style: k16semiBold),
                  const SizedBox(height: 7),
                  Obx(
                    () => Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        hasTextOverflow(
                                chatRoom.value.message.value.content, k16Normal,
                                maxWidth: Get.width - 190)
                            ? SizedBox(
                                width: Get.width - 190,
                                child: Text(
                                  chatRoom.value.message.value.content,
                                  style: chatRoom.value.notread.value == 0
                                      ? k16Normal.copyWith(color: maingray)
                                      : k16Normal.copyWith(
                                          fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ))
                            : Text(
                                chatRoom.value.message.value.content,
                                style: chatRoom.value.notread.value == 0
                                    ? k16Normal.copyWith(color: maingray)
                                    : k16Normal.copyWith(
                                        fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                        Text(
                            '· ${messagedurationCaculate(endDate: DateTime.now(), startDate: chatRoom.value.message.value.date)}',
                            style: k16Normal.copyWith(color: maingray)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (chatRoom.value.notread.value == 0) {
                return const SizedBox.shrink();
              } else {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36), color: mainblue),
                  width: 7,
                  height: 7,
                );
              }
            })
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
}
