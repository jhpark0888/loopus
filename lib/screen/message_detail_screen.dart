import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
      MessageDetailController(
          partnerId: partner.userid),
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
      child: SafeArea(
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
                      child: SvgPicture.asset('assets/icons/Arrow_left.svg'))),
              actions: [
                GestureDetector(
                  onTap: () async {
                    // // deleteDatabase(
                    // //                 join(await getDatabasesPath(), 'MY_database.db'));
                    showModalIOS(context, func1: () {
                      int roomId = controller.roomid;
                      if (controller.messageList.isNotEmpty) {
                        deleteChatRoom(controller.roomid, myProfile.userid)
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
                          child: SvgPicture.asset('assets/icons/More.svg'))),
                )
              ],
            ),
            bottomNavigationBar: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: sendField()
            ),
            body: Obx(
              () => controller.screenState.value == ScreenState.loading
                  ? const Center(child: LoadingWidget())
                  : controller.screenState.value == ScreenState.success
                      ? SmartRefresher(
                          controller: controller.refreshController,
                          scrollController: controller.scrollController,
                          enablePullUp: controller.refreshEnablePullUp.value,
                          enablePullDown: false,
                          onLoading: controller.onLoading,
                          header: ClassicHeader(
                            releaseIcon: Container(),
                            releaseText: '',
                            refreshingIcon: Container(),
                            refreshingText: '',
                            idleIcon: Container(),
                            idleText: '',
                          ),
                          footer: ClassicFooter(
                            loadingIcon: Container(),
                            loadingText: '',
                            idleIcon: Container(),
                            idleText: '',
                          ),
                          physics: const BouncingScrollPhysics(),
                          reverse: true,
                          child: SingleChildScrollView(
                            reverse: false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  primary: false,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    if(controller.messageList.length == 1){
                                      return MessageWidget(
                                          message: controller.messageList[index],
                                          isLast: true.obs,
                                          isFirst: true.obs,
                                          partner: partner,
                                          myId: controller.myId!);
                                    }
                                    else if (controller.messageList[index] ==
                                        controller.messageList.first) {
                                      return MessageWidget(
                                          message: controller.messageList[index],
                                          isLast: true.obs,
                                          isFirst: false.obs,
                                          partner: partner,
                                          myId: controller.myId!);
                                    } else if (controller.messageList[index] ==
                                        controller.messageList.last) {
                                      return MessageWidget(
                                          message: controller.messageList[index],
                                          isLast: false.obs,
                                          isFirst: true.obs,
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
                                            message:
                                                controller.messageList[index],
                                            isLast: false.obs,
                                            isFirst: false.obs,
                                            partner: partner,
                                            myId: controller.myId!),
                                      );
                                    }
                                  },
                                  itemCount: controller.messageList.length,
                                  separatorBuilder: (context, index) {
                                    if (DateFormat('yyyy-MM-dd').parse(controller
                                            .messageList[index].date
                                            .toString()) !=
                                        DateFormat('yyyy-MM-dd').parse(controller
                                            .messageList[index + 1].date
                                            .toString())) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 7, 20, 7),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Divider(
                                                    thickness: 0.5,
                                                    color: maingray,
                                                    height: 0.5),
                                              ),
                                              const SizedBox(width: 14),
                                              Text(
                                                '${controller.messageList[index].date.year}.${controller.messageList[index].date.month}.${controller.messageList[index].date.day}',
                                                style: k16Normal.copyWith(
                                                    color: maingray),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Divider(
                                                    thickness: 0.5,
                                                    color: maingray,
                                                    height: 0.5),
                                              ),
                                            ]),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        )
                      : controller.screenState.value == ScreenState.normal
                          ? Container()
                          : Container(),
            )),
      ),
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
              focusNode: controller.focusNode,
                keyboardType: TextInputType.multiline,
                controller: controller.sendText,
                minLines: 1,
                maxLines: 3,
                autocorrect: false,
                readOnly: false,
                style: k16Normal,
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
                  hintStyle: k16Normal.copyWith(color: maingray),
                )),
          ),
          const SizedBox(width: 14),
          GestureDetector(
              onTap: () async {
                if (controller.sendText.text.isNotEmpty) {
                  if (controller.hasInternet.value == true) {
                    controller.channel.sink.add(jsonEncode({
                      'content': controller.sendText.text,
                      'type': 'msg',
                      'name': myProfile.realName
                    }));
                  }
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
                }
              },
              child: SvgPicture.asset('assets/icons/Enter_Icon.svg'))
        ],
      ),
    );
  }
}
