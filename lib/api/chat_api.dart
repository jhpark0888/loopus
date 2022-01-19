import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/widget/message_widget.dart';

Future<void> getmessageroomlist() async {
  String? token = await const FlutterSecureStorage().read(key: 'token');

  final url = Uri.parse("http://3.35.253.151:8000/chat/get_list");

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
        .map((messageroom) => MessageRoom.fromJson(messageroom))
        .toList());
    print("---------------------------");
    print(responseBody);
    print(response.statusCode);
    return;
  } else {
    return Future.error(response.statusCode);
  }
}

Future<List<Message>> getmessagelist(int userid) async {
  String? token = await const FlutterSecureStorage().read(key: 'token');

  final url = Uri.parse("http://3.35.253.151:8000/chat/chatting/$userid");

  final response =
      await http.get(url, headers: {"Authorization": "Token $token"});

  print('채팅 리스트 statuscode: ${response.statusCode}');
  if (response.statusCode == 200) {
    List responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(responseBody);

    List<Message> messagelist =
        responseBody.map((message) => Message.fromJson(message)).toList();
    // MessageController.to.chattingroomlist(responseBody
    //     .map((messageroom) => MessageRoom.fromJson(messageroom))
    //     .toList());
    return messagelist;
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

  final url = Uri.parse("http://3.35.253.151:8000/chat/chatting/$userid");

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
    var responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    print(responseBody);

    Message messagelist = Message.fromJson(responseBody);
    return;
  } else {
    return Future.error(response.statusCode);
  }
}
