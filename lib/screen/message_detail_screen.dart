import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/message_widget.dart';

class MessageDetailScreen extends StatelessWidget {
  MessageDetailScreen({Key? key, required this.user}) : super(key: key);
  MessageController messageController = Get.find();

  User user;
  RxList<MessageWidget> messagelist = <MessageWidget>[].obs;

  void _handleSubmitted(String text) async {
    print(text);
    await postmessage(text, messageController.userid);
    messageController.messagelist.clear();
    await getmessagelist(messageController.userid);
    messageController.messagefocus.unfocus();
    messageController.messagetextController.clear();
  }

  Widget _buildTextComposer() {
    return Container(
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
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              cursorWidth: 1.2,
              focusNode: messageController.messagefocus,
              style: TextStyle(decoration: TextDecoration.none),
              cursorColor: mainblack.withOpacity(0.6),
              controller: messageController.messagetextController,
              onFieldSubmitted: _handleSubmitted,
              validator: (value) {},
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                suffixIconConstraints:
                    BoxConstraints(minHeight: 24, minWidth: 24),
                contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                hintText: "메세지 보내기...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: mainblack.withOpacity(0.38),
                ),
                fillColor: mainlightgrey,
                filled: true,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                _handleSubmitted(
                    messageController.messagetextController.value.text);
              },
              child: Text(
                "보내기",
                style: TextStyle(
                  color: mainblue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getmessagelist(user.userid).then((value) {
      messagelist(value
          .map((message) => MessageWidget(message: message, user: user))
          .toList());
      MessageController.to.isMessageListLoading(false);
    });
    return Scaffold(
      appBar: AppBarWidget(
        title: '${user.realName}님',
      ),
      body: Obx(
        () => Column(
          children: [
            messageController.isMessageListLoading.value
                ? Expanded(
                    child: Center(
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
                    ),
                  )
                : Expanded(
                    child: ListView(
                      children: [
                        Obx(
                          () => Column(
                            children: messagelist,
                          ),
                        ),
                      ],
                    ),
                  ),
            _buildTextComposer()
          ],
        ),
      ),
    );
  }
}
