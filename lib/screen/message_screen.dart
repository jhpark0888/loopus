import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/screen/message_detail_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/messageroom_widget.dart';

class MessageScreen extends StatelessWidget {
  MessageController messageController = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (messageController.chattingroomlist
            .where((messageroomwidget) =>
                messageroomwidget.messageRoom.notread.value != 0)
            .isNotEmpty) {
          ProfileController.to.isnewmessage(true);
        } else {
          ProfileController.to.isnewmessage(false);
        }
        Get.back();
        return true;
      },
      child: Scaffold(
          appBar: AppBarWidget(
            leading: IconButton(
              onPressed: () {
                if (messageController.chattingroomlist
                    .where((messageroomwidget) =>
                        messageroomwidget.messageRoom.notread.value != 0)
                    .isNotEmpty) {
                  ProfileController.to.isnewmessage(true);
                } else {
                  ProfileController.to.isnewmessage(false);
                }
                Get.back();
              },
              icon: SvgPicture.asset('assets/icons/Arrow.svg'),
            ),
            bottomBorder: false,
            title: '메시지',
          ),
          body: Obx(
            () => messageController.chatroomscreenstate.value ==
                    ScreenState.loading
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
                : messageController.chatroomscreenstate.value ==
                        ScreenState.disconnect
                    ? DisconnectReloadWidget(reload: () {
                        getmessageroomlist();
                      })
                    : messageController.chatroomscreenstate.value ==
                            ScreenState.error
                        ? ErrorReloadWidget(reload: () {
                            getmessageroomlist();
                          })
                        : messageController.chattingroomlist.isNotEmpty
                            ? SingleChildScrollView(
                                child: Column(
                                    children:
                                        messageController.chattingroomlist))
                            : SafeArea(
                                child: Container(
                                  width: Get.width,
                                  height: Get.height * 0.75,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
          )),
    );
  }
}
