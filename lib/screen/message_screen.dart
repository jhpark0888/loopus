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
          bottomBorder: false,
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
                          '메시지 목록을 받아오는 중이에요...',
                          style: TextStyle(
                            fontSize: 10,
                            color: mainblue,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ]),
                )
              : messageController.chattingroomlist.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                          children: messageController.chattingroomlist
                              .map((messageRoom) =>
                                  MessageRoomWidget(messageRoom: messageRoom))
                              .toList()))
                  : SafeArea(
                      child: Container(
                        width: Get.width,
                        height: Get.height * 0.75,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '메시지 목록이 비어있어요',
                              style: kSubTitle3Style.copyWith(
                                color: mainblack.withOpacity(0.38),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ));
  }
}
