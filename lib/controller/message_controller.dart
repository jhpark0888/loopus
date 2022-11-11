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

class MessageController extends GetxController with WidgetsBindingObserver {
  static MessageController get to => Get.find();
  RefreshController refreshController = RefreshController();
  TextEditingController searchName = TextEditingController();
  RxList<MessageRoomWidget> chattingRoomList = <MessageRoomWidget>[].obs;
  RxList<MessageRoomWidget> searchRoomList = <MessageRoomWidget>[].obs;
  // RxBool isMessageRoomListLoading = true.obs;
  Rx<ScreenState> chatroomscreenstate = ScreenState.loading.obs;
  RxBool activeTextfield = false.obs;
  RxList<Person> member = <Person>[].obs;
  @override
  void onInit() async {
    WidgetsBinding.instance!.addObserver(this);

    await SQLController.to.getDBMessageRoom().then((value) async {
      if (value.isNotEmpty) {
        List<ChatRoom> temp = value;
        await getDBUserInfo(temp);
        await addList(temp);
        await sortList();
      }
      chatroomscreenstate.value = ScreenState.success;
    });
    refresh();
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance!.removeObserver(this);
    const FlutterSecureStorage().delete(key: 'newMsg');
    super.onClose();
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
            user: Rx<Person>(member[index])))));
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print(state);
        String update = await FlutterSecureStorage().read(key: 'newMsg') ?? '';
        print(update);
        if (update != '') {
          if (Get.isRegistered<MessageController>()) {
            MessageController.to.refresh();
          }
        }
        print('연결되었습니다.');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        // listener.cancel();
        print('작동완료');
        print(state);
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> refresh() async {
    String? userId = await const FlutterSecureStorage().read(key: "id");
    print('$userId 유저아이디가 이거입니다');
    getChatroomlist(int.parse(userId!)).then((chatroom) async {
      if (chatroom.isError == false) {
        List<ChatRoom> temp = chatroom.data;
        List<int> membersId =
            List.generate(temp.length, (index) => temp[index].user);
        if (membersId.isNotEmpty) {
          await getUserProfile(membersId).then((usersList) {
            if (usersList.isError == false) {
              Map<String, List> allUserList =
                  Map<String, List>.from(usersList.data);
              List<int> none = List.from(allUserList['none']!);
              List<User> userList =
                  allUserList['profile']!.map((e) => User.fromJson(e)).toList();
              if (none.isNotEmpty) {
                none.forEach((userId) {
                  SQLController.to.updateUser('', '알수없음',1, userId);
                  chattingRoomList
                      .where((p0) => p0.user.value.userId == userId)
                      .first
                      .user
                      .value
                      .name = '알수없음';
                  chattingRoomList
                      .where((p0) => p0.user.value.userId == userId)
                      .first
                      .user
                      .value
                      .profileImage = '';
                  chattingRoomList
                      .where((p0) => p0.user.value.userId == userId)
                      .first
                      .user
                      .value
                      .withdrawal
                      .value = 1;
                  chattingRoomList
                      .where((p0) => p0.user.value.userId == userId)
                      .first
                      .user
                      .refresh();
                });
              }
              const FlutterSecureStorage().delete(key: 'newMsg');
              temp.forEach((element) async {
                User? user;
                if (userList
                    .where((user) => user.userId == element.user)
                    .isNotEmpty) {
                  user = userList
                      .where((user) => user.userId == element.user)
                      .first;
                }
                //  else {
                //   print('${element.user.runtimeType}입니다');
                //   user = User.defaultuser();
                //   user.name = '알수 없음';
                //   user.userId = element.user;
                //   user.withdrawal.value = 1;
                // }
                if (user != null) {
                  if (chattingRoomList
                      .where((messageRoom) =>
                          messageRoom.user.value.userId == user!.userId)
                      .isEmpty) {
                    SQLController.to.insertMessageRoom(element);
                    SQLController.to.insertUser(user);
                    chattingRoomList.add(MessageRoomWidget(
                        chatRoom: element.obs, user: user.obs));
                    searchRoomList.add(MessageRoomWidget(
                        chatRoom: element.obs, user: user.obs));
                  } else {
                    SQLController.to.updateLastMessage(
                        element.message.value.content,
                        element.message.value.date.toString(),
                        element.roomId);
                    if (chattingRoomList
                            .where((messageRoom) =>
                                messageRoom.user.value.userId == user!.userId)
                            .first
                            .user
                            .value
                            .profileImage !=
                        user.profileImage) {
                      SQLController.to
                          .updateUser(user.profileImage, null,null, user.userId);
                    }

                    chattingRoomList
                        .where((messageRoom) =>
                            messageRoom.chatRoom.value.roomId == element.roomId)
                        .first
                        .chatRoom
                        .value = element;
                    chattingRoomList
                        .where((messageRoom) =>
                            messageRoom.chatRoom.value.roomId == element.roomId)
                        .first
                        .chatRoom.refresh();
                    chattingRoomList
                        .where((messageRoom) =>
                            messageRoom.user.value.userId == user!.userId)
                        .first
                        .user
                        .value = user;

                    chattingRoomList
                        .where((messageRoom) =>
                            messageRoom.chatRoom.value.roomId == element.roomId)
                        .first
                        .user.refresh();
                  }
                }
              });
              searchRoomList.value = chattingRoomList.toList();
              sortList();
            }
          });
        }
      }
    });
  }
}
