import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/api/profile_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/profile_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/widget/messageroom_widget.dart';

class MessageController extends GetxController {
  static MessageController get to => Get.find();
  TextEditingController searchName = TextEditingController();
  RxList<MessageRoomWidget> chattingRoomList = <MessageRoomWidget>[].obs;
  RxList<MessageRoomWidget> searchRoomList = <MessageRoomWidget>[].obs;
  // RxBool isMessageRoomListLoading = true.obs;
  Rx<ScreenState> chatroomscreenstate = ScreenState.loading.obs;

  @override
  void onInit() async{
    // getmessageroomlist();
    String? userId = await const FlutterSecureStorage().read(key: "id");
    print('$userId 유저아이디가 이거입니다');
    getChatroomlist(int.parse(userId!)).then((value) {
      if (value.isError == false) {
        List<ChatRoom> temp = value.data;
        chattingRoomList.value = temp
            .map((messageRoom) => MessageRoomWidget(chatRoom: messageRoom.obs,userid: int.parse(userId)))
            .toList();
        searchRoomList.value = chattingRoomList.toList();
        // for (var element in temp) {
        //   SQLController.to.insertmessageRoom(element);
        // }
      }
    // getProfile(143).then((value) {if(value.isError == false){
    //   print(value.data);
    // }});
    });
    super.onInit();
  }
}
