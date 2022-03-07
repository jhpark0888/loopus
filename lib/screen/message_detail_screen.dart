import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/message_detail_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/message_widget.dart';
import 'package:loopus/widget/messageroom_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessageDetailScreen extends StatelessWidget {
  MessageDetailScreen(
      {Key? key, required this.userid, required this.realname, this.user})
      : super(key: key);

  int userid;
  String realname;
  User? user;
  late MessageDetailController controller = Get.put(
      MessageDetailController(
          userid: userid,
          user: user != null ? user!.obs : User.defaultuser().obs),
      tag: userid.toString());

  void _handleSubmitted(String text) async {
    if (controller.isSendButtonon.value) {
      if (controller.user!.value.banned != BanState.normal) {
        controller.messagefocus.unfocus();
        ModalController.to.showCustomDialog("해당 유저에게 메세지를 보낼 수 없습니다", 1000);
      } else {
        controller.messagefocus.unfocus();
        controller.messagetextController.clear();
        Message message = Message(
            id: 0,
            roomId: controller.messagelist.isEmpty
                ? 0
                : controller.messagelist.first.message.roomId,
            receiverId: userid,
            message: text,
            date: DateTime.now(),
            isRead: true,
            issender: 1,
            issending: true.obs);
        controller.messagelist.insert(controller.messagelist.length,
            MessageWidget(message: message, user: controller.user!.value));
        if (controller.scrollController.hasClients) {
          if (controller.scrollController.offset != 0) {
            controller.scrollController.jumpTo(
              0,
            );
          }
        }
        await postmessage(text, controller.userid).then((value) {
          message.issending(false);

          if (Get.isRegistered<MessageController>()) {
            MessageController messageController = Get.find<MessageController>();
            MessageRoomWidget messageroomwidget = messageController
                .chattingroomlist
                .where((messageroom) =>
                    messageroom.messageRoom.value.user.userid ==
                    controller.userid)
                .first;
            messageroomwidget.messageRoom.value.message.value = Message(
                id: 0,
                roomId: controller.messagelist.isEmpty
                    ? 0
                    : controller.messagelist.first.message.roomId,
                receiverId: userid,
                message: text,
                date: DateTime.now(),
                isRead: true,
                issender: 1,
                issending: true.obs);
            messageController.chattingroomlist.remove(messageroomwidget);
            messageController.chattingroomlist.insert(0, messageroomwidget);
          }
        });
      }
    }
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
                    child: Obx(
                      () => Text(
                        '보내기',
                        style: kButtonStyle.copyWith(
                            color: controller.isSendButtonon.value
                                ? mainblue
                                : mainblack.withOpacity(0.38)),
                      ),
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
    // Get.put(OnMessageScreenController(), tag: userid.toString());
    return Scaffold(
        appBar: AppBarWidget(
          bottomBorder: false,
          title: '${realname}',
        ),
        bottomNavigationBar: Transform.translate(
          offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
          child: BottomAppBar(
            elevation: 0,
            child: _buildTextComposer(),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Obx(() => controller.messagescreenstate.value ==
                  ScreenState.loading
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
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ]),
                )
              : controller.messagescreenstate.value == ScreenState.disconnect
                  ? DisconnectReloadWidget(reload: () {
                      controller.firstmessagesload();
                    })
                  : controller.messagescreenstate.value == ScreenState.error
                      ? ErrorReloadWidget(reload: () {
                          controller.firstmessagesload();
                        })
                      : SmartRefresher(
                          reverse: true,
                          controller: controller.messageRefreshController,
                          enablePullDown: false,
                          enablePullUp: controller.enablemessagePullup.value,
                          header: ClassicHeader(
                            spacing: 0.0,
                            height: 60,
                            completeDuration: Duration(milliseconds: 600),
                            textStyle: TextStyle(color: mainblack),
                            refreshingText: '',
                            releaseText: "",
                            completeText: "",
                            idleText: "",
                            refreshingIcon: Column(
                              children: [
                                Image.asset(
                                  'assets/icons/loading.gif',
                                  scale: 6,
                                ),
                              ],
                            ),
                            releaseIcon: Column(
                              children: [
                                Image.asset(
                                  'assets/icons/loading.gif',
                                  scale: 6,
                                ),
                              ],
                            ),
                            completeIcon: Column(
                              children: [
                                const Icon(
                                  Icons.check_rounded,
                                  color: mainblue,
                                ),
                              ],
                            ),
                            idleIcon: Column(
                              children: [
                                Image.asset(
                                  'assets/icons/loading.png',
                                  scale: 12,
                                ),
                              ],
                            ),
                          ),
                          footer: ClassicFooter(
                            completeDuration: Duration.zero,
                            loadingText: "",
                            canLoadingText: "",
                            idleText: "",
                            idleIcon: Container(),
                            noMoreIcon: Container(
                              child: Text('as'),
                            ),
                            loadingIcon: Image.asset(
                              'assets/icons/loading.gif',
                              scale: 6,
                            ),
                            canLoadingIcon: Image.asset(
                              'assets/icons/loading.gif',
                              scale: 6,
                            ),
                          ),
                          onLoading: controller.messageLoading,
                          child: SingleChildScrollView(
                            reverse: true,
                            controller: controller.scrollController,
                            child: Obx(
                              () => Padding(
                                padding: EdgeInsets.only(
                                    bottom: controller
                                            .keyboardController.isVisible
                                        ? controller.textBoxSize.value.height
                                        : 0),
                                child: Column(
                                  children: controller.messagelist.value,
                                ),
                              ),
                            ),
                          ),
                        )),
        ));
  }
}
