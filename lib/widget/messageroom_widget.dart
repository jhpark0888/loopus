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
    return ListTile(
      onTap: () async {
        controller.messageroomrefresh();
        Get.to(() => MessageDetailScreen(
              user: messageRoom.user,
            ));
      },
      leading: ClipOval(
        child: messageRoom.user.profileImage != null
            ? CachedNetworkImage(
                width: 56,
                height: 56,
                imageUrl:
                    messageRoom.user.profileImage!.replaceAll('https', 'http'),
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
                width: 56,
                height: 56,
              ),
      ),
      title: Text(
        messageRoom.user.realName,
        style: kSubTitle2Style,
      ),
      subtitle: Obx(
        () => Row(
          children: [
            SizedBox(
              width: 200,
              child: Text(
                controller.messagelist.first.message.message,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: mainblack.withOpacity(0.6),
                  fontFamily: 'Nanum',
                ),
              ),
            ),
            Text(
                ' · ${DurationCaculator().messagedurationCaculate(startDate: controller.messagelist.first.message.date, endDate: DateTime.now())} 전')
          ],
        ),
      ),
    );
  }
}
