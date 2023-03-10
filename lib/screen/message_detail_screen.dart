import 'dart:async';
import 'dart:async';
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
import 'package:loopus/api/profile_api.dart';
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
import 'package:loopus/screen/loading_screen.dart';
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

import '../utils/error_control.dart';

enum EnterRoute { popUp, messageScreen, otherProfile }

class MessageDetatilScreen extends StatelessWidget {
  MessageDetatilScreen({
    Key? key,
    required this.partner,
    required this.myProfile,
    required this.enterRoute,
  }) : super(key: key);
  User partner;
  User myProfile;
  EnterRoute enterRoute;
  late MessageDetailController controller = Get.put(
      MessageDetailController(partnerId: partner.userId),
      tag: partner.userId.toString());
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
            title: partner.name,
            bottomBorder: false,
            leading: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
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
                icon: SvgPicture.asset('assets/icons/appbar_back.svg')),
            actions: [
              GestureDetector(
                onTap: () async {
                  showBottomdialog(context, func1: () {
                    showButtonDialog(
                        leftText: '??????',
                        rightText: '?????????',
                        title: '????????? ?????????',
                        startContent:
                            '?????? ???????????? ?????? ????????? ??? ??????????????????? \n ?????? ???????????? ?????? ??? ??? ?????????.',
                        leftFunction: () => Get.back(),
                        rightFunction: () {
                          int roomId = controller.roomid;
                          if (controller.messageList.isNotEmpty) {
                            loading();
                            deleteChatRoom(
                                    controller.roomid,
                                    myProfile.userId,
                                    int.parse(
                                        controller.messageList.last.messageId!))
                                .then((value) {
                              if (value.isError == false) {
                                Get.back();
                                SQLController.to.deleteMessage(roomId);
                                SQLController.to.deleteMessageRoom(roomId);
                                SQLController.to.deleteUser(partner.userId);
                                if (Get.isRegistered<MessageController>()) {
                                  MessageController.to.searchRoomList.removeAt(
                                      MessageController.to.searchRoomList
                                          .indexWhere((messageRoom) =>
                                              messageRoom
                                                  .chatRoom.value.roomId ==
                                              roomId));
                                  MessageController.to.chattingRoomList
                                      .removeAt(MessageController
                                          .to.chattingRoomList
                                          .indexWhere((messageRoom) =>
                                              messageRoom
                                                  .chatRoom.value.roomId ==
                                              roomId));
                                }
                                Get.back();
                                if (enterRoute == EnterRoute.popUp) {
                                  Get.off(() => MessageScreen());
                                } else {
                                  getbacks(2);
                                }
                                showCustomDialog('???????????? ???????????????', 1400);
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
                        });
                  }, func2: () {
                    showTextFieldDialog(
                        textEditingController: TextEditingController(),
                        // leftText: '??????',
                        // rightText: '????????????',
                        title: '?????? ????????????',
                        hintText:
                            '?????? ????????? ??????????????????. ????????? ?????? \n ?????? ?????? ????????? ?????? ???????????????.\n ',
                        rightText: '???????????? ',
                        rightBoxColor: AppColors.rankred,
                        leftBoxColor: AppColors.maingray,
                        leftFunction: () => Get.back(),
                        rightFunction: () {
                          userreport(controller.partnerId).then((value) {
                            if (value.isError == false) {
                              dialogBack(modalIOS: true);
                              showCustomDialog("????????? ?????????????????????", 1000);
                            } else {
                              errorSituation(value);
                            }
                          });
                        });
                  },
                      value1: '????????? ?????????',
                      value2: '?????? ????????????',
                      isOne: partner.withdrawal.value == 0 ? false : true,
                      buttonColor1: AppColors.mainWhite,
                      buttonColor2: AppColors.rankred,
                      textColor1: AppColors.rankred,
                      textColor2: AppColors.mainWhite);
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
              child: sendField(context)),
          body: SafeArea(
            child: Obx(
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
                                    //???????????? ?????? ?????? ?????? isfirst??? ??????, ????????? ????????? ??????, isdaychange??? ?????? ????????? ??????
                                    return MessageWidget(
                                        message: controller.messageList[index],
                                        isFirst: true.obs,
                                        isDayChange: true.obs,
                                        partner: partner,
                                        myId: controller.myId!);
                                  } else if (controller.messageList[index] ==
                                      controller.messageList.first) {
                                    //????????? ???????????? ??????
                                    if (DateFormat('yyyy-MM-dd').parse(
                                            controller.messageList[index].date
                                                .toString()) !=
                                        DateFormat('yyyy-MM-dd').parse(
                                            controller
                                                .messageList[index + 1].date
                                                .toString())) {
                                      return MessageWidget(
                                          message:
                                              controller.messageList[index],
                                          isFirst: true.obs,
                                          isDayChange: true.obs,
                                          partner: partner,
                                          myId: controller.myId!);
                                    } else {
                                      return MessageWidget(
                                          message:
                                              controller.messageList[index],
                                          isFirst: true.obs,
                                          isDayChange: false.obs,
                                          partner: partner,
                                          myId: controller.myId!);
                                    }
                                  } else if (controller.messageList[index] ==
                                      controller.messageList.last) {
                                    //????????? ???????????? ??????
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
                                    //?????? ??????????????? ????????? ????????? ????????? ?????? ??????
                                    return MessageWidget(
                                        message: controller.messageList[index],
                                        isFirst: false.obs,
                                        isDayChange: true.obs,
                                        partner: partner,
                                        myId: controller.myId!);
                                  } else {
                                    //?????? ??????????????? ????????? ????????? ????????? ?????? ??????
                                    return MessageWidget(
                                        message: controller.messageList[index],
                                        isFirst: false.obs,
                                        isDayChange: false.obs,
                                        partner: partner,
                                        myId: controller.myId!);
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
            ),
          )),
    );
  }

  Widget sendField(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 6.5, 16, 6.5),
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(width: 1, color: AppColors.dividegray))),
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
                  readOnly: partner.withdrawal.value == 0 ? false : true,
                  style: MyTextTheme.mainheight(context),
                  cursorColor: AppColors.mainblack,
                  cursorWidth: 1.2,
                  cursorRadius: Radius.circular(5.0),
                  autofocus: false,
                  // textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.cardGray,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
                    isDense: true,
                    hintText: partner.withdrawal.value == 0
                        ? '????????? ??????'
                        : '????????? ???????????? ???????????????',
                    counterText: "",
                    hintStyle: MyTextTheme.main(context)
                        .copyWith(color: AppColors.maingray)
                        .copyWith(height: 1.4),
                  )),
            ),
            const SizedBox(width: 14),
            GestureDetector(
                onTap: () async {
                  print(controller.messageList
                      .where((p0) => p0.sendsuccess!.value == 'false')
                      .length
                      .toString());
                  Chat temp = Chat(
                      messageId: controller.messageList
                          .where((p0) => p0.sendsuccess!.value == 'false')
                          .length
                          .toString(),
                      content: controller.sendText.text,
                      date: DateTime.now(),
                      sender: controller.myId.toString(),
                      isRead: false.obs,
                      roomId: controller.roomid,
                      sendsuccess: 'false'.obs);
                  if (controller.sendText.text.isNotEmpty) {
                    await SQLController.to.insertmessage(temp);
                    await sendMessage();
                    controller.messageList.insert(0, temp);
                    controller.sendText.clear();
                    await Future.delayed(const Duration(milliseconds: 300));
                    controller.listViewController.jumpTo(
                        controller.listViewController.position.minScrollExtent);
                  }
                },
                child: SvgPicture.asset('assets/icons/enter.svg'))
          ],
        ),
      ),
    );
  }

  Future sendMessage() async {
    if (controller.hasInternet.value == true) {
      controller.channel.sink.add(jsonEncode({
        'content': controller.sendText.text,
        'type': 'msg',
        'name': myProfile.name
      }));
    }
  }
}
