import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/message_widget.dart';
import 'package:loopus/widget/messageroom_widget.dart';

import '../constant.dart';

Future<void> getmessageroomlist() async {
  ConnectivityResult result = await initConnectivity();
  MessageController.to.chatroomscreenstate(ScreenState.loading);
  if (result == ConnectivityResult.none) {
    MessageController.to.chatroomscreenstate(ScreenState.disconnect);
    ModalController.to.showdisconnectdialog;
  } else {
    String? token = await const FlutterSecureStorage().read(key: 'token');
    String? myid = await const FlutterSecureStorage().read(key: 'id');

    final url = Uri.parse("$serverUri/chat/get_list");

    http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
    );

    print('채팅방 리스트 statuscode: ${response.statusCode}');
    if (response.statusCode == 200) {
      List responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      MessageController.to.chattingroomlist(responseBody
          .map((messageroom) => MessageRoomWidget(
              messageRoom: MessageRoom.fromJson(messageroom, myid)))
          .toList());
      MessageController.to.chatroomscreenstate(ScreenState.success);
      print("---------------------------");
      print(responseBody);
      print(response.statusCode);
      return;
    } else {
      MessageController.to.chatroomscreenstate(ScreenState.error);
      return Future.error(response.statusCode);
    }
  }
}

Future<List<MessageWidget>> getmessagelist(int userid, int lastindex) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');
  String? myid = await const FlutterSecureStorage().read(key: 'id');
  MessageDetailController messageDetailController =
      Get.find<MessageDetailController>(tag: userid.toString());

  final url = Uri.parse("$serverUri/chat/chatting?id=$userid&last=$lastindex");

  final response =
      await http.get(url, headers: {"Authorization": "Token $token"});

  print('채팅 리스트 statuscode: ${response.statusCode}');
  if (response.statusCode == 200) {
    Map responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (lastindex == 0) {
      messageDetailController.user = User.fromJson(responseBody["profile"]).obs;
    }
    List<MessageWidget> modelmessagelist = List.from(responseBody["message"])
        .map((message) => Message.fromJson(message, myid))
        .toList()
        .map((message) => MessageWidget(
            message: message, user: messageDetailController.user!.value))
        .toList();
    // print(responseBody);

    // MessageController.to.chattingroomlist(responseBody
    //     .map((messageroom) => MessageRoom.fromJson(messageroom))
    //     .toList());
    return modelmessagelist;
  } else if (response.statusCode == 404) {
    messageDetailController.messagelist([]);
    return [];
  } else {
    return Future.error(response.statusCode);
  }
  // print(map);
  // String username = map["real_name"];
  // userid = map["user_id"];
  // if (map["messages"].length != 0) {
  //   map["messages"].forEach((element) {
  //     if (element["sender_id"] == map["user_id"]) {
  //       MessageController.to.messagelist.add(MessageWidget(
  //         content: element["message"],
  //         image: map["profile_image"],
  //         isSender: 1,
  //       ));
  //     } else {
  //       MessageController.to.messagelist.add(MessageWidget(
  //         content: element["message"],
  //         image: map["profile_image"],
  //         isSender: 0,
  //       ));
  //     }
  //   });
  // } else {
  //   return;
  // }
}

Future<void> postmessage(String content, int userid) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');
  String? myid = await const FlutterSecureStorage().read(key: 'id');

  final url = Uri.parse("$serverUri/chat/chatting?id=$userid");

  var message = {
    "message": content,
  };

  http.Response response = await http.post(url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(message));

  print('메세지 보내기 statuscode: ${response.statusCode}');
  if (response.statusCode == 200) {
    // var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    // print(responseBody);

    // Message messagelist = Message.fromJson(responseBody, myid);
    return;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<void> putonmessagescreen(String userid) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');
  String? myid = await const FlutterSecureStorage().read(key: 'id');

  final url = Uri.parse("$serverUri/chat/chatting?id=$userid");

  http.Response response = await http.put(
    url,
    headers: {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json'
    },
  );

  print('on 메세지 스크린 statuscode: ${response.statusCode}');
  if (response.statusCode == 200) {
    // var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    // print(responseBody);

    // Message messagelist = Message.fromJson(responseBody, myid);
    return;
  } else {
    return Future.error(response.statusCode);
  }
}
