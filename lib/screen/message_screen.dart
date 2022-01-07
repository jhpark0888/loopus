import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';

class MessageScreen extends StatelessWidget {
  MessageController messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: '메시지',
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ListTile(
              onTap: () async {
                messageController.messagelist.clear();
                await messageController.messageload(24);
                Get.to(() => MessageDetailScreen());
              },
              leading: ClipOval(
                child: Image.asset("assets/illustrations/default_profile.png"),
              ),
              title: Text(
                '손승태',
                style: kSubTitle2Style,
              ),
              subtitle: Text(
                '산업경영공학과',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: mainblack.withOpacity(0.6),
                  fontFamily: 'Nanum',
                ),
              ),
            ),
            ListTile(
              onTap: () async {},
              leading: ClipOval(
                child: Image.asset("assets/illustrations/default_profile.png"),
              ),
              title: Text(
                '손승태',
                style: kSubTitle2Style,
              ),
              subtitle: Text(
                '산업경영공학과',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: mainblack.withOpacity(0.6),
                  fontFamily: 'Nanum',
                ),
              ),
            ),
            ListTile(
              onTap: () async {},
              leading: ClipOval(
                child: Image.asset("assets/illustrations/default_profile.png"),
              ),
              title: Text(
                '손승태',
                style: kSubTitle2Style,
              ),
              subtitle: Text(
                '산업경영공학과',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: mainblack.withOpacity(0.6),
                  fontFamily: 'Nanum',
                ),
              ),
            ),
            ListTile(
              onTap: () async {},
              leading: ClipOval(
                child: Image.asset("assets/illustrations/default_profile.png"),
              ),
              title: Text(
                '손승태',
                style: kSubTitle2Style,
              ),
              subtitle: Text(
                '산업경영공학과',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: mainblack.withOpacity(0.6),
                  fontFamily: 'Nanum',
                ),
              ),
            ),
          ],
        )));
  }
}
