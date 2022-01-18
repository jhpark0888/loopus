import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/message_widget.dart';

class MessageDetailScreen extends StatelessWidget {
  MessageController messageController = Get.find();

  void _handleSubmitted(String text) async {
    print(text);
    await messagemake(text, messageController.userid);
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
                suffixIcon: Text('작성'),
                contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                hintText: "답변 남기기...",
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
          Obx(
            () => Align(
              alignment: Alignment.center,
              child: messageController.messagetextController.text == ""
                  ? InkWell(
                      onTap: () {},
                      child: Text(
                        "작성",
                        style: TextStyle(
                          color: mainblack.withOpacity(0.38),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        _handleSubmitted(
                            messageController.messagetextController.text);
                      },
                      child: Text(
                        "작성",
                        style: TextStyle(
                          color: mainblue,
                        ),
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
    return Scaffold(
      appBar: AppBarWidget(
        title: '${messageController.username}님',
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                child: ListView(
                  children: [
                    Column(
                      children: messageController.messagelist.value,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
          Align(alignment: Alignment.bottomCenter, child: _buildTextComposer())
        ],
      ),
    );
  }
}
