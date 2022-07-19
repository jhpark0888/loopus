import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/websocet_screen.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/widget/overflow_text_widget.dart';
import 'package:loopus/widget/user_image_widget.dart';

class MessageRoomWidget extends StatelessWidget {
  MessageRoomWidget({
    Key? key,
    required this.chatRoom,
    required this.userid
  }) : super(key: key);

  // late final MessageDetailController controller = Get.put(
  //     MessageDetailController(userid: messageRoom.user.userid),
  //     tag: messageRoom.user.userid.toString());
  Rx<ChatRoom> chatRoom;
  int userid;
  // late final HoverController _hoverController =
  //     Get.put(HoverController(), tag: messageRoom.value.user.userid.toString());

  @override
  Widget build(BuildContext context) {
    // print(messageRoom.message.date);
    // controller.messagelist.add(MessageWidget(
    //   message: messageRoom.message,
    //   user: messageRoom.user,
    // ));
    return
        //  GestureDetector(
        // behavior: HitTestBehavior.translucent,
        // onTapDown: (details) => _hoverController.isHover(true),
        // onTapCancel: () => _hoverController.isHover(false),
        // onTapUp: (details) => _hoverController.isHover(false),
        // onTap: () async {
        //   messageRoom.value.notread(0);
        //   if (MessageController.to.chattingroomlist
        //       .where((messageroomwidget) =>
        //           messageroomwidget.messageRoom.value.notread.value != 0)
        //       .isNotEmpty) {
        //     ProfileController.to.isnewmessage(true);
        //   } else {
        //     ProfileController.to.isnewmessage(false);
        //   }
        //   // controller.firstmessagesload();
        //   // messageRoom.value.message.value =
        //   //     await
        //   Get.to(() => MessageDetailScreen(
        //         userid: messageRoom.value.user.userid,
        //         realname: messageRoom.value.user.realName,
        //         user: messageRoom.value.user,
        //       ));
        // },
        // child:
        //   Container(
        //     padding: EdgeInsets.symmetric(
        //       horizontal: 16,
        //       vertical: 12,
        //     ),
        //     child: Row(
        //       children: [
        //         ClipOval(
        //           child: messageRoom.value.user.profileImage != null
        //               ? Obx(
        //                   () => Opacity(
        //                     opacity: _hoverController.isHover.value ? 0.6 : 1,
        //                     child: CachedNetworkImage(
        //                       width: 60,
        //                       height: 60,
        //                       imageUrl: messageRoom.value.user.profileImage!
        //                           .replaceAll('https', 'http'),
        //                       placeholder: (context, url) => kProfilePlaceHolder(),
        //                       errorWidget: (context, url, error) =>
        //                           kProfilePlaceHolder(),
        //                       fit: BoxFit.cover,
        //                     ),
        //                   ),
        //                 )
        //               : Obx(
        //                   () => Opacity(
        //                     opacity: _hoverController.isHover.value ? 0.6 : 1,
        //                     child: Image.asset(
        //                       "assets/illustrations/default_profile.png",
        //                       width: 60,
        //                       height: 60,
        //                     ),
        //                   ),
        //                 ),
        //         ),
        //         const SizedBox(
        //           width: 12,
        //         ),
        //         Expanded(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.stretch,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Row(
        //                 children: [
        //                   Obx(
        //                     () => Text(
        //                       // '${messageRoom.value.user.realName}' +
        //                           ' · ${messagedurationCaculate(startDate: messageRoom.value.message.value.date, endDate: DateTime.now())}',
        //                       style: messageRoom.value.notread.value == 0
        //                           ? kSubTitle3Style.copyWith(
        //                               color: _hoverController.isHover.value
        //                                   ? mainblack.withOpacity(0.6)
        //                                   : mainblack)
        //                           : kSubTitle2Style.copyWith(
        //                               color: _hoverController.isHover.value
        //                                   ? mainblack.withOpacity(0.6)
        //                                   : mainblack),
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     width: 8,
        //                   ),
        //                   Obx(() => messageRoom.value.notread.value == 0
        //                       ? Container()
        //                       : Container(
        //                           height: 18,
        //                           width: 18,
        //                           decoration: BoxDecoration(
        //                               color: mainblue.withOpacity(
        //                                   _hoverController.isHover.value ? 0.6 : 1),
        //                               shape: BoxShape.circle),
        //                           child: Center(
        //                             child: Text(
        //                               messageRoom.value.notread.value.toString(),
        //                               style: kButtonStyle.copyWith(
        //                                   color: mainWhite, height: 1.1),
        //                             ),
        //                           ),
        //                         )),
        //                 ],
        //               ),
        //               SizedBox(
        //                 height: 8,
        //               ),
        //               Row(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   Expanded(
        //                     child: Obx(
        //                       () => Text(
        //                         messageRoom.value.message.value.message
        //                                 .contains('\n')
        //                             ? messageRoom.value.message.value.message
        //                                     .split('\n')
        //                                     .first +
        //                                 '...'
        //                             : messageRoom.value.message.value.message,
        //                         overflow: TextOverflow.ellipsis,
        //                         style: messageRoom.value.notread.value == 0
        //                             ? kSubTitle3Style.copyWith(
        //                                 color: _hoverController.isHover.value
        //                                     ? mainblack.withOpacity(0.38)
        //                                     : mainblack.withOpacity(0.6))
        //                             : kSubTitle3Style.copyWith(
        //                                 color: _hoverController.isHover.value
        //                                     ? mainblack.withOpacity(0.6)
        //                                     : mainblack),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
        GestureDetector(
      onTap: () {
        print(chatRoom.value.user);
        print(userid);
        Get.to(() => WebsoketScreen(
              partnerId: chatRoom.value.user,
            ));
      },
      child: Container(
        width: Get.width,
        color: mainWhite,
        child: Row(
          children: [
            UserImageWidget(
                imageUrl:
                    'https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202203/23/d58e7390-afda-42cd-9374-ca327df1cad8.jpg',
                width: 36,
                height: 36),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('한근형', style: k16semiBold),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    hasTextOverflow(
                            chatRoom.value.message.value.content, k16Normal,
                            maxWidth: Get.width - 165)
                        ? SizedBox(
                            width: Get.width - 165,
                            child: Text(
                              chatRoom.value.message.value.content,
                              style: k16Normal,
                              overflow: TextOverflow.ellipsis,
                            ))
                        : Text(
                            chatRoom.value.message.value.content,
                            style: k16Normal,
                            overflow: TextOverflow.ellipsis,
                          ),
                    Text(
                        '· ${messagedurationCaculate(endDate: DateTime.now(), startDate: chatRoom.value.message.value.date)}',
                        style: k16Normal.copyWith(color: maingray)),
                  ],
                ),
                // RichText(
                //     text: TextSpan(children: [
                //   TextSpan(
                //       text: chatRoom.value.message.value.content, style: k16Normal),
                //   TextSpan(
                //       text:
                //           '· ${messagedurationCaculate(endDate: DateTime.now(), startDate: chatRoom.value.message.value.date)}',
                //       style: k16Normal.copyWith(color: maingray))
                // ]), maxLines: 1)
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
}
