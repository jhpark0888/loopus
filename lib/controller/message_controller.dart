import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/widget/message_widget.dart';
import 'package:loopus/widget/paper_competition_widget.dart';
import 'package:loopus/widget/paper_internship_widget.dart';

class MessageController extends GetxController {
  static MessageController get to => Get.find();
  RxList<MessageWidget> messagelist = <MessageWidget>[].obs;
  FocusNode messagefocus = FocusNode();
  TextEditingController messagetextController = TextEditingController();

  String username = "";
  int userid = 0;

  @override
  void onInit() {
    super.onInit();
  }

  Future<dynamic> messageload(int userid) async {
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final url = Uri.parse("http://3.35.253.151:8000/chat/chatting/$userid/");

    final response = await get(url, headers: {"Authorization": "Token $token"});
    var statusCode = response.statusCode;
    var responseHeaders = response.headers;
    var responseBody = utf8.decode(response.bodyBytes);
    print(statusCode);
    Map<String, dynamic> map = jsonDecode(responseBody);

    print(map);
    username = map["real_name"];
    userid = map["user_id"];
    if (map["messages"].length != 0) {
      map["messages"].forEach((element) {
        if (element["sender_id"] == map["user_id"]) {
          messagelist.add(MessageWidget(
            content: element["message"],
            image: map["profile_image"],
            isSender: 1,
          ));
        } else {
          messagelist.add(MessageWidget(
            content: element["message"],
            image: map["profile_image"],
            isSender: 0,
          ));
        }
      });
    } else {
      return;
    }
  }

  Future<void> messagemake(String content, int id) async {
    String? token;
    await FlutterSecureStorage().read(key: 'token').then((value) {
      token = value;
    });

    final url = Uri.parse("http://3.35.253.151:8000/chat/chatting/$id/");
    print("token");
    print(token);
    var data = {
      "content": content,
    };
    // TagController.to.selectedtaglist.clear();
    http.Response response = await http.post(url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(data));
    var responseHeaders = response.headers;
    var responseBody = utf8.decode(response.bodyBytes);
    // List<dynamic> list = jsonDecode(responseBody);
    // print(list);
    Map<String, dynamic> map = jsonDecode(responseBody);
    print("---------------------------");
    print(responseBody);
    print(response.statusCode);
    if (response.statusCode != 200) {
      return Future.error(response.statusCode);
    } else {
      return;
    }
  }

  bool hasTextOverflow(String text, TextStyle style,
      {double minWidth = 0, double maxWidth = 250, int maxLines = 1}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: minWidth, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }
}
