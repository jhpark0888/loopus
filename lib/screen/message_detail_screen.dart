import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/keyboard_controller.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/message_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/message_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:web_socket_channel/io.dart';

enum EnterRoute { popUp, messageScreen, otherProfile }

class MessageDetatilScreen extends StatelessWidget {
  MessageDetatilScreen(
      {Key? key,
      required this.partner,
      required this.myProfile,
      required this.enterRoute})
      : super(key: key);
  User partner;
  User myProfile;
  EnterRoute enterRoute;
  late MessageDetailController controller = Get.put(
      MessageDetailController(partnerId: partner.userid),
      tag: partner.userid.toString());
  // KeyBoardController keyBoardController = Get.put(KeyBoardController());
  Key centerKey = const ValueKey('QueryList');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBarWidget(
            title: partner.realName,
            bottomBorder: false,
            leading: GestureDetector(
                onTap: () {
                  if (enterRoute == EnterRoute.popUp) {
                    if (Get.isRegistered<MessageController>()) {
                      Get.back();
                    } else {
                      Get.off(() => MessageScreen());
                    }
                  } else {
                    Get.back();
                  }
                },
                child: Center(
                    child: SvgPicture.asset('assets/icons/appbar_back.svg'))),
            actions: [
              GestureDetector(
                onTap: () async {
                  // // deleteDatabase(
                  // //                 join(await getDatabasesPath(), 'MY_database.db'));
                  showModalIOS(context, func1: () {
                    int roomId = controller.roomid;
                    if (controller.messageList.isNotEmpty) {
                      deleteChatRoom(controller.roomid, myProfile.userid, int.parse(controller.messageList.last.messageId!))
                          .then((value) {
                        if (value.isError == false) {
                          SQLController.to.deleteMessage(roomId);
                          SQLController.to.deleteMessageRoom(roomId);
                          SQLController.to.deleteUser(partner.userid);
                          if (Get.isRegistered<MessageController>()) {
                            MessageController.to.searchRoomList.removeAt(
                                MessageController.to.searchRoomList.indexWhere(
                                    (messageRoom) =>
                                        messageRoom.chatRoom.value.roomId ==
                                        roomId));
                            MessageController.to.chattingRoomList.removeAt(
                                MessageController.to.chattingRoomList
                                    .indexWhere((messageRoom) =>
                                        messageRoom.chatRoom.value.roomId ==
                                        roomId));
                          }
                          Get.back();
                          if (enterRoute == EnterRoute.popUp) {
                            Get.off(() => MessageScreen());
                          } else {
                            Get.back();
                          }
                        }
                      });
                    } else {
                      Get.back();
                      if (enterRoute == EnterRoute.popUp) {
                        Get.off(() => MessageScreen());
                      } else {
                        Get.back();
                      }
                    }
                  }, func2: () {
                    Get.to(() => DatabaseList());
                  },
                      value1: '채팅방 나가기',
                      value2: '',
                      isValue1Red: true,
                      isValue2Red: false,
                      isOne: true);
                },
                child: SizedBox(
                    height: 44,
                    width: 44,
                    child: Center(
                        child: SvgPicture.asset(
                            'assets/icons/appbar_more_option.svg'))),
              )
            ],
          ),
          bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: sendField()),
          body: Obx(
            () => controller.screenState.value == ScreenState.loading
                ? const Center(child: LoadingWidget())
                : controller.screenState.value == ScreenState.success
                    ? Scrollbar(
                        child: FlutterListView(
                            reverse: true,
                            controller: controller.listViewController,
                            delegate: FlutterListViewDelegate(
                              (context, index) {
                                if (controller.messageList.length == 1) {
                                  //메세지가 한개 있을 경우 isfirst는 읽음, 안읽음 표시를 위함, isdaychange는 날싸 표시를 위함
                                  return MessageWidget(
                                      message: controller.messageList[index],
                                      isFirst: true.obs,
                                      isDayChange: true.obs,
                                      partner: partner,
                                      myId: controller.myId!);
                                } else if (controller.messageList[index] ==
                                    controller.messageList.first) {
                                  if (DateFormat('yyyy-MM-dd').parse(controller
                                          .messageList[index].date
                                          .toString()) !=
                                      DateFormat('yyyy-MM-dd').parse(controller
                                          .messageList[index + 1].date
                                          .toString())) {
                                    return MessageWidget(
                                        message: controller.messageList[index],
                                        isFirst: true.obs,
                                        isDayChange: true.obs,
                                        partner: partner,
                                        myId: controller.myId!);
                                  } else {
                                    return MessageWidget(
                                        message: controller.messageList[index],
                                        isFirst: true.obs,
                                        isDayChange: false.obs,
                                        partner: partner,
                                        myId: controller.myId!);
                                  }
                                } else if (controller.messageList[index] ==
                                    controller.messageList.last) {
                                  return MessageWidget(
                                      message: controller.messageList[index],
                                      isFirst: false.obs,
                                      isDayChange: true.obs,
                                      partner: partner,
                                      myId: controller.myId!);
                                } else if (DateFormat('yyyy-MM-dd').parse(
                                        controller.messageList[index].date
                                            .toString()) !=
                                    DateFormat('yyyy-MM-dd').parse(controller
                                        .messageList[index + 1].date
                                        .toString())) {
                                  return MessageWidget(
                                      message: controller.messageList[index],
                                      isFirst: false.obs,
                                      isDayChange: true.obs,
                                      partner: partner,
                                      myId: controller.myId!);
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      print(controller.messageList[index] ==
                                              controller.messageList.last ||
                                          DateFormat('yyyy-MM-dd').parse(
                                                  controller
                                                      .messageList[index].date
                                                      .toString()) !=
                                              DateFormat('yyyy-MM-dd').parse(
                                                  controller
                                                      .messageList[index].date
                                                      .toString()));
                                    },
                                    child: MessageWidget(
                                        message: controller.messageList[index],
                                        isFirst: false.obs,
                                        isDayChange: false.obs,
                                        partner: partner,
                                        myId: controller.myId!),
                                  );
                                }
                              },
                              childCount: controller.messageList.length,
                              onItemKey: (index) => controller
                                  .messageList[index].messageId
                                  .toString(),
                              initOffsetBasedOnBottom: true,
                              firstItemAlign: FirstItemAlign.end,
                              keepPosition: true,
                            )),
                      )
                    : controller.screenState.value == ScreenState.normal
                        ? Container()
                        : Container(),
          )),
    );
  }

  Widget sendField() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: dividegray))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              dragStartBehavior: DragStartBehavior.start,
                focusNode: controller.focusNode,
                keyboardType: TextInputType.multiline,
                controller: controller.sendText,
                minLines: 1,
                maxLines: 3,
                autocorrect: false,
                readOnly: false,
                style: kmain,
                cursorColor: mainblack,
                cursorWidth: 1.2,
                cursorRadius: Radius.circular(5.0),
                autofocus: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: cardGray,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  isDense: true,
                  hintText: '메세지 입력',
                  hintStyle: kmain.copyWith(color: maingray),
                )),
          ),
          const SizedBox(width: 14),
          GestureDetector(
              onTap: () async {
                if (controller.sendText.text.isNotEmpty) {
                  await sendMessage();
                  controller.messageList.insert(
                      0,
                      Chat(
                          content: controller.sendText.text,
                          date: DateTime.now(),
                          sender: controller.myId.toString(),
                          isRead: false.obs,
                          messageId: '0',
                          type: 'msg',
                          roomId: controller.roomid,
                          sendsuccess: false.obs));
                  controller.sendText.clear();
                  controller.listViewController.jumpTo(
                      controller.listViewController.position.minScrollExtent);
                }
              },
              child: SvgPicture.asset('assets/icons/enter.svg'))
        ],
      ),
    );
  }

  Future sendMessage() async {
    if (controller.hasInternet.value == true) {
      controller.channel.sink.add(jsonEncode({
        'content': controller.sendText.text,
        'type': 'msg',
        'name': myProfile.realName
      }));
    }
  }
}
