import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/widget/messageroom_widget.dart';

class MessageController extends GetxController {
  static MessageController get to => Get.find();
  TextEditingController searchName = TextEditingController();
  RxList<MessageRoomWidget> chattingroomlist = <MessageRoomWidget>[].obs;
  // RxBool isMessageRoomListLoading = true.obs;
  Rx<ScreenState> chatroomscreenstate = ScreenState.loading.obs;

  @override
  void onInit() {
    // getmessageroomlist();
    getChatroomlist().then((value) {
      if (value.isError == false) {
        List<ChatRoom> temp = value.data;
        chattingroomlist.value = temp
            .map((messageRoom) => MessageRoomWidget(chatRoom: messageRoom.obs))
            .toList();
      }
    });
    super.onInit();
  }
}
