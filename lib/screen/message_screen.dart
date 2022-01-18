import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/messageroom_widget.dart';

class MessageScreen extends StatelessWidget {
  MessageController messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          title: '메시지',
        ),
        body: Obx(
          () => messageController.isMessageRoomListLoading.value
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/loading.gif',
                          scale: 9,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '채팅 목록을 받아오는 중이에요...',
                          style: TextStyle(
                            fontSize: 10,
                            color: mainblue,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]),
                )
              : SingleChildScrollView(
                  child: Column(
                      children: messageController.chattingroomlist
                          .map((messageRoom) =>
                              MessageRoomWidget(messageRoom: messageRoom))
                          .toList()
                      // [
                      //   ListTile(
                      //     onTap: () async {
                      //       messageController.messagelist.clear();
                      //       await messageload(24);
                      //       Get.to(() => MessageDetailScreen());
                      //     },
                      //     leading: ClipOval(
                      //       child: Image.asset(
                      //           "assets/illustrations/default_profile.png"),
                      //     ),
                      //     title: Text(
                      //       '손승태',
                      //       style: kSubTitle2Style,
                      //     ),
                      //     subtitle: Text(
                      //       '산업경영공학과',
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //         color: mainblack.withOpacity(0.6),
                      //         fontFamily: 'Nanum',
                      //       ),
                      //     ),
                      //   ),
                      //   ListTile(
                      //     onTap: () async {},
                      //     leading: ClipOval(
                      //       child: Image.asset(
                      //           "assets/illustrations/default_profile.png"),
                      //     ),
                      //     title: Text(
                      //       '손승태',
                      //       style: kSubTitle2Style,
                      //     ),
                      //     subtitle: Text(
                      //       '산업경영공학과',
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //         color: mainblack.withOpacity(0.6),
                      //         fontFamily: 'Nanum',
                      //       ),
                      //     ),
                      //   ),
                      //   ListTile(
                      //     onTap: () async {},
                      //     leading: ClipOval(
                      //       child: Image.asset(
                      //           "assets/illustrations/default_profile.png"),
                      //     ),
                      //     title: Text(
                      //       '손승태',
                      //       style: kSubTitle2Style,
                      //     ),
                      //     subtitle: Text(
                      //       '산업경영공학과',
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //         color: mainblack.withOpacity(0.6),
                      //         fontFamily: 'Nanum',
                      //       ),
                      //     ),
                      //   ),
                      //   ListTile(
                      //     onTap: () async {},
                      //     leading: ClipOval(
                      //       child: Image.asset(
                      //           "assets/illustrations/default_profile.png"),
                      //     ),
                      //     title: Text(
                      //       '손승태',
                      //       style: kSubTitle2Style,
                      //     ),
                      //     subtitle: Text(
                      //       '산업경영공학과',
                      //       style: TextStyle(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //         color: mainblack.withOpacity(0.6),
                      //         fontFamily: 'Nanum',
                      //       ),
                      //     ),
                      //   ),
                      // ],
                      )),
        ));
  }
}
