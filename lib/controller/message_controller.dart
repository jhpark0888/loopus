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
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/messageroom_widget.dart';

class MessageController extends GetxController {
  static MessageController get to => Get.find();
  TextEditingController searchName = TextEditingController();
  RxList<MessageRoomWidget> chattingRoomList = <MessageRoomWidget>[].obs;
  RxList<MessageRoomWidget> searchRoomList = <MessageRoomWidget>[].obs;
  // RxBool isMessageRoomListLoading = true.obs;
  Rx<ScreenState> chatroomscreenstate = ScreenState.loading.obs;
  @override
  void onInit() async {
    String? userId = await const FlutterSecureStorage().read(key: "id");
    print('$userId 유저아이디가 이거입니다');
    

    getChatroomlist(int.parse(userId!)).then((chatroom) {
      if (chatroom.isError == false) {
        List<ChatRoom> temp = chatroom.data;
        List<int> membersId =
            List.generate(temp.length, (index) => temp[index].user);
        getUserProfile(membersId).then((usersList) {
          if (usersList.isError == false) {
            List<User> userList = usersList.data;
            chattingRoomList.value = temp
                .map((messageRoom) => MessageRoomWidget(
                    chatRoom: messageRoom.obs,
                    userid: int.parse(userId),
                    user: userList
                        .where((element) => element.userid == messageRoom.user) 
                        .toList().isNotEmpty ?userList
                        .where((element) => element.userid == messageRoom.user) 
                        .toList()[0] : User.defaultuser()))
                .toList();
            searchRoomList.value = chattingRoomList.toList();


            userList.forEach((element) {
           
              SQLController.to.insertUser(element);
             
            });
            temp.forEach((element) {
              SQLController.to.insertmessageRoom(element);
            });
          }
        });
      }
    });
    super.onInit();
  }
}
