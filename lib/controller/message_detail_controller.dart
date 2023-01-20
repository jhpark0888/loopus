import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/environment_model.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:web_socket_channel/io.dart';
import 'package:loopus/model/environment_model.dart';
import '../model/httpresponse_model.dart';

class MessageDetailController extends GetxController
    with WidgetsBindingObserver {
  MessageDetailController({required this.partnerId});
  late IOWebSocketChannel channel;
  late int roomid;
  RxBool hasInternet = true.obs;
  late var listener;

  int partnerId;
  int? myId;
  TextEditingController sendText = TextEditingController();
  ScrollController scrollController = ScrollController();
  RefreshController refreshController = RefreshController();
  ItemScrollController itemcontroller = ItemScrollController();
  FlutterListViewController listViewController = FlutterListViewController();
  RxList<Chat> tempMessageList = <Chat>[].obs;
  RxList<Chat> messageList = <Chat>[].obs;
  RxList<Chat> refreshList = <Chat>[].obs;
  Rx<ScreenState> screenState = ScreenState.normal.obs;
  RxBool isFirst = true.obs;
  RxBool refreshEnablePullUp = true.obs;
  RxBool connection = true.obs;
  RxString lastid = '0'.obs;
  RxDouble messageHeight = 0.0.obs;
  RxDouble messagesBoxPositionHeight = 0.0.obs;

  FocusNode focusNode = FocusNode();
  @override
  void onInit() async {
    WidgetsBinding.instance!.addObserver(this);
    listViewController.addListener(() {
      if (refreshEnablePullUp.value == true) {
        if (listViewController.position.pixels ==
            listViewController.position.maxScrollExtent) {
          onLoading();
        }
      }
    });
    screenState.value = ScreenState.loading;
    print('${partnerId}파트너아이디입니다.');
    myId = int.parse(
        (await const FlutterSecureStorage().read(key: "id")).toString());

    print('${myId}자기아이디입니다.');
    connection.listen((p0) async {
      //인터넷 연결 상태 확인
      if (p0 == false) {
        channel.sink.close();
        print('웹소켓 연결이 해제되었습니다.');
      } else {
        // if (isFirst.value == false) {
        await connectWebSocket();
        print(myId);
        channel.stream.listen((event) {
          print(event);
          messageTypeCheck(jsonDecode(event));
        }, onError: (error) async {
          await connectWebSocket();
        }, onDone: () async {
          hasInternet.value = false;
          print('끊겼습니다.');
          await connectWebSocket();
          print('재연결 되었습니다.');
        });
        // }
      }
    });
    listener = InternetConnectionChecker().onStatusChange.listen((event) {
      connection.value =
          event == InternetConnectionStatus.connected ? true : false;
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        print('내려가있습니다.');
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print(state);
        connection.value = true;
        print('연결되었습니다.');
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        connection.value = false;
        // listener.cancel();
        print('작동완료');
        print(state);
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onClose() {
    channel.sink.close();
    listener.cancel();
    print('웹소켓 연결 해제');
    messageList.clear();
    HomeController.to.enterMessageRoom.value = 0;
    WidgetsBinding.instance!.removeObserver(this);
    super.onClose();
  }

  void onLoading() async {
    print(lastid);
    List<Chat> list =
        (await SQLController.to.getDBMessage(roomid, int.parse(lastid.value)));
    print(list);
    if (list.isNotEmpty) {
      messageList.addAll(list);
      // messageList.insertAll(0, list);
      lastid.value = messageList.last.messageId!;
      refreshEnablePullUp(true);
    } else {
      refreshEnablePullUp.value = false;
    }
    refreshController.loadComplete();
  }

  void messageTypeCheck(Map<String, dynamic> json) async {
    print(json['type']);
    switch (json['type']) {
      case ('user_join'):
        if (json['user_id'] == myId) {
          print('내가 접속함');
          roomid = int.parse(json['room_id']);
          hasInternet.value = true;
          if (messageList.isEmpty) {
            messageList.addAll(await SQLController.to
                .getDBMessage(roomid, int.parse(lastid.value)));
          }

          await checkRoomId(roomid).then((value) async {
            if (value.isNotEmpty) {
              Chat firstMessage = messageList
                  .firstWhere((p0) => p0.sendsuccess!.value != 'false');
              await sendLastView(int.parse(firstMessage.messageId!));
              updateNotreadMsg();
              mustSendMessages();
            } else {
              sendLastView(0);
            }
          });

          lastid.value = messageList.isNotEmpty
              ? messageList.last.messageId ?? lastid.value
              : lastid.value;
          screenState.value = ScreenState.success;
        } else {
          print('상대가 접속함');
          changeReadMessage(roomid, null);
        }
        break;
      case ('msg'):
        if (json['sender'] == myId) {
          Chat chat = messageList
              .where((p0) =>
                  p0.sendsuccess != null && p0.sendsuccess!.value == 'false')
              .last;
          messageList.where((p0) => p0 == chat).last.sendsuccess!.value =
              'true';
          await SQLController.to.updateMessage(
              'true',
              json['id'],
              json['is_read'].toString(),
              json['date'].toString(),
              myId!,
              roomid,
              int.parse(chat.messageId!));
          afterMustSendMessages(json, chat);
        } else {
          messageList.insert(0, Chat.fromJson(json));
          SQLController.to.insertmessage(Chat.fromMsg(json, roomid));
        }
        await Future.delayed(const Duration(milliseconds: 100));
        SQLController.to
            .updateLastMessage(json['content'], json['date'], roomid);
        await changeMessageRoomState(
            json['content'], DateTime.parse(json['date']));
        if (json['sender'] != myId) {
          if (listViewController.position.pixels <= 300) {
            listViewController
                .jumpTo(listViewController.position.minScrollExtent);
          }
        }
        break;
      case 'chat_log':
        List<Chat> content = List<dynamic>.from(json['content'])
            .map((e) => Chat.fromJson(e))
            .toList();
        if (content.isNotEmpty) {
          content.forEach((element) {
            SQLController.to.insertmessage(element);
            messageList.insert(0, element);
          });
          SQLController.to.updateLastMessage(
              content.last.content, content.last.date.toString(), roomid);
          SQLController.to.updateNotReadCount(roomid, 0);
          await changeMessageRoomState(content.last.content, content.last.date);
          await Future.delayed(const Duration(milliseconds: 300));
          listViewController
              .jumpTo(listViewController.position.minScrollExtent);
          print('저장완료');
        }
        break;
      case 'other_view':
        if (json['content'] != 0) {
          changeReadMessage(roomid, json['content']);
        }
        break;
    }
  }

  Future<void> sendLastView(int id) async {
    channel.sink.add(jsonEncode({'id': id, 'type': 'update'}));
    print('보냈다.');
  }

  Future<List<Map<String, dynamic>>> checkRoomId(int id) async {
    List<Map<String, dynamic>> list;
    list = (await SQLController.to.database!
        .rawQuery('SELECT * FROM chatting WHERE room_id = $id'));
    return list;
  }

  Future<void> changeReadMessage(int roomid, int? msgid) async {
    if (msgid != null) {
      SQLController.to.database!.rawUpdate(
          'UPDATE chatting SET is_read = ? WHERE is_read = ? and room_id = ? and msg_id <= ?',
          ['true', 'false', roomid, msgid]);
      if (messageList
          .where((p0) => p0.messageId == msgid.toString())
          .isNotEmpty) {
        messageList
            .where((p0) => p0.messageId == msgid.toString())
            .first
            .isRead!
            .value = true;
      }
    } else {
      SQLController.to.database!.rawUpdate(
          'UPDATE chatting SET is_read = ? WHERE is_read = ? and room_id = ?',
          ['true', 'false', roomid]);
      if (messageList
          .where((p0) => p0.isRead!.value == false)
          .toList()
          .isNotEmpty) {
        messageList.first.isRead!.value = true;
      }
    }
    messageList.refresh();
    print('업데이트 성공!');
  }

  RxBool checkFirstScreenPosition() {
    if (messageHeight.value >= messagesBoxPositionHeight.value - 30) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  void updateNotreadMsg() async {
    await SQLController.to.updateNotReadCount(roomid, 0);
    SQLController.to.findNotReadMessage(roomid: roomid).then((value) {
      if (value == false) {
        HomeController.to.isNewMsg.value = false;
      } else {
        HomeController.to.isNewMsg.value = true;
      }
    });
  }

  Future<void> mustSendMessages() async {
    for (Chat chat in messageList
        .where((chat) => chat.sendsuccess!.value == 'false')
        .toList()
        .reversed) {
      channel.sink.add(jsonEncode({
        'content': chat.content,
        'type': 'msg',
        'name': HomeController.to.myProfile.value.name
      }));
    }
  }

  void afterMustSendMessages(Map<String, dynamic> json, Chat chat) {
    messageList.where((p0) => p0 == chat).last.messageId =
        json['id'].toString();
    messageList.where((p0) => p0 == chat).last.isRead!.value = json['is_read'];
    messageList.where((p0) => p0 == chat).last.date =
        DateTime.parse(json['date']);
    messageList.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> changeMessageRoomState(String content, DateTime date) async {
    if (Get.isRegistered<MessageController>()) {
      MessageController.to.searchRoomList
          .where((p0) => p0.chatRoom.value.roomId == roomid)
          .first
          .chatRoom
          .value
          .message
          .value
          .content = content;
      MessageController.to.searchRoomList
          .where((p0) => p0.chatRoom.value.roomId == roomid)
          .first
          .chatRoom
          .value
          .message
          .value
          .date = date;
      MessageController.to.searchRoomList.sort((a, b) => b
          .chatRoom.value.message.value.date
          .compareTo(a.chatRoom.value.message.value.date));
      MessageController.to.searchRoomList.forEach((element) {
        element.chatRoom.value.message.refresh();
        element.chatRoom.refresh();
      });
      await Future.delayed(const Duration(milliseconds: 300));
      MessageController.to.searchRoomList.refresh();
    }
  }

  Future<void> connectWebSocket() async {
    await Future.delayed(const Duration(milliseconds: 300));
    channel = IOWebSocketChannel.connect(
        Uri.parse(
            'ws://${Environment.chatApiUrl}/ws/chat/${partnerId.toString()}/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'id': '$myId'
        },
        pingInterval: const Duration(seconds: 1));
  }
}
