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
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/messageroom_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessageController extends GetxController {
  static MessageController get to => Get.find();
  RefreshController refreshController = RefreshController();
  TextEditingController searchName = TextEditingController();
  RxList<MessageRoomWidget> chattingRoomList = <MessageRoomWidget>[].obs;
  RxList<MessageRoomWidget> searchRoomList = <MessageRoomWidget>[].obs;
  // RxBool isMessageRoomListLoading = true.obs;
  Rx<ScreenState> chatroomscreenstate = ScreenState.loading.obs;
  RxBool activeTextfield = false.obs;
  RxList<User> member = <User>[].obs;
  @override
  void onInit() async {
    String? userId = await const FlutterSecureStorage().read(key: "id");
    print('$userId 유저아이디가 이거입니다');

    await SQLController.to.getDBMessageRoom().then((value) async {
      if (value.isNotEmpty) {
        List<ChatRoom> temp = value;
        await getDBUserInfo(temp);
        await addList(temp);
        await sortList();
      }
      chatroomscreenstate.value = ScreenState.success;
    });
    getChatroomlist(int.parse(userId!)).then((chatroom) async {
      if (chatroom.isError == false) {
        List<ChatRoom> temp = chatroom.data;

        List<int> membersId =
            List.generate(temp.length, (index) => temp[index].user);
        if (membersId.isNotEmpty) {
          await getUserProfile(membersId).then((usersList) {
            if (usersList.isError == false) {
              List<User> userList = usersList.data;

              temp.forEach((element) async {
                User user =
                    userList.where((user) => user.userid == element.user).first;
                if (chattingRoomList
                    .where((messageRoom) =>
                        messageRoom.user.value.userid == user.userid)
                    .isEmpty) {
                  SQLController.to.insertMessageRoom(element);
                  SQLController.to.insertUser(user);
                  if (chattingRoomList
                      .where((messageRoom) =>
                          messageRoom.chatRoom.value.user == user.userid)
                      .isNotEmpty) {
                    chattingRoomList
                        .where((messageRoom) =>
                            messageRoom.chatRoom.value.user == user.userid)
                        .first
                        .user
                        .value = user;
                    searchRoomList
                        .where((messageRoom) =>
                            messageRoom.chatRoom.value.user == user.userid)
                        .first
                        .user
                        .value = user;
                    print(chattingRoomList
                        .where((messageRoom) =>
                            messageRoom.chatRoom.value.user == user.userid)
                        .first
                        .user);
                    chattingRoomList
                        .where((messageRoom) =>
                            messageRoom.chatRoom.value.user == user.userid)
                        .first
                        .user
                        .refresh();
                    searchRoomList
                        .where((messageRoom) =>
                            messageRoom.chatRoom.value.user == user.userid)
                        .first
                        .user
                        .refresh();
                  } else {
                    chattingRoomList.add(MessageRoomWidget(
                        chatRoom: element.obs, user: user.obs));
                    searchRoomList.add(MessageRoomWidget(
                        chatRoom: element.obs, user: user.obs));
                  }
                } else {
                  SQLController.to.updateLastMessage(
                      element.message.value.content,
                      element.message.value.date.toString(),
                      element.roomId);
                  if (chattingRoomList
                          .where((messageRoom) =>
                              messageRoom.user.value.userid == user.userid)
                          .first
                          .user
                          .value
                          .profileImage !=
                      user.profileImage) {
                    SQLController.to
                        .updateUser(user.profileImage ?? '', user.userid);
                  }
                  chattingRoomList
                      .where((messageRoom) =>
                          messageRoom.chatRoom.value.roomId == element.roomId)
                      .first
                      .chatRoom
                      .value = element;
                  chattingRoomList
                      .where((messageRoom) =>
                          messageRoom.user.value.userid == user.userid)
                      .first
                      .user
                      .value
                      .profileImage = user.profileImage;
                  searchRoomList
                      .where((messageRoom) =>
                          messageRoom.chatRoom.value.roomId == element.roomId)
                      .first
                      .chatRoom
                      .value = element;
                  searchRoomList
                      .where((messageRoom) =>
                          messageRoom.user.value.userid == user.userid)
                      .first
                      .user
                      .value
                      .profileImage = user.profileImage;
                }
              });

              sortList();
            }
          });
        }
      }
    });
    super.onInit();
  }

  Future<void> getDBUserInfo(List<ChatRoom> temp) async {
    List<int> int_member =
        List.generate(temp.length, (index) => temp[index].user);

    await Future.forEach(
        int_member,
        (element) => SQLController.to
            .getDBUser(element as int)
            .then((value) => member.add(value)));
  }

  Future<void> addList(temp) async {
    chattingRoomList.addAll(List.generate(
        temp.length,
        ((index) => MessageRoomWidget(
            chatRoom: Rx<ChatRoom>(temp[index]),
            user: Rx<User>(member[index])))));
    searchRoomList.value = chattingRoomList.toList();
  }

  Future<void> sortList() async {
    MessageController.to.chattingRoomList.sort((a, b) => b
        .chatRoom.value.message.value.date
        .compareTo(a.chatRoom.value.message.value.date));
    MessageController.to.searchRoomList.sort((a, b) => b
        .chatRoom.value.message.value.date
        .compareTo(a.chatRoom.value.message.value.date));
  }
}
