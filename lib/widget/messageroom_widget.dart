import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/hover_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/widget/message_widget.dart';

class MessageRoomWidget extends StatelessWidget {
  MessageRoomWidget({
    Key? key,
    required this.messageRoom,
  }) : super(key: key);

  late final MessageDetailController controller = Get.put(
      MessageDetailController(userid: messageRoom.user.userid),
      tag: messageRoom.user.userid.toString());
  MessageRoom messageRoom;
  late final HoverController _hoverController =
      Get.put(HoverController(), tag: messageRoom.user.userid.toString());

  @override
  Widget build(BuildContext context) {
    // print(messageRoom.message.date);
    controller.messagelist.add(MessageWidget(
      message: messageRoom.message,
      user: messageRoom.user,
    ));
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (details) => _hoverController.isHover(true),
      onTapCancel: () => _hoverController.isHover(false),
      onTapUp: (details) => _hoverController.isHover(false),
      onTap: () async {
        messageRoom.notread(0);
        controller.messageroomrefresh();
        Get.to(() => MessageDetailScreen(
            userid: messageRoom.user.userid,
            realname: messageRoom.user.realName));
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            ClipOval(
              child: messageRoom.user.profileImage != null
                  ? Obx(
                      () => Opacity(
                        opacity: _hoverController.isHover.value ? 0.6 : 1,
                        child: CachedNetworkImage(
                          width: 60,
                          height: 60,
                          imageUrl: messageRoom.user.profileImage!
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
                          '${messageRoom.user.realName}' +
                              ' · ${DurationCaculator().messagedurationCaculate(startDate: controller.messagelist.last.message.date, endDate: DateTime.now())}',
                          style: messageRoom.notread.value == 0
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
                      Obx(() => messageRoom.notread.value == 0
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
                                  messageRoom.notread.value.toString(),
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
                            controller.messagelist.last.message.message
                                    .contains('\n')
                                ? controller.messagelist.last.message.message
                                        .split('\n')
                                        .first +
                                    '...'
                                : controller.messagelist.last.message.message,
                            overflow: TextOverflow.ellipsis,
                            style: messageRoom.notread.value == 0
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
