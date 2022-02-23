import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/widget/message_widget.dart';

class MessageRoomWidget extends StatelessWidget {
  MessageRoomWidget({
    Key? key,
    required this.messageRoom,
  }) : super(key: key);

  // late final MessageDetailController controller = Get.put(
  //     MessageDetailController(userid: messageRoom.user.userid),
  //     tag: messageRoom.user.userid.toString());
  Rx<MessageRoom> messageRoom;
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: messageRoom.value.user.userid.toString());

  @override
  Widget build(BuildContext context) {
    // print(messageRoom.message.date);
    // controller.messagelist.add(MessageWidget(
    //   message: messageRoom.message,
    //   user: messageRoom.user,
    // ));
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) => _hoverController.isHover(true),
      onTapCancel: () => _hoverController.isHover(false),
      onTapUp: (details) => _hoverController.isHover(false),
      onTap: () async {
        messageRoom.value.notread(0);
        if (MessageController.to.chattingroomlist
            .where((messageroomwidget) =>
                messageroomwidget.messageRoom.value.notread.value != 0)
            .isNotEmpty) {
          ProfileController.to.isnewmessage(true);
        } else {
          ProfileController.to.isnewmessage(false);
        }
        // controller.firstmessagesload();
        // messageRoom.value.message.value =
        //     await
        Get.to(() => MessageDetailScreen(
              userid: messageRoom.value.user.userid,
              realname: messageRoom.value.user.realName,
              user: messageRoom.value.user,
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            ClipOval(
              child: messageRoom.value.user.profileImage != null
                  ? Obx(
                      () => Opacity(
                        opacity: _hoverController.isHover.value ? 0.6 : 1,
                        child: CachedNetworkImage(
                          width: 60,
                          height: 60,
                          imageUrl: messageRoom.value.user.profileImage!
                              .replaceAll('https', 'http'),
                          placeholder: (context, url) => kProfilePlaceHolder(),
                          errorWidget: (context, url, error) =>
                              kProfilePlaceHolder(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Obx(
                      () => Opacity(
                        opacity: _hoverController.isHover.value ? 0.6 : 1,
                        child: Image.asset(
                          "assets/illustrations/default_profile.png",
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          '${messageRoom.value.user.realName}' +
                              ' · ${DurationCaculator().messagedurationCaculate(startDate: messageRoom.value.message.value.date, endDate: DateTime.now())}',
                          style: messageRoom.value.notread.value == 0
                              ? kSubTitle3Style.copyWith(
                                  color: _hoverController.isHover.value
                                      ? mainblack.withOpacity(0.6)
                                      : mainblack)
                              : kSubTitle2Style.copyWith(
                                  color: _hoverController.isHover.value
                                      ? mainblack.withOpacity(0.6)
                                      : mainblack),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Obx(() => messageRoom.value.notread.value == 0
                          ? Container()
                          : Container(
                              height: 18,
                              width: 18,
                              decoration: BoxDecoration(
                                  color: mainblue.withOpacity(
                                      _hoverController.isHover.value ? 0.6 : 1),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  messageRoom.value.notread.value.toString(),
                                  style: kButtonStyle.copyWith(
                                      color: mainWhite, height: 1.1),
                                ),
                              ),
                            )),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            messageRoom.value.message.value.message
                                    .contains('\n')
                                ? messageRoom.value.message.value.message
                                        .split('\n')
                                        .first +
                                    '...'
                                : messageRoom.value.message.value.message,
                            overflow: TextOverflow.ellipsis,
                            style: messageRoom.value.notread.value == 0
                                ? kSubTitle3Style.copyWith(
                                    color: _hoverController.isHover.value
                                        ? mainblack.withOpacity(0.38)
                                        : mainblack.withOpacity(0.6))
                                : kSubTitle3Style.copyWith(
                                    color: _hoverController.isHover.value
                                        ? mainblack.withOpacity(0.6)
                                        : mainblack),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
