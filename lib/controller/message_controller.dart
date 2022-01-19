import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/model/message_model.dart';
import 'package:loopus/widget/message_widget.dart';

class MessageController extends GetxController {
  static MessageController get to => Get.find();
  RxList<MessageWidget> messagelist = <MessageWidget>[].obs;
  FocusNode messagefocus = FocusNode();
  TextEditingController messagetextController = TextEditingController();
  RxList<MessageRoom> chattingroomlist = <MessageRoom>[].obs;
  RxBool isMessageRoomListLoading = false.obs;
  RxBool isMessageListLoading = false.obs;

  String username = "";
  int userid = 0;

  @override
  void onInit() {
    super.onInit();
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
