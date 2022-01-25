import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/utils/duration_calculate.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/widget/message_widget.dart';

class MessageRoomWidget extends StatelessWidget {
  MessageRoomWidget({Key? key, required this.messageRoom}) : super(key: key);

  late MessageDetailController controller = Get.put(
      MessageDetailController(messageRoom.user),
      tag: messageRoom.user.userid.toString());
  MessageRoom messageRoom;

  @override
  Widget build(BuildContext context) {
    controller.messagelist.add(MessageWidget(
      message: messageRoom.message,
      user: messageRoom.user,
    ));
    return GestureDetector(
      onTap: () async {
        controller.messageroomrefresh();
        Get.to(() => MessageDetailScreen(
              user: messageRoom.user,
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
              child: messageRoom.user.profileImage != null
                  ? CachedNetworkImage(
                      width: 60,
                      height: 60,
                      imageUrl: messageRoom.user.profileImage!
                          .replaceAll('https', 'http'),
                      placeholder: (context, url) => CircleAvatar(
                        backgroundColor: const Color(0xffe7e7e7),
                        child: Container(),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: const Color(0xffe7e7e7),
                        child: Container(),
                      ),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/illustrations/default_profile.png",
                      width: 60,
                      height: 60,
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
                  Text(
                    '${messageRoom.user.realName}' +
                        ' · ${DurationCaculator().messagedurationCaculate(startDate: messageRoom.message.date, endDate: DateTime.now())} 전',
                    style: kSubTitle2Style,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          messageRoom.message.message,
                          overflow: TextOverflow.ellipsis,
                          style: kSubTitle3Style,
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
