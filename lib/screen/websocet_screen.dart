import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:loopus/api/chat_api.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/controller/home_controller.dart';
import 'package:loopus/controller/key_controller.dart';
import 'package:loopus/controller/message_controller.dart';
import 'package:loopus/controller/modal_controller.dart';
import 'package:loopus/controller/sql_controller.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:loopus/screen/message_screen.dart';
import 'package:loopus/widget/appbar_widget.dart';
import 'package:loopus/widget/career_rank_widget.dart';
import 'package:loopus/widget/custom_header_footer.dart';
import 'package:loopus/widget/disconnect_reload_widget.dart';
import 'package:loopus/widget/error_reload_widget.dart';
import 'package:loopus/widget/loading_widget.dart';
import 'package:loopus/widget/message_widget.dart';
import 'package:loopus/widget/scroll_noneffect_widget.dart';
import 'package:path/path.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:web_socket_channel/io.dart';

enum EnterRoute { popUp, messageScreen, otherProfile }

class WebsoketScreen extends StatelessWidget {
  WebsoketScreen(
      {Key? key,
      required this.partner,
      required this.myProfile,
      required this.partnerToken,
      required this.enterRoute})
      : super(key: key);
  User partner;
  String? partnerToken;
  User myProfile;
  EnterRoute enterRoute;
  late WebsoketController controller = Get.put(
      WebsoketController(partnerId: partner.userid),
      tag: partner.userid.toString());
  Key centerKey = const ValueKey('QueryList');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBarWidget(
            title: partner.realName,
            bottomBorder: false,
            leading: GestureDetector(
                onTap: () {
                  if (enterRoute == EnterRoute.popUp) {
                    if (Get.isRegistered<MessageController>()) {
                      Get.back();
                    } else {
                      Get.off(() => MessageScreen());
                    }
                  } else {
                    Get.back();
                  }
                },
                child: Center(
                    child: SvgPicture.asset('assets/icons/Arrow_left.svg'))),
            actions: [
              GestureDetector(
                onTap: () async {
                  // // deleteDatabase(
                  // //                 join(await getDatabasesPath(), 'MY_database.db'));
                  showModalIOS(context, func1: () {
                    int roomId = controller.roomid;
                    if (controller.messageList.isNotEmpty) {
                      deleteChatRoom(controller.roomid, myProfile.userid)
                          .then((value) {
                        if (value.isError == false) {
                          SQLController.to.deleteMessage(roomId);
                          SQLController.to.deleteMessageRoom(roomId);
                          SQLController.to.deleteUser(partner.userid);
                          if (Get.isRegistered<MessageController>()) {
                            MessageController.to.searchRoomList.removeAt(
                                MessageController.to.searchRoomList.indexWhere(
                                    (messageRoom) =>
                                        messageRoom.chatRoom.value.roomId ==
                                        roomId));
                            MessageController.to.chattingRoomList.removeAt(
                                MessageController.to.chattingRoomList
                                    .indexWhere((messageRoom) =>
                                        messageRoom.chatRoom.value.roomId ==
                                        roomId));
                          }
                          Get.back();
                          if (enterRoute == EnterRoute.popUp) {
                            Get.off(() => MessageScreen());
                          } else {
                            Get.back();
                          }
                        }
                      });
                    } else {
                      Get.back();
                      if (enterRoute == EnterRoute.popUp) {
                        Get.off(() => MessageScreen());
                      } else {
                        Get.back();
                      }
                    }
                  }, func2: () {
                    Get.to(() => DatabaseList());
                  },
                      value1: '채팅방 나가기',
                      value2: '',
                      isValue1Red: true,
                      isValue2Red: false,
                      isOne: true);
                },
                child: SizedBox(
                    height: 44,
                    width: 44,
                    child: Center(
                        child: SvgPicture.asset('assets/icons/More.svg'))),
              )
            ],
          ),
          bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: sendField()),
          body: Obx(
            () => controller.screenState.value == ScreenState.loading
                ? const Center(child: LoadingWidget())
                : controller.screenState.value == ScreenState.success
                    ? SmartRefresher(
                        controller: controller.refreshController,
                        scrollController: controller.scrollController,
                        enablePullUp: controller.refreshEnablePullUp.value,
                        enablePullDown: false,
                        onLoading: controller.onLoading,
                        header: ClassicHeader(
                          releaseIcon: Container(),
                          releaseText: '',
                          refreshingIcon: Container(),
                          refreshingText: '',
                          idleIcon: Container(),
                          idleText: '',
                        ),
                        footer: ClassicFooter(
                          loadingIcon: Container(),
                          loadingText: '',
                          idleIcon: Container(),
                          idleText: '',
                        ),
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        child: SingleChildScrollView(
                          reverse: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  if (controller.messageList[index] ==
                                      controller.messageList.first) {
                                    return MessageWidget(
                                        message: controller.messageList[index],
                                        isLast: true.obs,
                                        partner: partner,
                                        myId: controller.myId!);
                                  } else {
                                    return MessageWidget(
                                        message: controller.messageList[index],
                                        isLast: false.obs,
                                        partner: partner,
                                        myId: controller.myId!);
                                  }
                                },
                                itemCount: controller.messageList.length,
                              )
                            ],
                          ),
                        ),
                      )
                    : controller.screenState.value == ScreenState.normal
                        ? Container()
                        : Container(),
          )),
    );
  }

  // List<Widget> messageBox() {
  //   return [
  //     SliverList(
  //         key: centerKey,
  //         delegate: SliverChildBuilderDelegate((context, index) {
  //           if (controller.checkFirstScreenPosition().value == true) {
  //             if (controller.messageList[index] ==
  //                 controller.messageList.first) {
  //               return MessageWidget(
  //                   key: Get.put(
  //                           KeyController(
  //                               isTextField: false.obs, ismessage: true),
  //                           tag: index.toString())
  //                       .viewKey,
  //                   message: controller.messageList[index],
  //                   isLast: true.obs,
  //                   partner: partner,
  //                   myId: controller.myId!);
  //             } else {
  //               if (index < 9) {
  //                 return MessageWidget(
  //                     key: Get.put(
  //                             KeyController(
  //                                 isTextField: false.obs, ismessage: true),
  //                             tag: index.toString())
  //                         .viewKey,
  //                     message: controller.messageList[index],
  //                     isLast: false.obs,
  //                     partner: partner,
  //                     myId: controller.myId!);
  //               } else {
  //                 return MessageWidget(
  //                     message: controller.messageList[index],
  //                     isLast: false.obs,
  //                     partner: partner,
  //                     myId: controller.myId!);
  //               }
  //             }
  //           } else {
  //             if (controller.messageList[index] ==
  //                 controller.messageList.last) {
  //               return MessageWidget(
  //                   message: controller.messageList.reversed.toList()[index],
  //                   isLast: true.obs,
  //                   partner: partner,
  //                   myId: controller.myId!);
  //             } else {
  //               return MessageWidget(
  //                   message: controller.messageList.reversed.toList()[index],
  //                   isLast: false.obs,
  //                   partner: partner,
  //                   myId: controller.myId!);
  //             }
  //           }
  //         }, childCount: controller.messageList.length)),
  //     SliverList(
  //         delegate: SliverChildBuilderDelegate(((context, index) {
  //       return MessageWidget(
  //           message: controller.refreshList[index],
  //           isLast: false.obs,
  //           partner: partner,
  //           myId: controller.myId!);
  //     }), childCount: controller.refreshList.length)),
  //   ];
  // }

  Widget sendField() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: dividegray))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                keyboardType: TextInputType.multiline,
                controller: controller.sendText,
                minLines: 1,
                maxLines: 3,
                autocorrect: false,
                readOnly: false,
                style: k16Normal,
                cursorColor: mainblack,
                cursorWidth: 1.2,
                cursorRadius: Radius.circular(5.0),
                autofocus: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: cardGray,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                  isDense: true,
                  hintText: '메세지 입력',
                  hintStyle: k16Normal.copyWith(color: maingray),
                )),
          ),
          const SizedBox(width: 14),
          GestureDetector(
              onTap: () async {
                if (controller.sendText.text.isNotEmpty) {
                  controller.channel.sink.add(jsonEncode({
                    'content': controller.sendText.text,
                    'type': 'msg',
                    'token': partnerToken,
                    'name': myProfile.realName
                  }));
                  controller.sendText.clear();
                }
              },
              child: SvgPicture.asset('assets/icons/Enter_Icon.svg'))
        ],
      ),
    );
  }
}

class WebsoketController extends GetxController with WidgetsBindingObserver {
  WebsoketController({required this.partnerId});
  late IOWebSocketChannel channel;
  late int roomid;
  late RxBool hasInternet;
  late var listener;

  String? token;
  int partnerId;
  int? myId;
  TextEditingController sendText = TextEditingController();
  ScrollController scrollController = ScrollController();
  RefreshController refreshController = RefreshController();

  RxList<Chat> messageList = <Chat>[].obs;
  RxList<Chat> refreshList = <Chat>[].obs;
  Rx<ScreenState> screenState = ScreenState.normal.obs;
  RxBool isFirst = true.obs;
  RxBool refreshEnablePullUp = true.obs;
  RxString lastid = '0'.obs;
  RxDouble messageHeight = 0.0.obs;
  RxDouble messagesBoxPositionHeight = 0.0.obs;
  @override
  void onInit() async {
    scrollController.addListener(() {
      if (refreshEnablePullUp.value == true) {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          print('실행되었습니다.');
          onLoading();
        }
      }
    });
    screenState.value = ScreenState.loading;
    print('${partnerId}파트너아이디입니다.');
    WidgetsBinding.instance!.addObserver(this);
    myId = int.parse(
        (await const FlutterSecureStorage().read(key: "id")).toString());

    print('${myId}자기아이디입니다.');
    listener = InternetConnectionChecker().onStatusChange.listen((event) {
      bool connection =
          event == InternetConnectionStatus.connected ? true : false;
      hasInternet = connection.obs;
      if (connection == false) {
        channel.sink.close();
        print('웹소켓 연결이 해제되었습니다.');
      } else {
        // if (isFirst.value == false) {
        channel = IOWebSocketChannel.connect(
            Uri.parse('ws://$chatServerUri/ws/chat/${partnerId.toString()}/'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'id': '$myId'
            },
            pingInterval: const Duration(seconds: 1));
        channel.stream.listen((event) {
          print(event);
          messageTypeCheck(jsonDecode(event));
        }, onError: (error) {
          print(error);
        }, onDone: () {
          print('끊김');
          channel.sink.close();
        });
        // }
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
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        print(state);
        break;
    }
  }

  @override
  void onClose() {
    channel.sink.close();
    listener.cancel();
    print('웹소켓 연결 해제');
    messageList.clear();
    HomeController.to.enterMessageRoom.value = 0;
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
          messageList.addAll(await SQLController.to
              .getDBMessage(roomid, int.parse(lastid.value)));
          checkRoomId(roomid).then((value) {
            if (value.isNotEmpty) {
              print(messageList[0].messageId);
              sendLastView(int.parse(messageList.first.messageId!));
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
      case ('user_leave'):
        print('상대가 나감');
        break;
      case ('msg'):
        SQLController.to.insertmessage(Chat.fromMsg(json, roomid));
        messageList.insert(0, Chat.fromJson(json));
        await Future.delayed(const Duration(milliseconds: 100));
        SQLController.to
            .updateLastMessage(json['content'], json['date'], roomid);
        if (Get.isRegistered<MessageController>()) {
          MessageController.to.searchRoomList
              .where((p0) => p0.chatRoom.value.roomId == roomid)
              .first
              .chatRoom
              .value
              .message
              .value
              .content = json['content'];
          MessageController.to.searchRoomList
              .where((p0) => p0.chatRoom.value.roomId == roomid)
              .first
              .chatRoom
              .value
              .message
              .value
              .date = DateTime.parse(json['date']);
          MessageController.to.searchRoomList.sort((a, b) => b
              .chatRoom.value.message.value.date
              .compareTo(a.chatRoom.value.message.value.date));
          MessageController.to.searchRoomList.forEach((element) {
            element.chatRoom.value.message.refresh();
            element.chatRoom.refresh();
          });
          MessageController.to.searchRoomList.refresh();
        }
        break;
      case 'chat_log':
        List<dynamic> content = json['content'];
        if (content.isNotEmpty) {
          content.forEach((element) {
            SQLController.to.insertmessage(Chat.fromJson(element));
            messageList.insert(0, Chat.fromJson(element));
          });
          print('저장완료');
        }
        break;
      case 'other_view':
        if (json['content'] != null) {
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
    } else {
      SQLController.to.database!.rawUpdate(
          'UPDATE chatting SET is_read = ? WHERE is_read = ? and room_id = ?',
          ['true', 'false', roomid]);
      if (messageList
          .where((p0) => p0.isRead!.value == false)
          .toList()
          .isNotEmpty) {
        print('실행되는중');
        if (checkFirstScreenPosition().value == true) {
          messageList.first.isRead!.value = true;
        } else {
          messageList.last.isRead!.value = true;
        }
      }
      messageList.refresh();
    }
    print('업데이트 성공!');
  }

  RxBool checkFirstScreenPosition() {
    if (messageHeight.value >= messagesBoxPositionHeight.value - 30) {
      return true.obs;
    } else {
      return false.obs;
    }
  }
}
