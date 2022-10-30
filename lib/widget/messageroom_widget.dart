import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/app_controller.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/screen/before_message_detail_screen.dart';
import 'package:loopus/widget/user_image_widget.dart';

class MessageRoomWidget extends StatelessWidget {
  MessageRoomWidget({Key? key, required this.chatRoom, required this.user})
      : super(key: key);

  Rx<ChatRoom> chatRoom;
  Rx<Person> user;
  MessageController messageController = Get.find<MessageController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        chatRoom.value.notread.value = 0;
        if (MessageController.to.chattingRoomList
            .where((messageroomwidget) =>
                messageroomwidget.chatRoom.value.notread.value != 0)
            .isNotEmpty) {
          HomeController.to.isNewMsg(true);
        } else {
          HomeController.to.isNewMsg(false);
        }

        Get.to(() => MessageDetatilScreen(
              partner: user.value,
              myProfile: HomeController.to.myProfile.value,
              enterRoute: EnterRoute.messageScreen,
            ));

        SQLController.to.updateNotReadCount(chatRoom.value.roomId, 0);

        HomeController.to.enterMessageRoom.value = user.value.userId;
      },
      child: Obx(
        () => Slidable(
          key: ValueKey(chatRoom.value.roomId.toString()),
          closeOnScroll: true,
          groupTag: '1',
          endActionPane: ActionPane(extentRatio: 0.2,motion: const ScrollMotion(), children: [
            // SlidableAction(
            //   // An action can be bigger than the others.
            //   onPressed: (context) {
            //     showButtonDialog(
            //         title: chatRoom.value.type.value == 1 ? '알림해제' : '알림켜기',
            //         startContent: chatRoom.value.type.value == 1
            //             ? '해제를 하면 해당 유저로부터 알림을 받을 수 없습니다.'
            //             : '켜기를 하면 해당 유저로부터 알림을 받을 수 있습니다.',
            //         leftFunction: () {
            //           Get.back();
            //         },
            //         rightFunction: () async {
            //           await roomAlarmStatus(
            //                   HomeController.to.myProfile.value.userId,
            //                   chatRoom.value.roomId,
            //                   chatRoom.value.type.value)
            //               .then((value) {
            //             if (value.isError == false) {
            //               SQLController.to
            //                   .updateRoomAlarmActive(chatRoom.value.type.value,
            //                       chatRoom.value.roomId)
            //                   .then((type) => chatRoom.value.type.value = type);
            //             }
            //           });
            //           Get.back();
            //         },
            //         rightText: chatRoom.value.type.value == 1 ? '해제' : "켜기",
            //         leftText: '취소');
            //   },
            //   backgroundColor: maingray,
            //   foregroundColor: Colors.white,
            //   label: chatRoom.value.type.value == 1 ? '알림끄기' : '알림켜기',
            // ),
            SlidableAction(
              onPressed: (context) {
                showButtonDialog(
                    title: '채팅방 나가기',
                    startContent: '나가기를 하면 메세지가 모두 삭제되고\n 메세지 목록에서도 삭제됩니다.',
                    leftText: '취소',
                    leftFunction: () {
                      Get.back();
                    },
                    rightText: '나가기',
                    rightFunction: () async {
                      await SQLController.to
                          .getLastmessageId(chatRoom.value.roomId)
                          .then((msgId) => deleteChatRoom(
                                      chatRoom.value.roomId,
                                      HomeController.to.myProfile.value.userId,
                                      msgId)
                                  .then((value) {
                                if (value.isError == false) {
                                  SQLController.to
                                      .deleteMessage(chatRoom.value.roomId);
                                  SQLController.to
                                      .deleteMessageRoom(chatRoom.value.roomId);
                                  SQLController.to
                                      .deleteUser(user.value.userId);

                                  messageController.searchRoomList.removeAt(
                                      messageController.searchRoomList
                                          .indexWhere((messageRoom) =>
                                              messageRoom
                                                  .chatRoom.value.roomId ==
                                              chatRoom.value.roomId));
                                  messageController.chattingRoomList.removeAt(
                                      messageController.chattingRoomList
                                          .indexWhere((messageRoom) =>
                                              messageRoom
                                                  .chatRoom.value.roomId ==
                                              chatRoom.value.roomId));
                                }
                              }));
                      Get.back();
                    });
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: '나가기',
            ),
          ]),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: Get.width,
            color: mainWhite,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                UserImageWidget(
                  imageUrl: user.value.profileImage,
                  width: 36,
                  height: 36,
                  userType: user.value.userType,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(user.value.name, style: kmainbold),
                      const SizedBox(height: 7),
                      Obx(
                        () => Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            hasTextOverflow(
                                    chatRoom.value.message.value.content, kmain,
                                    maxWidth: Get.width - 190)
                                ? SizedBox(
                                    width: Get.width - 190,
                                    child: Text(
                                      chatRoom.value.message.value.content,
                                      style: chatRoom.value.notread.value == 0
                                          ? kmain.copyWith(color: maingray)
                                          : kmain.copyWith(
                                              fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ))
                                : Text(
                                    chatRoom.value.message.value.content,
                                    style: chatRoom.value.notread.value == 0
                                        ? kmain.copyWith(color: maingray)
                                        : kmain.copyWith(
                                            fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                            Text(
                                '· ${messageRoomDurationCalculate(endDate: DateTime.now(), startDate: chatRoom.value.message.value.date)}',
                                style: kmain.copyWith(color: maingray)),
                            const SizedBox(width: 7),
                            chatRoom.value.type.value == 0
                                ? const Icon(
                                    Icons.alarm_off_rounded,
                                    size: 16,
                                  )
                                : const SizedBox.shrink()
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
                          borderRadius: BorderRadius.circular(36),
                          color: mainblue),
                      width: 7,
                      height: 7,
                    );
                  }
                })
              ],
            ),
          ),
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
