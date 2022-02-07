import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/message_widget.dart';

class MessageDetailController extends GetxController {
  static MessageDetailController get to => Get.find();
  MessageDetailController(
    this.user,
  );

  RxList<MessageWidget> messagelist = <MessageWidget>[].obs;
  FocusNode messagefocus = FocusNode();
  TextEditingController messagetextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  KeyboardVisibilityController keyboardController =
      KeyboardVisibilityController();
  RxBool isMessageListLoading = false.obs;
  RxBool isSendButtonon = false.obs;

  String username = "";
  User user;

  RxDouble textFormHeight = 0.0.obs;
  Rx<GlobalKey> textFieldBoxKey = GlobalKey().obs;
  Rx<Size> textBoxSize = Size(Get.width, 0).obs;

  getSize(GlobalKey key) {
    if (key.currentContext != null) {
      RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size;
    }
    return Size(Get.width, 36);
  }

  void messageroomrefresh() {
    isMessageListLoading(true);
    getmessagelist(user.userid).then((value) {
      messagelist(value
          .map((message) => MessageWidget(message: message, user: user))
          .toList());
      isMessageListLoading(false);
    });
  }

  void bottomtoscroll() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void onInit() {
    messagetextController.addListener(() {
      textBoxSize.value = getSize(textFieldBoxKey.value);
      if (messagetextController.text.replaceAll(" ", "") == "") {
        isSendButtonon(false);
      } else {
        isSendButtonon(true);
      }
    });

    keyboardController.onChange.listen((isVisible) {
      if (isVisible) {
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.offset,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      } else {
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.offset,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        }
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
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
