import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/widget/messageroom_widget.dart';

class MessageController extends GetxController {
  static MessageController get to => Get.find();
  RxList<MessageRoomWidget> chattingroomlist = <MessageRoomWidget>[].obs;
  // RxBool isMessageRoomListLoading = true.obs;
  Rx<ScreenState> chatroomscreenstate = ScreenState.loading.obs;

  @override
  void onInit() {
    getmessageroomlist();
    super.onInit();
  }
}
