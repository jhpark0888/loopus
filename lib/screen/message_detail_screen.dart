import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/message_widget.dart';

class MessageDetailScreen extends StatelessWidget {
  MessageDetailScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  User user;
  late MessageDetailController controller = Get.put(
      MessageDetailController(
        user,
      ),
      tag: user.userid.toString());

  void _handleSubmitted(String text) async {
    controller.messagefocus.unfocus();
    controller.messagetextController.clear();
    controller.messagelist.insert(
        0,
        MessageWidget(
            message: Message(
                roomId: controller.messagelist.isEmpty
                    ? 0
                    : controller.messagelist.first.message.roomId,
                receiverId: user.userid,
                message: text,
                date: DateTime.now(),
                isRead: true,
                issender: 1,
                issending: true.obs),
            user: user));
    if (controller.scrollController.hasClients) {
      if (controller.scrollController.offset != 0) {
        controller.scrollController.jumpTo(
          0,
        );
      }
    }
    await postmessage(text, controller.user.userid).then((value) {
      controller.messagelist.first.message.issending(false);
    });
  }

  Widget _buildTextComposer() {
    return Container(
      key: controller.textFieldBoxKey.value,
      decoration: BoxDecoration(
        color: mainWhite,
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color(0xffe7e7e7),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: TextFormField(
        autocorrect: false,
        enableSuggestions: false,
        cursorWidth: 1.2,
        style: const TextStyle(decoration: TextDecoration.none),
        cursorColor: mainblack.withOpacity(0.6),
        controller: controller.messagetextController,
        onFieldSubmitted: _handleSubmitted,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
          suffixIconConstraints: BoxConstraints(minWidth: 24),
          suffixIcon: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    _handleSubmitted(
                        controller.messagetextController.value.text);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '보내기',
                      style: kButtonStyle.copyWith(color: mainblue),
                    ),
                  ),
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: "메시지를 입력해주세요...",
          hintStyle: TextStyle(
            fontSize: 14,
            color: mainblack.withOpacity(0.38),
          ),
          fillColor: mainlightgrey,
          filled: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        bottomBorder: false,
        title: '${user.realName}님',
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          elevation: 0,
          child: _buildTextComposer(),
        ),
      ),
      body: Obx(
        () => controller.isMessageListLoading.value
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/loading.gif',
                        scale: 9,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '메세지 목록을 받아오는 중이에요...',
                        style: TextStyle(
                          fontSize: 10,
                          color: mainblue,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]),
              )
            : Obx(
                () => Padding(
                  padding: EdgeInsets.only(
                      bottom: controller.keyboardController.isVisible
                          ? controller.textBoxSize.value.height
                          : 0),
                  child: ListView(
                    reverse: true,
                    controller: controller.scrollController,
                    children: controller.messagelist,
                  ),
                ),
              ),
      ),
    );
  }
}
